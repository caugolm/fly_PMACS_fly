#!/bin/bash

if [[ $# -lt 2 ]] ; then
	echo "USAGE ./wrap_export_convert_bids_upload.sh <sub,ses.csv> <config_file> <opt: exclude quarantine>"
	echo "See setting_up_your_config_file.md for details on how to set up your config_file"
	echo "This script will loop through a csv of INDDID,session to run the conveniently named export_convert_bids_upload.sh"
	echo "export_convert_bids_upload.sh exports dicoms from flywheel, convert dicoms to nifti, BIDSify and then upload the BIDS files back to flywheel"
	echo "opt: exclude quarantine: default 0: export all dicoms. if 1, then ignores dicoms with the 'Quarantine' file tag. Useful for when choosing one of a repeated or useless acquisition"
	echo "" 
	exit 1
fi

subjlist=$1
config_file=$2

if [[ $3 == "" || $3 == 0 ]] ; then 
	exclude_quarantine=0
elif [[ $3 == 1 ]] ; then 
	exclude_quarantine=1
else 
	echo "exclude_quarantine must be 0 or 1...exiting"
	exit 1
fi

echo "Using subject list: ${subjlist}"
echo "Using config file: ${config_file}"
echo "-------------------------------"
echo "Your config file has variables set as follows:"
cat $config_file
echo "-------------------------------"
echo "exclude_quarantine is set to: ${exclude_quarantine}"
source $config_file
echo "-------------------------------"


for i in `cat $subjlist` ; do
	subj=`echo "$i" | cut -f1 -d ','`
    sess=`echo "$i" | cut -f2 -d ','`
	cmd="${scripts_dir}/export_convert_bids_upload.sh ${subj} ${sess} ${config_file} ${exclude_quarantine}"
	echo "Running ${cmd}"
	echo "Log will be saved to ${log_path}/sub-${subj}_ses-${sess}_log.txt"
	$cmd | tee ${log_path}/sub-${subj}_ses-${sess}_log.txt
done    
	