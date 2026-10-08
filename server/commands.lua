local ESX = exports['es_extended']:getSharedObject()

RegisterCommand('givecar', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return
    end

    if xPlayer.getGroup() ~= 'admin' and xPlayer.getGroup() ~= 'superadmin' then
        TriggerClientEvent('chat:addMessage', source, {
            args = {'ERROR', 'Nincs jogosults��god ehhez a parancshoz!'}
        })
        return
    end

    if #args < 2 then
        TriggerClientEvent('chat:addMessage', source, {
            args = {'HELP', 'Helyes használat: /givecar <playerId> <vehicleModel>'}
        })
        return
    end

    local targetPlayerId = tonumber(args[1])
    local vehicleModel = string.lower(tostring(args[2]))

    if not targetPlayerId then
        TriggerClientEvent('chat:addMessage', source, {
            args = {'ERROR', 'Érvénytelen játékos ID!'}
        })
        return
    end

    local allowed = false
    for _, model in ipairs(Config.VehicleModels) do
        if model == vehicleModel then
            allowed = true
            break
        end
    end

    if not allowed then
        TriggerClientEvent('chat:addMessage', source, {
            args = {'ERROR', 'Érvénytelen jármű model: ' .. vehicleModel}
        })
        return
    end

    local targetPlayer = ESX.GetPlayerFromId(targetPlayerId)
    if not targetPlayer then
        TriggerClientEvent('chat:addMessage', source, {
            args = {'ERROR', 'A játékos nincs online!'}
        })
        return
    end

    local ownedVehicles = GetOwnedVehiclesByOwner(targetPlayer.identifier)
    for _, vehicle in ipairs(ownedVehicles) do
        local props = json.decode(vehicle.vehicle_props or '{}')
        if props.model and string.lower(tostring(props.model)) == vehicleModel then
            TriggerClientEvent('chat:addMessage', source, {
                args = {'ERROR', 'Ez a játékos már rendelkezik ezzel a járművel!'}
            })
            return
        end
    end

    local plate = GeneratePlate()
    local props = {
        model = vehicleModel,
        plate = plate,
        label = vehicleModel
    }

    local insertId = MySQL.insert.await(
        'INSERT INTO ' .. Config.VehicleTable .. ' (owner, plate, vehicle_props, state, fuel, engine, body, tarp) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        {
            targetPlayer.identifier,
            plate,
            json.encode(props),
            json.encode({}),
            100,
            1000.0,
            1000.0,
            0
        }
    )

    if insertId then
        TriggerClientEvent('chat:addMessage', source, {
            args = {'Vehicle System', string.format('Jármű sikeresen megadva %s-nak/nek! (Plate: %s)', targetPlayer.getName(), plate)}
        })
        TriggerClientEvent('chat:addMessage', targetPlayerId, {
            args = {'Vehicle System', 'Új ' .. vehicleModel .. ' járművet kaptál! Rendszám: ' .. plate}
        })
        TriggerClientEvent('esx_vehicle:loadPlayerVehicles', targetPlayerId, targetPlayer.identifier)
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = {'ERROR', 'Nem sikerült a jármű hozzáadása az adatbázishoz!'}
        })
    end
end, false)
