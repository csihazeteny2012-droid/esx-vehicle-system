fx_version 'cerulean'
game 'gta5'

author 'ESX Vehicle System'
description 'FiveM ESX Legacy persistent vehicle system with tarp management'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'locales/hu.lua',
    'locales/en.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/commands.lua',
    'server/vehicles.lua',
}

client_scripts {
    'client/main.lua',
    'client/target.lua',
    'client/tarp.lua',
}

dependencies {
    'es_extended',
    'ox_lib',
    'oxmysql',
    'ox_target',
}
