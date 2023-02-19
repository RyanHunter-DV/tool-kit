#! /usr/bin/env bash
apphome=/home/ryanhunter/Projects/GitHub/rhFlow/be/v2/test/be/app
argumentCommands=`${apphome}/accessory/__optionProcess__.rb $@`
eval ${argumentCommands}
echo "${cmd} tool: ${tool}, version: ${version}"
appConfig=${apphome}/tools/${tool}/${version}/app.config
if [ ${cmd} == '' ]; then
	echo "Error, invalid input options: $@"
	return 3
fi
if [ ${cmd} == 'setup' ]; then
	mkdir -p ${apphome}/tools/${tool}
	mkdir -p ${apphome}/tools/${tool}/${version}
	touch ${apphome}/tools/${tool}/${version}/app.config
	if [ ! -e ${apphome}/tools/${tool}/current ]; then
		ln -s ${apphome}/tools/${tool}/${version} ${apphome}/tools/${tool}/current
	fi
fi
if [ ! -e $appConfig ]; then
	echo "Error, no app.config file found for: ${appConfig}"
	echo "you can setup your config through: app setup ${tool}/${version}"
	return 3
fi
setupCommands=`${apphome}/accessory/__appConfigProcess__.rb ${appConfig} ${cmd}`
if [ ! -z "${setupCommands}" ]; then
	eval $setupCommands
fi
echo "Success, ${cmd} completed"
return 0
