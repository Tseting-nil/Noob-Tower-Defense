# NTD API 使用說明 
- By Claude Code

> 適用遊戲：Roblox《Noob Tower Defense》（PlaceId `131658557901126`）
> 載入後全域物件：`getgenv().NTD`（旗標 `getgenv().NTDAPI = true`）

NTD 是一套塔防遊戲的自動化框架，依「目前所在場景」自動初始化對應資源，分為**大廳模式**與**關卡內模式**兩種。載入腳本後直接呼叫 `NTD.*` 函式即可。

---

## 目錄

1. [載入與啟動](#一載入與啟動)
2. [場景判斷](#二場景判斷)
3. [大廳函式](#三大廳函式)
4. [關卡內：操作佇列](#四關卡內操作佇列)
5. [關卡內：直接控制](#五關卡內直接控制)
6. [設定](#六設定)
7. [佇列計時查詢](#七佇列計時查詢)
8. [多階段地圖（Phase 2）](#八多階段地圖phase-2)
9. [自動重試機制](#九自動重試機制)
10. [完整範例](#十完整範例)
11. [函式速查表](#十一函式速查表)

---

## 一、載入與啟動

API: 必須先通過 **密鑰系統** 驗證。才能使用本服務：

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Tseting-nil/Noob-Tower-Defense/refs/heads/main/%E5%AF%86%E9%91%B0%E7%B3%BB%E7%B5%B1.lua"))()
```


流程：

**驗證通過後，API 自動載入到本地環境**，建立 `getgenv().NTD`（console 印出 `[NTD] API已加載`）

API 載入後會自動判斷目前在大廳還是關卡，並初始化對應資源——你不需要手動初始化。之後直接呼叫 `NTD.*` 即可。

### 語言切換

啟動時讀取 `Tsetingnil_script/NTD/API_VAR.json`：

```json
{ "language": "English" }
```

- `language` = `"English"` → 訊息輸出英文
- 其他／檔案不存在 → 預設中文

### 跨傳送自動續跑

大廳 → 關卡是一次 Roblox 傳送，腳本記憶體會被清空。框架用 `queue_on_teleport` 處理：

1. 在**大廳**先用 `NTD.SaveLocalScript(你的關卡腳本內容)` 把要在關卡內執行的腳本存成
   `Tsetingnil_script/NTD/main_<你的UserId>.lua`
2. 觸發傳送（`SelectMap` 內部會自動注入續跑邏輯）
3. 進入關卡後，框架自動 `loadfile` 跑回你存的那份腳本

> 框架也內建**斷線偵測**：偵測到 CoreGui 的 ErrorPrompt 會自動重新注入續跑腳本（需 executor 支援 `queue_on_teleport`）。

---

## 二、場景判斷

| 函式 | 回傳 | 說明 |
|---|---|---|
| `NTD.IsLobby()` | boolean | 目前是否在大廳 |
| `NTD.IsInGame()` | boolean | 目前是否在關卡內 |

---

## 三、大廳函式（僅大廳可用）

### `NTD.GotoElevators()`
自動尋找一個空電梯，傳送並導航過去，直到進入電梯。
電梯被別人搶走會自動換一台重試；逾時 30 秒會放棄並重新尋找。

### `NTD.SelectMap(mapName, modes)`
選地圖並開始遊戲（內部會自動先呼叫 `GotoElevators`）。

| 參數 | 型別 | 說明 |
|---|---|---|
| `mapName` | string | 地圖名稱，如 `"Plains"` |
| `modes` | nil / string / table | `nil` → 預設無附加模式；單一字串 → 一個模式；table → 多模式組合 |

```lua
NTD.SelectMap("Plains", "Rush")
NTD.SelectMap("Plains", { "Rush", "Boss" })
```

> 若先前 `EquipTower` 失敗（背包缺塔），`SelectMap` 會中止，不會進圖。

### `NTD.StartGame()`
觸發電梯啟動進關卡。`SelectMap` 內部會自動呼叫，通常不必手動使用。

### `NTD.EquipTower(names)`
依塔名裝備到裝備欄（透過 client-side `equipTower`，有 UI 更新）。會自動卸下不在清單內的塔，最多 6 格。

| 參數 | 型別 | 說明 |
|---|---|---|
| `names` | string / table | 單一塔名，或由「塔名」/「`{塔名, condition}`」混合組成的陣列 |

`condition`（mutation 篩選）可為 string（如 `"Shiny"`）或 table（如 `{"Shiny","Prime"}`）。

```lua
NTD.EquipTower("Marksman")
NTD.EquipTower({ "Marksman", "Farm", "Sniper" })
NTD.EquipTower({ "Marksman", { "Doombringer", {"Shiny","Prime"} } })
```

### `NTD.GetEquippedUUIDs() -> table`
回傳目前裝備欄已裝備的 UUID 列表（最多 6 個）。

### `NTD.SaveLocalScript(scriptContent)`
把字串內容存成 `Tsetingnil_script/NTD/main_<你的UserId>.lua`，供傳送後自動續跑（見[載入與啟動](#一載入與啟動)）。

### `NTD.Lobby()`
注入「回到大廳後自動重載大廳介面」的續跑腳本，並觸發返回大廳（需 `queue_on_teleport`）。

---

## 四、關卡內：操作佇列

**佇列模式**：先用 `Add*` 系列把所有操作排好，再呼叫 `ExecuteQueue` 一次性按時間排程執行。

- **排序規則**：先按 `phase`（1 < 1.5 < 2），同 phase 再按 `elapsed`（遊戲開始後秒數）升序。
- **序號（order）系統**：每次成功放置會自動分配一個 `order`，從 **1** 開始遞增。之後的升級／售出／能力都用這個 order 參照「第幾個被放的塔」。

### `NTD.AddPlaceTower(unitType, x, y, z, rotation, elapsed [, condition])`
加入「放置塔」操作。

| 參數 | 型別 | 說明 |
|---|---|---|
| `unitType` | string | 塔名（必須在背包中） |
| `x, y, z` | number | 世界座標（必須落在某個 `Placeable` 上） |
| `rotation` | number | 旋轉角度 |
| `elapsed` | number | 遊戲開始後第幾秒執行 |
| `condition` | string / table / nil | mutation 篩選（如 `"Shiny"`）；nil 表示不限 |

### `NTD.AddUpgradeTower(order, elapsed)`
升級第 `order` 個放置的塔。

### `NTD.AddSellTower(order, elapsed)`
售出第 `order` 個塔。售出後該 order 被清空，無法再升級／售出。

### `NTD.AddTowerAbility(order, abilityName, elapsed)`
對第 `order` 個塔使用能力。`abilityName` 如 `"Rage"`、`"Heal"`、`"Spin"`（可用能力見 TowerAbilities 模組）。

### `NTD.AddSkipWave(elapsed)`
加入「跳過波次」。若遊戲已開啟自動跳波，會自動略過此操作。

### `NTD.AddSetSpeed(speed, elapsed)`
設定遊戲倍速（`speed` = 1、2、3…）。

### `NTD.AddGameSetting(settingName, value, elapsed)`
在指定時間切換某遊戲設定（例如 `"AutoSkipWave"`）。僅在目前值與 `value` 不符時才切換。

### `NTD.AddEnd(elapsed)`
標記佇列結束點，並啟動 5 分鐘超時計時器：超時後若 `AutoReplay` 開啟則自動重播。也設定 `GetQueueRemaining` 的基準時間。

### `NTD.ExecuteQueue()`
執行佇列。只能在關卡內呼叫。流程：
1. 等待遊戲開始（期間若 `AutoReady` 開啟會自動點 Ready）
2. 以自身計時器按 `elapsed` 排程每個操作
3. 監控遊戲結束；結束時若 `AutoReplay` 開啟自動重播
4. 操作延遲超過 5 秒會 `warn`，但仍執行不跳過

---

## 五、關卡內：直接控制

非佇列、立即執行的操作。

| 函式 | 說明 |
|---|---|
| `NTD.Ready()` | 對伺服器送出 Ready（準備開始）。內建防呆：連續觸發 50 次會自動重啟 |
| `NTD.Replay()` | 觸發重播 |
| `NTD.Difficulty(difficulty)` | 依目前 UI 狀態設定難度並啟動遊戲，並掛上遊戲結束監控 |
| `NTD.GameSetting(settingName, targetValue)` | 立即把某設定切到 `targetValue`（目前值不符才切） |
| `NTD.GetMap() -> string` | 回傳目前地圖名稱（失敗回 `"Unknown"`） |

---

## 六、設定

### `NTD.AutoReplay(value: boolean)`
設定遊戲結束後是否自動重開。

### `NTD.Debug(value: boolean)`
`NTD.Debug(true)`：關閉自動 Ready、關閉自動重播，並載入**放置追蹤器**（用於擷取塔的座標／除錯）。

---

## 七、佇列計時查詢

| 函式 | 回傳 | 說明 |
|---|---|---|
| `NTD.GetQueueElapsed()` | number / nil | 佇列已執行秒數（從遊戲開始算）。未呼叫 `ExecuteQueue` 回傳 nil |
| `NTD.GetQueueRemaining()` | number / nil | 距 `AddEnd` 設定時間點的剩餘秒數，負值代表已超過。未呼叫 `ExecuteQueue` 或未呼叫 `AddEnd` 回傳 nil |

---

## 八、多階段地圖（Phase 2）

部分地圖（如 Moon）會中途切換地圖，需要把佇列分成 Phase 1 / Phase 2。

### `NTD.AddMapWait([targetMap])`
插入一個「等待地圖切換」標記（phase 1.5，排在所有 Phase 1 之後、Phase 2 之前）。呼叫後，之後加入的操作自動歸為 **Phase 2**。

- 帶 `targetMap` → 等到地圖切換成該名稱
- 省略 → 等到地圖切成「與目前不同」的任意地圖

地圖切換後框架會：重設 Phase 2 計時基準、清空 Phase 1 塔的實例資料（但**保留 order 序號連貫**：Phase 1 #1~#N → Phase 2 從 #N+1 起），並嘗試載入外部 Phase 2 腳本
`Tsetingnil_script/NTD/Script/*_<地圖名>.lua`。

> **序號自動偏移**：外部 Phase 2 腳本若用 `-- #N` 註記錄製時的起始序號，框架會依本次實際 Phase 1 塔數自動修正 `AddUpgradeTower` / `AddSellTower` / `AddTowerAbility` 的 order，免得手改。

---

## 九、自動重試機制

放置／升級透過兩層自動重試，提升在 lag 或速率限制下的成功率，並保護序號不被汙染。

### 放置 place
```
ExecuteOperation → RawPlaceTower(底層重試 5 次 × 0.2s)
   成功 → orderToId[nextOrder] = id，nextOrder++  ✅
   失敗 → 佇列層再補 10 次（× 0.2s，約 2s）
            成功 → 分配序號，nextOrder++  ✅
            全失敗 → 等 2s 後強制 nextOrder++（序號留空洞，避免後塔偷序號）⏭
   放置總計最多 5 + 10 = 15 次（約 3s）
```

### 升級 upgrade
```
ExecuteOperation → 查 orderToId[order]
   找不到（塔沒放成功）→ 不重試，直接跳過 ⏭
   找到 → RawUpgradeTower(底層重試 3 次 × 0.1s)
            失敗 → 佇列層再補 10 次（× 0.2s）→ 全失敗則放棄 ⏭
   升級總計最多 3 + 10 = 13 次
```

### 例外防護
所有 `InvokeServer` 與佇列主迴圈的 `ExecuteOperation` 都包了 `pcall`：伺服器端報錯（throw）會被當成普通失敗、流入上述重試／跳過邏輯，**不會讓整條佇列協程靜默死亡**。

---

## 十、完整範例

```lua
-- ===== 在大廳 =====
-- 先把「關卡內要跑的腳本」存起來，供傳送後自動續跑
NTD.SaveLocalScript([[
    NTD.EquipTower({ "Marksman", "Farm" })

    -- 排佇列（elapsed = 遊戲開始後秒數）
    NTD.AddPlaceTower("Farm",     10, 5, 20, 0, 5.0)   -- +5.0s 放 Farm    (→ #1)
    NTD.AddPlaceTower("Marksman", 15, 5, 25, 0, 8.5)   -- +8.5s 放 Marksman (→ #2)
    NTD.AddUpgradeTower(2, 45.0)                        -- +45s 升級 #2 (Marksman)
    NTD.AddSetSpeed(3, 60.0)                            -- +60s 切 3 倍速
    NTD.AddSkipWave(90.0)                               -- +90s 跳波
    NTD.AddSellTower(1, 120.0)                          -- +120s 賣掉 #1 (Farm)
    NTD.AddEnd(150.0)                                   -- 標記結束 + 超時保險

    NTD.AutoReplay(true)                               -- 結束自動重開
    NTD.ExecuteQueue()                                 -- 開始執行
]])

-- 選圖並開始（自動進電梯 + 傳送，續跑上面那份腳本）
NTD.SelectMap("Plains", { "Rush" })
```

---

## 十一、函式速查表

### 場景
| 函式 | 場景 | 用途 |
|---|---|---|
| `IsLobby()` / `IsInGame()` | 任意 | 判斷場景 |

### 大廳
| 函式 | 用途 |
|---|---|
| `GotoElevators()` | 進電梯 |
| `SelectMap(map, modes)` | 選圖開始（自動進電梯） |
| `StartGame()` | 啟動電梯（通常自動） |
| `EquipTower(names)` | 裝備塔 |
| `GetEquippedUUIDs()` | 查已裝備 UUID |
| `SaveLocalScript(str)` | 存關卡續跑腳本 |
| `Lobby()` | 注入返回大廳續跑 |

### 關卡內佇列
| 函式 | 用途 |
|---|---|
| `AddPlaceTower(unit,x,y,z,rot,elapsed[,cond])` | 放塔（分配 order） |
| `AddUpgradeTower(order, elapsed)` | 升級 |
| `AddSellTower(order, elapsed)` | 售出 |
| `AddTowerAbility(order, ability, elapsed)` | 塔能力 |
| `AddSkipWave(elapsed)` | 跳波 |
| `AddSetSpeed(speed, elapsed)` | 倍速 |
| `AddGameSetting(name, value, elapsed)` | 切設定 |
| `AddMapWait([map])` | 等地圖切換（進 Phase 2） |
| `AddEnd(elapsed)` | 結束標記 + 超時保險 |
| `ExecuteQueue()` | 執行佇列 |

### 關卡內直接控制
| 函式 | 用途 |
|---|---|
| `Ready()` | 送 Ready |
| `Replay()` | 重播 |
| `Difficulty(diff)` | 設難度開始 |
| `GameSetting(name, value)` | 立即切設定 |
| `GetMap()` | 目前地圖名 |

### 設定 / 查詢
| 函式 | 用途 |
|---|---|
| `AutoReplay(bool)` | 自動重開 |
| `Debug(bool)` | 除錯模式 + 放置追蹤器 |
| `GetQueueElapsed()` | 已執行秒數 |
| `GetQueueRemaining()` | 距 AddEnd 剩餘秒數 |
