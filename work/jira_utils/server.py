from activity_stream import *
from ConfigParser    import SafeConfigParser
import web, sys

# globals
render = None
config = None

class index:

	def GET(self):

		data = web.input()
		msg = None

		try:
			msg = data.msg
		except AttributeError:
			pass

		if msg is not None:
			msg = ActivityStreamError.ERROR_CODES[msg]

		return render.index(msg)

class jtime:

	def POST(self):

		data = web.input()

		act = ActivityStream(config)

		try:
			date_spl = data.date.rsplit('/')
			tickets = act.do_activity_stream(
				data.username,
				data.password,
				date_spl[0],
				date_spl[1]
			)
		except ActivityStreamError as e:
			print e.message
			if e.code == 'BAD_USER' or e.code == 'NO_ACTIVITIES':
				web.seeother('/?msg=' + e.code)
				return

		return render.jtime(tickets)

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
