#!/usr/bin/env python

import pydicom as dicom
import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--dicom-dir', help='Directory of DICOMs')

args = parser.parse_args()

if args.dicom_dir:
  args.dicom_dir = os.path.expanduser(args.dicom_dir)
  args.input = list()

  file_list = [f for f in os.listdir(args.dicom_dir) if os.path.isfile(os.path.join(args.dicom_dir,f)) and ".zip" not in f ]
  for f in file_list:
    f = os.path.join(args.dicom_dir, f)
    # only add valid dicom files from input directory
    try:
      with open(f, 'rb') as fo:
        dicom.filereader.read_preamble(fo, force=False)
    except dicom.errors.InvalidDicomError:
      print(f'ignoring {f}')
      continue
    args.input.append(f)


def whatAreWe(filepath):
  one_dicom = dicom.read_file(filepath)
  if "setter" in one_dicom.SeriesDescription :
    time_int = int(float(one_dicom.SeriesTime))
    hours = time_int // 10000
    minutes = (time_int % 10000) // 100
    seconds = time_int % 100
    #print(one_dicom)
    formatted_time = f"{hours:02d}:{minutes:02d}:{seconds:d}"
    
    return(formatted_time)

if len(args.input) > 1:
  just_need_one = args.input[1]
  series_acq_time_for_setter = whatAreWe(just_need_one)
else:
    series_acq_time_for_setter = ""

print(series_acq_time_for_setter)