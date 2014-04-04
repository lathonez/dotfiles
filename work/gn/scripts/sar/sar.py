#! /usr/bin/python

from ConfigParser import SafeConfigParser
import datetime
import os
import re

class sar:

	def __init__(self):

		self.config = SafeConfigParser()
		self.config.read('sar.cfg')
		self.cpu  = []
		self.mem  = []
		self.swap = []
		self.load = []
		self.net  = []

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

		list = eval('self.' + list_name)
		sort_key = self.config.get('sar',list_name + '_sort').split(':')
		reverse = (sort_key[1] == "True")
		return sorted(list, key=lambda k: k[sort_key[0]], reverse=reverse) 
	
	# nicely format a list of dicts
	def print_dict_list(self,list):

		log_time = self.config.getboolean('sar','log_time')
		header = self._get_header_from_dict(list[0])
		lines  = [header]

		for dict in list:
			line = dict['hostname'] + ' '
			for col in dict.keys():
				if not log_time and col == 'time':
					continue
				if col == 'hostname':
					continue
				line += '| ' + str(dict[col]) + ' '
			lines.append(line)

		for line in lines:
			print line
			
	def _get_header_from_dict(self,dict):

		header = 'hostname '
		log_time = self.config.getboolean('sar','log_time')

		for col in dict.keys():
			if not log_time and col == 'time':
				continue
			if col == 'hostname':
				continue
			header += '| ' + col + ' '

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
		for col in cols:
			c = line.pop(0)
			if col == 'junk':
				continue
			if col == 'time':
				d[col] = self._parse_time(c)
				continue
			col, type = col.split(':')
			if type == 'int':
				d[col] = int(c)
				continue
			if type == 'float':
				d[col] = float(c)
				continue
			d[col] = c

		return d

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
	print('\nCPU:')
	sar.cpu = sar.sort_dict_list('cpu')
	sar.print_dict_list(sar.cpu)
	print('\nMEM:')
	sar.mem = sar.sort_dict_list('mem')
	sar.print_dict_list(sar.mem)
	print('\nSWAP:')
	sar.swap = sar.sort_dict_list('swap')
	sar.print_dict_list(sar.swap)
	print('\nLOAD:')
	sar.load = sar.sort_dict_list('load')
	sar.print_dict_list(sar.load)
	print('\nNET:')
	sar.net = sar.sort_dict_list('net')
	sar.print_dict_list(sar.net)

