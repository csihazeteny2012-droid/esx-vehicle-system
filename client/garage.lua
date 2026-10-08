local ESX = exports['es_extended']:getSharedObject()

local garageMarkerInRange = false
local currentGarageZone = nil

local function getGarageText()
    return 'Garázs\n[ E ] Autó kivétele\n[ G ] Autó visszahozása'
end

local function isPlayerNearGarage(x, y, z)
    for _, garage in ipairs(Config.Garages) do
        local dist = #(vector3(x, y, z) - vector3(garage.x, garage.y, garage.z))
        if dist <= garage.radius then
            return true, garage
        end
    end
    return false, nil
end

CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local inRange, garage = isPlayerNearGarage(coords.x, coords.y, coords.z)

        if inRange and not garageMarkerInRange then
            garageMarkerInRange = true
            currentGarageZone = garage
            exports['ox_lib']:notify({ title = 'Garázs', description = getGarageText(), type = 'inform' })
        elseif not inRange and garageMarkerInRange then
            garageMarkerInRange = false
            currentGarageZone = nil
        end

        if garageMarkerInRange and IsControlJustPressed(0, 38) then
            TriggerServerEvent('esx_vehicle:openGarage')
        end

        if garageMarkerInRange and IsControlJustPressed(0, 47) then
            local player = ESX.GetPlayerData()
            if player and player.identifier then
                TriggerEvent('esx_vehicle:showGarageReturnMenu', player.identifier)
            end
        end

        Wait(200)
    end
end)

RegisterNetEvent('esx_vehicle:showGarageMenu', function(options)
    if not options or #options == 0 then
        return
    end

    local menuItems = {}
    for _, option in ipairs(options) do
        table.insert(menuItems, {
            title = option.title,
            description = option.description,
            icon = option.icon,
            onSelect = option.onSelect
        })
    end

    lib.registerContext({
        id = 'garage_menu',
        title = 'Garázs',
        options = menuItems
    })

    lib.showContext('garage_menu')
end)

RegisterNetEvent('esx_vehicle:showGarageReturnMenu', function(identifier)
    ESX.TriggerServerCallback('esx_vehicle:getOwnedVehicles', function(rows)
        local opts = {}
        for _, row in ipairs(rows or {}) do
            local props = json.decode(row.vehicle_props or '{}')
            if tonumber(row.tarp or 0) == 0 then
                table.insert(opts, {
                    title = string.format('%s - %s', props.model or 'vehicle', row.plate),
                    description = 'Visszakerül a garázsba.',
                    icon = 'fa-solid fa-car',
                    onSelect = function()
                        TriggerServerEvent('esx_vehicle:storeVehicleToGarage', row.id)
                    end
                })
            end
        end

        if #opts == 0 then
            exports['ox_lib']:notify({ title = 'Garázs', description = 'Nincs kint autód a visszahozásra.', type = 'error' })
            return
        end

        lib.registerContext({
            id = 'garage_return_menu',
            title = 'Autó visszahozása',
            options = opts
        })

        lib.showContext('garage_return_menu')
    end, identifier)
end)
