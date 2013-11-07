#!/bin/bash
# switch to rep_client's checkout directory
cd /opt/openbet/rep_client/OXi/services/repClient

# maven options
ulimit -v 4194304
export MAVEN_OPTS="-Xms32m -Xmx1024m"

# do the build
mvn install:install-file -Dfile=src/main/lib/ojdbc6_g.jar -DgroupId=com.oracle       -DartifactId=ojdbc   -Dversion=6_g      -DpomFile=pom.xml
mvn install:install-file -Dfile=src/main/lib/ifxjdbc.jar  -DgroupId=com.ibm.informix -DartifactId=ifxjdbc -Dversion=3.70.JC1 -DpomFile=pom.xml
