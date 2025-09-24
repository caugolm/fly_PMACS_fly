#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created 1/10/2025
Modified 8/27/2025

@author: caugolm

This script is a Flywheel SDK-based method of exporting dicom archives from flywheel
Here, we require 1) group, 2) project, 3) subject, 4) session, so we can look up just that session.
We find dicoms (and zips of dicoms) and download them in a loop.

"""

import flywheel
import sys
import os.path

fw=flywheel.Client('')

if (nargs := len(sys.argv)) < 5:
	print("USAGE: python3 sdkexport_export.py subject_label session_label flywheel_group flywheel_project dicom_base <opt: exclude Quarantine True/False (default False)>")
	raise SystemExit(2)

subject_label = sys.argv[1]
session_label = sys.argv[2]
group = sys.argv[3]
project_label = sys.argv[4]
dcm_base = sys.argv[5]
exclude_qcfails = False

print("project = " + project_label + ", subject = " + subject_label + ", session = " + session_label + ", outDir = " + dcm_base)


if len(sys.argv) > 6:
    if sys.argv[6] == "True" :
        exclude_qcfails = True
        print("excluding dicoms with Quarantine in file.tags ")


# get session 
try:
    sess = fw.lookup("{}/{}/{}/{}".format(group, project_label, subject_label, session_label))
except:
    print("no session found for project = " + project_label + ", subject = " + subject_label + ", session = " + session_label + " exiting..." )
    exit()

def find_dicoms(sess, exclude_qcfails):
    abs_dcmout_path = dcm_base + '/' + subject_label + '/' + session_label + '/'
    if os.path.exists(abs_dcmout_path):
        print(abs_dcmout_path + " path exists!! delete to re-export...exiting...")
        exit()
    # use iter_find to grab acquisitions for the session
    for acq in sess.acquisitions.iter_find():
        acq = acq.reload()
        # for dicom data, we search for dicom zip files, or dicoms themselves 
        # dcm_objs = [file_obj for file_obj in acq.files if (file_obj.name.endswith('.dicom.zip') or file_obj.name.endswith('dcm.zip') or file_obj.name.endswith('.dicom') or file_obj.name.endswith('.dcm'))]
        dcm_objs = [file_obj for file_obj in acq.files if (file_obj.type == "dicom")]
        for file in dcm_objs:
            if "Quarantine" not in file.tags or exclude_qcfails == False :
                clean_acq = acq.label
                # get rid of characters that tend to cause issues
                clean_acq = clean_acq.replace(' ', '_')
                clean_acq = clean_acq.replace(')', '')
                clean_acq = clean_acq.replace('(', '')
                clean_acq = clean_acq.replace('*', '')
                clean_acq = clean_acq.replace('[', '')
                clean_acq = clean_acq.replace(']', '')
                clean_acq = clean_acq.replace('{', '')
                clean_acq = clean_acq.replace('}', '')
                clean_acq = clean_acq.replace('/', '')
                clean_acq = clean_acq.replace('__', '_')
            
            
                print(clean_acq)
                # create the directory if it doesn't exist
                if not os.path.exists(abs_dcmout_path):
                    os.makedirs(abs_dcmout_path)
            
                # don't want to call a dicom a zip, or ignore something
                ext = file.name[file.name.rindex('.')+1:]
                out_file = abs_dcmout_path + clean_acq + '.' + ext

                # we assume these are all "fresh" because you should only have to do this once
                # so if the file already exists, it probably means an acquisition was repeated, so tag on a counting number 
                # the while statement helps flexibility for if something is repeated n times 
                if not os.path.isfile(out_file):
                    print("downloading: " + out_file)
                    file.download(out_file)
                else:
                    addone = True
                    i = 0
                    while addone == True:
                        # assume repeats, add counter
                        i = i + 1
                        out_file = abs_dcmout_path + clean_acq + "_" + str(i) + '.' + ext
                        if os.path.isfile(out_file) == False:
                            print("downloading: " + out_file)
                            file.download(out_file)
                            addone = False
                   
find_dicoms(sess, exclude_qcfails)
