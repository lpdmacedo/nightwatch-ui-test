FROM mercadolibre/grails:latest

####### GRAILS #########

#Define here your Grails version.
ENV GRAILS_VERSION=2.4.5

#Defines grails options for execution
#ENV GRAILS_OPTS_RUN="-https"

#Defines grails options in general
#ENV GRAILS_OPTS=""

#######  MOCKS #########

#Defines a custom location where your mocks are located. 'mocks' is the default folder.
#ENV MOCKS_FOLDER="my_mocks_folder"

#Specifies if mocks should be started on 'fury run'
#ENV MOCKS_START_ON_FURY_RUN="true"

#Specifies if mocks should be started on 'fury test'
#ENV MOCKS_START_ON_FURY_TEST="false"

ADD ./commands/test.sh /commands/test.sh

RUN chmod -R 777 /commands