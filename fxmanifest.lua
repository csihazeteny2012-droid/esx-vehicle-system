fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'SeeRPG Vehicle System'
description 'Persistent ESX vehicle system with tarp + ox_target + simple garage'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'locales/hu.lua',
    'locales/en.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/commands.lua',
    'server/garage.lua'
}

client_scripts {
    'client/main.lua',
    'client/target.lua',
    'client/tarp.lua',
    'client/garage.lua'
}

dependencies {
    'es_extended',
    'ox_lib',
    'oxmysql',
    'ox_target'
}
