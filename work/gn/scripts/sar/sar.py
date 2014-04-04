#! /usr/bin/python

from ConfigParser import *
import datetime, os, re, sys

class sar:

	def __init__(self):

		self.config = SafeConfigParser()
		self.config.read('sar.cfg')

		self.cpu  = []
		self.mem  = []
		self.swap = []
		self.load = []
		self.net  = []

		self.do_highlight = sys.stdout.isatty()
		# some colours for logging
		self.colours = {
			'black': '30',
			'red': '31',
			'green': '32',
			'yellow': '33',
			'blue': '34',
			'pink': '35',
			'cyan': '36',
			'white': '37'
		}

	def read_logs(self):

		filenames = []
		logs      = {}
		current   = self._get_current()
		log_dir   = self.config.get('sar','log_dir')

		for file in os.listdir(log_dir):
			if file.endswith(current):
				filenames.append(file)

		for fn in filenames:

			box = fn[:8]
			fh = open(log_dir + '/' + fn, 'r')
			try:
				content = fh.read()
			finally:
				fh.close()

			logs[box] = content

		return logs

	# go over the logs and build up the different metric dicts
	def parse_logs(self,logs):

		for box in logs.keys():

			# store the last line for each match
			cl = ''
			ml = ''
			sl = ''
			ll = ''
			nl = ''

			lines = logs[box].split('\n')

			# get the last relevant line
			for line in lines:
				if line.find('<CPU>') > -1:
					cl = line
					continue
				if line.find('<Memory>') > -1:
					ml = line
					continue
				if line.find('<Swap>') > -1:
					sl = line
					continue
				if line.find('<LoadAvg>') > -1:
					ll = line
					continue
				if line.find('<NetNFS>') > -1:
					nl = line
					continue

			self.cpu.append(self._parse_line('cpu',cl,box))
			self.mem.append(self._parse_line('mem',ml,box))
			self.swap.append(self._parse_line('swap',sl,box))
			self.load.append(self._parse_line('load',ll,box))
			self.net.append(self._parse_line('net',nl,box))

	# sort the parsed dict list according to the configured value
	def sort_dict_list(self,list_name):

		d = {
			'list': eval('self.' + list_name),
			'sort_key': self.config.get('sar',list_name + '_sort').split(':'),
			'self': self
		}
		d['reverse'] = (d['sort_key'][1] == "True")

		exec('self.' + list_name + ' = sorted(list, key=lambda k: k[sort_key[0]], reverse=reverse)',d)
	
	# nicely format a list of dicts
	def print_dict_list(self,type):

		list = eval('self.' + type)

		log_time  = self.config.getboolean('sar','log_time')
		log_check = self.config.getboolean('sar','log_check')
		skips     = ['hostname','time','warnings','dangers']
		header    = self._get_header_from_dict(list[0],type)

		if log_check:
			header.insert(0,type.upper())

		lines = [header]

		for dict in list:
			line = []
			if log_check:
				line.append(type.upper())
			line.append(dict['hostname'])
			if log_time:
				line.append(self._col_to_str(dict['time']))
			for col in dict.keys():
				if col in skips:
					continue

				str = self._col_to_str(dict[col])

				# this is dirt
				if col in dict['dangers']:
					str = 'D|' + str
				elif col in dict['warnings']:
					str = 'W|' + str
				
				line.append(str)

			lines.append(line)

		# now we've got a list containing each line, which itself is a list of items
		w = self._get_max_col_width(lines)

		i = 0
		for line in lines:
			j = 0

			# print header sep
			if i == 1:
				l = '+'
				for col in line:
					l += '-' * (w[j]+2)
					l += '+'
					j += 1
				i += 1
				j = 0
				print l

			l = '| '
			for col in line:
				l += self._highlight_align(col,w[j])
				l += ' | '
				j += 1
			print l
			i += 1

	# helper function to get the column index for a given column
	def _get_col_index(self,col,header):
		skips = set(['hostname','time','warnings','dangers'])
		header = set(header) - skips
		return header.index(col)

	# give the accurate string length, stripping our hacky markings out
	def _get_str_len(self,str):

		marked = False
		if str.find('D|') > -1 or str.find('W|') > -1:
			marked = True

		l = len(str)
		if marked:
			l -= 2

		return l

	# http://stackoverflow.com/questions/2330245/python-change-text-color-in-shell
	def _highlight_align(self,str,width):

		colour = None

		# strip out the marker and decide which colour to chose as a matter of course
		if str.find('D|') > -1:
			str = str.replace('D|','')
			colour = 'red'
			bold   = True

		if str.find('W|') > -1:
			str = str.replace('W|','')
			colour = 'yellow'
			bold   = True

		str = str.ljust(width)

		if not self.do_highlight or colour is None:
			return str

		attr = []
		attr.append(self.colours[colour])

		if bold:
			attr.append('1')

		return '\x1b[%sm%s\x1b[0m' % (';'.join(attr), str)

	# turn an output columns into a string
	def _col_to_str(self,col):

		if type(col) is datetime.datetime:
			return col.strftime('%H:%M')

		# assume large ints are KB and convert to GB
		if self.config.getboolean('sar','round_kb') and type(col) is int and col > 1000000:
			return "%.2f" % (float(col)/1024/1024)

		if type(col) is float:
			return "%.2f" % (float(col))

		return str(col)

	# for a list of lines input, return the maximum column width of each column
	def _get_max_col_width(self,lines):

		col_width = []

		# pad with 0
		for col in lines[0]:
			col_width.append(0)

		for line in lines:
			i = 0
			for col in line:
				l = self._get_str_len(col)
				if l > col_width[i]:
					col_width[i] = l
				i += 1

		return col_width

	# return a list of the header columns
	def _get_header_from_dict(self,dict,type):

		header   = ['hostname']
		log_time = self.config.getboolean('sar','log_time')
		skips    = ['hostname','time','warnings','dangers']

		if log_time:
			header.append('time')

		s,r = self.config.get('sar',type + '_sort').split(':')

		for col in dict.keys():
			if col in skips:
				continue
			if s == col:
				col += '*'
			header.append(col)

		return header

	# parse a log line and add it to the appropraite dict
	#
	# type - what kind of line is this
	# line - the actual line contents
	# box  - boxname
	def _parse_line(self,type,line,box):
		p = re.compile(r'\s+')
		line = re.sub(p, ' ', line).split(' ')
		cols = self.config.get('sar',type + '_cols').split('|')
		cols.insert(0,'time')
		cols.insert(0,'junk')
		cols.insert(0,'junk')

		d = {}
		d['hostname'] = box
		d['warnings'] = []
		d['dangers']  = []

		# for load we add a spoof column for the la/core calc
		line.append(None)

		for col in cols:
			c = line.pop(0)
			if col == 'junk':
				continue
			if col == 'time':
				d[col] = self._parse_time(c)
				continue
			col, datatype = col.split(':')

			# need to derive this from the load_average
			if col == 'la/core':
				cores = self.config.getint('sar', box + '_cores')
				c = d['load_avg'] / cores

			# check for breaching warning or error threshold
			if datatype == 'int' or datatype == 'float':
				warning = self._check_threshold(type,col,c,'W',box)
				danger  = self._check_threshold(type,col,c,'D',box)
				if danger:
					d['dangers'].append(col)
				if warning:
					d['warnings'].append(col)
			if datatype == 'int':
				d[col] = int(c)
				continue
			if datatype == 'float':
				d[col] = float(c)
				continue
			d[col] = c

		return d

	# check whether or not a value has breached the error/warning threshold for a given column
	#
	# type   - cpu
	# column - %idle
	# value  - 20
	# mode   - (W)arning|(D)anger
	# box    - what box are we on
	#
	# returns True if the threshold has been breached, else false
	def _check_threshold(self,type,column,value,mode,box):

		thres_type = 'danger'

		if mode == 'D':
			thres_type = 'danger'
		if mode == 'W':
			thres_type = 'warning'

		try:
			# grab the thresholds for this type	
			threspl = self.config.get('sar',type + '_' + thres_type).split('|')
		except NoOptionError, e:
			return False

		for t in threspl:

			col, threshold, direction = t.split(':')

			if col != column:
				continue

			if direction == 'lower':
				if float(value) < float(threshold):
					return True
			else:
				if float(value) > float(threshold):
					return True

		return False
	
	# returns python datetime from sar time string: 04/04-03:50
	def _parse_time(self,str):

		for s in ['/','-',':']:
			str = str.replace(s,' ')

		spl = str.split(' ')
		spl.insert(0,datetime.datetime.now().strftime('%Y'))

		# now we've got (year month day hour minute)
		return datetime.datetime(*map(int,spl))

	# return the current date string for grabbing a log file
	# 20140406_12
	def _get_current(self):
		now = datetime.datetime.now()
		n = now.timetuple()

		# get the previous hour's logs if necessary
		if (n.tm_min <= self.config.getint('sar','prev_min')):
			now = now - datetime.timedelta(hours=1)

		return now.strftime('%Y%m%d_%H')

if __name__ == "__main__":

	sar = sar()
	logs = sar.read_logs()
	sar.parse_logs(logs)

	for check in ['load','cpu','mem','swap','net']:
		sar.sort_dict_list(check)
		sar.print_dict_list(check)
		print ''

