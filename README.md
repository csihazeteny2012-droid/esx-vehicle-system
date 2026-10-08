# ESX Vehicle System

FiveM ESX Legacy persistent vehicle system with tarp management and ox_target integration.

## Features

- **Persistent Vehicles**: Vehicles stay where players leave them
- **Auto-Despawn/Respawn**: Vehicles disappear on disconnect, reappear on reconnect
- **Tarp System**: Apply and remove tarps with ox_target
- **Vehicle State**: Saves fuel, engine, body, heading, position
- **Admin Commands**: `/givecar` to give vehicles to players
- **Plate System**: Random plate generation and database tracking
- **ox_target Integration**: Easy vehicle interactions

## Dependencies

- es_extended (ESX Legacy)
- ox_lib
- oxmysql
- ox_target

## Installation

1. Download or clone this resource to your `resources` folder
2. Run the `SQL.sql` file in your database to create the `owned_vehicles` table
3. Add to your `server.cfg`:
   ```
   ensure esx-vehicle-system
   ```
4. Restart your server

## Commands

### /givecar (Admin Only)
Give a vehicle to a player

```
/givecar <playerId> <vehicleModel>
```

**Example:**
```
/givecar 5 sultan
```

This will:
- Spawn a Sultan for player ID 5
- Add it to their owned_vehicles database entry
- Generate a random 8-character plate
- Allow them to manage it with the persistent system

## Configuration

Edit `shared/config.lua` to customize:

- **Locale**: Language (hu/en)
- **VehicleModels**: Available vehicle models
- **TarpProp**: Tarp model (default: `carcover_01`)
- **TargetDistance**: Distance for ox_target interactions (default: 3.0)
- **RespawnTime**: Vehicle respawn delay in seconds

## Usage

### For Players

1. Vehicles are automatically loaded when you join
2. Vehicles persist where you left them
3. Use ox_target (scroll/aim) near your vehicle to:
   - Apply tarp
   - Remove tarp
4. Vehicles are saved every 30 seconds
5. On disconnect, vehicles disappear
6. On reconnect, vehicles respawn at their last location

### For Admins

```
/givecar <playerID> <vehicleModel>
```

Example:
```
/givecar 1 adder
```

This creates a new vehicle entry in the database for the player.

## Vehicle Data Saved

- Position (X, Y, Z)
- Heading (rotation)
- Fuel level
- Engine health
- Body health
- Vehicle props (color, mods, etc.)
- Tarp state

## Localization

Supported languages:
- Hungarian (hu)
- English (en)

Edit `locales/hu.lua` or `locales/en.lua` to customize messages.

## Troubleshooting

**Vehicles not spawning:**
- Check if the `owned_vehicles` table exists in your database
- Verify player identifier matches the database
- Check server console for errors

**Vehicles disappearing:**
- Vehicles are removed on disconnect (by design)
- Wait 30 seconds for automatic save before disconnect

**ox_target not working:**
- Ensure `ox_target` is properly installed
- Check distance (`Config.TargetDistance`)
- Reload the resource with `/refresh` or restart server

## License

MIT License
