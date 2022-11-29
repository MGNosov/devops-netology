#!/usr/bin/env python3

import os
import sys

cmd=sys.argv[1]
bash_command = ["cd "+cmd, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(cmd+prepare_result)
