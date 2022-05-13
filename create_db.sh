#!/bin/bash
cd /home/pod/Esup-Pod
#source env/bin/activate
pip3 install --no-cache-dir -r requirements.txt
sh create_data_base.sh
