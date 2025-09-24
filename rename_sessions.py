#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jan 25 15:23:18 2023

@author: co
"""
import pandas as pd
import datetime
import flywheel
import pytz
import os.path

fw=flywheel.Client('')

# make column names
# initialize list for storing new subject and session names
cols = ['sub','ses']
updateList = []

# datetime our file
today = datetime.date.today()
tonow = datetime.datetime.now()
strnow = tonow.strftime("%H%M%S")
todayStr = '{}{}{}'.format(today.year,f'{today.month:02}',f'{today.day:02}')

#def find_new_sessions(group = "pennftdcenter", projectLabel = "HUP6", matchString = "BRAIN RESEARCH"):
def find_new_sessions(matchString,group = "pennftdcenter", projectLabel = "HUP6_XA60"):
	project = fw.lookup("{}/{}".format(group, projectLabel))
	sessions = project.sessions.iter_find("label=~{}".format(matchString))
	for s in sessions:
			# print(s)
			# Create a new session label by piecing together year/month/day/hour/minute info
			# from the session timestamp.
			tstamp = s.timestamp.astimezone(pytz.timezone("US/Eastern"))
			lab = '{}{}{}x{}{}'.format(tstamp.year,f'{tstamp.month:02}',f'{tstamp.day:02}',f'{tstamp.hour:02}',f'{tstamp.minute:02}')
			submess = s.parents.subject
			fwsub = fw.get_subject(submess)
			sub = fwsub.label		
			updateList.append([sub,lab])

			# Update the session label using the update() method, whose input is a dictionary
			# of the fields to be changed and their new values.
			s.update({'label': lab})
	
	# convert list to data frame for ease of saving and stuff
	updateDf = pd.DataFrame(updateList, columns = cols)
	# create file name
	fname = "/project/ftdc_volumetric/hup6_xa60/lists/to_curate_" + todayStr + "x" + strnow + ".csv"
	updateDf.to_csv(fname, header=False, index=False)
	print(fname)

find_new_sessions('BRAIN')
