#/bin/bash

ncat -l 2000 --keep-open --exec "/bin/bash ${PWD}/echo.sh"
