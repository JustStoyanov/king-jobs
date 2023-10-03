fx_version 'cerulean';
game 'gta5';
lua54 'yes';
use_experimental_fxv2_oal 'yes';

author 'gadget2';
description 'Job system for FiveM [ox_core]';
version '1.0.5';

client_scripts {
    '@ox_core/imports/client.lua',

    'code/core/client.lua',

    'code/modules/experience/client.lua',
    'code/modules/salary/client.lua'
};

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@ox_core/imports/server.lua',

    'code/core/server.lua',

    'code/modules/commands/server.lua',
    'code/modules/experience/server.lua',
    'code/modules/salary/server.lua'
};

shared_scripts {
    '@ox_lib/init.lua',

    'config/config.lua',
    'config/jobs.lua',
    'config/gangs.lua',

    'code/core/shared.lua'
};

files {
    'code/modules/**/submodules/*.lua',
    'code/modules/**/submodules/**/*.lua'
};