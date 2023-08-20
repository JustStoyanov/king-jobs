fx_version 'cerulean';
game 'gta5';
lua54 'yes';

author 'gadget2';
description 'Job system for FiveM [ox_core]';
version '1.0.4';

client_scripts {
    '@ox_core/imports/client.lua',

    'core/client.lua',
    'modules/**/client.lua'
};

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@ox_core/imports/server.lua',

    'core/server.lua',
    'modules/**/server.lua'
};

shared_scripts {
    '@ox_lib/init.lua',

    'core/shared.lua',
    'config/config.lua',
    'config/jobs.lua',
    'config/gangs.lua'
};
provides {'mst-experience'};