#!/usr/bin/python3
# Usage ##
# ksec COMMAND AND ARGUMENTS
#
# Any normal command can be prefaced with `ksec`, which will run the original
# command with any secrets from a .secrets.yaml file injected as environment
# variables.
import base64
import os
import subprocess
import sys
import yaml


with open('.secrets.yaml') as f:
    for doc in yaml.load_all(f):
        for secret in doc['items']:
            for key, value in secret['data'].items():
                decoded_value = base64.b64decode(value).decode()
                os.environ[key.upper()] = decoded_value


subprocess.call('{}'.format(' '.join(sys.argv[1:])), shell=True)
