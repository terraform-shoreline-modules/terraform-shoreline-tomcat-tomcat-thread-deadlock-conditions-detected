
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

#  Tomcat Thread Deadlock Conditions Detected
---

Thread deadlock conditions occur when two or more threads are blocked and waiting for each other to release a resource, causing a system to hang or become unresponsive. In the context of a Tomcat server, this could cause the server to stop responding to incoming requests. Detection of thread deadlock conditions on Tomcat is an indication of a critical issue that requires immediate attention to restore normal server operation.

### Parameters
```shell
export PID_OF_TOMCAT="PLACEHOLDER"

export PATH_TO_TOMCAT="PLACEHOLDER"

export PATH_TO_SERVER_XML="PLACEHOLDER"

export PATH_TO_TOMCAT_HOME="PLACEHOLDER"

export NEW_THREAD_POOL_SIZE="PLACEHOLDER"
```

## Debug

### Check the number of threads that Tomcat is currently running
```shell
ps aux | grep tomcat
```

### Check the number of idle threads
```shell
${PATH_TO_TOMCAT}/bin/jstack ${PID_OF_TOMCAT} | grep "java.lang.Thread.State: WAITING (parking)"

# If the output shows a high number of WAITING threads, it could indicate a deadlock
```

### Check the status of the Tomcat server
```shell
sudo systemctl status tomcat
```

### Check the server logs for errors related to thread deadlock
```shell
cat ${PATH_TO_TOMCAT}/logs/catalina.out | grep "deadlock"
```

### Check the current memory usage of Tomcat
```shell
jmap -heap ${PID_OF_TOMCAT}
```

### Check which threads are holding onto locks
```shell
${PATH_TO_TOMCAT}/bin/jstack ${PID_OF_TOMCAT} | grep -E "^\".*\".*$|^.*waiting on.*$"
```

### Incorrect synchronization of threads leading to deadlock.
```shell


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


```

## Repair

### Restart Tomcat: This is the most common solution to fix the thread deadlock conditions. Restarting Tomcat forces all threads to stop and start fresh.
```shell
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


```

### Increase Thread Pool Size: A deadlock can occur when there are not enough threads available to execute requests. Increasing the size of the thread pool can help avoid deadlock conditions.
```shell


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

```