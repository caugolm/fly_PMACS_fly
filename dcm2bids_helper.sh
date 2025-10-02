#!/bin/bash


if [[ $# -lt 7 ]] ; then
    echo "USAGE: ./dcm2bids_helper.sh <subID> <sesID> <dicom_base> <bids_base> "
    exit 1
fi

subj=$1
sess=$2
dicom_base=$3
bids_base=$4


dicom_dir=${dicom_base}/${subj}/${sess}
uncompressed_dicom_dir=${dicom_base}/${subj}/${sess}/uncompressed/
eval "$(conda shell.bash hook)"

echo "Running dcm2niix for subject: $subj and session: $sess"


nifti_dir=${bids_base}/tmp_dcm2bids/sub-${subj}_ses-${sess}

rm -rf ${nifti_dir} #avoiding conflicts with previous runs
mkdir -p ${nifti_dir}
#  
if [ -e "${dicom_dir}/dicoms.tar" ] ; then
    echo "Unzipping dicoms.tar"
    tar -xvf ${dicom_dir}/dicoms.tar -C ${dicom_dir}
else
    if [[ ! -d ${uncompressed_dicom_dir} ]] ; then
        mkdir -p ${uncompressed_dicom_dir}
    fi
    mv ${dicom_dir}/* ${uncompressed_dicom_dir}
fi


for file in ${uncompressed_dicom_dir}/*.zip; do
    zipname=$(echo $file | rev | cut -d '/' -f1 | rev | sed 's/.zip/_unzipped/')
    unzip -o ${file} -d ${uncompressed_dicom_dir}/${zipname}/
done


# Run dcm2niix:
dcm2niix -b y -ba n -z y -f %3s_%f_%p_%t -o ${nifti_dir} ${uncompressed_dicom_dir}

# subjlist="x"
# for i in `cat $subjlist` ; do
# 	subj=`echo "$i" | cut -f1 -d ','`
#     sess=`echo "$i" | cut -f2 -d ','`
#     /project/ftdc_volumetric/hup6_xa60/scripts/fly_PMACS_fly/dcm2bids_helper.sh $subj $sess $dicom_base $bids_base
# done