fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name "id_deathui"
description "Death UI | Responsive UI"
author "grandson#6863"
version "1.0.0"

client_scripts {
    'client/*.lua',
    'shared/*.lua',
}

server_scripts {
    'server/*.lua',
    'shared/*.lua',
}

ui_page "web/index.html"

files {
    'web/index.html',
    'web/script.js',
    'web/style.css',
    'web/img/*.png',
}