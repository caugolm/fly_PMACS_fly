#!/bin/bash

subj=$1
sess=$2
scripts_dir=$3
dicom_base=$4
bids_base=$5

dicom_dir=${dicom_base}/${subj}/${sess}/
bids_dir=${bids_base}/sub-${subj}/ses-${sess}/

module load python/3.11

for tmpDira in `find "${dicom_dir}/uncompressed/" -type d `; do 
    echo $tmpDira
    # if the dicom dir contains vnav setters then dicom_check returns dicom series acquisition time, else returns "None"
    setter_acqtime=`python ${scripts_dir}/setter_time_to_match.py --dicom-dir ${tmpDira}`
    # if vnav setters, get the rms and max mean motion
    echo $setter_acqtime
    if [[ $setter_acqtime != "" && $setter_acqtime != "None" ]] ; then
        rms=`python ${scripts_dir}/parse_vNav_Motion.py --input-dir ${tmpDira} --tr 2.4 --rms --radius 64`
        max=`python ${scripts_dir}/parse_vNav_Motion.py --input-dir ${tmpDira} --tr 2.4 --max --radius 64`
        rms=$(echo $rms | sed 's/://')
        max=$(echo $max | sed 's/://')
        # if the anat jsons contain a matching series acquisition time then add the rms and max to the json
        # echo "setter acquitision time $setter_acqtime " 
        # echo "  measured motion $rms and $max"
        for anat_json in `ls ${bids_dir}/anat/sub-${subj}_ses-${ses}*json`; do
            grep_acqtime=`cat $anat_json | grep "AcquisitionTime"`
            acqtime_string=$(echo $grep_acqtime | cut -d ':' -f2- | cut -d "\"" -f2 | cut -d '.' -f1)
            echo $setter_acqtime $acqtime_string 2
            time_match=`python ${scripts_dir}/envelope_time_match.py $setter_acqtime $acqtime_string 2 `

            grep_time_match=$(echo $time_match | grep -i 'true')
            if [[ $grep_time_match != "" ]] ; then
                echo " adding measured motion $rms and $max to $anat_json"
                # Add vnav rms 
                python ${scripts_dir}/add_info_to_json.py ${anat_json} ${rms}
                # Add vnav max
                python ${scripts_dir}/add_info_to_json.py ${anat_json} ${max}
            fi
        done
    fi
done
