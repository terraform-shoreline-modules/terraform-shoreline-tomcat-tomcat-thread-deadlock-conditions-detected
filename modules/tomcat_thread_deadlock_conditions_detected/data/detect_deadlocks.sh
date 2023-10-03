${PATH_TO_TOMCAT}/bin/jstack ${PID_OF_TOMCAT} | grep "java.lang.Thread.State: WAITING (parking)"

# If the output shows a high number of WAITING threads, it could indicate a deadlock