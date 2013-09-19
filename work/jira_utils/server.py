from activity_stream import *
from ConfigParser    import SafeConfigParser
import web, sys

# globals
render = None
config = None

class index:

	def GET(self):
		return render.index()

class jtime:

	def POST(self):

		data = web.input()

		act = ActivityStream(config)

		try:
			stream = act.get_stream(data.username, data.password)
		except ActivityStreamError as e:
			if e.code == -2:
				print 'Login to Jira failed: invalid username / password'
				web.seeother('/')
				return

		date_spl = date.rsplit('/')

		tickets = act.parse_stream(date_spl[0], date_spl[1])

		return 'HELLO!'

	# split dd/mm/yyyy into [day, month]
	def _split_date(self, date):

		spl = date.rsplit('/')

		return (spl[0],spl[1])

class Server():

	def __init__ (self):

		global config, render

		# read the conf
		config = SafeConfigParser()
		config.read('activity_stream.cfg')

		# grab the port and spoof command args
		port = config.get('app','port')
		sys.argv.append(port)

		# set up the urls we're going to serve
		self._set_urls()

		render = web.template.render('html/')

	def _set_urls(self):

		self.urls = (
			'/', 'index',
			'/doJTime', 'jtime'
		)

	def run(self):

		self.app = web.application(self.urls, globals())
		self.app.run()


if __name__ == "__main__":

	server = Server()
	server.run()
