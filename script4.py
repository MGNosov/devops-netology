#Changes made
#!/usr/bin/env python3

import os
bash_command = ["cd /Users/mgnosov/devops-netology", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        path = os.popen('pwd').read().replace('\n', '')
        print(f"{path}{prepare_result}")
        
