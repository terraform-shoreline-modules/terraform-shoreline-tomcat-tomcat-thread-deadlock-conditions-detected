

#!/bin/bash



# Check if the JVM is running

if ! pgrep java >/dev/null 2>&1; then

    echo "JVM not running. Exiting."

    exit 1

fi



# Get the process ID of the Tomcat instance

tomcat_pid=$(ps aux | grep tomcat | grep -v grep | awk '{print $2}')



# Check if there are any deadlocked threads

deadlocked_threads=$(jstack $tomcat_pid | grep "java.lang.Thread.State: BLOCKED" | wc -l)



if [[ $deadlocked_threads -eq 0 ]]; then

    echo "No deadlocked threads found."

else

    echo "$deadlocked_threads deadlocked threads found."

    

    # Print information about the deadlocked threads

    jstack $tomcat_pid | grep "java.lang.Thread.State: BLOCKED" -A 1

fi