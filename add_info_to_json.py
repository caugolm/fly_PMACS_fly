# -*- coding: utf-8 -*-
'''
Created on August 20, 2025
@author Chris
Add info to a BIDS json
'''

import json
import sys


json_file = str(sys.argv[1]) #sub-AAA
new_key = str(sys.argv[2])
new_value = sys.argv[3]

def go_float_a_boat(string):
    try:
        float(string)
        return True
    except ValueError:
        return False

if go_float_a_boat(new_value):
    new_value = float(new_value)


with open(json_file,'r') as f:
    data=json.load(f)
    data[new_key] = new_value
with open(json_file,'w') as f:
    json.dump(data,f,indent=4,sort_keys=True)

