local ESX = exports['es_extended']:getSharedObject()

local PlayerVehicles = {}

local function deleteVehicleIfExists(vehicle)
    if vehicle and DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
    end
end

local function spawnVehicleForPlayer(record)
    local state = json.decode(record.state or '{}')
    local props = json.decode(record.vehicle_props or '{}')

    if not state.x or not state.y or not state.z then
        return nil
    end

    local model = props.model or 'sultan'
    local modelHash = GetHashKey(model)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(10)
    end

    local veh = CreateVehicle(modelHash, state.x, state.y, state.z, state.heading or 0.0, true, false)
    if not veh or veh == 0 then
        return nil
    end

    SetVehicleNumberPlateText(veh, record.plate)
    SetVehicleFuelLevel(veh, tonumber(record.fuel or 100))
    SetVehicleEngineHealth(veh, tonumber(record.engine or 1000.0))
    SetVehicleBodyHealth(veh, tonumber(record.body or 1000.0))

    return {
        id = record.id,
        entity = veh,
        tarp = tonumber(record.tarp or 0),
        model = model,
        plate = record.plate,
        owner = record.owner
    }
end

local function refreshPlayerVehicles(identifier)
    ESX.TriggerServerCallback('esx_vehicle:getOwnedVehicles', function(rows)
        for _, old in ipairs(PlayerVehicles) do
            deleteVehicleIfExists(old.entity)
        end
        PlayerVehicles = {}

        if not rows then
            return
        end

        for _, row in ipairs(rows) do
            local spawned = spawnVehicleForPlayer(row)
            if spawned then
                table.insert(PlayerVehicles, spawned)
                TriggerEvent('esx_vehicle:registerTarget', spawned.entity, spawned)
            end
        end
    end, identifier)
end

RegisterNetEvent('esx:playerLoaded', function()
    Wait(1000)
    local xPlayer = ESX.GetPlayerData()
    if xPlayer and xPlayer.identifier then
        refreshPlayerVehicles(xPlayer.identifier)
    end
end)

RegisterNetEvent('esx_vehicle:loadPlayerVehicles', function(identifier)
    refreshPlayerVehicles(identifier)
end)

RegisterNetEvent('esx_vehicle:saveAllVehicles', function()
    for _, data in ipairs(PlayerVehicles) do
        if DoesEntityExist(data.entity) then
            local coords = GetEntityCoords(data.entity)
            local payload = {
                state = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                    heading = GetEntityHeading(data.entity)
                },
                vehicle_props = {
                    model = data.model,
                    plate = data.plate,
                    label = data.model
                },
                fuel = GetVehicleFuelLevel(data.entity),
                engine = GetVehicleEngineHealth(data.entity),
                body = GetVehicleBodyHealth(data.entity),
                tarp = data.tarp or 0
            }

            ESX.TriggerServerCallback('esx_vehicle:saveVehicleState', function(success)
            end, data.id, payload)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(Config.SaveTimer)
        TriggerEvent('esx_vehicle:saveAllVehicles')
    end
end)

RegisterNetEvent('playerDropped', function()
    for _, vehicle in ipairs(PlayerVehicles) do
        if DoesEntityExist(vehicle.entity) then
            DeleteEntity(vehicle.entity)
        end
    end
    PlayerVehicles = {}
end)
