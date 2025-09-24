import os
import re
import json
import sys
import flywheel

fw = flywheel.Client('')

# Usage: python .py <subject> <session> <group> <project> 
subject = sys.argv[1]
session = sys.argv[2]
group = sys.argv[3]
project = sys.argv[4]

# Flywheel location:
# get session 
try:
    sess = fw.lookup(f"{group}/{project}/{subject}/{session}")
except:
    print("no session found for group: " + group + ", project: " + project + ", subject: " + subject + ", session: " + session + " exiting..." )
    exit()

def find_things_to_classify(sess):
    # use iter_find to grab acquisitions for the session
    for acq in sess.acquisitions.iter_find():
        acq = acq.reload()
        if re.search("^MultiShell_6dir_PA(?!_)", acq.label) is not None:        
            for file_obj in acq.files:
                print(file_obj.name)
                acq.replace_file_classification(file_obj.name, {
                    'Intent': ['Fieldmap'],
                    'Measurement': ['Diffusion'] }, 
                    modality = 'MR')
        if re.search("^MultiShell_117dir(?!_)", acq.label) is not None:        
            for file_obj in acq.files:
                print(file_obj.name)
                acq.replace_file_classification(file_obj.name, {
                    'Intent': ['Structural'],
                    'Features': ['Multi-Shell'],
                    'Measurement': ['Diffusion'] }, 
                    modality = 'MR')

find_things_to_classify(sess)

