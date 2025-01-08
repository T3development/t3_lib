fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 't3mpu5'
description 't3_lib'
version '1.0.4'


files {
    'init.lua',
}

client_scripts {
	'client/main.lua',
}

server_scripts {
	'server/main.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}