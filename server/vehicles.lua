local ESX = exports['es_extended']:getSharedObject()

-- Register callback to load player vehicles
ESX.RegisterServerCallback('esx_vehicle:getPlayerVehicles', function(source, cb, identifier)
    local vehicles = GetPlayerVehicles(identifier)
    cb(vehicles)
end)

-- Save vehicle state
ESX.RegisterServerCallback('esx_vehicle:saveVehicleState', function(source, cb, vehicleId, vehicleData)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb(false)
        return
    end
    
    local vehicle = GetVehicleData(vehicleId)
    if not vehicle or vehicle.owner ~= xPlayer.identifier then
        cb(false)
        return
    end
    
    SaveVehicleData(vehicleData)
    cb(true)
end)

-- Spawn vehicle for player
ESX.RegisterServerCallback('esx_vehicle:spawnVehicle', function(source, cb, vehicleId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb(false)
        return
    end
    
    local vehicle = GetVehicleData(vehicleId)
    if not vehicle or vehicle.owner ~= xPlayer.identifier then
        cb(false)
        return
    end
    
    cb(true, vehicle)
end)
