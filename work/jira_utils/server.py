from activity_stream import *
from ConfigParser    import SafeConfigParser
import web, sys

class index:

	def GET(self):
		return render.index()

class Server():

	def __init__ (self):

		# read the conf
		self.config = SafeConfigParser()
		self.config.read('activity_stream.cfg')
		self.activity_stream = ActivityStream(self.config)

		# grab the port and spoof command args
		port = self.config.get('app','port')
		sys.argv.append(port)

		# set up the urls we're going to serve
		self._set_urls()

	def _set_urls(self):

		self.urls = (
			'/', 'index'
		)

	def run(self):

		self.app = web.application(self.urls, globals())
		self.app.run()


if __name__ == "__main__":

	render = web.template.render('html/')
	server = Server()
	server.run()
