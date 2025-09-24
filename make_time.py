# -*- coding: utf-8 -*-
'''
Created on September 5, 2025
@author Chris
checks/tries to convert thing to datetime time
'''

import datetime

def make_time(a_time):
    print(type(a_time))
    if isinstance(a_time, datetime.datetime):
        a_time = a_time.time()
    elif isinstance(a_time, datetime.time):
        a_time = a_time
    else:
        try:
            a_time = datetime.datetime.strptime(a_time, '%H:%M:%S').time()
        except ValueError:
            return False
    return a_time

