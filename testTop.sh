#!/bin/bash
# Directory to monitor
directory ='/home/chikenbalwa'
log_file ='/home/chikenbalwa/logfile.log'
#Ensuring the log file is there
touch $log_file
#Function to monitor filesystem
check_file(){
    local event=$1
    local file=$2
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $event - $file" >> $LOG_FILE
}

# Monitor the directory for changes
inotifywait -m -r -e create -e modify -e delete --format '%e %w%f' $MONITORED_DIR | while read event file; do
    handle_event "$event" "$file"
done

# Function to monitor disk space
check_disk_space() {
    echo "Disk Space Usage:"
    df -h | grep '^/dev/'
    echo "-----------------------"
}

# Function to monitor memory usage
check_memory_usage() {
    echo "Memory Usage:"
    free -h
    echo "-----------------------"
}

# Function to monitor CPU usage
check_cpu_usage() {
    echo "CPU Usage:"
    top -b -n1 | grep "Cpu(s)"
    echo "-----------------------"
}

# Main script loop
while true; do
    echo "System Monitoring - $(date)"
    echo "-----------------------"
    check_disk_space
    check_memory_usage
    check_cpu_usage
    echo "Press [Ctrl+C] to stop monitoring."
    sleep 10 # Wait for 10 seconds before refreshing
done

