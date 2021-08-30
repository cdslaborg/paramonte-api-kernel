#!/bin/bash
FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
doxygen "${FILE_DIR}/config.txt"