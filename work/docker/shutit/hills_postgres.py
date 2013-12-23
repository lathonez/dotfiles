from shutit_module import ShutItModule
import util

# Hills specific stuff to do on top of a postgres install
class hills_postgres(ShutItModule):

	def is_installed(self,config_dict):

		container_child = util.get_pexpect_child('container_child')

		# use JDBC to check for installation
		return util.file_exists(container_child,'/usr/lib/postgresql/postgresql-9.1-903.jdbc4.jar',config_dict['expect_prompts']['root_prompt'])

	def build(self,config_dict):

		# postgres version
		v = config_dict['com.openbet.openbet_builder.postgres']['version']

		container_child = util.get_pexpect_child('container_child')

		# make the /database directory and own it
		util.send_and_expect(container_child,'mkdir /database',config_dict['expect_prompts']['root_prompt'])
		util.send_and_expect(container_child,'chown openbet:openbet /database',config_dict['expect_prompts']['root_prompt'])
		
		# switch to postgres and create the openbet superuser role
		util.send_and_expect(container_child,'sudo su - postgres',config_dict['expect_prompts']['postgres_prompt'])
		util.send_and_expect(container_child,'echo "create role openbet with login;" | psql postgres',config_dict['expect_prompts']['postgres_prompt'])
		util.send_and_expect(container_child,'echo "alter role openbet with superuser;" | psql postgres',config_dict['expect_prompts']['postgres_prompt'])
		util.send_and_expect(container_child,'exit',config_dict['expect_prompts']['root_prompt'])

		# add password authentication for dbpublish
		util.add_line_to_file(container_child,'local all dbpublish password','/etc/postgresql/' + v + '/main/pg_hba.conf',config_dict['expect_prompts']['root_prompt'],force=True)
	
		# we need this locale generating
		util.send_and_expect(container_child,'locale-gen en_US.UTF-8',config_dict['expect_prompts']['root_prompt'])

		# symlink pg_ctl
		util.send_and_expect(container_child,'ln -s /usr/lib/postgresql/' + v + '/bin/pg_ctl /usr/bin/pg_ctl',config_dict['expect_prompts']['root_prompt'])

		# grab the JDBC driver
		util.send_and_expect(container_child,'cd /usr/lib/postgresql/' + v + '/lib',config_dict['expect_prompts']['root_prompt'])
		util.send_and_expect(container_child,'wget http://jdbc.postgresql.org/download/postgresql-9.1-903.jdbc4.jar',config_dict['expect_prompts']['root_prompt'])

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
		cp = config_dict['config_parser']
		config_dict['com.openbet.openbet_builder.postgres']['version'] = cp.get('com.openbet.openbet_builder.postgres','version')
		config_dict['expect_prompts']['postgres_prompt']               = '.*postgres@' + config_dict['container']['hostname'] + '.*:'
		return True

obj = hills_postgres('com.openbet.openbet_builder.hills_postgres',100318949455001)
obj.add_dependency('com.openbet.setup')
obj.add_dependency('com.openbet.openbet_builder.postgres')
util.get_shutit_modules().append(obj)
ShutItModule.register(hills_postgres)

