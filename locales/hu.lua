TW = TW or {}

local Translations = {
    error = {
        no_permission = 'Nincs jogosultságod ehhez a parancshoz!',
        invalid_player = 'Érvénytelen játékos ID!',
        invalid_vehicle = 'Érvénytelen jármű model!',
        player_offline = 'A játékos nincs online!',
        vehicle_exists = 'Ez a játékos már rendelkezik ezzel a járművel!'
    },
    success = {
        vehicle_given = 'Jármű sikeresen megadva %s-nak/nek!',
        vehicle_received = 'Új járművet kaptál!',
        tarp_applied = 'Ponyva felhelyezve',
        tarp_removed = 'Ponyva eltávolítva'
    },
    target = {
        apply_tarp = 'Ponyva felhelyezése',
        remove_tarp = 'Ponyva levétele'
    }
}

TW[Config.Locale] = Translations
