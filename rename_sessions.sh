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
module load python/3.11

config=$1

source $config

python ./rename_sessions.py $flywheel_group $flywheel_project $lists_path
