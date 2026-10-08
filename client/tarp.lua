local ESX = exports['es_extended']:getSharedObject()

local tarpProps = {}

-- Apply tarp to vehicle
function ApplyTarp(vehicle, vehicleId)
    if not DoesEntityExist(vehicle) then
        return
    end
    
    local modelHash = GetHashKey(Config.TarpProp)
    RequestModel(modelHash)
    
    while not HasModelLoaded(modelHash) do
        Wait(10)
    end
    
    local tarpProp = CreateObject(modelHash, GetEntityCoords(vehicle), false, false, true)
    
    if tarpProp ~= 0 then
        AttachEntityToEntity(
            tarpProp,
            vehicle,
            GetEntityBoneIndexByName(vehicle, 'chassis'),
            Config.TarpAttachOffset.x,
            Config.TarpAttachOffset.y,
            Config.TarpAttachOffset.z,
            0.0, 0.0, 0.0,
            false, false, false, false, 2, true
        )
        
        tarpProps[vehicleId] = tarpProp
        
        -- Update vehicle data
        for _, v in ipairs(PlayerVehicles) do
            if v.id == vehicleId then
                v.tarp = 1
                break
            end
        end
        
        TriggerEvent('chat:addMessage', {
            args = { 'Vehicle', TW[Config.Locale].success.tarp_applied }
        })
    end
    
    ReleaseModelAndFreeMem(modelHash)
end

-- Remove tarp from vehicle
function RemoveTarp(vehicle, vehicleId)
    if tarpProps[vehicleId] and DoesEntityExist(tarpProps[vehicleId]) then
        DeleteEntity(tarpProps[vehicleId])
        tarpProps[vehicleId] = nil
        
        -- Update vehicle data
        for _, v in ipairs(PlayerVehicles) do
            if v.id == vehicleId then
                v.tarp = 0
                break
            end
        end
        
        TriggerEvent('chat:addMessage', {
            args = { 'Vehicle', TW[Config.Locale].success.tarp_removed }
        })
    end
end

-- Reattach tarps on vehicle spawn
SetInterval(function()
    if PlayerVehicles then
        for _, vehicle in ipairs(PlayerVehicles) do
            if vehicle.tarp == 1 and vehicle.entity and DoesEntityExist(vehicle.entity) then
                if not tarpProps[vehicle.id] or not DoesEntityExist(tarpProps[vehicle.id]) then
                    ApplyTarp(vehicle.entity, vehicle.id)
                end
            end
        end
    end
end, 5000)
