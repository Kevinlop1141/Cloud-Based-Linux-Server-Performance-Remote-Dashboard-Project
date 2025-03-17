#!/bin/bash

# Check if stress is installed, install if not
if ! command -v stress &> /dev/null
then
  echo "stress is not installed. Installing now..."
  sudo apt-get update
  sudo apt-get install -y stress
  if [ $? -ne 0 ]; then
    echo "Failed to install stress. Exiting."
    exit 1
  fi
else
  echo "stress is already installed."
fi

# Get the number of CPU cores
NUM_CORES=$(nproc)

# Stress CPU and memory
echo "Stressing CPU with $NUM_CORES cores and allocating 1GB of memory..."
stress --cpu $NUM_CORES --vm 1 --vm-bytes 1G --timeout 60s

# Run stress to simulate heavy I/O and OS load
echo "Stressing I/O and OS..."
sudo stress --cpu "$NUM_CORES" --io "$NUM_CORES" --vm "$NUM_CORES" --vm-bytes 1G --hdd "$NUM_CORES" --hdd-bytes 1G --timeout 60s

# Configuration for stressing filesystem
TEST_FILE="stress_test_file.dat"
BLOCK_SIZE="1M"
DURATION="60" # seconds

# Create a test file and write to it repeatedly
start_time=$(date +%s)
end_time=$((start_time + DURATION))

while [ $(date +%s) -lt $end_time ]; do
    # Write to the file
    dd if=/dev/urandom of=$TEST_FILE bs=$BLOCK_SIZE count=1024 conv=fsync &> /dev/null
    
    # Read from the file
    dd if=$TEST_FILE of=/dev/null bs=$BLOCK_SIZE count=1024 &> /dev/null
    
    echo "$(date +%T): Wrote and read 1GB"
done

echo "Stress test completed."

# Cleanup (optional, remove the test file)
rm -f $TEST_FILE
