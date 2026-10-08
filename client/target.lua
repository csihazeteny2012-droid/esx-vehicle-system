local ESX = exports['es_extended']:getSharedObject()

-- Add ox_target options to vehicles
AddEventHandler('esx:playerLoaded', function()
    Wait(1000)
    UpdateVehicleTargets()
end)

RegisterNetEvent('esx_vehicle:loadPlayerVehicles', function()
    Wait(500)
    UpdateVehicleTargets()
end)

function UpdateVehicleTargets()
    if PlayerVehicles and #PlayerVehicles > 0 then
        for _, vehicle in ipairs(PlayerVehicles) do
            if vehicle.entity and DoesEntityExist(vehicle.entity) then
                AddVehicleTargets(vehicle.entity, vehicle.id)
            end
        end
    end
end

function AddVehicleTargets(vehicle, vehicleId)
    -- Apply tarp option
    exports.ox_target:addEntity(vehicle, {
        {
            label = TW[Config.Locale].target.apply_tarp,
            icon = 'fa-solid fa-sheet',
            distance = Config.TargetDistance,
            onSelect = function()
                ApplyTarp(vehicle, vehicleId)
            end,
            canInteract = function()
                return not IsVehicleTarpApplied(vehicle)
            end
        },
        {
            label = TW[Config.Locale].target.remove_tarp,
            icon = 'fa-solid fa-sheet',
            distance = Config.TargetDistance,
            onSelect = function()
                RemoveTarp(vehicle, vehicleId)
            end,
            canInteract = function()
                return IsVehicleTarpApplied(vehicle)
            end
        }
    })
end

function IsVehicleTarpApplied(vehicle)
    for _, vehicle_ in ipairs(PlayerVehicles) do
        if vehicle_.entity == vehicle then
            return vehicle_.tarp == 1
        end
    end
    return false
end
