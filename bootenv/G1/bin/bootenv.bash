#! /usr/bin/env bash
cdir=$(cd $(dirname $0);pwd)
toolhome=$(dirname $cdir);
workdir=$(pwd);

if [ ! -e "$workdir/env/modulefile" ]; then
	echo "Error, not find modulefile, you're probably not in available workdir"
	return -1;
fi

# read modulefile and eval it
md=`stat -c '%Y' env/modulefile`;
flag=0;
if [ ! -z "$__BOOTENV__FLAG__" ]; then
	flag=$__BOOTENV__FLAG__;
fi
#echo $md
#echo $flag
if [ "$md" = "$flag" ]; then
	echo "env already booted"
	return 0;
else
	export STEM=$workdir
	codes=`cat $workdir/env/modulefile`
	eval $codes
	export __BOOTENV__FLAG__=$md
	echo "env boot completed"
fi

#eval $workdir/env/modulefile
