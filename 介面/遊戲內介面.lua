-- 側邊通知模組
if not getgenv().NotificationModule then
	loadstring(game:HttpGet("https://gist.githubusercontent.com/Tseting-nil/08653e6aa9fc12a9f097bfb10e6654e7/raw/00001d614d928fc5dafce59133a012dd78419afd/%25E5%2581%25B4%25E9%2582%258A%25E9%2580%259A%25E7%259F%25A5%25E6%25A8%25A1%25E7%25B5%2584.lua"))()
end

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
		sectionStatus  = "當前狀態",
		envChecking    = "環境檢查中...",
		gameState      = "遊戲當前狀態",
		autoReplay     = "重開",
		sectionControl = "控制按鈕",
		btnToggleAutoReplay = "控制自動重開",
		btnManualReplay     = "手動重開",
		btnLobby            = "回大廳",
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
	},
	en = {
		windowTitle    = "In-Game UI",
		sectionStatus  = "Current Status",
		envChecking    = "Checking environment...",
		gameState      = "Game State",
		autoReplay     = "Auto Replay",
		sectionControl = "Control Buttons",
		btnToggleAutoReplay = "Toggle Auto Replay",
		btnManualReplay     = "Replay",
		btnLobby            = "To Lobby",
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
	},
}

local L = i18n[currentLang]
local fontSize = currentLang == "en" and 14 or nil

local Msg = getgenv().NotificationModule
local NTD_API = nil
local Scripttable = nil
local Mainfunction = nil

local ReGui = loadstring(game:HttpGet("https://gist.githubusercontent.com/Tseting-nil/169b7303e1418cb301bad5ab427e9351/raw/93e90190f628387b545eef62b49e4ce146d1dad8/GUI:ReGui"))()

local windowSize = currentLang == "en" and UDim2.new(0, 280, 0, 150) or UDim2.new(0, 250, 0, 180)

local Window = ReGui:Window({
	Title = L.windowTitle,
	Size = windowSize,
	NoScroll = true,
	Theme = "DarkTheme",
	Visible = true,
  NoResize = true,
})

local Tab_main = Window:ScrollingCanvas({
	Fill = true,
	UiPadding = UDim.new(0, 0)
})

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
	Callback = function()
    if getgenv().NTDAPI then
      Mainfunction.Queueload()
			NTD_API.Replay()
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
  else
    API_Check_Label.Text = L.envNotExist
    AutoReplay_Label.Text = L.noEnv
  end
  task.wait(0.5)
end
