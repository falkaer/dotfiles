#!/bin/bash

# always start julia with all threads
export JULIA_NUM_THREADS=$(grep -c ^processor /proc/cpuinfo)