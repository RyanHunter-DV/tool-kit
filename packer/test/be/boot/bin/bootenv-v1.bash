#! /usr/bin/env bash
boothome=/home/ryanhunter/Projects/GitHub/rhFlow/be/v2/test/be/boot
workhome=`realpath .`
project=`basename ${workhome}`
argumentCommands=`${boothome}/accessory/__optionProcess__.rb ${SHELLTYPE} $@`
eval ${argumentCommands}
envfile=${workhome}/__be__/${envview}.anchor
if [ ! -e ${envfile} ]; then
	echo "the specified env file not exists ${envfile}"
	return 3
fi
nterm=/usr/bin/gnome-terminal
echo "project: ${project}"
termopts="--title \"[booted] ${project}\" --hide-menubar --geometry=120x40+40+40"
setupcmd="export SHELLTYPE=bash"
bootcmd="source ${boothome}/bin/__bootinNewTerminal__.${SHELLTYPE} ${envfile} ${workhome}"
logincmd="${setupcmd};${bootcmd};${SHELLTYPE}"
localcmd=${bootcmd};
if [ ${newterm} == 1 ]; then
	echo "booting project env with new terminal"
	fullcmd="${nterm} ${termopts} -- ${SHELLTYPE} -c \"${logincmd}\""
else
	echo "booting project env with local terminal"
	fullcmd="${localcmd}"
fi
echo ${fullcmd}
eval ${fullcmd}
