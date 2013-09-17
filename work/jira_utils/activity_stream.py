from ConfigParser import SafeConfigParser
from utils        import HTTPUtils
import feedparser

class ActivityStream():

	def __init__ (self):

		# read the conf
		self.config = SafeConfigParser()
		self.config.read('activity_stream.cfg')
		self.http_utils = HTTPUtils(self.config)

	# username: 
	# password: 
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

		resp = self.http_utils.do_req(
			url=url,
			data=request_params,
			post=False,
			username=username,
			password=password,
			url_encode=False
		)

		print 'get_stream: Stream received from Jira, parsing..'

		stream = feedparser.parse(resp['response_string'])

		return stream

	def print_stream(self, stream):

		for entry in stream.entries:

			print 'title: {0}, date: {1}'.format(
				entry.title,
				entry.published
			)

	# parse the stream:
	#  - pull out relevant entries
	#  - sum the time up
	#
	# day:   day of the month (e.g. 26)
	# month: month of the year (e.g. 09)
	def _parse_stream(self, stream, day, month):

		fn      = '_parse_stream:'
		day     = int(day)
		month   = int(month)
		events  = []
		tickets = TicketList()

		for entry in stream.entries:

			e_day = int(entry.published_parsed.tm_mday)
			e_month = int(entry.published_parsed.tm_mon)

			if day == e_day and month == e_month:

				events.append(entry)

		if not len(events):
			raise ActivityStreamError('No events found')

		print fn,len(events),'events found'

		for event in events:

			try:
				# temp ticket to test with
				t = Ticket(self.config, event)
			except ActivityStreamError as e:
				# we've got a random event like 'linked two tickets', ignore
				if str(e).find('ticket id found in'):
					print fn,'skipping event @',event.published
					continue
				else:
					raise e

			# only unique tickets will be added
			tickets.add(t)

		tickets.print_ids()

	# pretend we're getting some input from web form
	def spoof_request(self):

		username = self.config.get('user','username')
		password = self.config.get('user','password')
		day      = self.config.get('user','day')
		month    = self.config.get('user','month')

		stream = self.get_stream(username, password)
		self._parse_stream(stream, day, month)


class ActivityStreamError(Exception):

	def __init__(self, message):

		Exception.__init__(self, message)


# Unique list of tickets
class TicketList():

	def __init__(self):

		self.tickets = []

	# Adds this ticket to the list if one doesn't already exist with the same id
	# t - an instance of Ticket
	def add(self,t):

		if not self.has(t):
			self.tickets.append(t)
			return True

		return False

	# Checks whether or not a ticket with the same id exists in the list
	# t - an instance of Ticket
	def has(self,t):

		for ticket in self.tickets:
			if ticket.ticket_id == t.ticket_id:
				return True

		return False

	def print_ids(self):
		for ticket in self.tickets:
			print ticket.ticket_id


import re, ConfigParser
# represents a single Jira ticket:
class Ticket():

	# entry:  raw activity stream entry, will be parsed into the ticket object
	# config: parsed config file
	def __init__(self, config, entry):

		self.config      = config
		td               = self._parse_title_detail(entry.title_detail.value)
		self.project     = td['project']
		self.ticket_id   = self.project + '-' + td['ticket_id']
		self.tenrox_code = self._get_tenrox_code(self.project)

	# returns dict containing:
	# project (JEN)
	# ticket_id (JEN-10308)
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

	def _get_tenrox_code(self, project):

		try:
			code = self.config.get('tenrox_codes',project)
		except ConfigParser.NoOptionError:
			code = project + '300'

		return code



def main(args=None):

	print 'Running jira'
	activity_stream = ActivityStream()
	activity_stream.spoof_request()

if __name__ == '__main__':
	main()

