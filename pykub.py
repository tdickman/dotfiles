#!/usr/bin/env python3
import base64
import os
import subprocess
import sys
import yaml


with open('.secrets.yaml') as f:
    for doc in yaml.load_all(f):
        for key, value in doc['data'].items():
            decoded_value = base64.b64decode(value).decode()
            os.environ[key.upper()] = decoded_value


subprocess.call('python3 {}'.format(sys.argv[1]), shell=True)
