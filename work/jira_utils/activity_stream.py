from ConfigParser import SafeConfigParser
from utils        import HTTPUtils
import feedparser

class ActivityStream():

	def __init__ (self):

		# read the conf
		self.config = SafeConfigParser()
		self.config.read('activity_stream.cfg')
		self.http_utils = HTTPUtils(self.config)

	def get_stream(self):

		url      = self.config.get('app','base_url')
		auth     = self.config.get('app','auth_type')
		username = self.config.get('user','username')
		password = self.config.get('user','password')
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


def main(args=None):

	print 'Running jira'
	activity_stream = ActivityStream()
	stream = activity_stream.get_stream()
	activity_stream.print_stream(stream)

if __name__ == '__main__':
	main()

