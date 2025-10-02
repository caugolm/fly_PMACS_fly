#!/bin/bash

if [[ $# -lt 3 ]] ; then
    echo "USAGE: ./dcm2bids_helper.sh <subj> <sess> <config>"
    echo "  runs dcm2niix and outputs in bids_base/tmp_dcm2bids, where bids_base is defined in config (as is input dicom_base and conda_env_path) "
    exit 1
fi


subj=$1
sess=$2
config=$3

source $config

eval "$(conda shell.bash hook)"
conda activate $dcm2bids_conda_path

echo "Running dcm2niix for subject: $subj and session: $sess"
input_dir=${dicom_base}/${subj}/${sess}
output_dir=${bids_base}/tmp_dcm2bids/sub-${subj}_ses-${sess}
rm -rf ${output_dir}
mkdir -p ${output_dir}

rm ${input_dir}/Localizer*dcm
rm ${input_dir}/PhoenixZIP*.zip

for file in ${input_dir}/*.zip; do
    unzip -o "$file" -d "${input_dir}"
done

# Run dcm2niix:
dcm2niix -b y -ba n -z y -f %3s_%f_%p_%t -o ${output_dir} ${input_dir}
