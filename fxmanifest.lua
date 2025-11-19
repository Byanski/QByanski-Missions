fx_version 'cerulean'
game 'gta5'
author 'Monster Dev Team'
description 'QByanski-Mission for QBOX forked from MST-MISSION'
version '1.0.0'

lua54 'yes'

-- Dependencies
dependency 'ox_lib'
dependency 'ox_target'

-- Shared script (IMPORTANT: Load ox_lib first)
shared_script '@ox_lib/init.lua'

-- Client scripts
client_scripts {
    'config.lua',
    'client/main.lua',
    'client/menu.lua',
    'client/npc.lua',
}

-- Server scripts
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/main.lua'
}

-- Status check (if you use this anticheat)
client_script '@status/acloader.lua'
 