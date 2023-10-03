

#!/bin/bash



# Define variables

TOMCAT_HOME=${PATH_TO_TOMCAT_HOME}

SERVER_XML=${PATH_TO_SERVER_XML}

THREAD_POOL_SIZE=${NEW_THREAD_POOL_SIZE}



# Stop Tomcat

${TOMCAT_HOME}/bin/shutdown.sh



# Update server.xml with new thread pool size

sed -i "s/maxThreads=\"[0-9]*\"/maxThreads=\"$THREAD_POOL_SIZE\"/" $SERVER_XML


# Start Tomcat

sudo systemctl start tomcat.service