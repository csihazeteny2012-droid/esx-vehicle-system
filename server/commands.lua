local ESX = exports['es_extended']:getSharedObject()

-- /givecar command - Give vehicle to player
ESX.RegisterCommand('givecar', 'admin', function(xPlayer, args, showError)
    local targetPlayerId = tonumber(args[1])
    local vehicleModel = string.lower(args[2])
    
    if not targetPlayerId then
        return showError(TW[Config.Locale].error.invalid_player)
    end
    
    local targetPlayer = ESX.GetPlayerFromId(targetPlayerId)
    if not targetPlayer then
        return showError(TW[Config.Locale].error.player_offline)
    end
    
    local modelHash = GetHashKey(vehicleModel)
    if not IsModelAVehicle(modelHash) then
        return showError(TW[Config.Locale].error.invalid_vehicle)
    end
    
    -- Generate plate and check if exists
    local plate = GeneratePlate()
    
    -- Check if player already owns this vehicle model
    local vehicles = GetPlayerVehicles(targetPlayer.identifier)
    for _, v in ipairs(vehicles) do
        local props = json.decode(v.vehicle_props)
        if props.model == vehicleModel then
            return showError(TW[Config.Locale].error.vehicle_exists)
        end
    end
    
    -- Insert into database
    local vehicleProps = {
        model = vehicleModel,
        plate = plate,
        label = vehicleModel,
    }
    
    MySQL.insert.await('INSERT INTO ' .. Config.VehicleTable .. ' (owner, plate, vehicle_props, state, fuel, engine, body, tarp) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        targetPlayer.identifier,
        plate,
        json.encode(vehicleProps),
        json.encode({}),
        100,
        1000.0,
        1000.0,
        0
    })
    
    TriggerClientEvent('esx:showNotification', targetPlayerId, TW[Config.Locale].success.vehicle_received)
    TriggerClientEvent('esx_vehicle:loadPlayerVehicles', targetPlayerId, targetPlayer.identifier)
    
    TriggerClientEvent('chat:addMessage', xPlayer.source, {
        args = { 'Vehicle System', string.format(TW[Config.Locale].success.vehicle_given, targetPlayer.getName()) }
    })
end, true, { help = 'Give a vehicle to a player', validate = true, arguments = {
    { name = 'playerId', help = 'Player ID' },
    { name = 'vehicleModel', help = 'Vehicle model' }
}})
