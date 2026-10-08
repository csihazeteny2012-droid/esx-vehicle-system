local Translations = {
    error = {
        no_permission = 'You do not have permission for this command!',
        invalid_player = 'Invalid player ID!',
        invalid_vehicle = 'Invalid vehicle model!',
        player_offline = 'Player is not online!',
        vehicle_exists = 'This player already owns this vehicle!',
        spawn_failed = 'Failed to spawn vehicle!',
    },
    success = {
        vehicle_given = 'Vehicle successfully given to %s!',
        vehicle_received = 'You received a new vehicle!',
        tarp_applied = 'Tarp applied',
        tarp_removed = 'Tarp removed',
    },
    target = {
        apply_tarp = 'Apply Tarp',
        remove_tarp = 'Remove Tarp',
        engine_on = 'Start Engine',
        engine_off = 'Stop Engine',
        access_trunk = 'Open Trunk',
    },
    info = {
        fuel = 'Fuel: %d%%',
        engine = 'Engine: %s',
        body = 'Body: %s',
        tarp = 'Tarp: %s',
    },
}

TW[Config.Locale] = Translations
