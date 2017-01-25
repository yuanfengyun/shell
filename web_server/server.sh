#/bin/bash

nohup ncat -l 2000 --keep-open --exec "/bin/bash ${PWD}/service.sh" &
