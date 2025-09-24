## What is this repository for?
If you use Flywheel to reap dicoms from the scanner, but want to use the Penn PMACS LPC to do pretty much everything else, this repository will (hopefully) be useful.
It does the following:
1. Downloads the DICOMs from Flywheel to the PMACS LPC using the [Flywheel SDK](https://api-docs.flywheel.io/latest/tags/21.0.0/python/index.html). 
2. Converts these DICOMs to NIFTI using [dcm2niix](https://github.com/rordenlab/dcm2niix)
3. Curates these NIFTIs to BIDS format using [dcm2bids](https://unfmontreal.github.io/Dcm2Bids/3.2.0/)
4. Exports these BIDS curates NIFTIs, along with all its metadata, back to the Flywheel project folder for completeness. 

## What do you need to get this going:
1. The absolute path to a comma separated list of the FlywheelSubjectLabel and FlywheelSessionLabel instances you want to run this on, saved as a csv file. An example csv will look something like this:
    12345,tp01


    23456,tp02

    
    34566,tp03
2. The absolute path to a *directory* config file which defines where everything else lives, plus some additional options. See setting_up_your_config_file.md for more information on how to set this up. 
3. You will also need a *heuristic* config file to pass to dcm2bids to get your BIDS curation going. See https://unfmontreal.github.io/Dcm2Bids/3.2.0/how-to/create-config-file/ for more information. The script tabulate_dcm2bids_helper.py can help you create this heuristic, if needed. 

TO DO:
Add details about quarantine, motion calculation.