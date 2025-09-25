## How to set up your directory config_file

The directory_config_file helps you set things up to run these scripts for your project with ease. We highly recommend copying over the example config in `configs/hup6_xa60_directory_config.txt` and editing it to make sure you don't miss anything. 


### The config file expects the following parameters to be set:
1. `flywheel_group`: 
This is your flywheel group lol. If the path to your project folder looks something like:  `fw://pennftdcenter/HUP6_XA60` then your flywheel group is"pennftdcenter"


2. `flywheel_project`:
This is your flywheel project. If the path to your project folder looks something like: `fw://pennftdcenter/HUP6_XA60` then your flywheel project is "HUP6_XA60"


3. `scripts_dir`:
The absolute path to the fly_PMACS_fly repo on the cluster for you.


4. `dcm2bids_conda_path`:
We're using conda environments to get dcm2bids to work. If this actually works, then this path should just be {path_to_fly_PMACS_fly}/envs/dcm2bids. Reach out to Hamsi and Chris if this doesn't actually work, and we can get solutions working for you.


5. `config_file`:
The absolute path to this config file.


6. `heuristic_path`:
The absolute path to the curation heuristic you want dcm2bids to use.


7. `dicom_base`:
The absolute path to where you want the dicoms to be downloaded to from Flywheel


8. `exclude_quarantine_dicom_base`:
The absolute path to where you want the quarantine-excluded dicoms to be downloaded to from Flywheel.


9. `bids_base`:
The absolute path to where you want your bids curated NIFTIs to live.


10. `log_path`:
The absolute path to the directory you want your log files to live in. Log files are saved as `${log_path}/sub-${subj}_ses-${sess}_log.txt`


11. `overwrite`:
Set False if you don't want existing directories to be deleted for the subject,session combo. You'll probably only need to set this to True if you're trying to rerun something.


12. `calculate_add_motion`:
If you're using the harmonized PENN ADRC/FTDC scanning protocol, this adds motion estimates calculated from the vnav setters to the json. Set to False if this is not being collected. 
