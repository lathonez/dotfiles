from utils        import HTTPUtils
from time         import mktime
from datetime     import datetime
import feedparser, re, ConfigParser

# Class to obtain and parse an activity stream from Jira
class ActivityStream():

	def __init__ (self, config):

		self.config = config
		self.http_utils = HTTPUtils(self.config)

	# get the activity stream for a given user
	#
	# username: Jira username
	# password: Jira password
	#
	# return: feedparsed activiy stream
	def get_stream(self, username, password):

		url      = self.config.get('app','base_url')
		auth     = self.config.get('app','auth_type')
		results  = self.config.get('user','results')
		streams  = 'user+IS+{0}'.format(username)

		print 'get_stream: Attemptint to get stream for user',username

		request_params = {
			'maxResults': results,
			'streams': streams,
			'os_authType': auth
		}

		try:
			resp = self.http_utils.do_req(
				url=url,
				data=request_params,
				post=False,
				username=username,
				password=password,
				url_encode=False
			)
		except Exception as e:

			# check for failed login
			if str(e).index('HTTP error code: 401'):
				raise ActivityStreamError('Invalid username or password',-2)
			else:
				raise e

		print 'get_stream: Stream received from Jira, parsing..'

		stream = feedparser.parse(resp['response_string'])

		return stream

	# print the title and published date from the entire stream
	#
	# stream: feedparsed activity stream
	def print_stream(self, stream):

		for entry in stream.entries:

			print 'title: {0}, date: {1}'.format(
				entry.title,
				entry.published
			)

	# parse the stream:
	#  - newest events are first in the stream
	#  - pull out relevant entries
	#  - find unique tickets from entries
	#  - sum the time up for each ticket
	#
	# stream: feedparsed activity stream
	# day:    day of the month (e.g. 26)
	# month:  month of the year (e.g. 09)
	#
	# return: list of ticket dicts
	def parse_stream(self, stream, day, month):

		fn      = '_parse_stream:'
		day     = int(day)
		month   = int(month)
		entries = []
		tickets = []

		# find relevant entries
		for entry in stream.entries:

			e_day = int(entry.published_parsed.tm_mday)
			e_month = int(entry.published_parsed.tm_mon)

			if day == e_day and month == e_month:
				entries.append(entry)

		if not len(entries):
			raise ActivityStreamError('No relevant entries found',-3)

		print fn,len(entries),'events found'

		# debug available time
		start = entries[0]
		end   = entries[len(entries)-1]
		avail = self._get_time_difference(start,end)
		print fn,'Time Available:',avail

		prev_entry  = None
		prev_ticket = None

		for entry in entries:

			try:
				# temp ticket to test with
				t = self._build_ticket_dict(entry)
			except ActivityStreamError as e:
				# we've got a random event like 'linked two tickets', ignore
				if str(e).find('ticket id found in'):
					print fn,'skipping entry @',entry.published
					continue
				else:
					raise e

			exists = self._get_ticket(tickets,t['ticket_id'])

			# if we've not seen this ticket yet, add it
			if exists is None:
				tickets.append(t)
			else:
				t = exists

			# first event, we can't do anything here
			if prev_entry is None:
				prev_entry = entry
				prev_ticket = t
				continue

			# what's the time differnce?
			diff = self._get_time_difference(prev_entry, entry)

			# this time difference is applied to the previous event
			# we're moving back through time in this loop
			if prev_ticket['time'] is None:
				prev_ticket['time'] = diff
			else:
				prev_ticket['time'] += diff

			prev_entry = entry
			prev_ticket = t

		# sanity check time
		total_time = self._get_total_time(tickets,False)
		if total_time != avail:
			raise ActivityStreamError('Time missing: total_time {0} vs avail {1}'.format(total_time,avail))
		else:
			print fn,total_time,'accounted for'

		return tickets

	# pretend we're getting some input from web form
	def spoof_request(self):

		username = self.config.get('user','username')
		password = self.config.get('user','password')
		day      = self.config.get('user','day')
		month    = self.config.get('user','month')

		stream = self.get_stream(username, password)
		self._parse_stream(stream, day, month)

	# work out the (published) time difference between two rss entries
	#
	# entry1: first entry in the stream (latest)
	# entry2: subsequent entry in the stream (older than entry 1)
	#
	# return datetime object representing the time difference
	def _get_time_difference(self, entry1, entry2):

		time1 = datetime.fromtimestamp(mktime(entry1.published_parsed))
		time2 = datetime.fromtimestamp(mktime(entry2.published_parsed))
		diff  = time1 - time2

		return diff

	# build a dict from an rss entry
	#
	# entry: rss entry
	#
	# returns: {
	#     'project': LBR,
	#     'ticket_id': LBR-12345,
	#     'tenrox_code': LBR300,
	#     'time': None
	# }
	def _build_ticket_dict(self,entry):

		td          = self._parse_title_detail(entry.title_detail.value)
		project     = td['project']
		ticket_id   = project + '-' + td['ticket_id']
		tenrox_code = self._get_tenrox_code(project)

		return {
			'projet': project,
			'ticket_id': ticket_id,
			'tenrox_code': tenrox_code,
			'time': None
		}

	# parse the rss title detail into useful info
	#
	# rss entry .title_detail.value
	#
	# return {
	#     'project': LBR,
	#     'ticket_id': LBR-12345
	# }
	def _parse_title_detail(self, title_detail):

		jira_link = 'https://jira.openbet.com/browse/'
		rexp      = '([A-Z][A-Z][A-Z]?)-([1-9][0-9]*)'
		idx       = title_detail.find(jira_link) + len(jira_link)
		jira_id   = title_detail[idx:idx+9]
		match     = re.search(rexp,jira_id)

		if match is None:
			raise ActivityStreamError('No ticket id found in ' + title_detail)

		try:
			project   = match.group(1)
			ticket_id = match.group(2)
		except Exception as e:
			raise ActivityStreamError('Failed to parse title' + str(e))

		return {
			'project': project,
			'ticket_id': ticket_id
		}

	# derive the tenrox code from a project
	#
	# project: Jira project (LBR)
	#
	# returns: tenrox code (LBR300)
	def _get_tenrox_code(self, project):

		try:
			code = self.config.get('tenrox_codes',project)
		except ConfigParser.NoOptionError:
			code = project + '300'

		return code

	# get a ticket dict in a list of tickets based on ticket_id
	#
	# tickets: list of ticket dicts
	# ticket_id: ticket_id we're looking for
	#
	# returns ticket dict if found, else None
	def _get_ticket(self,tickets,ticket_id):

		i = iter(ticket for ticket in tickets if ticket['ticket_id'] == ticket_id)

		ticket = None
		try:
			return next(i)
		except StopIteration:
			return None
		finally:
			del i

	# get the total across all tickets
	#
	# tickets: list of ticket dicts
	# debug:   print the following info whilst summing
	#  - for each ticket: ticket_id, time
	#  - total time when completed
	#
	# returns datetime object containing the total time (convenience)
	def _get_total_time(self,tickets,debug=False):

		total_time = None

		for ticket in tickets:

			if debug:
				print ticket['ticket_id'], ticket['time']

			if ticket['time'] is not None:
				if total_time is None:
					total_time = ticket['time']
				else:
					total_time += ticket['time']

		if debug:
			print 'total_time:',total_time

		return total_time


# application specific error thrown by the ActivityStream
#
# Error codes: -1 - Default / unknown
#              -2 - Invalid username / Password
#              -3 - No activities found in stream
#
class ActivityStreamError(Exception):

	def __init__(self, message, code=-1):
		Exception.__init__(self, message)
		self.code = code
