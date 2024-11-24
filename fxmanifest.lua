fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Arthur Ropke'
description 'DB System'
version '1.0.0'

dependencies {
    'oxmysql' -- Banco de dados (oxmysql)
}

shared_scripts {
    'shared/shared.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- Certifique-se de que o oxmysql está incluído
    'core/config.lua',
    'core/logger.lua',
    'core/cache.lua',
    'core/crud.lua',
    'core/database.lua',
    --USER--
    'models/user.lua',
    'models/userStatus.lua',
    'models/userInventory.lua',
    'collections/user.lua',
    'collections/userInventory.lua',
    'collections/userStatus.lua',
    --USER--
    'server/server.lua',
}


server_exports {
    'GetDB', -- Exporta a função para acessar o DB
}
