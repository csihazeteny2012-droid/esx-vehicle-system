local TarpObjects = {}

RegisterNetEvent('esx_vehicle:applyTarp', function(entity, vehicleId)
    if not DoesEntityExist(entity) then
        return
    end

    if TarpObjects[vehicleId] and DoesEntityExist(TarpObjects[vehicleId]) then
        return
    end

    local propHash = GetHashKey(Config.TarpProp)
    RequestModel(propHash)
    while not HasModelLoaded(propHash) do
        Wait(10)
    end

    local obj = CreateObject(propHash, GetEntityCoords(entity), false, false, false)
    if obj and obj ~= 0 then
        AttachEntityToEntity(obj, entity, 0, 0.0, 0.0, 1.1, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        TarpObjects[vehicleId] = obj

        for _, data in ipairs(PlayerVehicles) do
            if data.id == vehicleId then
                data.tarp = 1
                break
            end
        end
    end
end)

RegisterNetEvent('esx_vehicle:removeTarp', function(entity, vehicleId)
    if TarpObjects[vehicleId] and DoesEntityExist(TarpObjects[vehicleId]) then
        DeleteEntity(TarpObjects[vehicleId])
        TarpObjects[vehicleId] = nil

        for _, data in ipairs(PlayerVehicles) do
            if data.id == vehicleId then
                data.tarp = 0
                break
            end
        end
    end
end)
