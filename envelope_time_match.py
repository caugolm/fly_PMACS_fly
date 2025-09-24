# -*- coding: utf-8 -*-
'''
Created on September 5, 2025
@author Chris
Add info to a BIDS json
'''

import datetime
import sys
import make_time

setter_time = sys.argv[1] # time of setters
image_time = sys.argv[2] # time of image of interest
time_window = sys.argv[3] # number of seconds on either side to look 

setter_time = make_time.make_time(setter_time)
image_time = make_time.make_time(image_time)
time_window = float(time_window)

setter_time = datetime.datetime.combine(datetime.date.today(),setter_time)
image_time = datetime.datetime.combine(datetime.date.today(),image_time)

def envelope_time_match(setter_time, image_time, time_window): 
    setter_time_plus_window = setter_time + datetime.timedelta(0, time_window) 
    setter_time_minus_window = setter_time - datetime.timedelta(0, time_window) 
    if image_time <= setter_time_plus_window and image_time >= setter_time_minus_window:
        return True
    else:
        return False 

match_tf = envelope_time_match(setter_time, image_time, time_window)
print(match_tf)
