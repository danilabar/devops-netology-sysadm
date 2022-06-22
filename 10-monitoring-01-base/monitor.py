#!/usr/bin/env python3

import json
import os
import datetime
import time

day = datetime.datetime.today().today().strftime("%Y-%m-%d")
log_path = "/var/log/metrics"
file_name = day + "-awesome-monitoring.log"
unix_time = time.time_ns()

metrics = []

with open("/proc/loadavg") as file:
    cpu_load = file.read().split(' ')[0]

with open("/proc/meminfo") as file:
    for mem in file.readlines():
        if mem.startswith("MemAvailable:"):
            mem_available = mem.split(':')[1].lstrip().split(' ')[0]
        elif mem.startswith("SwapFree:"):
            swap_free = mem.split(':')[1].lstrip().split(' ')[0]
        elif mem.startswith("Active:"):
            mem_active = mem.split(':')[1].lstrip().split(' ')[0]


metrics_dict = {"timestamp": unix_time, "cpu_load": cpu_load, "mem_available": mem_available,
                "swap_free": swap_free, "mem_active": mem_active}

if not os.path.isdir(log_path):
    os.mkdir(log_path)

if os.path.isfile(log_path + "/" + file_name):
    with open(log_path + "/" + file_name, "r") as f:
        metrics = json.load(f)

metrics.append(metrics_dict)

with open(log_path + "/" + file_name, "w") as f:
    f.write(json.dumps(metrics))
