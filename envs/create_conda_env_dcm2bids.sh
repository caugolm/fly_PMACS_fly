#!/bin/bash
conda_yml=dcm2bids_20251119.yml

if [[ $# -lt 1 ]] ; then 
    echo "USAGE: ./create_conda_env_dcm2bids.sh </absolute/path/to/where/you/want/your/dcm2bids > "
    echo "  this uses the $conda_yml file to try to create a conda environment for you to use with the fly_PMACS_fly repo"
    echo " "
    echo "  </absolute/path/to/where/you/want/your/dcm2bids > the absolute path is recommended if you are going to be sharing this with another user"
    echo ""
    echo " after this finishes correctly, put the absolute path to the dcm2bids conda env in your config file in ../configs/"
    exit 1
fi

env_path=$1

# not needed here but just getting in some practice
export PYTHONNOUSERSITE=1

module unload miniconda 
module load miniconda/3-25
eval "$(conda shell.bash hook)"

echo "Once this finishes correctly, put the absolute path to the dcm2bids conda env in your config file in ../configs/"

conda env create -f dcm2bids_20251119.yml --prefix $env_path

echo "Now go put the absolute path to the dcm2bids conda env in your config file in ../configs/"
echo "Should be this: "
echo ${env_path}
