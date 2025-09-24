#!/bin/bash

eval "$(conda shell.bash hook)"
conda activate /project/ftdc_volumetric/hup6_xa60/envs/dcm2bids
# module load dcm2niix/

subj=$1
sess=$2


echo "Running dcm2niix for subject: $subj and session: $sess"
input_dir=/project/ftdc_volumetric/hup6_xa60/dicoms/${subj}/${sess}
output_dir=/project/ftdc_volumetric/hup6_xa60/bids/tmp_dcm2bids/sub-${subj}_ses-${sess}
rm -rf ${output_dir}
mkdir -p ${output_dir}

rm ${input_dir}/Localizer*dcm
rm ${input_dir}/PhoenixZIP*.zip

for file in ${input_dir}/*.zip; do
    unzip -o "$file" -d "${input_dir}"
done

# Run dcm2niix:
dcm2niix -b y -ba n -z y -f %3s_%f_%p_%t -o ${output_dir} ${input_dir}


# # Usage:
# subjlist=/project/ftdc_volumetric/hup6_xa60/lists/EG_20250625_NACCSC.csv
# mkdir -p /project/ftdc_volumetric/hup6_xa60/logs/dcm2bids_helper/
# for i in `cat $subjlist` ; do
# 	subj=`echo "$i" | cut -f1 -d ','`
#     sess=`echo "$i" | cut -f2 -d ','`
#     echo "Submitting job for subject: $subj and session: $sess"
#     bsub -B -N -J ${subj}_${sess} -q bsc_short -o /project/ftdc_volumetric/hup6_xa60/logs/dcm2bids_helper/sub-${subj}_ses-${sess}.txt -n 1 /project/ftdc_volumetric/hup6_xa60/scripts/dcm2bids_helper.sh $subj $sess
# done    