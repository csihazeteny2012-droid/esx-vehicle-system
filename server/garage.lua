local ESX = exports['es_extended']:getSharedObject()

function GetOwnedVehiclesByOwner(owner)
    local rows = MySQL.query.await('SELECT * FROM ' .. Config.VehicleTable .. ' WHERE owner = ?', { owner })
    if not rows then
        return {}
    end
    return rows
end

RegisterNetEvent('esx_vehicle:openGarage', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return
    end

    local rows = GetOwnedVehiclesByOwner(xPlayer.identifier)
    local options = {}

    for _, row in ipairs(rows) do
        local props = json.decode(row.vehicle_props or '{}')
        local state = json.decode(row.state or '{}')

        if row.tarp == 1 then
            table.insert(options, {
                title = string.format('%s - %s', props.model or 'vehicle', row.plate),
                description = 'Ponyva felhelyezve, autó a garázsban marad.',
                icon = 'fa-solid fa-car',
                onSelect = function()
                    MySQL.update.await(
                        'UPDATE ' .. Config.VehicleTable .. ' SET state = ?, tarp = ? WHERE id = ?',
                        {
                            json.encode({
                                x = Config.Garages[1].spawnX,
                                y = Config.Garages[1].spawnY,
                                z = Config.Garages[1].spawnZ,
                                heading = Config.Garages[1].spawnHeading
                            }),
                            0,
                            row.id
                        }
                    )

                    TriggerClientEvent('esx_vehicle:loadPlayerVehicles', source, xPlayer.identifier)
                    TriggerClientEvent('chat:addMessage', source, {
                        args = {'Garage', 'Autó kivéve a garázsból: ' .. (props.model or 'vehicle')}
                    })
                end
            })
        end
    end

    if #options == 0 then
        TriggerClientEvent('chat:addMessage', source, {
            args = {'Garage', 'Nincs garázsban autód.'}
        })
        return
    end

    TriggerClientEvent('esx_vehicle:showGarageMenu', source, options)
end)

RegisterNetEvent('esx_vehicle:storeVehicleToGarage', function(vehicleId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return
    end

    local rows = MySQL.query.await('SELECT * FROM ' .. Config.VehicleTable .. ' WHERE id = ? AND owner = ?', { vehicleId, xPlayer.identifier })
    if not rows or #rows == 0 then
        return
    end

    local row = rows[1]
    local state = json.decode(row.state or '{}')

    MySQL.update.await(
        'UPDATE ' .. Config.VehicleTable .. ' SET state = ?, tarp = ? WHERE id = ?',
        {
            json.encode({
                x = Config.Garages[1].spawnX,
                y = Config.Garages[1].spawnY,
                z = Config.Garages[1].spawnZ,
                heading = Config.Garages[1].spawnHeading
            }),
            1,
            row.id
        }
    )

    TriggerClientEvent('esx_vehicle:loadPlayerVehicles', source, xPlayer.identifier)
    TriggerClientEvent('chat:addMessage', source, {
        args = {'Garage', 'Autó visszakerült a garázsba.'}
    })
end)
