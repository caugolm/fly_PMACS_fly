import os
import json
import pandas as pd
import sys

'''
USAGE:
python tabulate_dcm2bids_helper.py /path/to/tmp_dcm2bids /path/to/output.csv
Once your dicoms are converted to BIDS using dcm2bids, this script will create a table (csv) of all the json files in the tmp_dcm2bids directory.
The table will have one row per json file, with columns for each key in the json files.
This is useful for creating your heuristic file for dcm2bids.
'''

parent_directory = sys.argv[1] #path to tmp_dcm2bids directory. Typically ${bids_base}/tmp_dcm2bids

# Initialize a list to store rows for the table
table_data = []

# Traverse through subdirectories
for subdir in os.listdir(parent_directory):
    subdir_path = os.path.join(parent_directory, subdir)
    if os.path.isdir(subdir_path): 
        for file in os.listdir(subdir_path):
            if file.endswith(".json"):  
                json_path = os.path.join(subdir_path, file)
                with open(json_path, 'r') as f:
                    try:
                        json_data = json.load(f)  
                        row = {"Subdirectory": subdir, "JSON Filename": file}
                        row.update(json_data)  # Add all keys and values from the JSON file
                        table_data.append(row)
                    except json.JSONDecodeError:
                        print(f"Error decoding JSON file: {json_path}")

df = pd.DataFrame(table_data)

output_csv = sys.argv[2]
df.to_csv(output_csv, index=False)

print(f"Table saved to {output_csv}")