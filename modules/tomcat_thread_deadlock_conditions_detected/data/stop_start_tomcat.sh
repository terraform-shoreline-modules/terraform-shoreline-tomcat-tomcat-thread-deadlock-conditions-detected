bash

#!/bin/bash



# Stop Tomcat

sudo systemctl stop tomcat.service



# Wait for Tomcat to stop

while [ "$(sudo systemctl is-active tomcat.service)" == "active" ]

do

  sleep 5

done



# Start Tomcat

sudo systemctl start tomcat.service