#!/bin/bash

echo "executing rename_sessions.py"
module unload python
module load python/3.11
python ./rename_sessions.py
