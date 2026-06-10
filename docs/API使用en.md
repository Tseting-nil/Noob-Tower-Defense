# NTD API Usage Guide

> Game: Roblox *Noob Tower Defense*
>
> Lobby PlaceId: `127758462685845`
>
> In-game PlaceId: `131658557901126`
>
> Global object after load: `getgenv().NTD`, flag: `getgenv().NTDAPI = true`

NTD is an automation API for Noob Tower Defense. After loading, it detects the current PlaceId and initializes either lobby resources or in-game resources automatically. You only need to call `NTD.*` functions.

This document follows `API/完整_正式版.lua`.

---

## Contents

1. [Loading & Language](#1-loading--language)
2. [Teleport Resume](#2-teleport-resume)
3. [Scene Detection](#3-scene-detection)
4. [Lobby API](#4-lobby-api)
5. [Equip API](#5-equip-api)
6. [In-Game Queue API](#6-in-game-queue-api)
7. [Direct In-Game Control](#7-direct-in-game-control)
8. [Phase 2 Maps](#8-phase-2-maps)
9. [Settings & Queries](#9-settings--queries)
10. [Retry & Safety](#10-retry--safety)
11. [Complete Example](#11-complete-example)
12. [Quick Reference](#12-quick-reference)

---

## 1. Loading & Language

The API is loaded after the key system verification succeeds:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Tseting-nil/Noob-Tower-Defense/refs/heads/main/%E5%AF%86%E9%91%B0%E7%B3%BB%E7%B5%B1.lua"))()
```

After loading:

```lua
getgenv().NTD
getgenv().NTDAPI = true
```

Language is read from:

```text
Tsetingnil_script/NTD/API_VAR.json
```

English output:

```json
{ "language": "English" }
```

Any other value, or a missing file, defaults to Chinese output.

---

## 2. Teleport Resume

When Roblox teleports from lobby to game, the running script memory is cleared. NTD resumes automation by combining `queue_on_teleport` with a local script file.

Recommended flow:

1. In the lobby, call `NTD.SaveLocalScript(scriptContent)`.
2. The API saves it to `Tsetingnil_script/NTD/main_<UserId>.lua`.
3. Call `NTD.SelectMap(...)`.
4. When teleport starts, the API injects the resume loader.
5. In the game place, it runs `loadfile("Tsetingnil_script/NTD/main_<UserId>.lua")()`.

In the lobby or an unknown PlaceId, the resume loader shows a confirmation dialog. It auto-confirms when the countdown ends. In the in-game PlaceId, it resumes directly.

The API also watches CoreGui disconnect prompts. When a disconnect prompt appears, it reinjects the resume loader. This requires an executor with `queue_on_teleport` support.

---

## 3. Scene Detection

| Function | Returns | Description |
|---|---:|---|
| `NTD.IsLobby()` | boolean | Whether the current PlaceId is the lobby |
| `NTD.IsInGame()` | boolean | Whether the current PlaceId is the in-game place |

---

## 4. Lobby API

### `NTD.GotoElevators()`

Finds an empty elevator, moves into the Play area, and navigates to the elevator.

Behavior:

- Chooses only elevators with no players on the platform.
- If another player occupies the target elevator first, navigation stops and another elevator is selected.
- If navigation times out after about 45 seconds, it retries.
- Elevator entry is detected through the internal `Constants.inElevator` flag, which is more stable than checking UI visibility.

### `NTD.SelectMap(mapName, modes)`

Selects a map and starts the elevator. If you are not already in an elevator, it automatically calls `NTD.GotoElevators()` and waits up to about 60 seconds.

| Param | Type | Description |
|---|---|---|
| `mapName` | string | Map name, e.g. `"Plains"` |
| `modes` | nil / string / table | `nil` means no extra modes; string means one mode; table means multiple modes |

```lua
NTD.SelectMap("Plains")
NTD.SelectMap("Plains", "Rush")
NTD.SelectMap("Plains", { "Rush", "Boss" })
```

Notes:

- If the previous `NTD.EquipTower(...)` failed, `SelectMap` aborts to avoid starting automation with missing towers.
- The resume loader is injected only when teleport actually starts.
- If the user manually leaves the elevator, the map selection flow stops.

### `NTD.StartGame()`

Sends the start-elevator event. Usually called by `SelectMap`; manual use is rarely needed.

### `NTD.SaveLocalScript(scriptContent)`

Saves the Lua code that should resume after teleport.

```lua
NTD.SaveLocalScript([[
    NTD.AddSetSpeed(3, 1)
    NTD.ExecuteQueue()
]])
```

Saved path:

```text
Tsetingnil_script/NTD/main_<UserId>.lua
```

### `NTD.Lobby()`

Injects a loader that reloads the lobby UI after returning, then sends the game's Return event.

Requires `queue_on_teleport`.

---

## 5. Equip API

### `NTD.EquipTower(names) -> boolean`

Equips towers by name. It keeps already-equipped towers that match the target list, unequips extras, equips missing targets, then verifies the final hotbar.

Accepted formats:

```lua
NTD.EquipTower("Marksman")
NTD.EquipTower({ "Marksman", "Farm", "Sniper" })
NTD.EquipTower({ "Marksman", { "Doombringer", "Shiny" } })
NTD.EquipTower({ "Marksman", { "Doombringer", { "Shiny", "Prime" } } })
NTD.EquipTower({ "Marksman", { "Doombringer", "Speed2" } })
```

`condition` may be a string or array and is used as a mutation filter. Without a condition, the API prefers the same tower with no mutations, then falls back to another same-name tower when needed.

Equip flow:

1. Scan the current hotbar.
2. Match condition-specific entries first.
3. Assign each target one UUID only.
4. Unequip extra towers.
5. Equip missing towers.
6. Poll for up to about 3 seconds to confirm server data has synced.

If a tower is missing or final verification fails, it returns `false` and marks `equipFailed`; the next `NTD.SelectMap(...)` will automatically abort.

### `NTD.GetEquippedUUIDs() -> table`

Returns an array of currently equipped tower UUIDs, up to 6.

### `NTD.UnequipAll() -> boolean`

Unequips every currently equipped tower and verifies that the hotbar is empty.

The official version does not currently assign a Chinese-key alias. Use `NTD.UnequipAll()`.

---

## 6. In-Game Queue API

Queue mode is for recorded or fixed automation routes. Add operations with `Add*` functions, then call `NTD.ExecuteQueue()`.

Sort rules:

- First by `phase`: `1 < 1.5 < 2`
- Within the same phase, by `elapsed` ascending

Tower order rules:

- Every successful placement receives an order starting from `1`.
- Upgrade, sell, and ability operations reference that order.
- If all placement retries fail, the API still advances the order and leaves a hole, so later towers do not receive the wrong order.

### `NTD.AddPlaceTower(unitType, x, y, z, rotation, elapsed [, condition])`

Queues a tower placement.

| Param | Type | Description |
|---|---|---|
| `unitType` | string | Tower name |
| `x, y, z` | number | World coordinates; must be on a `Placeable` |
| `rotation` | number | Reserved parameter; the current official version mainly uses coordinates and tower data |
| `elapsed` | number | Seconds after game start |
| `condition` | string / table / nil | Mutation filter |

```lua
NTD.AddPlaceTower("Farm", 10, 5, 20, 0, 5.0)
NTD.AddPlaceTower("Doombringer", 12, 5, 22, 0, 8.0, "Shiny")
```

### `NTD.AddUpgradeTower(order, elapsed)`

Upgrades the `order`-th successfully placed tower at the given time.

### `NTD.AddSellTower(order, elapsed)`

Sells the `order`-th tower. After selling, that order is cleared and cannot be upgraded or sold again.

### `NTD.AddTowerAbility(order, abilityName, elapsed)`

Uses an ability on the `order`-th tower.

```lua
NTD.AddTowerAbility(2, "Rage", 60)
```

### `NTD.AddSkipWave(elapsed)`

Queues a skip-wave action. If `AutoSkipWave` is already enabled, the operation is skipped automatically.

### `NTD.AddSetSpeed(speed, elapsed)`

Sets game speed.

```lua
NTD.AddSetSpeed(3, 10)
```

### `NTD.AddGameSetting(settingName, value, elapsed)`

Toggles a game setting at the given time. It calls `ToggleSetting` only when the current value differs from the target value.

```lua
NTD.AddGameSetting("AutoSkipWave", true, 2)
```

### `NTD.AddEnd(elapsed)`

Adds an end marker and sets the reference point for `NTD.GetQueueRemaining()`.

When the `end` operation runs, the API starts a 5-minute timeout timer. If the timer expires and `AutoReplay` is enabled, it injects the resume loader and replays.

### `NTD.ExecuteQueue()`

Runs the queue. In-game only.

Flow:

1. Check that the current scene is in-game.
2. Sort the queue.
3. Start the auto-Ready loop until `GameRunning` becomes `true`.
4. Wait for the game to start.
5. Run operations according to `elapsed`.
6. If an operation is more than 5 seconds late, warn but still run it.
7. Watch game end and auto-replay when `AutoReplay` is enabled.

---

## 7. Direct In-Game Control

| Function | Description |
|---|---|
| `NTD.Ready()` | Sends Ready. If triggered 50 consecutive times, it attempts replay to avoid getting stuck |
| `NTD.Replay()` | Sends Replay |
| `NTD.Difficulty(difficulty)` | Sets difficulty based on current UI state and starts the game; also attaches an end monitor |
| `NTD.GameSetting(settingName, targetValue)` | Immediately toggles a setting only when the current value differs |
| `NTD.GetMap() -> string` | Returns `Values.Map.Value`; returns `"Unknown"` on failure |

---

## 8. Phase 2 Maps

Some maps switch to another map during the run and need Phase 1 / Phase 2 separation.

### `NTD.AddMapWait([scriptName])`

Adds a map-switch wait marker. Its phase is always `1.5`, so it runs after Phase 1 and before Phase 2. After calling it, newly added queue operations are assigned to Phase 2.

`scriptName` is an optional Phase 2 script prefix.

After the map changes, the API:

1. Waits until `Values.Map.Value` becomes the new map name.
2. Resets the Phase 2 timing baseline.
3. Clears Phase 1 placed-tower cache.
4. Keeps `nextOrder`, so Phase 2 order numbers continue after Phase 1.
5. Tries to load an external Phase 2 script.

External script folder:

```text
Tsetingnil_script/NTD/Script
```

Search rules:

- Collect files matching `*_<actualMapName>.lua`.
- If `scriptName` is provided, prefer a basename equal to `<scriptName>` or `<scriptName>_<mapName>`.
- If no preferred file matches, sort by filename descending and use the newest one.
- If an external script is found, the current queue is cleared, the script is loaded, and that script is expected to call `NTD.ExecuteQueue()`.
- If no external script is found, the already-queued inline Phase 2 operations continue.

Example:

```lua
-- Phase 1
NTD.AddPlaceTower("Farm", 10, 5, 20, 0, 5) -- #1
NTD.AddMapWait("MoonRun")

-- If no external MoonRun_<map>.lua is found, this inline Phase 2 still runs
NTD.AddPlaceTower("Marksman", 15, 5, 25, 0, 2) -- #2
NTD.ExecuteQueue()
```

### Automatic Phase 2 Order Offset

External Phase 2 scripts may annotate the first `AddPlaceTower(...)` with the recorded Phase 2 starting order:

```lua
NTD.AddPlaceTower("Marksman", 15, 5, 25, 0, 2) -- #7
NTD.AddUpgradeTower(7, 20)
```

If the actual Phase 1 tower count differs from the recorded run, the API automatically adjusts orders in:

- `AddUpgradeTower(order, ...)`
- `AddSellTower(order, ...)`
- `AddTowerAbility(order, ...)`

Only orders greater than or equal to the annotated starting order are offset.

---

## 9. Settings & Queries

### `NTD.AutoReplay(value: boolean)`

Controls whether the API auto-replays after game end or timeout.

Default: `false`

### `NTD.Debug(value: boolean)`

Main supported usage:

```lua
NTD.Debug(true)
```

Effects:

- Disables auto-Ready.
- Disables auto-replay.
- Loads the placement tracker.

### `NTD.GetQueueElapsed() -> number | nil`

Returns queue elapsed seconds. Returns `nil` before the queue has started.

### `NTD.GetQueueRemaining() -> number | nil`

Returns seconds remaining until `NTD.AddEnd(elapsed)`. May be negative. Returns `nil` if the queue has not started or `AddEnd` was not called.

### `NTD.Auto(boolen)`

Reserved in the official version. No implemented behavior yet.

---

## 10. Retry & Safety

### Placement

Low-level `RawPlaceTower` retries up to 5 times by default, about 0.2 seconds apart.

If the queue layer still sees placement failure, it retries 10 more times, about 0.2 seconds apart.

If all retries fail, it waits about 2 seconds and advances the order anyway, leaving a hole so later towers do not receive the wrong order.

### Upgrade

Low-level `RawUpgradeTower` retries up to 3 times by default, about 0.1 seconds apart.

If the queue layer still sees upgrade failure and the order has a tower id, it retries 10 more times, about 0.2 seconds apart.

### Exception Guard

Placement and upgrade `InvokeServer` calls are wrapped with `pcall`. Each `ExecuteQueue` operation is also wrapped with `pcall`. Server throws or one-off operation errors are treated as failures and do not stop the entire queue coroutine.

---

## 11. Complete Example

### Lobby Script

```lua
NTD.EquipTower({ "Marksman", "Farm" })

NTD.SaveLocalScript([[
    -- Runs automatically after entering the game place
    NTD.AddGameSetting("AutoSkipWave", true, 1)
    NTD.AddSetSpeed(3, 2)

    NTD.AddPlaceTower("Farm", 10, 5, 20, 0, 5)       -- #1
    NTD.AddPlaceTower("Marksman", 15, 5, 25, 0, 8)   -- #2
    NTD.AddUpgradeTower(2, 45)
    NTD.AddTowerAbility(2, "Rage", 60)
    NTD.AddSellTower(1, 120)
    NTD.AddEnd(150)

    NTD.AutoReplay(true)
    NTD.ExecuteQueue()
]])

NTD.SelectMap("Plains", { "Rush" })
```

### In-Game Test

```lua
NTD.AddSetSpeed(3, 1)
NTD.AddPlaceTower("Marksman", 15, 5, 25, 0, 5)
NTD.AddUpgradeTower(1, 30)
NTD.AddEnd(60)
NTD.ExecuteQueue()
```

---

## 12. Quick Reference

### Scene

| Function | Purpose |
|---|---|
| `NTD.IsLobby()` | Detect lobby |
| `NTD.IsInGame()` | Detect in-game |

### Lobby

| Function | Purpose |
|---|---|
| `NTD.GotoElevators()` | Find and navigate to an empty elevator |
| `NTD.SelectMap(mapName, modes)` | Select map and start |
| `NTD.StartGame()` | Start the elevator |
| `NTD.SaveLocalScript(scriptContent)` | Save teleport resume script |
| `NTD.Lobby()` | Return to lobby and load lobby UI |

### Equip

| Function | Purpose |
|---|---|
| `NTD.EquipTower(names)` | Equip target towers |
| `NTD.GetEquippedUUIDs()` | Get equipped UUIDs |
| `NTD.UnequipAll()` | Unequip all towers |

### In-Game Queue

| Function | Purpose |
|---|---|
| `NTD.AddPlaceTower(unit,x,y,z,rot,elapsed[,condition])` | Queue placement |
| `NTD.AddUpgradeTower(order, elapsed)` | Queue upgrade |
| `NTD.AddSellTower(order, elapsed)` | Queue sell |
| `NTD.AddTowerAbility(order, abilityName, elapsed)` | Queue tower ability |
| `NTD.AddSkipWave(elapsed)` | Queue skip wave |
| `NTD.AddSetSpeed(speed, elapsed)` | Queue speed change |
| `NTD.AddGameSetting(settingName, value, elapsed)` | Queue setting toggle |
| `NTD.AddMapWait([scriptName])` | Wait for map switch and enter Phase 2 |
| `NTD.AddEnd(elapsed)` | Queue end marker and timeout guard |
| `NTD.ExecuteQueue()` | Run queue |

### Direct Control, Settings, Queries

| Function | Purpose |
|---|---|
| `NTD.Ready()` | Send Ready |
| `NTD.Replay()` | Replay |
| `NTD.Difficulty(difficulty)` | Set difficulty and start |
| `NTD.GameSetting(settingName, targetValue)` | Toggle setting immediately |
| `NTD.GetMap()` | Get current map |
| `NTD.AutoReplay(bool)` | Set auto-replay |
| `NTD.Debug(bool)` | Debug mode |
| `NTD.GetQueueElapsed()` | Query queue elapsed seconds |
| `NTD.GetQueueRemaining()` | Query seconds until AddEnd |
| `NTD.Auto(boolen)` | Reserved, not implemented |
