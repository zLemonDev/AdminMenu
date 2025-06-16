Config = {}

-- Menu Configuration
Config.MenuKey = 'F6' -- Key to open admin menu
Config.AdminGroups = {'admin', 'superadmin', 'mod'} -- Groups that can access menu

-- Admin Permissions
Config.Permissions = {
    ['superadmin'] = {
        player_management = true,
        vehicle_management = true,
        teleport = true,
        weather = true,
        time = true,
        server_management = true,
        ban_system = true,
        economy = true,
        spectate = true,
        noclip = true,
        godmode = true,
        invisible = true
    },
    ['admin'] = {
        player_management = true,
        vehicle_management = true,
        teleport = true,
        weather = false,
        time = false,
        server_management = false,
        ban_system = true,
        economy = false,
        spectate = true,
        noclip = true,
        godmode = true,
        invisible = true
    },
    ['mod'] = {
        player_management = false,
        vehicle_management = false,
        teleport = true,
        weather = false,
        time = false,
        server_management = false,
        ban_system = false,
        economy = false,
        spectate = true,
        noclip = false,
        godmode = false,
        invisible = false
    }
}

-- Vehicle Categories
Config.VehicleCategories = {
    ['Super'] = {
        'adder', 'banshee2', 'bullet', 'cheetah', 'entityxf', 'fmj', 'gp1', 'infernus', 'nero', 'osiris', 'pfister811', 'reaper', 'sc1', 'sultanrs', 't20', 'tempesta', 'turismor', 'tyrus', 'vacca', 'voltic', 'zentorno'
    },
    ['Sports'] = {
        'alpha', 'banshee', 'bestiagts', 'blista2', 'buffalo', 'buffalo2', 'carbonizzare', 'comet2', 'coquette', 'elegy2', 'feltzer2', 'furoregt', 'fusilade', 'jester', 'khamelion', 'kuruma', 'lynx', 'massacro', 'ninef', 'penumbra', 'rapidgt', 'schafter3', 'sultan', 'surano', 'tropos', 'verlierer2'
    },
    ['Motorcycles'] = {
        'akuma', 'bagger', 'bati', 'bati2', 'bf400', 'carbonrs', 'cliffhanger', 'daemon', 'daemon2', 'defiler', 'enduro', 'esskey', 'faggio', 'gargoyle', 'hakuchou', 'hexer', 'innovation', 'lectro', 'nemesis', 'pcj', 'ruffian', 'sanchez', 'sovereign', 'thrust', 'vader', 'vindicator', 'vortex', 'wolfsbane', 'zombiea'
    },
    ['Emergency'] = {
        'ambulance', 'fbi', 'fbi2', 'firetruk', 'lguard', 'pbus', 'police', 'police2', 'police3', 'police4', 'policeb', 'policeold1', 'policeold2', 'policet', 'pranger', 'predator', 'riot', 'sheriff', 'sheriff2'
    }
}

-- Weather Types
Config.WeatherTypes = {
    'CLEAR', 'EXTRASUNNY', 'CLOUDS', 'OVERCAST', 'RAIN', 'CLEARING', 'THUNDER', 'SMOG', 'FOGGY', 'XMAS', 'SNOWLIGHT', 'BLIZZARD'
}

-- Teleport Locations
Config.TeleportLocations = {
    ['Los Santos Airport'] = {x = -1037.0, y = -2737.0, z = 20.0},
    ['Mount Chiliad'] = {x = 501.0, y = 5604.0, z = 797.0},
    ['Vinewood Sign'] = {x = -1465.0, y = 876.0, z = 190.0},
    ['Maze Bank Tower'] = {x = -75.0, y = -818.0, z = 326.0},
    ['Fort Zancudo'] = {x = -2267.0, y = 3123.0, z = 32.0},
    ['Sandy Shores'] = {x = 1836.0, y = 3672.0, z = 34.0},
    ['Paleto Bay'] = {x = -101.0, y = 6467.0, z = 31.0}
}