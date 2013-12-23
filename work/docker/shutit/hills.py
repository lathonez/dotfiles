from shutit_module import ShutItModule
import util

# Hills specific misc stuff
class hills(ShutItModule):

	def is_installed(self,config_dict):

		# atm we'd have to grep for this line in /etc/sudoers. Later on there will be something more straightforward to check for
		return False

	def build(self,config_dict):

		container_child = util.get_pexpect_child('container_child')

		# give ourselves passwordless permission for stuff as the openbet user
		# apache2ctl
		util.add_line_to_file(container_child,'openbet ALL = NOPASSWD: /usr/sbin/apache2ctl','/etc/sudoers',config_dict['expect_prompts']['root_prompt'],force=True)

		return True

	def start(self,config_dict):
		return True

	def stop(self,config_dict):
		return True

	def cleanup(self,config_dict):
		return True

	def finalize(self,config_dict):
		return True

	def remove(self,config_dict):
		return True

	def test(self,config_dict):
		return True

	def get_config(self,config_dict):
		# cp = config_dict['config_parser']
		# config_dict['com.openbet.openbet_builder.postgres']['version'] = cp.get('com.openbet.openbet_builder.postgres','version')
		# config_dict['expect_prompts']['postgres_prompt']               = '.*postgres@' + config_dict['container']['hostname'] + '.*:'
		return True

obj = hills('com.openbet.openbet_builder.hills',100318949470001)
obj.add_dependency('com.openbet.setup')
obj.add_dependency('com.openbet.openbet_builder.appserv')
util.get_shutit_modules().append(obj)
ShutItModule.register(hills)

