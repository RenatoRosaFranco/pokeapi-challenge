APP 		  = pokemon-api
DCMP 		  = docker-compose
TEST_CONFIG   = ${DCMP} -f docker-compose.yml
DCMP_EXEC_APP = ${TEST_CONFIG} exec ${APP}
DCMP_RUN_APP  = ${TEST_CONFIG} run ${APP}
DCMP_TEST     = @[ "$(BUILD)" = "dev" ] && ${TEST_CONFIG}

BUNDLE 		  = bundle exec
RAILS  		  = ${BUNDLE} rails

#==================================================================================================#
# DEV																						   	   #
#==================================================================================================#
# There are some plug n play commands for using on development									   #
#==================================================================================================#

# [✓]
up:
	${DCMP_TEST} up || ${DCMP} up

# [✓]
down:
	${DCMP_TEST} down || ${DCMP} down

# [✓]
bash:
	${DCMP_EXEC_APP} bash

# [✓]
console:
	${DCMP_EXEC_APP} rails c

# [✓]
start:
	RAILS_ENV=development bash ./server.sh

# [✓]
clean:
	sudo chown -R ${USER}:${USER} .
	rm -rf ./coverage ./tmp/* ./log/*

# [✓]
docker-dbrebuild:
	${DCMP_RUN_APP} ${RAILS} db:drop db:create db:migrate db:seed

#==================================================================================================#
# ENV																					   	   	   #
#==================================================================================================#
# There are some plug n play commands for using to env											   #
#==================================================================================================#

# [✓]
create-env-file:
	cp .env.sample .env

#==================================================================================================#
# DEV																						   	   #
#==================================================================================================#
# There are some plug n play commands for using to database									       #
#==================================================================================================#

# [✓]
dbcreate:
	${RAILS} db:create

# [✓]
dbrenew:
	${RAILS} db:drop db:create db:migrate db:test:prepare

# [✓]
dbreset:
	${RAILS} db:drop db:create db:migrate db:seed db:test:prepare

# [✓]
rebuild:
	${DCMP_TEST} up --build || ${DCMP} up

#==================================================================================================#
# TEST																				   	  		   #
#==================================================================================================#
# There are some plug n play commands to using for test									   		   #
#==================================================================================================#

# [✓]
test:
	- bash -c "source ./finder.sh && ./build.sh"
	- rake coverage:report

#==================================================================================================#
# CI																					   	       #
#==================================================================================================#
# There are some plug n play commands to using for CI									   		   #
#==================================================================================================#

# [✓]
install:
	gem install bundler
	bundle lock --add-platform x86_64-linux ruby x86-mingw32 x86-mswin32 x64-mingw32 java
	bundle install

# [✓]
overcommit:
	overcommit -i
	overcommit --sign pre-commit
	overcommit -r

# [✓]
gems-renew:
	gem uninstall -aIx
	sudo apt autoremove
	make install

#==================================================================================================#
# SUPPORT																					   	   #
#==================================================================================================#
# There are some plug n play commands to using for support										   #
#==================================================================================================#

# [✓]
credentials:
	EDITOR=vim ${RAILS} credentials:edit

#==================================================================================================#
# QUALITY																					   	   #
#==================================================================================================#
# There are some plug n play commands to using for quality										   #
#==================================================================================================#

# [✓]
fasterer:
	${BUNDLE} fasterer .

# [✓]
rubycritic:
	${BUNDLE} rubycritic .

# [✓]
best-practices:
	${BUNDLE} rails_best_practices .

# [✓]
brakeman:
	${BUNDLE} brakeman .

# [✓]
flog:
	${BUNDLE} flog .

# [✓]
rubocop:
	${BUNDLE} rubocop -A --only FrozenStringLiteralComment

# [✓]
rubocop-spec:
	${BUNDLE} -- require rubocop-rspec

define cp-file
	cp -vf config/$(1) $(2)/;
endef