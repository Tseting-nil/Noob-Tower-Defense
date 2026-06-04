# NTD API Usage Guide 
- By Claude Code

> Game: Roblox *Noob Tower Defense* (PlaceId `131658557901126`)
> Global object after loading: `getgenv().NTD` (flag `getgenv().NTDAPI = true`)

NTD is an automation framework for the tower-defense game. It auto-initializes the right resources based on **where you currently are**, split into **Lobby mode** and **In-Game mode**. After loading the script, just call the `NTD.*` functions.

---

## Table of Contents

1. [Loading & Startup](#1-loading--startup)
2. [Scene Detection](#2-scene-detection)
3. [Lobby Functions](#3-lobby-functions)
4. [In-Game: Operation Queue](#4-in-game-operation-queue)
5. [In-Game: Direct Control](#5-in-game-direct-control)
6. [Settings](#6-settings)
7. [Queue Timing Queries](#7-queue-timing-queries)
8. [Multi-Phase Maps (Phase 2)](#8-multi-phase-maps-phase-2)
9. [Auto-Retry Mechanism](#9-auto-retry-mechanism)
10. [Full Example](#10-full-example)
11. [Quick Reference](#11-quick-reference)

---

## 1. Loading & Startup

API: you must pass the **Key System** verification first before using this service:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Tseting-nil/Noob-Tower-Defense/refs/heads/main/%E5%AF%86%E9%91%B0%E7%B3%BB%E7%B5%B1.lua"))()
```


Flow:

**Once verified, the API auto-loads into the local environment**, creating `getgenv().NTD` (console prints `[NTD] API loaded`)

After loading, the API auto-detects whether you are in the lobby or in a level and initializes the matching resources — no manual init needed. Then just call `NTD.*`.

### Language

On startup it reads `Tsetingnil_script/NTD/API_VAR.json`:

```json
{ "language": "English" }
```

- `language` = `"English"` → English output
- anything else / file missing → Chinese (default)

### Auto-Resume Across Teleports

Lobby → level is a Roblox teleport, which wipes script memory. The framework handles this with `queue_on_teleport`:

1. In the **lobby**, call `NTD.SaveLocalScript(<your in-game script>)` to save the script that should run inside the level to
   `Tsetingnil_script/NTD/main_<YourUserId>.lua`
2. Trigger the teleport (`SelectMap` injects the resume logic automatically)
3. Once in the level, the framework `loadfile`s and runs your saved script again

> The framework also has **disconnect detection**: if it sees CoreGui's ErrorPrompt it auto-reinjects the resume script (requires an executor that supports `queue_on_teleport`).

---

## 2. Scene Detection

| Function | Returns | Description |
|---|---|---|
| `NTD.IsLobby()` | boolean | Whether you are in the lobby |
| `NTD.IsInGame()` | boolean | Whether you are inside a level |

---

## 3. Lobby Functions (lobby only)

### `NTD.GotoElevators()`
Finds an empty elevator, teleports and navigates to it until you enter.
If another player grabs the elevator it auto-retries on a different one; after 30s timeout it gives up and searches again.

### `NTD.SelectMap(mapName, modes)`
Pick a map and start the game (internally calls `GotoElevators` first).

| Param | Type | Description |
|---|---|---|
| `mapName` | string | Map name, e.g. `"Plains"` |
| `modes` | nil / string / table | `nil` → no extra modes; single string → one mode; table → multiple modes |

```lua
NTD.SelectMap("Plains", "Rush")
NTD.SelectMap("Plains", { "Rush", "Boss" })
```

> If a previous `EquipTower` failed (tower missing from inventory), `SelectMap` aborts and will not enter the map.

### `NTD.StartGame()`
Starts the elevator into the level. `SelectMap` calls this for you — rarely needed manually.

### `NTD.EquipTower(names)`
Equips towers by name (via the client-side `equipTower`, with UI updates). Automatically unequips towers not in the list. Max 6 slots.

| Param | Type | Description |
|---|---|---|
| `names` | string / table | A single tower name, or an array mixing `"name"` and `{name, condition}` entries |

`condition` (mutation filter) can be a string (e.g. `"Shiny"`) or a table (e.g. `{"Shiny","Prime"}`).

```lua
NTD.EquipTower("Marksman")
NTD.EquipTower({ "Marksman", "Farm", "Sniper" })
NTD.EquipTower({ "Marksman", { "Doombringer", {"Shiny","Prime"} } })
```

### `NTD.GetEquippedUUIDs() -> table`
Returns the list of currently equipped UUIDs (up to 6).

### `NTD.SaveLocalScript(scriptContent)`
Saves a string to `Tsetingnil_script/NTD/main_<YourUserId>.lua`, used for auto-resume after teleport (see [Loading & Startup](#1-loading--startup)).

### `NTD.Lobby()`
Injects a resume script that reloads the lobby UI after returning, and triggers the return to lobby (requires `queue_on_teleport`).

---

## 4. In-Game: Operation Queue

**Queue model**: stage all operations with the `Add*` family first, then call `ExecuteQueue` to run them all on a schedule.

- **Sort order**: first by `phase` (1 < 1.5 < 2), then within a phase by `elapsed` (seconds after game start), ascending.
- **Order (sequence) system**: every successful placement is auto-assigned an `order`, starting from **1**. Upgrades / sells / abilities reference this order ("the Nth tower placed").

### `NTD.AddPlaceTower(unitType, x, y, z, rotation, elapsed [, condition])`
Queue a "place tower" operation.

| Param | Type | Description |
|---|---|---|
| `unitType` | string | Tower name (must be in inventory) |
| `x, y, z` | number | World coordinates (must land on a `Placeable`) |
| `rotation` | number | Rotation angle |
| `elapsed` | number | Seconds after game start to run |
| `condition` | string / table / nil | mutation filter (e.g. `"Shiny"`); nil = no filter |

### `NTD.AddUpgradeTower(order, elapsed)`
Upgrade the `order`-th placed tower.

### `NTD.AddSellTower(order, elapsed)`
Sell the `order`-th tower. After selling, that order is cleared and can no longer be upgraded/sold.

### `NTD.AddTowerAbility(order, abilityName, elapsed)`
Use an ability on the `order`-th tower. `abilityName` e.g. `"Rage"`, `"Heal"`, `"Spin"` (see the TowerAbilities module for available abilities).

### `NTD.AddSkipWave(elapsed)`
Queue a "skip wave". If the game already has auto-skip enabled, this op is skipped automatically.

### `NTD.AddSetSpeed(speed, elapsed)`
Set game speed (`speed` = 1, 2, 3…).

### `NTD.AddGameSetting(settingName, value, elapsed)`
Toggle a game setting (e.g. `"AutoSkipWave"`) at the given time. Only toggles if the current value differs from `value`.

### `NTD.AddEnd(elapsed)`
Marks the queue's end point and starts a 5-minute timeout timer: on timeout, if `AutoReplay` is on it auto-replays. Also sets the baseline for `GetQueueRemaining`.

### `NTD.ExecuteQueue()`
Runs the queue. In-game only. Flow:
1. Wait for game start (auto-clicks Ready if `AutoReady` is on)
2. Schedule each op by its `elapsed` using an internal timer
3. Monitor game over; auto-replay on end if `AutoReplay` is on
4. Ops more than 5s late emit a `warn`, but still run (never skipped for lateness)

---

## 5. In-Game: Direct Control

Immediate, non-queued operations.

| Function | Description |
|---|---|
| `NTD.Ready()` | Send Ready to the server. Safety guard: 50 consecutive triggers auto-restart |
| `NTD.Replay()` | Trigger a replay |
| `NTD.Difficulty(difficulty)` | Set difficulty based on current UI state and start, attaching a game-over monitor |
| `NTD.GameSetting(settingName, targetValue)` | Immediately set a setting to `targetValue` (only if it differs) |
| `NTD.GetMap() -> string` | Current map name (returns `"Unknown"` on failure) |

---

## 6. Settings

### `NTD.AutoReplay(value: boolean)`
Whether to auto-restart after the game ends.

### `NTD.Debug(value: boolean)`
`NTD.Debug(true)`: disables auto-Ready and auto-replay, and loads the **placement tracker** (for capturing tower coordinates / debugging).

---

## 7. Queue Timing Queries

| Function | Returns | Description |
|---|---|---|
| `NTD.GetQueueElapsed()` | number / nil | Seconds the queue has run (since game start). nil if `ExecuteQueue` not called yet |
| `NTD.GetQueueRemaining()` | number / nil | Seconds left until the `AddEnd` time point; negative = past it. nil if `ExecuteQueue` or `AddEnd` not called |

---

## 8. Multi-Phase Maps (Phase 2)

Some maps (e.g. Moon) switch maps mid-run, requiring the queue to be split into Phase 1 / Phase 2.

### `NTD.AddMapWait([targetMap])`
Inserts a "wait for map switch" marker (phase 1.5, ordered after all Phase 1, before Phase 2). After calling it, all subsequently added ops belong to **Phase 2**.

- with `targetMap` → wait until the map switches to that name
- omitted → wait until the map switches to any map different from the current one

After the switch, the framework: resets the Phase 2 timing baseline, clears Phase 1 tower instance data (but **keeps order numbering continuous**: Phase 1 #1..#N → Phase 2 starts at #N+1), and tries to load an external Phase 2 script
`Tsetingnil_script/NTD/Script/*_<mapName>.lua`.

> **Auto order offset**: if the external Phase 2 script annotates its recorded starting order with `-- #N`, the framework auto-corrects the `order` of `AddUpgradeTower` / `AddSellTower` / `AddTowerAbility` to match this run's actual Phase 1 tower count — no manual edits needed.

---

## 9. Auto-Retry Mechanism

Placement / upgrade use two layers of auto-retry to improve success under lag or rate-limiting, and to protect the order sequence from corruption.

### Place
```
ExecuteOperation → RawPlaceTower (low-level retry 5× × 0.2s)
   success → orderToId[nextOrder] = id, nextOrder++  ✅
   fail    → queue layer adds 10 more (× 0.2s, ~2s)
               success → assign order, nextOrder++  ✅
               all fail → wait 2s then force nextOrder++ (leave a hole so later
                          towers don't steal the order) ⏭
   total: up to 5 + 10 = 15 attempts (~3s)
```

### Upgrade
```
ExecuteOperation → look up orderToId[order]
   not found (tower never placed) → no retry, skip ⏭
   found → RawUpgradeTower (low-level retry 3× × 0.1s)
             fail → queue layer adds 10 more (× 0.2s) → give up if all fail ⏭
   total: up to 3 + 10 = 13 attempts
```

### Exception Guard
Every `InvokeServer` and the queue main loop's `ExecuteOperation` are wrapped in `pcall`: a server-side error (throw) is treated as a normal failure and flows into the retry/skip logic above, so it **never silently kills the whole queue coroutine**.

---

## 10. Full Example

```lua
-- ===== In the lobby =====
-- Save the in-game script first, so it auto-resumes after teleport
NTD.SaveLocalScript([[
    NTD.EquipTower({ "Marksman", "Farm" })

    -- Build the queue (elapsed = seconds after game start)
    NTD.AddPlaceTower("Farm",     10, 5, 20, 0, 5.0)   -- +5.0s place Farm     (→ #1)
    NTD.AddPlaceTower("Marksman", 15, 5, 25, 0, 8.5)   -- +8.5s place Marksman (→ #2)
    NTD.AddUpgradeTower(2, 45.0)                        -- +45s upgrade #2 (Marksman)
    NTD.AddSetSpeed(3, 60.0)                            -- +60s set 3x speed
    NTD.AddSkipWave(90.0)                               -- +90s skip wave
    NTD.AddSellTower(1, 120.0)                          -- +120s sell #1 (Farm)
    NTD.AddEnd(150.0)                                   -- end marker + timeout guard

    NTD.AutoReplay(true)                               -- auto-restart on end
    NTD.ExecuteQueue()                                 -- start running
]])

-- Pick a map and start (auto enter elevator + teleport, resuming the script above)
NTD.SelectMap("Plains", { "Rush" })
```

---

## 11. Quick Reference

### Scene
| Function | Scene | Purpose |
|---|---|---|
| `IsLobby()` / `IsInGame()` | any | Detect scene |

### Lobby
| Function | Purpose |
|---|---|
| `GotoElevators()` | Enter an elevator |
| `SelectMap(map, modes)` | Pick map & start (auto-enters elevator) |
| `StartGame()` | Start elevator (usually automatic) |
| `EquipTower(names)` | Equip towers |
| `GetEquippedUUIDs()` | Query equipped UUIDs |
| `SaveLocalScript(str)` | Save in-game resume script |
| `Lobby()` | Inject return-to-lobby resume |

### In-Game Queue
| Function | Purpose |
|---|---|
| `AddPlaceTower(unit,x,y,z,rot,elapsed[,cond])` | Place tower (assigns order) |
| `AddUpgradeTower(order, elapsed)` | Upgrade |
| `AddSellTower(order, elapsed)` | Sell |
| `AddTowerAbility(order, ability, elapsed)` | Tower ability |
| `AddSkipWave(elapsed)` | Skip wave |
| `AddSetSpeed(speed, elapsed)` | Game speed |
| `AddGameSetting(name, value, elapsed)` | Toggle setting |
| `AddMapWait([map])` | Wait for map switch (enter Phase 2) |
| `AddEnd(elapsed)` | End marker + timeout guard |
| `ExecuteQueue()` | Run the queue |

### In-Game Direct Control
| Function | Purpose |
|---|---|
| `Ready()` | Send Ready |
| `Replay()` | Replay |
| `Difficulty(diff)` | Set difficulty & start |
| `GameSetting(name, value)` | Immediately toggle a setting |
| `GetMap()` | Current map name |

### Settings / Queries
| Function | Purpose |
|---|---|
| `AutoReplay(bool)` | Auto-restart |
| `Debug(bool)` | Debug mode + placement tracker |
| `GetQueueElapsed()` | Seconds elapsed |
| `GetQueueRemaining()` | Seconds left until AddEnd |
