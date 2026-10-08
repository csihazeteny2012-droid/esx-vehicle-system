local ESX = exports['es_extended']:getSharedObject()

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

function GetOwnedVehiclesByOwner(owner)
    local rows = MySQL.query.await('SELECT * FROM ' .. Config.VehicleTable .. ' WHERE owner = ?', { owner })
    if not rows then
        return {}
    end
    return rows
end

function SaveVehicleState(vehicleId, payload)
    if not vehicleId or not payload then
        return false
    end

    local result = MySQL.update.await(
        'UPDATE ' .. Config.VehicleTable .. ' SET state = ?, vehicle_props = ?, fuel = ?, engine = ?, body = ?, tarp = ? WHERE id = ?',
        {
            json.encode(payload.state or {}),
            json.encode(payload.vehicle_props or {}),
            payload.fuel or 100,
            payload.engine or 1000.0,
            payload.body or 1000.0,
            payload.tarp or 0,
            vehicleId
        }
    )

    return result ~= nil
end

ESX.RegisterServerCallback('esx_vehicle:getOwnedVehicles', function(source, cb, identifier)
    local rows = GetOwnedVehiclesByOwner(identifier)
    cb(rows or {})
end)

ESX.RegisterServerCallback('esx_vehicle:saveVehicleState', function(source, cb, vehicleId, payload)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb(false)
        return
    end

    local rows = MySQL.query.await('SELECT * FROM ' .. Config.VehicleTable .. ' WHERE id = ? AND owner = ?', { vehicleId, xPlayer.identifier })
    if not rows or #rows == 0 then
        cb(false)
        return
    end

    cb(SaveVehicleState(vehicleId, payload))
end)
