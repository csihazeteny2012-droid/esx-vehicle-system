Config = {}

Config.Locale = 'hu'

-- Vehicle models that can be spawned/given
Config.VehicleModels = {
    'sultan',
    'adder',
    'oracle',
    't20',
    'baller',
    'granger',
    'fugitive',
    'asea',
    'oracle80',
    'dilettante',
    'issi2',
    'prairie',
    'panto',
}

-- Tarp prop model
Config.TarpProp = 'carcover_01'

-- Tarp attachment offset
Config.TarpAttachOffset = {
    x = 0.0,
    y = 0.0,
    z = 0.0,
}

-- Plate format
Config.PlateFormat = '^[A-Z0-9]{8}$' -- 8 character random format

-- Target distance for vehicle interactions
Config.TargetDistance = 3.0

-- Vehicle respawn time in seconds (when player rejoins)
Config.RespawnTime = 30

-- Database table name
Config.VehicleTable = 'owned_vehicles'
