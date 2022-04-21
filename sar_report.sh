#!/usr/bin/bash

echo "Enter server name:"
server=$(hostname | awk -F "." '{print $1}')
mkdir "${server}_sar_report"
echo "Enter the dates(comma seprated) for which the sar report is required (e.g 01,02,18,22): "
read dates
IFS="," read -r -a date_array <<< "$dates"
echo "Enter the options(comma separated) for the report that are require (e.g q,u,r for cpu load, cpu details, memory):"
echo "A: Combined report. Equivalent to -bBdHqrRSuvwWy -I SUM -I XALL -m ALL -n ALL -u ALL -P ALL"
echo "B: Report Paging statistics"
echo "b: I/O and transfer statistics" 
echo "q: CPU load average"
echo "r: Memory details"
echo "u: CPU details"
read report_option
IFS="," read -r -a options_array <<< "$report_option"
for i in "${date_array[@]}"
do
	mkdir "${server}_sar_report/${server}_${i}_sar_report"
	
	for j in "${options_array[@]}"
	do
		if [ $j == "q" ]
		then
			file_name="${server}_cpu_load.txt"
		elif [ $j == "u" ]
		then
			file_name="${server}_cpu_details.txt"
		elif [ $j == "r" ]
		then
			file_name="${server}_memory_details.txt"
		elif [ $j == "b"]
		then
			file_name="${server}_io_stats.txt"
		elif [ $j == "d" ]
		then
			file_name="${server}_block_device.txt"
		elif [ $j == "A" ]
		then
			file_name="${server}_combined.txt"
		elif [ $j == "B" ]
		then
			file_name="${server}_paging_stats.txt"
		fi

		echo $(sar -f /var/log/sa/sa${i} -${j} > ${server}_sar_report/${server}_${i}_sar_report/${file_name})
	
	done
done

