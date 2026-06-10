# NTD API 使用說明

> 適用遊戲：Roblox《Noob Tower Defense》
>
> 大廳 PlaceId：`127758462685845`
>
> 關卡 PlaceId：`131658557901126`
>
> 載入後全域物件：`getgenv().NTD`，旗標：`getgenv().NTDAPI = true`

NTD 是 Noob Tower Defense 的自動化 API。載入後會依目前 PlaceId 自動初始化大廳或關卡資源，使用者只需要呼叫 `NTD.*` 函式。

目前文件以 `API/完整_正式版.lua` 為準。

---

## 目錄

1. [載入與語言](#一載入與語言)
2. [跨傳送續跑](#二跨傳送續跑)
3. [場景判斷](#三場景判斷)
4. [大廳 API](#四大廳-api)
5. [裝備 API](#五裝備-api)
6. [關卡佇列 API](#六關卡佇列-api)
7. [關卡直接控制](#七關卡直接控制)
8. [Phase 2 地圖](#八phase-2-地圖)
9. [設定與查詢](#九設定與查詢)
10. [重試與保護機制](#十重試與保護機制)
11. [完整範例](#十一完整範例)
12. [函式速查](#十二函式速查)

---

## 一、載入與語言

API 需先通過密鑰系統驗證，驗證成功後會自動載入：

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Tseting-nil/Noob-Tower-Defense/refs/heads/main/%E5%AF%86%E9%91%B0%E7%B3%BB%E7%B5%B1.lua"))()
```

載入完成後會建立：

```lua
getgenv().NTD
getgenv().NTDAPI = true
```

語言設定讀取本地檔案：

```text
Tsetingnil_script/NTD/API_VAR.json
```

英文輸出：

```json
{ "language": "English" }
```

其他值或檔案不存在時，預設使用中文輸出。

---

## 二、跨傳送續跑

Roblox 從大廳傳送到關卡時，原本執行中的腳本記憶體會清空。NTD 透過 `queue_on_teleport` 和本地檔案續跑。

建議流程：

1. 在大廳先呼叫 `NTD.SaveLocalScript(scriptContent)`。
2. API 會把內容存到 `Tsetingnil_script/NTD/main_<UserId>.lua`。
3. 呼叫 `NTD.SelectMap(...)` 進圖。
4. Teleport 開始時，API 自動注入續跑腳本。
5. 進入關卡後會自動 `loadfile("Tsetingnil_script/NTD/main_<UserId>.lua")()`。

續跑畫面在大廳或未知 PlaceId 會顯示確認視窗，倒數結束會自動確認；在關卡 PlaceId 會直接續跑。

API 也會監控 CoreGui 的斷線錯誤視窗。偵測到斷線後會重新注入續跑腳本。此功能需要執行器支援 `queue_on_teleport`。

---

## 三、場景判斷

| 函式 | 回傳 | 說明 |
|---|---:|---|
| `NTD.IsLobby()` | boolean | 目前 PlaceId 是否為大廳 |
| `NTD.IsInGame()` | boolean | 目前 PlaceId 是否為關卡 |

---

## 四、大廳 API

### `NTD.GotoElevators()`

尋找空電梯，切到 Play 區域並導航到電梯。

行為：

- 只選平台上沒有玩家的電梯。
- 若電梯被其他玩家先佔用，會停止目前導航並重新找電梯。
- 導航逾時約 45 秒會重新嘗試。
- 是否已進入電梯使用遊戲內部 `Constants.inElevator` 判斷，比單純看 UI 更穩定。

### `NTD.SelectMap(mapName, modes)`

選擇地圖並啟動電梯。若尚未在電梯內，會自動先呼叫 `NTD.GotoElevators()` 並最多等待約 60 秒。

| 參數 | 型別 | 說明 |
|---|---|---|
| `mapName` | string | 地圖名稱，例如 `"Plains"` |
| `modes` | nil / string / table | `nil` 代表不附加模式；string 代表單一模式；table 代表多模式 |

```lua
NTD.SelectMap("Plains")
NTD.SelectMap("Plains", "Rush")
NTD.SelectMap("Plains", { "Rush", "Boss" })
```

注意：

- 如果前一次 `NTD.EquipTower(...)` 失敗，`SelectMap` 會取消進圖，避免背包缺塔仍開始自動化。
- Teleport 真正開始時才注入續跑腳本，避免選圖後使用者改變意圖。
- 如果使用者主動離開電梯，API 會停止後續選圖流程。

### `NTD.StartGame()`

送出啟動電梯事件。通常由 `SelectMap` 自動呼叫，不需要手動使用。

### `NTD.SaveLocalScript(scriptContent)`

儲存關卡內要續跑的 Lua 程式碼。

```lua
NTD.SaveLocalScript([[
    NTD.AddSetSpeed(3, 1)
    NTD.ExecuteQueue()
]])
```

儲存位置：

```text
Tsetingnil_script/NTD/main_<UserId>.lua
```

### `NTD.Lobby()`

注入「回到大廳後載入大廳介面」的續跑腳本，並呼叫遊戲的 Return 事件回大廳。

此功能需要 `queue_on_teleport`。

---

## 五、裝備 API

### `NTD.EquipTower(names) -> boolean`

依塔名裝備塔。會先保留符合目標的已裝備塔，卸下多餘塔，再補上缺少的塔，最後驗證裝備欄。

`names` 可用格式：

```lua
NTD.EquipTower("Marksman")
NTD.EquipTower({ "Marksman", "Farm", "Sniper" })
NTD.EquipTower({ "Marksman", { "Doombringer", "Shiny" } })
NTD.EquipTower({ "Marksman", { "Doombringer", { "Shiny", "Prime" } } })
NTD.EquipTower({ "Marksman", { "Doombringer", "Speed2" } })
```

條件 `condition` 可為字串或陣列，用來篩選 mutation。若沒有指定 condition，API 會優先找沒有 mutation 的同名塔；必要時才使用同名備援。

裝備流程：

1. 掃描目前裝備欄。
2. condition 指定項目優先匹配。
3. 每個目標只會分配一個 UUID。
4. 卸下不需要的塔。
5. 裝備缺少的塔。
6. 最多輪詢約 3 秒確認伺服器資料已同步。

如果找不到塔或最終驗證失敗，回傳 `false`，並標記 `equipFailed`；下一次 `NTD.SelectMap(...)` 會自動中止。

### `NTD.GetEquippedUUIDs() -> table`

回傳目前裝備欄內的塔 UUID 陣列，最多 6 個。

### `NTD.UnequipAll() -> boolean`

解除所有目前裝備中的塔，並輪詢確認是否清空。

正式版目前沒有建立中文 key 別名，請使用 `NTD.UnequipAll()`。

---

## 六、關卡佇列 API

佇列模式適合錄製/重播固定流程。先用 `Add*` 函式排程，再呼叫 `NTD.ExecuteQueue()`。

排序規則：

- 先依 `phase` 排序：`1 < 1.5 < 2`
- 同 phase 內依 `elapsed` 由小到大排序

塔序號規則：

- 每次成功放置會分配一個 order，從 `1` 開始。
- 升級、售出、能力使用都以 order 指定「第幾個放置的塔」。
- 放置重試全部失敗時，API 仍會讓序號前進，留下空洞，避免後面的塔拿到錯誤序號。

### `NTD.AddPlaceTower(unitType, x, y, z, rotation, elapsed [, condition])`

加入放塔操作。

| 參數 | 型別 | 說明 |
|---|---|---|
| `unitType` | string | 塔名 |
| `x, y, z` | number | 世界座標，必須落在 `Placeable` 上 |
| `rotation` | number | 目前參數保留；正式版放置 Remote 主要使用座標與塔資料 |
| `elapsed` | number | 遊戲開始後第幾秒執行 |
| `condition` | string / table / nil | mutation 篩選 |

```lua
NTD.AddPlaceTower("Farm", 10, 5, 20, 0, 5.0)
NTD.AddPlaceTower("Doombringer", 12, 5, 22, 0, 8.0, "Shiny")
```

### `NTD.AddUpgradeTower(order, elapsed)`

在指定時間升級第 `order` 個成功放置的塔。

### `NTD.AddSellTower(order, elapsed)`

在指定時間售出第 `order` 個塔。售出後該 order 會清空，不能再升級或再次售出。

### `NTD.AddTowerAbility(order, abilityName, elapsed)`

對第 `order` 個塔使用能力。

```lua
NTD.AddTowerAbility(2, "Rage", 60)
```

### `NTD.AddSkipWave(elapsed)`

加入跳波操作。若遊戲設定 `AutoSkipWave` 已開啟，此操作會自動略過，避免重複送出。

### `NTD.AddSetSpeed(speed, elapsed)`

設定遊戲速度。

```lua
NTD.AddSetSpeed(3, 10)
```

### `NTD.AddGameSetting(settingName, value, elapsed)`

在指定時間切換遊戲設定。只有目前值與目標值不同時才會呼叫 `ToggleSetting`。

```lua
NTD.AddGameSetting("AutoSkipWave", true, 2)
```

### `NTD.AddEnd(elapsed)`

加入佇列結束標記，並設定 `NTD.GetQueueRemaining()` 的基準時間。

當 `end` 操作執行後，API 會啟動 5 分鐘超時計時器。若超時且 `AutoReplay` 開啟，會自動注入續跑並重播。

### `NTD.ExecuteQueue()`

開始執行佇列。只能在關卡內呼叫。

流程：

1. 檢查是否在關卡。
2. 排序佇列。
3. 自動 Ready 協程啟動，直到 `GameRunning` 變成 `true`。
4. 等待遊戲開始。
5. 依 `elapsed` 執行操作。
6. 若操作延遲超過 5 秒，印出警告但仍執行。
7. 監控遊戲結束，若 `AutoReplay` 開啟則自動重播。

---

## 七、關卡直接控制

| 函式 | 說明 |
|---|---|
| `NTD.Ready()` | 送出 Ready。連續觸發達 50 次會自動嘗試重播，避免卡住 |
| `NTD.Replay()` | 送出 Replay |
| `NTD.Difficulty(difficulty)` | 依目前 UI 狀態設定難度並開始遊戲，也會掛上結束監控 |
| `NTD.GameSetting(settingName, targetValue)` | 立即切換設定，只有目前值不同才送出 |
| `NTD.GetMap() -> string` | 回傳目前 `Values.Map.Value`，失敗回 `"Unknown"` |

---

## 八、Phase 2 地圖

部分地圖會中途切換地圖，需要將流程拆成 Phase 1 / Phase 2。

### `NTD.AddMapWait([scriptName])`

加入等待地圖切換標記。此操作 phase 固定為 `1.5`，會排在 Phase 1 後、Phase 2 前。呼叫後，後續新增的佇列操作會自動歸到 Phase 2。

參數 `scriptName` 是可選的 Phase 2 腳本前綴。

地圖切換後 API 會：

1. 等待 `Values.Map.Value` 變成新地圖名。
2. 重設 Phase 2 的計時起點。
3. 清空 Phase 1 的場上塔快取。
4. 保留 `nextOrder`，讓 Phase 2 序號接續 Phase 1。
5. 嘗試載入外部 Phase 2 腳本。

外部腳本搜尋資料夾：

```text
Tsetingnil_script/NTD/Script
```

搜尋規則：

- 先收集所有符合 `*_<實際地圖名>.lua` 的檔案。
- 若 `scriptName` 有指定，優先使用 basename 等於 `<scriptName>` 或 `<scriptName>_<地圖名>` 的檔案。
- 若沒有指定或沒命中，按檔名降序選最新檔。
- 找到外部腳本時，會清空目前佇列、載入該腳本，並由外部腳本自行呼叫 `NTD.ExecuteQueue()`。
- 找不到時，會繼續執行目前腳本中已排好的內嵌 Phase 2 操作。

範例：

```lua
-- Phase 1
NTD.AddPlaceTower("Farm", 10, 5, 20, 0, 5) -- #1
NTD.AddMapWait("MoonRun")

-- 若找不到外部 MoonRun_<地圖名>.lua，以下內嵌 Phase 2 仍會繼續跑
NTD.AddPlaceTower("Marksman", 15, 5, 25, 0, 2) -- #2
NTD.ExecuteQueue()
```

### Phase 2 序號自動偏移

外部 Phase 2 腳本可在第一個 `AddPlaceTower(...)` 後面加上 `-- #N` 註記錄製時的 Phase 2 起始序號：

```lua
NTD.AddPlaceTower("Marksman", 15, 5, 25, 0, 2) -- #7
NTD.AddUpgradeTower(7, 20)
```

如果本次 Phase 1 實際放置塔數和錄製時不同，API 會自動修正外部腳本中的：

- `AddUpgradeTower(order, ...)`
- `AddSellTower(order, ...)`
- `AddTowerAbility(order, ...)`

只有 order 大於等於註記起始序號時才會偏移。

---

## 九、設定與查詢

### `NTD.AutoReplay(value: boolean)`

設定遊戲結束或超時後是否自動重播。

預設：`false`

### `NTD.Debug(value: boolean)`

目前主要使用：

```lua
NTD.Debug(true)
```

效果：

- 關閉自動 Ready。
- 關閉自動重播。
- 載入放置追蹤器。

### `NTD.GetQueueElapsed() -> number | nil`

回傳佇列已執行秒數。尚未執行佇列時回傳 `nil`。

### `NTD.GetQueueRemaining() -> number | nil`

回傳距離 `NTD.AddEnd(elapsed)` 的剩餘秒數。可能為負值。尚未執行佇列或未呼叫 `AddEnd` 時回傳 `nil`。

### `NTD.Auto(boolen)`

目前正式版中保留，尚未實作實際行為。

---

## 十、重試與保護機制

### 放置塔

底層 `RawPlaceTower` 預設最多重試 5 次，每次間隔約 0.2 秒。

若佇列層判定放置失敗，會額外重試 10 次，每次間隔約 0.2 秒。

全部失敗後會等待約 2 秒並強制序號前進，留下空洞，避免後續塔拿到錯誤 order。

### 升級塔

底層 `RawUpgradeTower` 預設最多重試 3 次，每次間隔約 0.1 秒。

若佇列層判定升級失敗，且該 order 有對應塔 id，會額外重試 10 次，每次間隔約 0.2 秒。

### 例外保護

放置與升級的 `InvokeServer` 使用 `pcall` 包住。`ExecuteQueue` 執行每個操作時也使用 `pcall`。伺服器端 throw 或單次操作錯誤會被當成失敗處理，不會讓整條佇列協程直接停止。

---

## 十一、完整範例

### 大廳腳本

```lua
NTD.EquipTower({ "Marksman", "Farm" })

NTD.SaveLocalScript([[
    -- 進入關卡後會自動執行這段
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

### 關卡內單獨測試

```lua
NTD.AddSetSpeed(3, 1)
NTD.AddPlaceTower("Marksman", 15, 5, 25, 0, 5)
NTD.AddUpgradeTower(1, 30)
NTD.AddEnd(60)
NTD.ExecuteQueue()
```

---

## 十二、函式速查

### 場景

| 函式 | 用途 |
|---|---|
| `NTD.IsLobby()` | 判斷是否在大廳 |
| `NTD.IsInGame()` | 判斷是否在關卡 |

### 大廳

| 函式 | 用途 |
|---|---|
| `NTD.GotoElevators()` | 自動找空電梯並導航 |
| `NTD.SelectMap(mapName, modes)` | 選圖並開始 |
| `NTD.StartGame()` | 啟動電梯 |
| `NTD.SaveLocalScript(scriptContent)` | 儲存傳送後續跑腳本 |
| `NTD.Lobby()` | 回大廳並載入大廳介面 |

### 裝備

| 函式 | 用途 |
|---|---|
| `NTD.EquipTower(names)` | 裝備指定塔 |
| `NTD.GetEquippedUUIDs()` | 取得已裝備 UUID |
| `NTD.UnequipAll()` | 解除全部裝備 |

### 關卡佇列

| 函式 | 用途 |
|---|---|
| `NTD.AddPlaceTower(unit,x,y,z,rot,elapsed[,condition])` | 排程放塔 |
| `NTD.AddUpgradeTower(order, elapsed)` | 排程升級 |
| `NTD.AddSellTower(order, elapsed)` | 排程售出 |
| `NTD.AddTowerAbility(order, abilityName, elapsed)` | 排程使用塔能力 |
| `NTD.AddSkipWave(elapsed)` | 排程跳波 |
| `NTD.AddSetSpeed(speed, elapsed)` | 排程設定速度 |
| `NTD.AddGameSetting(settingName, value, elapsed)` | 排程切換設定 |
| `NTD.AddMapWait([scriptName])` | 等待地圖切換並進入 Phase 2 |
| `NTD.AddEnd(elapsed)` | 佇列結束點與超時保護 |
| `NTD.ExecuteQueue()` | 執行佇列 |

### 直接控制、設定、查詢

| 函式 | 用途 |
|---|---|
| `NTD.Ready()` | 送出 Ready |
| `NTD.Replay()` | 重播 |
| `NTD.Difficulty(difficulty)` | 設定難度並開始 |
| `NTD.GameSetting(settingName, targetValue)` | 立即切換設定 |
| `NTD.GetMap()` | 取得目前地圖 |
| `NTD.AutoReplay(bool)` | 設定自動重播 |
| `NTD.Debug(bool)` | 除錯模式 |
| `NTD.GetQueueElapsed()` | 查詢佇列已執行秒數 |
| `NTD.GetQueueRemaining()` | 查詢距離 AddEnd 剩餘秒數 |
| `NTD.Auto(boolen)` | 保留，尚未實作 |
