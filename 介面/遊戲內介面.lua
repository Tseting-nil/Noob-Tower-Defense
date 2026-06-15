-- 側邊通知模組
if not getgenv().NotificationModule then
	loadstring(game:HttpGet("https://gist.githubusercontent.com/Tseting-nil/08653e6aa9fc12a9f097bfb10e6654e7/raw/00001d614d928fc5dafce59133a012dd78419afd/%25E5%2581%25B4%25E9%2582%258A%25E9%2580%259A%25E7%259F%25A5%25E6%25A8%25A1%25E7%25B5%2584.lua"))()
end

if not getgenv().MOVEAPI then
  local MoveAPI = loadstring(game:HttpGet("https://gist.githubusercontent.com/Tseting-nil/494a4830fa6d3466596e4e01ca25bdee/raw/15a370f3f09720e1359601e05da6d9e0a24bcc23/%25E5%25B7%25A1%25E8%25B7%25AF%25E6%25A8%25A1%25E7%25B5%2584"))()
  MoveAPI:SetJumpEnabled(false)
  MoveAPI:SetDirectMovementDistance(500)
  getgenv().MOVEAPI = MoveAPI
end
local Move = getgenv().MOVEAPI

-- i18n
local HttpService = game:GetService("HttpService")
local currentLang = "zh"
do
	local API_VAR_PATH = "Tsetingnil_script/NTD/API_VAR.json"
	pcall(function()
		if isfile and isfile(API_VAR_PATH) and readfile then
			local raw = readfile(API_VAR_PATH)
			if raw and raw ~= "" then
				local ok, data = pcall(HttpService.JSONDecode, HttpService, raw)
				if ok and type(data) == "table" and data.language then
					local lang = tostring(data.language):upper()
					if lang == "CHINESE" then
						currentLang = "zh"
					elseif lang == "ENGLISH" then
						currentLang = "en"
					end
				end
			end
		end
	end)
end

local i18n = {
	zh = {
		windowTitle    = "遊戲內介面",
    tab_main       = "Main",
    tab_playinfo = "玩家資訊",
    tab_localscript = "本地腳本",
		sectionStatus  = "當前狀態",
		envChecking    = "環境檢查中...",
		gameState      = "遊戲當前狀態",
		autoReplay     = "重開",
		sectionControl = "控制按鈕",
		btnToggleAutoReplay = "控制自動重開",
		btnManualReplay     = "手動重開",
		btnLobby            = "回大廳",
    AutoGetBooks   = "自動獲取怪物圖鑑",
		noEnv          = "無環境",
		cantLeave      = "遊戲限制未完成戰鬥無法離開",
		stateReady     = "當前遊戲狀態：準備中",
		stateGamemodes = "當前遊戲狀態：選擇模式中",
		stateCombat    = "當前遊戲狀態：戰鬥中",
		stateGameOver  = "當前遊戲狀態：結束",
		stateUnknown   = "當前遊戲狀態：未知",
		envExist       = "環境檢查：本地環境存在",
		envNotExist    = "環境檢查：本地環境不存在",
		autoReplayOn   = "自動重新戰鬥：已開啟",
		autoReplayOff  = "自動重新戰鬥：未開啟",
		queueRemaining = "佇列剩餘：",
		queueNA        = "---",
		queueOvertime  = "（超時）",
		localscript_path           = "路徑: ",
		localscript_list           = "腳本列表",
		localscript_refresh        = "重新整理",
		localscript_run            = "執行",
		localscript_no_scripts     = "目錄中無腳本",
		localscript_done           = "執行完成",
		localscript_error          = "執行錯誤",
		localscript_refreshed      = "清單已重新整理",
		localscript_delete         = "刪除",
		localscript_confirm_title  = "確認刪除?",
		localscript_confirm_title2 = "⚠ 此操作無法復原",
		localscript_confirm_yes    = "確認",
		localscript_confirm_no     = "取消",
		localscript_delete_final   = "永久刪除",
		localscript_deleted        = "已刪除",
		localscript_delete_error   = "刪除失敗",
		localscript_info           = "i",
		localscript_info_no_block  = "（無資訊區塊）",
		localscript_info_read_fail = "讀取失敗",
		localscript_info_close     = "關閉",
		localscript_info_copy      = "複製",
		localscript_info_copied    = "已複製到剪貼簿",
		localscript_save_running    = "儲存正在運行的腳本",
		localscript_save            = "儲存",
		localscript_save_name_title = "輸入儲存名稱",
		localscript_save_name_ph    = "腳本名稱...",
		localscript_save_success    = "已儲存",
		localscript_save_error      = "儲存失敗",
		localscript_save_no_running = "無正在運行的腳本",
		replayConfirm_title    = "確認手動重開?",
		playCoinInit           = "金幣：---",
		playGemInit            = "鑽石：---",
		playCurrencyNotFound   = "找不到玩家貨幣資料，請確認已進入遊戲",
		playCoinFmt            = "金幣：%d",
		playGemFmt             = "鑽石：%d",
		tab_settings              = "設置",
		keyTimeLabel              = "密鑰剩餘時間：",
		keyTimePerm               = "永久",
		keyExpired                = "已過期",
		unitDay = "天", unitHour = "時", unitMin = "分",
		instantUpdate             = "自動更新",
		onText = "開", offText = "關",
		instantUpdateConfirmTitle = "確認關閉自動更新？",
		instantUpdateConfirmDesc  = "關閉後主腳本只會在『大廳』更新，掛機中途不會被打斷。",
		tab_stats              = "統計",
		stats_section          = "累計統計",
		stats_wins             = "勝：",
		stats_losses           = "輸：",
		stats_total            = "總場：",
		stats_winrate          = "勝率：",
		stats_money            = "賺取金幣：",
		stats_lastReset        = "上次重置：",
		stats_reset            = "重置統計",
		stats_reset_confirm    = "確認重置統計？",
		stats_never_reset      = "從未重置",
	},
	en = {
		windowTitle    = "In-Game UI",
    tab_main       = "Main",
    tab_playinfo = "Player Info",
    tab_localscript = "Local Script",
		sectionStatus  = "Current Status",
		envChecking    = "Checking environment...",
		gameState      = "Game State",
		autoReplay     = "Auto Replay",
		sectionControl = "Control Buttons",
		btnToggleAutoReplay = "Toggle Auto Replay",
		btnManualReplay     = "Replay",
		btnLobby            = "To Lobby",
    AutoGetBooks   = "AutoGetIndexBooks",
		noEnv          = "No Environment",
		cantLeave      = "Cannot leave mid-combat",
		stateReady     = "Game State: Ready",
		stateGamemodes = "Game State: Selecting Mode",
		stateCombat    = "Game State: In Combat",
		stateGameOver  = "Game State: Game Over",
		stateUnknown   = "Game State: Unknown",
		envExist       = "Environment: Local env exists",
		envNotExist    = "Environment: Local env missing",
		autoReplayOn   = "Auto Replay: Enabled",
		autoReplayOff  = "Auto Replay: Disabled",
		queueRemaining = "Queue Remaining: ",
		queueNA        = "---",
		queueOvertime  = " (overtime)",
		localscript_path           = "Path: ",
		localscript_list           = "Script List",
		localscript_refresh        = "Refresh",
		localscript_run            = "Run",
		localscript_no_scripts     = "No scripts in directory",
		localscript_done           = "Executed",
		localscript_error          = "Error",
		localscript_refreshed      = "List refreshed",
		localscript_delete         = "Delete",
		localscript_confirm_title  = "Confirm Delete?",
		localscript_confirm_title2 = "⚠ This cannot be undone",
		localscript_confirm_yes    = "Confirm",
		localscript_confirm_no     = "Cancel",
		localscript_delete_final   = "Delete Forever",
		localscript_deleted        = "Deleted",
		localscript_delete_error   = "Delete failed",
		localscript_info           = "i",
		localscript_info_no_block  = "(No info block)",
		localscript_info_read_fail = "Read failed",
		localscript_info_close     = "Close",
		localscript_info_copy      = "Copy",
		localscript_info_copied    = "Copied to clipboard",
		localscript_save_running    = "Save Running Script",
		localscript_save            = "Save",
		localscript_save_name_title = "Enter Save Name",
		localscript_save_name_ph    = "Script name...",
		localscript_save_success    = "Saved",
		localscript_save_error      = "Save failed",
		localscript_save_no_running = "No running script",
		replayConfirm_title    = "Confirm Replay?",
		playCoinInit           = "Coins: ---",
		playGemInit            = "Gems: ---",
		playCurrencyNotFound   = "Player currency data not found, please confirm you have entered the game",
		playCoinFmt            = "Coins: %d",
		playGemFmt             = "Gems: %d",
		tab_settings              = "Settings",
		keyTimeLabel              = "Key time left: ",
		keyTimePerm               = "Permanent",
		keyExpired                = "Expired",
		unitDay = "d", unitHour = "h", unitMin = "m",
		instantUpdate             = "Auto Update",
		onText = "ON", offText = "OFF",
		instantUpdateConfirmTitle = "Disable auto update?",
		instantUpdateConfirmDesc  = "When off, the main script only updates in the LOBBY — farming won't be interrupted.",
		tab_stats              = "Stats",
		stats_section          = "Cumulative Stats",
		stats_wins             = "Wins: ",
		stats_losses           = "Losses: ",
		stats_total            = "Total: ",
		stats_winrate          = "Win Rate: ",
		stats_money            = "Coins Earned: ",
		stats_lastReset        = "Last Reset: ",
		stats_reset            = "Reset Stats",
		stats_reset_confirm    = "Confirm Reset?",
		stats_never_reset      = "Never reset",
	},
}

local L = i18n[currentLang]
local fontSize = currentLang == "en" and 14 or nil

local Msg = getgenv().NotificationModule
local NTD_API = nil
local Scripttable = nil
local Mainfunction = nil

-- ========================================================================== --
-- GUI

local ReGui = loadstring(game:HttpGet("https://gist.githubusercontent.com/Tseting-nil/169b7303e1418cb301bad5ab427e9351/raw/93e90190f628387b545eef62b49e4ce146d1dad8/GUI:ReGui"))()

local UserInputService = game:GetService("UserInputService")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local windowSize = currentLang == "en" and UDim2.new(0, 300, 0, 220) or UDim2.new(0, 300, 0, 250)

local TabsWindow =  ReGui:TabsWindow({
	Title = L.windowTitle,
	Size = windowSize,
	NoScroll = true,
})

local Tabs = {}

for _, Name in ipairs({
	L.tab_main,
  L.tab_playinfo,
  L.tab_localscript,
  L.tab_settings,
  L.tab_stats
}) do
	local Tab = TabsWindow:CreateTab({
		Name = Name
	})
	table.insert(Tabs, Tab)
end

-- 修改 Tab 字體和大小
task.spawn(function()
	task.wait(0.1)
	for _, tab in ipairs(Tabs) do
		local tabButton = tab.TabButton.Button
		local label = tabButton:FindFirstChildWhichIsA("TextLabel")
		if label then
			label.TextSize = currentLang == "en" and 14 or 18
			label.Font = Enum.Font.Ubuntu
		end
	end
end)

local Tab_main = Tabs[1]:ScrollingCanvas({
	Fill = true,
	UiPadding = UDim.new(0, 0)
})

local Tab_playinfo = Tabs[2]:ScrollingCanvas({
  Fill = true,
  UiPadding = UDim.new(0, 0)
})

local Tab_Localscript = Tabs[3]:ScrollingCanvas({
	Fill = true,
	UiPadding = UDim.new(0, 0)
})

local Tab_settings = Tabs[4]:ScrollingCanvas({
	Fill = true,
	UiPadding = UDim.new(0, 0)
})

local Tab_stats = Tabs[5]:ScrollingCanvas({
	Fill = true,
	UiPadding = UDim.new(0, 0)
})

-- ===== 設置分頁：密鑰剩餘時間 + 即時更新開關 =====
local SETTINGS_API_VAR = "Tsetingnil_script/NTD/API_VAR.json"

local function readApiVarTable()
	local ok, data = pcall(function()
		if isfile and readfile and isfile(SETTINGS_API_VAR) then
			return HttpService:JSONDecode(readfile(SETTINGS_API_VAR))
		end
	end)
	return (ok and type(data) == "table") and data or {}
end

local function writeInstantUpdate(value)
	pcall(function()
		if not writefile then return end
		local data = readApiVarTable()
		data.instant_update = value and true or false
		writefile(SETTINGS_API_VAR, HttpService:JSONEncode(data))
	end)
end

-- 由 loader 寫入 API_VAR 的 expires_at(秒) 計算剩餘時間文字
local function fmtKeyRemaining()
	local exp = tonumber(readApiVarTable().expires_at)
	if not exp then return L.keyTimeLabel .. L.keyTimePerm end
	if exp > 1e10 then exp = math.floor(exp / 1000) end -- 毫秒→秒
	local left = exp - os.time()
	if left <= 0 then return L.keyTimeLabel .. L.keyExpired end
	local d = math.floor(left / 86400)
	local h = math.floor((left % 86400) / 3600)
	local m = math.floor((left % 3600) / 60)
	return string.format("%s%d%s %d%s %d%s", L.keyTimeLabel, d, L.unitDay, h, L.unitHour, m, L.unitMin)
end

Tab_settings:Separator({ Text = L.tab_settings })

local KeyTime_Label = Tab_settings:Label({
	Text = fmtKeyRemaining(),
	TextSize = fontSize or 16,
	NoTheme = true,
	TextColor3 = Color3.fromRGB(240, 240, 240),
})

-- 自動更新開關(Radiobox)：預設關(只在大廳更新)；關閉時彈二級確認
local InstantUpdate_Box
local _instantBoxReady = false
InstantUpdate_Box = Tab_settings:Radiobox({
	Value = readApiVarTable().instant_update == true, -- 預設 false
	Label = L.instantUpdate,
	TextSize = fontSize or 16,
	Callback = function(_, Value)
		if not _instantBoxReady then return end -- 略過建構期的初始回呼
		if Value then
			-- 開啟自動更新(關卡內也即時更新)
			writeInstantUpdate(true)
		else
			-- 關閉 → 二級確認；取消則還原為開
			local Popup = Tab_settings:PopupModal({})
			Popup:Separator({ Text = L.instantUpdateConfirmTitle })
			Popup:Label({
				Text = L.instantUpdateConfirmDesc,
				TextSize = fontSize or 14,
				NoTheme = true,
				TextColor3 = Color3.fromRGB(230, 230, 230),
			})
			local PopupRow = Popup:Row({ Expanded = true })
			PopupRow:Button({
				Text = L.localscript_confirm_yes,
				Callback = function()
					Popup:ClosePopup()
					writeInstantUpdate(false)
				end,
			})
			PopupRow:Button({
				Text = L.localscript_confirm_no,
				Callback = function()
					Popup:ClosePopup()
					InstantUpdate_Box:SetValue(true) -- 取消 → 還原為開
				end,
			})
		end
	end,
})
_instantBoxReady = true

Tab_main:Separator({
	Text = L.sectionStatus
})

local API_Check_Label = Tab_main:Label({
	Text = L.envChecking,
	TextSize = fontSize or 18,
	NoTheme = true,
	TextColor3 = Color3.fromRGB(240, 240, 240),
})

local GameState_Label = Tab_main:Label({
	Text = L.gameState,
	TextSize = fontSize or 16,
	NoTheme = true,
	TextColor3 = Color3.fromRGB(240, 240, 240),
})

local AutoReplay_Label = Tab_main:Label({
	Text = L.autoReplay,
	TextSize = fontSize or 16,
	NoTheme = true,
	TextColor3 = Color3.fromRGB(240, 240, 240),
})

local QueueRemaining_Label = Tab_main:Label({
	Text = L.queueRemaining .. L.queueNA,
	TextSize = fontSize or 16,
	NoTheme = true,
	TextColor3 = Color3.fromRGB(240, 240, 240),
})

Tab_main:Separator({
	Text = L.sectionControl
})

local ROW_QK = Tab_main:Row()

ROW_QK:Button({
	Text = L.btnToggleAutoReplay,
  TextSize = fontSize or 18,
	Callback = function()
    if getgenv().NTDAPI then
      if Scripttable.AutoReplay then
        NTD_API.AutoReplay(false)
      else
        NTD_API.AutoReplay(true)
      end
    else
      Msg:Warning(L.noEnv)
    end
	end,
	DoubleClick = false,
})

ROW_QK:Button({
	Text = L.btnManualReplay,
  TextSize = fontSize or 18,
	Callback = function(btn)
    if getgenv().NTDAPI then
      local Popup = Tab_main:PopupModal({ RelativeTo = btn })
      Popup:Separator({ Text = L.replayConfirm_title })
      local PopupRow = Popup:Row({ Expanded = true })
      PopupRow:Button({
        Text = L.localscript_confirm_yes,
        Callback = function()
          Popup:ClosePopup()
          Mainfunction.Queueload()
          NTD_API.Replay()
        end,
      })
      PopupRow:Button({
        Text = L.localscript_confirm_no,
        Callback = function()
          Popup:ClosePopup()
        end,
      })
    else
      Msg:Warning(L.noEnv)
    end
	end,
	DoubleClick = false,
})

ROW_QK:Button({
	Text = L.btnLobby,
  TextSize = fontSize or 18,
	Callback = function()
    if getgenv().NTDAPI then
      local GameState = Mainfunction.GetGameState()
      if GameState == "GameOver" then
        if NTD_API.Lobby() then
          NTD_API.Lobby()
        end
      else
        Msg:Warning(L.cantLeave)
      end
    else
      Msg:Warning(L.noEnv)
    end
	end,
	DoubleClick = false,
})

if getgenv().NTDAPI then
  NTD_API = getgenv().NTD
  Scripttable = getgenv().NTD.Scripttable
  Mainfunction = getgenv().NTD.Mainfunction
end

local function ReGameStateLabel()
  local GameState = Mainfunction.GetGameState()
  if GameState == "Ready" then
    GameState_Label.Text = L.stateReady
  elseif GameState == "Gamemodes" then
    GameState_Label.Text = L.stateGamemodes
  elseif GameState == "Combat" then
    GameState_Label.Text = L.stateCombat
  elseif GameState == "GameOver" then
    GameState_Label.Text = L.stateGameOver
  else
    GameState_Label.Text = L.stateUnknown
  end
end

local function UpdateQueueLabels()
  local remaining = NTD_API.GetQueueRemaining()
  if remaining then
    if remaining < 0 then
      QueueRemaining_Label.Text = L.queueRemaining .. string.format("%d s", -remaining) .. L.queueOvertime
    else
      QueueRemaining_Label.Text = L.queueRemaining .. string.format("%d s", remaining)
    end
  else
    QueueRemaining_Label.Text = L.queueRemaining .. L.queueNA
  end
end

task.spawn(function()
  while true do
    if getgenv().NTDAPI and getgenv().NTD then
      NTD_API = getgenv().NTD
      Scripttable = getgenv().NTD.Scripttable
      Mainfunction = getgenv().NTD.Mainfunction
      API_Check_Label.Text = L.envExist
      if Scripttable.AutoReplay then
        AutoReplay_Label.Text = L.autoReplayOn
      else
        AutoReplay_Label.Text = L.autoReplayOff
      end
      task.spawn(ReGameStateLabel)
      task.spawn(UpdateQueueLabels)
    else
      API_Check_Label.Text = L.envNotExist
      AutoReplay_Label.Text = L.noEnv
    end
    pcall(function() KeyTime_Label.Text = fmtKeyRemaining() end)
    task.wait(1)
  end
end)

local AutoGetBooks = {
  enable = false,
  path = workspace:FindFirstChild("ClientIndexBooks"), -- 用 FindFirstChild，遊戲移除此物件時不會在載入時 throw
  CurrentTarget = nil,
  Busy = false
}

local function ProcessNext()
  if not AutoGetBooks.enable or AutoGetBooks.Busy or not AutoGetBooks.path then return end
  -- 找下一個目標
  local Target = AutoGetBooks.path:FindFirstChildWhichIsA("Model")
  if not Target then return end
  AutoGetBooks.CurrentTarget = Target
  AutoGetBooks.Busy = true
  task.spawn(function()
    local Pos = Target:GetPivot().Position
    pcall(Move.NavigateToPosition, Move, Pos.X, Pos.Y, Pos.Z)
    -- 等待：停用 或 目標消失
    repeat task.wait(0.5) until not AutoGetBooks.enable or not Target.Parent
    AutoGetBooks.CurrentTarget = nil
    AutoGetBooks.Busy = false
    if AutoGetBooks.enable then ProcessNext() end
  end)
end

AutoGetBooks.path.ChildAdded:Connect(ProcessNext)
AutoGetBooks.path.ChildRemoved:Connect(function(Child)
    if Child == AutoGetBooks.CurrentTarget then
        AutoGetBooks.CurrentTarget = nil
    end
    ProcessNext()
end)

local AutoGetBooks = Tab_main:Radiobox({
  Value = false,
  Label = L.AutoGetBooks,
  TextSize = fontSize or 16,
  Disabled = false,
  Callback = function(_, Value)
    AutoGetBooks.enable = Value
    if Value then
      ProcessNext()
    else
      AutoGetBooks.CurrentTarget = nil
      AutoGetBooks.Busy = false
    end
  end,
})
AutoGetBooks:SetValue(true)
-- ========================================================================== --
-- Tab_playinfo
local play_coin = Tab_playinfo:Label({
  Text = L.playCoinInit,
  TextSize = fontSize or 16,
  NoTheme = true,
  TextColor3 = Color3.fromRGB(240, 240, 240),
})

local play_gem = Tab_playinfo:Label({
  Text = L.playGemInit,
  TextSize = fontSize or 16,
  NoTheme = true,
  TextColor3 = Color3.fromRGB(240, 240, 240),
})
task.spawn(function()
  local ReplicatedStorage = game:GetService("ReplicatedStorage")
  local Constants = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("Constants"))
  local currencies = Constants.currentPlrData and Constants.currentPlrData.Currencies
  if not currencies then
    warn(L.playCurrencyNotFound)
    return
  end
  play_gem.Text = string.format(L.playGemFmt, math.floor(currencies.Gems or 0))
  play_coin.Text = string.format(L.playCoinFmt, math.floor(currencies.Coins or 0))
end)

-- ========================================================================== --
-- Tab_Localscript
local Localscript = {
  path = "Tsetingnil_script/NTD/Script", -- 用正斜線：腳本以 / 路徑儲存，部分手機執行器不會正規化 \
  ScriptListTable = nil,
  Excluded = {"_Venus", "_Saturn", "_Mars"},
}

local BuildScriptList
BuildScriptList = function()
	Localscript.ScriptListTable:ClearRows()
	local path = Localscript.path
	local ok, files = pcall(listfiles, path)
	local scripts = {}
	if ok and files then
		for _, filePath in ipairs(files) do
			local name = filePath:match("([^/\\]+)$") or filePath
			if name:match("%.lua$") or name:match("%.txt$") then
				local excluded = false
				for _, suffix in ipairs(Localscript.Excluded) do
					if name:match(suffix .. "%.lua$") or name:match(suffix .. "%.txt$") then
						excluded = true; break
					end
				end
				if not excluded then
					scripts[#scripts + 1] = { name = name, path = filePath }
				end
			end
		end
	end
	if #scripts == 0 then
		local EmptyRow = Localscript.ScriptListTable:NextRow()
		EmptyRow:Column():Label({ Text = L.localscript_no_scripts })
		return
	end
	for _, script in ipairs(scripts) do
		local Row = Localscript.ScriptListTable:NextRow()

		-- 名稱欄：無 UIFlexItem → 佔剩餘空間
		local NameCol = Row:Column()
		NameCol:Label({ Text = script.name })

		-- 操作欄：固定 150px（資訊 + 運行 + 刪除並排）
		local ActionsCol = Row:Column()
		local actionsFrame = ActionsCol.RawObject
		local actionsFlex = Instance.new("UIFlexItem", actionsFrame)
		actionsFlex.FlexMode = Enum.UIFlexMode.None
		actionsFrame.Size = UDim2.new(0, 80, 1, 0)

		local ActionRow = ActionsCol:Row({ Expanded = true })

		ActionRow:SmallButton({
			Text = L.localscript_info,
			Callback = function()
				local content
				local ok3, raw = pcall(readfile, script.path)
				if ok3 and raw then
					local block = raw:match("%-%-%[%[(.-)%]%]")
					if block then
						local map, diff, mod, timeStr
						local towers = {}
						local inTowers = false
						for line in (block .. "\n"):gmatch("([^\n]*)\n") do
							line = line:gsub("\r", "")
							local m, d, mo = line:match(
								"Map:%s*(.-)%s*|%s*Difficulty:%s*(.-)%s*|%s*Modifier:%s*(.-)%s*$"
							)
							if m then
								map, diff, mod = m, d, mo
							elseif line:find("^%s*Time:") then
								-- 只取括號前的部分，例如 "4m 20s"
								timeStr = line:match("Time:%s*(.-)%s*%(") or line:match("Time:%s*(.-)%s*$")
								if timeStr then timeStr = timeStr:match("^%s*(.-)%s*$") end
							elseif line:find("Towers used:") then
								inTowers = true
							elseif inTowers and line:find("%-%s+%S") then
								local tower = line:match("%-%s+(.-)%s*$")
								if tower and tower ~= "" then
									towers[#towers + 1] = tower
								end
							end
						end
						local out = {}
						if map and diff then
							local row1 = "Map: " .. map .. " | Difficulty: " .. diff
							if timeStr then row1 = row1 .. " | Time: " .. timeStr end
							out[#out + 1] = row1
						end
						if mod and mod ~= "" then
							out[#out + 1] = "<font color='#FFB347'>Modifier:</font>"
							for part in (mod .. ","):gmatch("([^,]+),") do
								local trimmed = part:match("^%s*(.-)%s*$")
								if trimmed ~= "" then
									out[#out + 1] = "  " .. trimmed
								end
							end
						end
						if #towers > 0 then
							out[#out + 1] = "<font color='#5BC8F5'>Towers used:</font>"
							for _, t in ipairs(towers) do
								out[#out + 1] = "  - " .. t
							end
						end
						content = #out > 0 and table.concat(out, "\n") or L.localscript_info_no_block
					else
						content = L.localscript_info_no_block
					end
				else
					content = L.localscript_info_read_fail
				end
				local InfoModal = TabsWindow:PopupModal({ Title = script.name })
				-- 按鈕列放在 Console 上方：手機端 Console 過高會把下方按鈕擠出視窗，置頂可確保可見
				local BtnRow = InfoModal:Row({ Expanded = true })
				BtnRow:Button({
					Text     = L.localscript_info_close,
					Callback = function() InfoModal:ClosePopup() end,
				})
				BtnRow:Button({
					Text     = L.localscript_info_copy,
					Callback = function()
						if raw and pcall(setclipboard, raw) then
							Msg:Success(L.localscript_info_copied)
						end
					end,
				})
				InfoModal:Console({
					Value    = content,
					ReadOnly = true,
					RichText = true,
					Border   = true,
					Size     = UDim2.new(1, 0, 0, isMobile and 110 or 150),
				})
			end,
		})

		ActionRow:SmallButton({
			Text = L.localscript_delete,
			Callback = function(delBtn)
				-- 第一次確認
				local Popup1 = Tab_Localscript:PopupModal({
					RelativeTo = delBtn,
				})
				Popup1:Separator({ Text = L.localscript_confirm_title })
				Popup1:Label({ Text = script.name, TextWrapped = true })
				local Row1 = Popup1:Row({ Expanded = true })
				Row1:Button({
					Text = L.localscript_confirm_yes,
					Callback = function()
						Popup1:ClosePopup()
						-- 第二次確認
						local Popup2 = Tab_Localscript:PopupModal({
							RelativeTo = delBtn,
						})
						Popup2:Separator({ Text = L.localscript_confirm_title2 })
						local Row2 = Popup2:Row({ Expanded = true })
						Row2:Button({
							Text = L.localscript_delete_final,
							Callback = function()
								Popup2:ClosePopup()
								local ok2, err = pcall(delfile, script.path)
								if ok2 then
									Msg:Success(L.localscript_deleted .. ": " .. script.name)
									BuildScriptList()
								else
									Msg:Warning(L.localscript_delete_error .. ": " .. tostring(err))
								end
							end,
						})
						Row2:Button({
							Text = L.localscript_confirm_no,
							Callback = function()
								Popup2:ClosePopup()
							end,
						})
					end,
				})
				Row1:Button({
					Text = L.localscript_confirm_no,
					Callback = function()
						Popup1:ClosePopup()
					end,
				})
			end,
		})
	end
end

Tab_Localscript:Label({
	Text = L.localscript_path .. Localscript.path,
	TextSize = fontSize,
})

Tab_Localscript:Separator({ Text = L.localscript_list })

local HeaderRow = Tab_Localscript:Row()

HeaderRow:Button({
	Text = L.localscript_refresh,
	Callback = function()
		BuildScriptList()
		Msg:Success(L.localscript_refreshed)
	end,
})

HeaderRow:Button({
	Text = L.localscript_save_running,
	Callback = function()
		local userId = tostring(game.Players.LocalPlayer.UserId)
		local mainPathBS = "Tsetingnil_script\\NTD\\main_" .. userId .. ".lua"
		local mainPathFW = "Tsetingnil_script/NTD/main_" .. userId .. ".lua"
		-- 判斷執行器支援的路徑格式
		local useFW = isfile and isfile(mainPathFW) and not isfile(mainPathBS)
		local mainPath = useFW and mainPathFW or mainPathBS
		local ok3, raw = pcall(readfile, mainPath)
		if not ok3 or not raw or raw == "" then
			-- 備用：嘗試另一種路徑格式
			ok3, raw = pcall(readfile, useFW and mainPathBS or mainPathFW)
		end
		if not ok3 or not raw or raw == "" then
			Msg:Warning(L.localscript_save_no_running)
			return
		end
		local content
		local block = raw:match("%-%-%[%[(.-)%]%]")
		if block then
			local map, diff, mod, timeStr
			local towers = {}
			local inTowers = false
			for line in (block .. "\n"):gmatch("([^\n]*)\n") do
				line = line:gsub("\r", "")
				local m, d, mo = line:match(
					"Map:%s*(.-)%s*|%s*Difficulty:%s*(.-)%s*|%s*Modifier:%s*(.-)%s*$"
				)
				if m then
					map, diff, mod = m, d, mo
				elseif line:find("^%s*Time:") then
					timeStr = line:match("Time:%s*(.-)%s*%(") or line:match("Time:%s*(.-)%s*$")
					if timeStr then timeStr = timeStr:match("^%s*(.-)%s*$") end
				elseif line:find("Towers used:") then
					inTowers = true
				elseif inTowers and line:find("%-%s+%S") then
					local tower = line:match("%-%s+(.-)%s*$")
					if tower and tower ~= "" then towers[#towers + 1] = tower end
				end
			end
			local out = {}
			if map and diff then
				local row1 = "Map: " .. map .. " | Difficulty: " .. diff
				if timeStr then row1 = row1 .. " | Time: " .. timeStr end
				out[#out + 1] = row1
			end
			if mod and mod ~= "" then
				out[#out + 1] = "<font color='#FFB347'>Modifier:</font>"
				for part in (mod .. ","):gmatch("([^,]+),") do
					local trimmed = part:match("^%s*(.-)%s*$")
					if trimmed ~= "" then out[#out + 1] = "  " .. trimmed end
				end
			end
			if #towers > 0 then
				out[#out + 1] = "<font color='#5BC8F5'>Towers used:</font>"
				for _, t in ipairs(towers) do out[#out + 1] = "  - " .. t end
			end
			content = #out > 0 and table.concat(out, "\n") or L.localscript_info_no_block
		else
			content = L.localscript_info_no_block
		end
		local scriptTitle = "main_" .. userId
		local InfoModal = TabsWindow:PopupModal({ Title = scriptTitle })
		-- 按鈕列置頂，Console 放下方並在手機端降低高度，避免按鈕被擠出視窗
		local BtnRow = InfoModal:Row({ Expanded = true })
		BtnRow:Button({
			Text = L.localscript_save,
			Callback = function()
				local inputName = ""
				local NameModal = TabsWindow:PopupModal({ Title = L.localscript_save_name_title })
				NameModal:InputText({
					Placeholder = L.localscript_save_name_ph,
					Value = "",
					Callback = function(_, text)
						inputName = text
					end,
				})
				local NRow = NameModal:Row({ Expanded = true })
				NRow:Button({
					Text = L.localscript_confirm_yes,
					Callback = function()
						local name = inputName:match("^%s*(.-)%s*$")
						if name == "" then return end
						-- 根據執行器路徑格式選擇分隔符
						local sep = useFW and "/" or "\\"
						local savePath = "Tsetingnil_script" .. sep .. "NTD" .. sep .. "Script" .. sep .. name .. ".lua"
						local outerBlock = raw:match("%-%-%[%[(.-)%]%]") or ""
						local wrappedContent = "--[[\n" .. outerBlock .. "\n]]\n\n" ..
							"-- ========== FULL SCRIPT ==========\n" ..
							"local fullScript = [=[\n" ..
							raw ..
							"\n]=]\n\n" ..
							"-- ========== Start ==========\n" ..
							"local NTD = getgenv().NTD\n" ..
							"if not NTD then\n" ..
							"\tloadstring(game:HttpGet(\"https://raw.githubusercontent.com/Tseting-nil/Noob-Tower-Defense/refs/heads/main/%E5%AF%86%E9%91%B0%E7%B3%BB%E7%B5%B1.lua\"))()\n" ..
							"\tNTD = getgenv().NTD\n" ..
							"end\n\n" ..
							"NTD.SaveLocalScript(fullScript)\n" ..
							"loadstring(fullScript)()\n"
						if not isfolder("Tsetingnil_script") then makefolder("Tsetingnil_script") end
						if not (isfolder("Tsetingnil_script\\NTD") or isfolder("Tsetingnil_script/NTD")) then makefolder("Tsetingnil_script" .. sep .. "NTD") end
						if not (isfolder("Tsetingnil_script\\NTD\\Script") or isfolder("Tsetingnil_script/NTD/Script")) then makefolder("Tsetingnil_script" .. sep .. "NTD" .. sep .. "Script") end
						local ok4, err = pcall(writefile, savePath, wrappedContent)
						if ok4 then
							Msg:Success(L.localscript_save_success .. ": " .. name)
							NameModal:ClosePopup()
							InfoModal:ClosePopup()
							BuildScriptList()
						else
							Msg:Warning(L.localscript_save_error .. ": " .. tostring(err))
						end
					end,
				})
				NRow:Button({
					Text = L.localscript_confirm_no,
					Callback = function()
						NameModal:ClosePopup()
					end,
				})
			end,
		})
		BtnRow:Button({
			Text = L.localscript_info_close,
			Callback = function() InfoModal:ClosePopup() end,
		})
		InfoModal:Console({
			Value    = content,
			ReadOnly = true,
			RichText = true,
			Border   = true,
			Size     = UDim2.new(1, 0, 0, isMobile and 110 or 150),
		})
	end,
})

Localscript.ScriptListTable = Tab_Localscript:Table({
	RowBackground = true,
	Border = true,
})

BuildScriptList()

-- ========================================================================== --
-- Tab_stats
-- ========================================================================== --
local STATS_DATA_PATH = "Tsetingnil_script/NTD/Config/Ingame_Data_Config.json"
local Stats_LocalPlayer = game:GetService("Players").LocalPlayer
local Stats_playerId    = tostring(Stats_LocalPlayer.UserId)

local function statsEnsureFolder()
	pcall(function()
		if not isfolder or not makefolder then return end
		if not isfolder("Tsetingnil_script") then makefolder("Tsetingnil_script") end
		if not isfolder("Tsetingnil_script/NTD") then makefolder("Tsetingnil_script/NTD") end
		if not isfolder("Tsetingnil_script/NTD/Config") then makefolder("Tsetingnil_script/NTD/Config") end
	end)
end

local function statsReadAll()
	local ok, data = pcall(function()
		if not (isfile and isfile(STATS_DATA_PATH) and readfile) then return {} end
		return HttpService:JSONDecode(readfile(STATS_DATA_PATH))
	end)
	return (ok and type(data) == "table") and data or {}
end

local function statsWriteAll(allData)
	pcall(function()
		if not writefile then return end
		statsEnsureFolder()
		writefile(STATS_DATA_PATH, HttpService:JSONEncode(allData))
	end)
end

local function statsGetOrInit(allData)
	if not allData[Stats_playerId] then
		allData[Stats_playerId] = {
			lastReset = os.time(),
			wins      = 0,
			losses    = 0,
			money     = 0,
		}
		statsWriteAll(allData)
	end
	return allData[Stats_playerId]
end

local function statsSave(isWin, earned)
	local allData = statsReadAll()
	local pd = statsGetOrInit(allData)
	if isWin then
		pd.wins = pd.wins + 1
	else
		pd.losses = pd.losses + 1
	end
	pd.money = pd.money + earned
	allData[Stats_playerId] = pd
	statsWriteAll(allData)
	return pd
end

local function statsReset()
	local allData = statsReadAll()
	allData[Stats_playerId] = {
		lastReset = os.time(),
		wins      = 0,
		losses    = 0,
		money     = 0,
	}
	statsWriteAll(allData)
	return allData[Stats_playerId]
end

local function statsParseEarned(richText)
	local raw = richText:match("%(%+([%d,]+)%)")
	if not raw then return 0 end
	return tonumber(raw:gsub(",", "")) or 0
end

local function statsComma(n)
	local s = tostring(math.floor(n))
	return s:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function statsFmtWinRate(wins, losses)
	local total = wins + losses
	if total == 0 then return "0.0%" end
	return string.format("%.1f%%", wins / total * 100)
end

local function statsFmtTime(ts)
	if not ts or ts == 0 then return L.stats_never_reset end
	return os.date("%Y-%m-%d %H:%M:%S", ts)
end

-- 初始載入
local _statsAllData = statsReadAll()
local _statsPd      = statsGetOrInit(_statsAllData)

-- UI
Tab_stats:Separator({ Text = L.stats_section })

local statsLabel_wins = Tab_stats:Label({
	Text = L.stats_wins .. _statsPd.wins,
	TextSize = fontSize or 16,
	NoTheme = true,
	TextColor3 = Color3.fromRGB(240, 240, 240),
})

local statsLabel_losses = Tab_stats:Label({
	Text = L.stats_losses .. _statsPd.losses,
	TextSize = fontSize or 16,
	NoTheme = true,
	TextColor3 = Color3.fromRGB(240, 240, 240),
})

local statsLabel_total = Tab_stats:Label({
	Text = L.stats_total .. (_statsPd.wins + _statsPd.losses),
	TextSize = fontSize or 16,
	NoTheme = true,
	TextColor3 = Color3.fromRGB(240, 240, 240),
})

local statsLabel_winrate = Tab_stats:Label({
	Text = L.stats_winrate .. statsFmtWinRate(_statsPd.wins, _statsPd.losses),
	TextSize = fontSize or 16,
	NoTheme = true,
	TextColor3 = Color3.fromRGB(240, 240, 240),
})

local statsLabel_money = Tab_stats:Label({
	Text = L.stats_money .. statsComma(_statsPd.money),
	TextSize = fontSize or 16,
	NoTheme = true,
	TextColor3 = Color3.fromRGB(240, 240, 240),
})

local statsLabel_lastReset = Tab_stats:Label({
	Text = L.stats_lastReset .. statsFmtTime(_statsPd.lastReset),
	TextSize = fontSize or 14,
	NoTheme = true,
	TextColor3 = Color3.fromRGB(180, 180, 180),
})

local function refreshStatsUI(pd)
	statsLabel_wins.Text      = L.stats_wins      .. pd.wins
	statsLabel_losses.Text    = L.stats_losses    .. pd.losses
	statsLabel_total.Text     = L.stats_total     .. (pd.wins + pd.losses)
	statsLabel_winrate.Text   = L.stats_winrate   .. statsFmtWinRate(pd.wins, pd.losses)
	statsLabel_money.Text     = L.stats_money     .. statsComma(pd.money)
	statsLabel_lastReset.Text = L.stats_lastReset .. statsFmtTime(pd.lastReset)
end

Tab_stats:Button({
	Text = L.stats_reset,
	TextSize = fontSize or 16,
	Callback = function(btn)
		local Popup = Tab_stats:PopupModal({ RelativeTo = btn })
		Popup:Separator({ Text = L.stats_reset_confirm })
		local PopupRow = Popup:Row({ Expanded = true })
		PopupRow:Button({
			Text = L.localscript_confirm_yes,
			Callback = function()
				Popup:ClosePopup()
				local pd = statsReset()
				refreshStatsUI(pd)
			end,
		})
		PopupRow:Button({
			Text = L.localscript_confirm_no,
			Callback = function()
				Popup:ClosePopup()
			end,
		})
	end,
})

-- GameOver 偵測
task.spawn(function()
	local ok, GameOver = pcall(function()
		return Stats_LocalPlayer:WaitForChild("PlayerGui", 30):WaitForChild("UI", 30):WaitForChild("Game", 30):WaitForChild("GameOver", 30)
	end)
	if not ok or not GameOver then return end

	local CoinsTitle = GameOver.Info.Currencies.Coins.Title

	GameOver:GetPropertyChangedSignal("Visible"):Connect(function()
		if not GameOver.Visible then return end

		local titleText = GameOver.Victory.Title.Text
		local isWin  = titleText == "VICTORY!"
		local isLoss = titleText == "DEFEAT!"
		if not (isWin or isLoss) then return end

		-- 等 UpdateCurrencies 把金幣文字寫入，最多 2 秒
		local recorded = false
		local conn
		conn = CoinsTitle:GetPropertyChangedSignal("Text"):Connect(function()
			if recorded then return end
			recorded = true
			conn:Disconnect()
			local pd = statsSave(isWin, statsParseEarned(CoinsTitle.Text))
			refreshStatsUI(pd)
		end)

		task.delay(2, function()
			if not recorded then
				recorded = true
				if conn.Connected then conn:Disconnect() end
				-- UpdateCurrencies 未到（金幣 0 或已滿），只記輸贏
				local pd = statsSave(isWin, 0)
				refreshStatsUI(pd)
			end
		end)
	end)
end)