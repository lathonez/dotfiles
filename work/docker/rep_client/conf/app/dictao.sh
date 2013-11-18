#!/bin/bash
# $Revision$

# What is the operator name
export operator=$1

if [ "$operator" = "" ]; then
	operator=SETME;
fi

# Are we on production or integration
export env=$2

if [ "$env" = "" ]; then
	env=INTG;
fi

# App specific settings
export VERSION=0.1
export D3SC_HOME=$(pwd)
export LOG_FOLDER=$OPENBETLOGDIR/dictao
export ENCODING="-Dfile.encoding=UTF8"

export D3SC_OPTS="-Djavax.net.ssl.keyStore=$D3SC_HOME/certs/${operator}/${operator}-${env}-01.p12 -Djavax.net.ssl.keyStorePassword=$(cat $D3SC_HOME/certs/${operator}/${env}-password) -Djavax.net.ssl.keyStoreType=PKCS12"
JVM_OPTS="-Djavax.net.ssl.trustStore=$D3SC_HOME/certs/${operator}/truststore.jks -Djavax.net.ssl.trustStoreType=JKS -Djavax.net.ssl.trustStorePassword=password"
# Uncomment this to send SOAP XML messages to stdout.
#JVM_OPTS="${JVM_OPTS} -Dcom.sun.xml.ws.util.pipe.StandaloneTubeAssembler.dump=true"
export JVM_OPTS
# Gabage collection logging.

# TODO - I guess this Xloggc thing is some lib
#export JAVA_OPTS="-Xloggc:$LOG_FOLDER/gc.log -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps"

# Create the log folder
if [ ! -d "$LOG_FOLDER" ]; then
	mkdir -p $LOG_FOLDER
fi

# TODO - why do we have to do this?
#11/18-17:47:50  [4] <24301> log4j:WARN No appenders could be found for logger (org.apache.commons.configuration.PropertiesConfiguration).
#11/18-17:47:50  [4] <24301> log4j:WARN Please initialize the log4j system properly.
#11/18-17:47:50  [4] <24301> log4j:WARN See http://logging.apache.org/log4j/1.2/faq.html#noconfig for more info.
#11/18-17:47:51  [4] <24301> Exception in thread "main" java.lang.NullPointerException
rm $LOG_FOLDER/dictao-logger.log

# Create the environment specific config
if [ ! -f "${PWD}/conf/environment.properties" ]; then
	ln -s $OB/setup/conf/app/dictao.properties ${PWD}/conf/environment.properties
fi

java $D3SC_OPTS $JVM_OPTS $JAVA_OPTS $ENCODING -jar target/openbet-spain-${VERSION}-SNAPSHOT-jar-with-dependencies.jar -operatorId $(echo $operator | tr '[A-Z]' '[a-z]')
