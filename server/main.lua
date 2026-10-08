local ESX = exports['es_extended']:getSharedObject()

TW = {}

-- Load player vehicles on join
AddEventHandler('esx:playerLoaded', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer then
        TriggerClientEvent('esx_vehicle:loadPlayerVehicles', playerId, xPlayer.identifier)
    end
end)

-- Clean up vehicles on disconnect
AddEventHandler('playerDropped', function(reason)
    local playerId = source
    TriggerClientEvent('esx_vehicle:removePlayerVehicles', playerId)
end)

-- Get player vehicles from database
function GetPlayerVehicles(identifier)
    local vehicles = {}
    local result = MySQL.query.await('SELECT * FROM ' .. Config.VehicleTable .. ' WHERE owner = ?', { identifier })
    
    if result and #result > 0 then
        vehicles = result
    end
    
    return vehicles
end

-- Get vehicle data
function GetVehicleData(vehicleId)
    local result = MySQL.query.await('SELECT * FROM ' .. Config.VehicleTable .. ' WHERE id = ?', { vehicleId })
    if result and result[1] then
        return result[1]
    end
    return nil
end

-- Save vehicle data
function SaveVehicleData(vehicleData)
    if vehicleData.id then
        MySQL.update.await('UPDATE ' .. Config.VehicleTable .. ' SET state = ?, vehicle_props = ?, fuel = ?, engine = ?, body = ?, tarp = ? WHERE id = ?', {
            json.encode(vehicleData.state),
            json.encode(vehicleData.vehicle_props),
            vehicleData.fuel,
            vehicleData.engine,
            vehicleData.body,
            vehicleData.tarp,
            vehicleData.id
        })
    end
end

-- Generate random plate
function GeneratePlate()
    local plate = ''
    for i = 1, 8 do
        local randType = math.random(0, 1)
        if randType == 0 then
            plate = plate .. string.char(math.random(65, 90))
        else
            plate = plate .. tostring(math.random(0, 9))
        end
    end
    return plate
end

-- Export functions
exports('GetPlayerVehicles', GetPlayerVehicles)
exports('GetVehicleData', GetVehicleData)
exports('SaveVehicleData', SaveVehicleData)
exports('GeneratePlate', GeneratePlate)
