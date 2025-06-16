fx_version 'cerulean'
game 'gta5'

author 'Admin Menu System'
description 'Complete Admin Menu for FiveM Server'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/functions.lua'
}

server_scripts {
    'server/main.lua',
    'server/functions.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}