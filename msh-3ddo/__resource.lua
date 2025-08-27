
resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

name "MSH do"
author "Mshdev!!"

client_script 'client.lua'
server_scripts {
    'server.lua',
    '@mysql-async/lib/MySQL.lua',
  }
