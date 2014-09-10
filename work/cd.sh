#! /bin/bash

ics_version="0.1-SNAPSHOT"
conf_version="0.1-SNAPSHOT"

ics_tar_name="willhill-issuer_card_service-0.1-SNAPSHOT.tgz"
ics_tar_location="/home/shazleto/.m2/repository/com/openbet-willhill/issuer_card_service/willhill-issuer_card_service/0.1-SNAPSHOT/"

conf_tar_name="willhill-issuer_card_service_conf-0.1-SNAPSHOT.tgz"
conf_tar_location="/home/shazleto/.m2/repository/com/openbet-willhill/issuer_card_service/willhill-issuer_card_service_conf/0.1-SNAPSHOT/"

echo "Cleaning up.."
rm -rf $ics_tar_location
rm -rf $conf_tar_location

echo "Downloading ICS Artifact.."
mvn org.apache.maven.plugins:maven-dependency-plugin:LATEST:unpack -U -DoutputDirectory=/tmp -Dmdep.useBaseVersion=true -DremoteRepositories=http://artifactory.ci01.openbet/artifactory/openbet-repository -Dartifact=com.openbet-willhill.issuer_card_service:willhill-issuer_card_service:${ics_version}:tgz

echo "Downloading Conf Artifact.."
mvn org.apache.maven.plugins:maven-dependency-plugin:LATEST:unpack -U -DoutputDirectory=/tmp -Dmdep.useBaseVersion=true -DremoteRepositories=http://artifactory.ci01.openbet/artifactory/openbet-repository -Dartifact=com.openbet-willhill.issuer_card_service:willhill-issuer_card_service_conf:${conf_version}:tgz

echo "Deleting null.."
rm -rf null

scp ${ics_tar_location}/${ics_tar_name} openbet@brsux244.willhill:~/current
scp ${conf_tar_location}/${conf_tar_name} openbet@brsux244.willhill:~/current

ssh openbet@brsux244.willhill \
	"cd ~/current && \
	tar -xzvf ~/current/${ics_tar_name} && \
	tar -xzvf ~/current/${conf_tar_name} && \
	rm ~/current/${ics_tar_name} && \
	rm ~/current/${conf_tar_name} && \
	ob_control stop issuer_card_service && \
	sleep 2 && \
	ob_control start issuer_card_service && \
	ob_control log issuer_card_service"
