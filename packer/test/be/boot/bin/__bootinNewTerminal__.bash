#! /usr/bin/env bash
envfile=$1
workhome=$2
export PROJECT_HOME=${workhome}
shopt -s expand_aliase
alias app='/home/ryanhunter/Projects/GitHub/rhFlow/be/v2/test/be/app/bin/appShell.bash'
info=`cat ${envfile} | sed -e 's/$/;/'`
cmdl="${info}"
eval ${cmdl}
