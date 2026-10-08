local ESX = exports['es_extended']:getSharedObject()

local PlayerVehicles = {}

RegisterNetEvent('esx_vehicle:registerTarget', function(entity, data)
    local options = {
        {
            label = TW[Config.Locale].target.apply_tarp,
            icon = 'fa-solid fa-sheet-plastic',
            distance = Config.TargetDistance,
            onSelect = function()
                TriggerEvent('esx_vehicle:applyTarp', entity, data.id)
            end,
            canInteract = function()
                return data.tarp == 0
            end
        },
        {
            label = TW[Config.Locale].target.remove_tarp,
            icon = 'fa-solid fa-sheet-plastic',
            distance = Config.TargetDistance,
            onSelect = function()
                TriggerEvent('esx_vehicle:removeTarp', entity, data.id)
            end,
            canInteract = function()
                return data.tarp == 1
            end
        }
    }

    exports.ox_target:addLocalEntity(entity, options)
end)

RegisterNetEvent('esx_vehicle:loadPlayerVehicles', function(identifier)
    ESX.TriggerServerCallback('esx_vehicle:getOwnedVehicles', function(rows)
        for _, vehicle in ipairs(PlayerVehicles) do
            if vehicle.entity and DoesEntityExist(vehicle.entity) then
                DeleteEntity(vehicle.entity)
            end
        end
        PlayerVehicles = {}

        if not rows then
            return
        end

        for _, row in ipairs(rows) do
            local state = json.decode(row.state or '{}')
            local props = json.decode(row.vehicle_props or '{}')

            if state.x and state.y and state.z then
                local modelHash = GetHashKey(props.model or 'sultan')
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                    Wait(10)
                end

                local veh = CreateVehicle(modelHash, state.x, state.y, state.z, state.heading or 0.0, true, false)
                if veh and veh ~= 0 then
                    SetVehicleNumberPlateText(veh, row.plate)
                    SetVehicleFuelLevel(veh, tonumber(row.fuel or 100))
                    SetVehicleEngineHealth(veh, tonumber(row.engine or 1000.0))
                    SetVehicleBodyHealth(veh, tonumber(row.body or 1000.0))

                    table.insert(PlayerVehicles, {
                        id = row.id,
                        entity = veh,
                        tarp = tonumber(row.tarp or 0),
                        model = props.model,
                        plate = row.plate,
                        owner = row.owner
                    })

                    TriggerEvent('esx_vehicle:registerTarget', veh, PlayerVehicles[#PlayerVehicles])
                end
            end
        end
    end, identifier)
end)

RegisterNetEvent('esx:playerLoaded', function()
    Wait(1000)
    local xPlayer = ESX.GetPlayerData()
    if xPlayer and xPlayer.identifier then
        TriggerEvent('esx_vehicle:loadPlayerVehicles', xPlayer.identifier)
    end
end)
