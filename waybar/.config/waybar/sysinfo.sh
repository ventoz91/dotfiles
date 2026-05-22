#!/bin/bash

#CPU usage

cpu=$(grep 'cpu ' /proc/stat)
sleep 0.1
cpu2=$(grep 'cpu ' /proc/stat)

cpu_idle1=$(echo $cpu | awk '{print $5}')
cpu_idle2=$(echo $cpu2 | awk '{print $5}')

cpu_total1=$(echo $cpu | awk '{sum=0; for(i=2;i<=NF;i++) sum+=$i; print sum}')
cpu_total2=$(echo $cpu2 | awk '{sum=0; for(i=2;i<=NF;i++) sum+=$i; print sum}')

cpu_usage=$((100 * ( (cpu_total2-cpu_total1) - (cpu_idle2-cpu_idle1) ) / (cpu_total2-cpu_total1) ))

# Memory
mem_used=$(free -h | awk '/Mem:/ {print $3}')
mem_total=$(free -h | awk '/Mem:/ {print $2}')

# Temp (works on most systems)
temp=$(sensors 2>/dev/null | awk '/Tctl|Package id 0|temp1/ {print $2; exit}')

# Output
echo "{\"text\": \"CPU ${cpu_usage}% | RAM ${mem_used}\", \"tooltip\": \"CPU: ${cpu_usage}%\\nRAM: ${mem_used}/${mem_total}\\nTemp: ${temp}\"}"
