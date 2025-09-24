#!/bin/bash

if [[ $# -lt 3 ]] ; then
    echo "USAGE: ./export_convert_bids_upload.sh <subID> <sessID> <config_file> <opt: exclude quarantine>"
	echo " config_file should at least have: path to config_file containing scripts_dir, vnav_parse_scripts_dir, dcm2bids_conda_path, dicom_base, exclude_quarantine_dicom_base, bids_base, flywheel_group, flywheel_project" 
	echo "See setting_up_your_config_file.txt for more details on how to set up your config_file"
   	echo "	opt: exclude quarantine: default 0: export all dicoms. if 1, then ignores dicoms with the 'Quarantine' file tag. Useful for when choosing one of a repeated or useless acquisition"
    exit 1
fi

# All steps for a single subject/session
subj=$1
sess=$2
config_file=$3 

source $config_file

echo Scripts Directory for main scripts: $scripts_dir
echo Path to dcm2bids conda environment: $dcm2bids_conda_path 

if [[ $overwrite == "True" ]] ; then
	echo "Overwriting existing data -- clearing previous data first"
	echo "Deleting: ${dicom_base}/${subj}/${sess} , ${bids_base}/tmp_dcm2bids/sub-${subj}_ses-${sess} , ${bids_base}/sub-${subj}/ses-${sess}"
	rm -rf ${dicom_base}/${subj}/${sess}
	rm -rf ${bids_base}/tmp_dcm2bids/sub-${subj}_ses-${sess} 
	rm -rf ${bids_base}/sub-${subj}/ses-${sess} 
fi

if [[ $4 == "" || $4 == 0 ]] ; then 
	exclude_quarantine="False"
    dicom_base=${dicom_base}
elif [[ $4 == 1 ]] ; then 
	exclude_quarantine="True"
    dicom_base=${exclude_quarantine_dicom_base}
else 
	echo "exclude_quarantine must be 0 or 1...exiting"
	exit 1
fi

echo "Using python version: 3.11"
module unload python
module load python/3.11

# Export dicoms from flywheel:
echo "Exporting dicoms from Flywheel for subject: $subj, session: $sess"
python ${scripts_dir}/sdkexport_dicoms.py ${subj} ${sess} ${flywheel_group} ${flywheel_project} ${dicom_base} ${exclude_quarantine}
echo "Export complete."
echo "Dicoms exported to: ${dicom_base}/${subj}/${sess}"
echo "*--------------------------------*"

# Convert dicoms to BIDS nifti using dcm2bids:
echo "Converting dicoms to BIDS format for subject: $subj, session: $sess"
cmd="${scripts_dir}/dcm2bids.sh ${subj} ${sess} ${scripts_dir} ${dcm2bids_conda_path} ${dicom_base} ${bids_base} ${heuristic_path}"
echo $cmd 
$cmd 
echo "BIDS conversion complete in: ${bids_base}/sub-${subj}/ses-${sess}"
echo "*--------------------------------*"

echo "Clearing previous BIDS, if any, from flywheel for subject: $subj, session: $sess"
python ${scripts_dir}/remove_bids_from_flywheel.py ${subj} ${sess} ${flywheel_group} ${flywheel_project}
echo "BIDS removal complete at fw://${flywheel_group}/${flywheel_project}"

# Import BIDS data back into Flywheel:
echo "Importing BIDS data back into Flywheel for subject: $subj, session: $sess"
python ${scripts_dir}/import_bids_to_flywheel.py ${subj} ${sess} ${flywheel_group} ${flywheel_project} ${bids_base}
echo "BIDS import complete to fw://${flywheel_group}/${flywheel_project}"
echo "*--------------------------------*"

echo "All done for subject: $subj, session: $sess"
echo "BIDS data located at: ${bids_base}/sub-${subj}/ses-${sess}"
echo "Find a copy of this log at: ${log_path}/sub-${subj}_ses-${sess}_log.txt"
echo "----------------------------------"
