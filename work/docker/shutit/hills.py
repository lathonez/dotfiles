from shutit_module import ShutItModule
import util

# Hills specific misc stuff
class hills(ShutItModule):

	def is_installed(self,config_dict):

		container_child = util.get_pexpect_child('container_child')
		return util.file_exists(container_child,'/var/www/static',config_dict['expect_prompts']['root_prompt'])

	def build(self,config_dict):

		container_child = util.get_pexpect_child('container_child')

		# give ourselves passwordless permission for stuff as the openbet user
		# apache2ctl
		util.add_line_to_file(container_child,'openbet ALL = NOPASSWD: /usr/sbin/apache2ctl','/etc/sudoers',config_dict['expect_prompts']['root_prompt'],force=True)

		# create static directories
		util.send_and_expect(container_child,'mkdir -p /var/www/static',config_dict['expect_prompts']['root_prompt'])
		util.send_and_expect(container_child,'chown -R openbet:orbis /var/www/static',config_dict['expect_prompts']['root_prompt'])

		# clone the hills specific docker scripts/configs
		util.send_and_expect(container_child,'sudo su - openbet',config_dict['expect_prompts']['openbet_prompt'])
		util.send_and_expect(container_child,'git clone http://dev03.openbet/gitbucket/git/ahobsons/dockerutil.git',config_dict['expect_prompts']['openbet_prompt'])
		util.send_and_expect(container_child,'ln -s dockerutil/hills/setup_base.sh setup.sh',config_dict['expect_prompts']['openbet_prompt'])
		util.send_and_expect(container_child,'ln -s dockerutil/hills setup',config_dict['expect_prompts']['openbet_prompt'])
		util.send_and_expect(container_child,'exit',config_dict['expect_prompts']['root_prompt'])

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

