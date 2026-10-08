local ESX = exports['es_extended']:getSharedObject()

local PlayerVehicles = {}
local spawnedVehicles = {}

-- Load player vehicles
RegisterNetEvent('esx_vehicle:loadPlayerVehicles', function(identifier)
    ESX.TriggerServerCallback('esx_vehicle:getPlayerVehicles', function(vehicles)
        PlayerVehicles = vehicles
        
        -- Spawn all vehicles
        for _, vehicle in ipairs(vehicles) do
            SpawnPlayerVehicle(vehicle)
        end
    end, identifier)
end)

-- Remove player vehicles on disconnect
RegisterNetEvent('esx_vehicle:removePlayerVehicles', function()
    for _, vehicleEntity in ipairs(spawnedVehicles) do
        if DoesEntityExist(vehicleEntity) then
            DeleteEntity(vehicleEntity)
        end
    end
    spawnedVehicles = {}
end)

-- Spawn a vehicle
function SpawnPlayerVehicle(vehicleData)
    if not vehicleData.state or vehicleData.state == '{}' then
        return
    end
    
    local state = json.decode(vehicleData.state)
    if not state.x or not state.y or not state.z then
        return
    end
    
    local modelHash = GetHashKey(vehicleData.vehicle_props and json.decode(vehicleData.vehicle_props).model or 'adder')
    
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(10)
    end
    
    local vehicle = CreateVehicle(modelHash, state.x, state.y, state.z, state.heading or 0.0, true, false)
    
    if vehicle == 0 then
        print('Failed to spawn vehicle ' .. vehicleData.id)
        return
    end
    
    -- Apply vehicle props
    if vehicleData.vehicle_props and vehicleData.vehicle_props ~= '{}' then
        local props = json.decode(vehicleData.vehicle_props)
        if props.plate then
            SetVehicleNumberPlateText(vehicle, props.plate)
        end
        if props.color1 then
            SetVehicleColours(vehicle, props.color1, props.color2 or 0)
        end
        if props.modelsVariations then
            ApplyVehicleCustomization(vehicle, props.modelsVariations)
        end
    end
    
    -- Set fuel, engine, body damage
    if vehicleData.fuel then
        SetVehicleFuelLevel(vehicle, vehicleData.fuel)
    end
    if vehicleData.engine then
        SetVehicleEngineHealth(vehicle, vehicleData.engine)
    end
    if vehicleData.body then
        SetVehicleBodyHealth(vehicle, vehicleData.body)
    end
    
    table.insert(spawnedVehicles, vehicle)
    vehicleData.entity = vehicle
    
    -- Attach tarp if needed
    if vehicleData.tarp == 1 then
        AttachTarp(vehicle, vehicleData.id)
    end
end

-- Apply vehicle customization
function ApplyVehicleCustomization(vehicle, mods)
    if mods then
        for modType, modValue in pairs(mods) do
            SetVehicleMod(vehicle, tonumber(modType) or 0, tonumber(modValue) or -1)
        end
    end
end

-- Get vehicle entity from ID
function GetVehicleFromId(vehicleId)
    for _, vehicle in ipairs(PlayerVehicles) do
        if vehicle.id == vehicleId and vehicle.entity and DoesEntityExist(vehicle.entity) then
            return vehicle.entity
        end
    end
    return nil
end

-- Save all vehicles periodically
SetInterval(function()
    for _, vehicle in ipairs(PlayerVehicles) do
        if vehicle.entity and DoesEntityExist(vehicle.entity) then
            local coords = GetEntityCoords(vehicle.entity)
            vehicle.state = json.encode({
                x = coords.x,
                y = coords.y,
                z = coords.z,
                heading = GetEntityHeading(vehicle.entity)
            })
            vehicle.fuel = math.max(0, GetVehicleFuelLevel(vehicle.entity))
            vehicle.engine = GetVehicleEngineHealth(vehicle.entity)
            vehicle.body = GetVehicleBodyHealth(vehicle.entity)
            
            ESX.TriggerServerCallback('esx_vehicle:saveVehicleState', function(success)
                if not success then
                    print('Failed to save vehicle ' .. vehicle.id)
                end
            end, vehicle.id, vehicle)
        end
    end
end, 30000) -- Save every 30 seconds
