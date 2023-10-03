resource "shoreline_notebook" "tomcat_thread_deadlock_conditions_detected" {
  name       = "tomcat_thread_deadlock_conditions_detected"
  data       = file("${path.module}/data/tomcat_thread_deadlock_conditions_detected.json")
  depends_on = [shoreline_action.invoke_detect_deadlocks,shoreline_action.invoke_jvm_deadlock_check,shoreline_action.invoke_stop_start_tomcat,shoreline_action.invoke_update_thread_pool]
}

resource "shoreline_file" "detect_deadlocks" {
  name             = "detect_deadlocks"
  input_file       = "${path.module}/data/detect_deadlocks.sh"
  md5              = filemd5("${path.module}/data/detect_deadlocks.sh")
  description      = "Check the number of idle threads"
  destination_path = "/agent/scripts/detect_deadlocks.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "jvm_deadlock_check" {
  name             = "jvm_deadlock_check"
  input_file       = "${path.module}/data/jvm_deadlock_check.sh"
  md5              = filemd5("${path.module}/data/jvm_deadlock_check.sh")
  description      = "Incorrect synchronization of threads leading to deadlock."
  destination_path = "/agent/scripts/jvm_deadlock_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "stop_start_tomcat" {
  name             = "stop_start_tomcat"
  input_file       = "${path.module}/data/stop_start_tomcat.sh"
  md5              = filemd5("${path.module}/data/stop_start_tomcat.sh")
  description      = "Restart Tomcat: This is the most common solution to fix the thread deadlock conditions. Restarting Tomcat forces all threads to stop and start fresh."
  destination_path = "/agent/scripts/stop_start_tomcat.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_thread_pool" {
  name             = "update_thread_pool"
  input_file       = "${path.module}/data/update_thread_pool.sh"
  md5              = filemd5("${path.module}/data/update_thread_pool.sh")
  description      = "Increase Thread Pool Size: A deadlock can occur when there are not enough threads available to execute requests. Increasing the size of the thread pool can help avoid deadlock conditions."
  destination_path = "/agent/scripts/update_thread_pool.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_detect_deadlocks" {
  name        = "invoke_detect_deadlocks"
  description = "Check the number of idle threads"
  command     = "`chmod +x /agent/scripts/detect_deadlocks.sh && /agent/scripts/detect_deadlocks.sh`"
  params      = ["PID_OF_TOMCAT","PATH_TO_TOMCAT"]
  file_deps   = ["detect_deadlocks"]
  enabled     = true
  depends_on  = [shoreline_file.detect_deadlocks]
}

resource "shoreline_action" "invoke_jvm_deadlock_check" {
  name        = "invoke_jvm_deadlock_check"
  description = "Incorrect synchronization of threads leading to deadlock."
  command     = "`chmod +x /agent/scripts/jvm_deadlock_check.sh && /agent/scripts/jvm_deadlock_check.sh`"
  params      = []
  file_deps   = ["jvm_deadlock_check"]
  enabled     = true
  depends_on  = [shoreline_file.jvm_deadlock_check]
}

resource "shoreline_action" "invoke_stop_start_tomcat" {
  name        = "invoke_stop_start_tomcat"
  description = "Restart Tomcat: This is the most common solution to fix the thread deadlock conditions. Restarting Tomcat forces all threads to stop and start fresh."
  command     = "`chmod +x /agent/scripts/stop_start_tomcat.sh && /agent/scripts/stop_start_tomcat.sh`"
  params      = []
  file_deps   = ["stop_start_tomcat"]
  enabled     = true
  depends_on  = [shoreline_file.stop_start_tomcat]
}

resource "shoreline_action" "invoke_update_thread_pool" {
  name        = "invoke_update_thread_pool"
  description = "Increase Thread Pool Size: A deadlock can occur when there are not enough threads available to execute requests. Increasing the size of the thread pool can help avoid deadlock conditions."
  command     = "`chmod +x /agent/scripts/update_thread_pool.sh && /agent/scripts/update_thread_pool.sh`"
  params      = ["NEW_THREAD_POOL_SIZE","PATH_TO_SERVER_XML","PATH_TO_TOMCAT_HOME"]
  file_deps   = ["update_thread_pool"]
  enabled     = true
  depends_on  = [shoreline_file.update_thread_pool]
}

