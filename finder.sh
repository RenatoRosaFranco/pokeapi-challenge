#!/bin/bash

if [[ -n $IS_ACTION && $IS_ACTION == 'Action' ]]; then
  RUN_ALL='false';
else
  RUN_ALL='true';
fi;

FINDER=$(find . -name test.sh | sort);

export FINDER
export RUN_ALL