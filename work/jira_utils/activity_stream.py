from ConfigParser import SafeConfigParser
from utils        import HTTPUtils

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

		resp_str = resp['response'].read()

		print 'get_stream: Response from Jira'
		print resp_str

def main(args=None):

	print 'Running jira'
	stream = ActivityStream()
	stream.get_stream()

if __name__ == '__main__':
	main()

