#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo "USAGE: ./rename_session.sh <config>" 
    echo "  renames sessions on flywheel that have specified string to YYYYMMDDxHHmm format."
    echo "  uses configs to define flywheel group, flywheel project, and the directory a csv file that contains the SubjectLabel and new SessionLabels is output to"
    echo "  renames things with 'BRAIN' in the session name, so all of this is kind of FTDC specific at the moment"
    exit 1
fi

echo "executing rename_sessions.py"
module unload python

config=$1

source $config


module unload miniconda
module load miniconda/3-25
eval "$(conda shell.bash hook)"

conda activate $dcm2bids_conda_path


python ./rename_sessions.py $flywheel_group $flywheel_project $lists_path
