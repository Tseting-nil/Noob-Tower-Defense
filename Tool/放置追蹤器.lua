local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- === 裝置檢測 ===
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local UISizes = {
	mainFrame              = isMobile and UDim2.new(0, 320, 0, 350) or UDim2.new(0, 550, 0, 480),
	mainFrameMinimized     = isMobile and UDim2.new(0, 320, 0, 50)  or UDim2.new(0, 550, 0, 50),
	mainFrameExpanded      = isMobile and UDim2.new(0, 320, 0, 350) or UDim2.new(0, 550, 0, 450),
	parameterFrame         = isMobile and UDim2.new(0, 280, 0, 350) or UDim2.new(0, 360, 0, 400),
	parameterFramePosition = isMobile and UDim2.new(0.5, -140, 0.5, -175) or UDim2.new(0.5, -180, 0.5, -200),
	saveFrame              = isMobile and UDim2.new(0, 280, 0, 200) or UDim2.new(0, 350, 0, 230),
	saveFramePosition      = isMobile and UDim2.new(0.5, -140, 0.5, -100) or UDim2.new(0.5, -175, 0.5, -115),
	manageFrame            = isMobile and UDim2.new(0, 300, 0, 350) or UDim2.new(0, 400, 0, 450),
	manageFramePosition    = isMobile and UDim2.new(0.5, -150, 0.5, -175) or UDim2.new(0.5, -200, 0.5, -225),
}

-- === 全局下拉選單管理 ===
local currentOpenDropdownList = nil

-- === UI 主題 ===
local Theme = {
	Background      = Color3.fromRGB(25, 27, 30),
	Surface         = Color3.fromRGB(35, 38, 42),
	SurfaceHighlight= Color3.fromRGB(45, 48, 52),
	Border          = Color3.fromRGB(60, 65, 70),
	Text            = Color3.fromRGB(230, 230, 230),
	TextDark        = Color3.fromRGB(30, 30, 30),
	TextDim         = Color3.fromRGB(160, 160, 160),
	Accent          = Color3.fromRGB(60, 160, 255),
	AccentHover     = Color3.fromRGB(90, 180, 255),
	Success         = Color3.fromRGB(100, 220, 120),
	Warning         = Color3.fromRGB(255, 180, 60),
	Error           = Color3.fromRGB(255, 80, 80),
	CornerRadius    = UDim.new(0, 10),
	Font            = Enum.Font.GothamMedium,
	FontBold        = Enum.Font.GothamBold,
	SizeLarge       = 24,
	SizeMedium      = 16,
	SizeNormal      = 16,
}

-- === 遊戲資訊 ===
local gameSettings = {
	mapId      = "Unknown",
	difficulty = "Unknown",
	modifier   = "None",
}

-- === 腳本設定 ===
local ScriptSettings = {
	AutoReplay = true,
}

local currentLang = "en"  -- default，若讀取失敗保持 EN
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
local Lang = {
	zh = {
		titleMain        = "新手塔房 | 排程追蹤器",
		titleParam       = "  ⚙️ 參數設定",
		titleSave        = "  💾 儲存腳本",
		titleManage      = "  📁 腳本管理",
		btnCopy          = "📋 複製",
		btnCopied        = "✅ 已複製",
		btnSave          = "💾 儲存",
		btnParam         = "⚙️ 參數",
		btnRefresh       = "🔄 刷新",
		btnReset         = "🔄 重置追蹤器",
		btnDebug         = "🔍 塔追蹤清單",
		btnConfirmSave   = "✅ 確認儲存",
		btnCancel        = "❌ 取消",
		toggleOn         = "開",
		toggleOff        = "關",
		lblInterface     = "📜 介面設定",
		lblAutoScroll    = "自動捲軸",
		lblGameInfo      = "ℹ️ 遊戲資訊",
		lblTrackerOp     = "🛠️ 追蹤器操作",
		lblScriptParam   = "📝 腳本參數",
		lblAutoReplay    = "自動重播 (AutoReplay)",
		lblFileName      = "輸入腳本名稱:",
		phFileName       = "輸入腳本名稱...",
		infoFmt          = "地圖: %s\n難易度: %s\n效果: %s",
		logNoOps         = "⚠️ 沒有可生成的操作記錄",
		logSaved         = "✅ 已儲存: %s",
		logSaveFailed    = "❌ 儲存失敗: %s",
		logNoScripts     = "尚無已儲存的腳本",
		logCopied        = "📋 已複製: %s",
		logDeleted       = "🗑️ 已刪除: %s",
		logCopyOk        = "✅ 腳本已複製到剪貼板！",
		logCopyConsole   = "⚠️ 腳本已輸出到控制台（F9查看）",
		logInvalidName   = "⚠️ 請輸入有效的腳本名稱",
		logReset         = "🔄 追蹤器已重置",
		logTowerListHdr  = "=== 塔追蹤清單 ===",
		logNoRecord      = "  (無記錄)",
		logReady         = "⏳ Ready 已送出，請選擇難易度...",
		logSkipWave      = "跳過關卡  +%.1fs",
		logSpeedSet      = "速度設定: %dx  +%.1fs",
		logDiffStart     = "難易度選擇: %s → 開始計時",
		logDiffUpdate    = "難易度更新: %s",
		logModAdd        = "效果套用: %s",
		logModRemove     = "效果移除: %s，當前: %s",
		logWaitReady     = "⏳ 等待 Ready...",
		logFlow          = "📋 流程：Ready → 選擇難易度 → 自動開始計時",
		logGameEnd       = "🏁 遊戲結束  總時間: %dm %ds (%.1fs)",
		logStarted       = "🎉 追蹤系統已啟動！地圖: %s  難易度: %s  效果: %s",
		logInitFailed    = "❌ 追蹤系統初始化失敗（可能不在遊戲中）",
		logPlaceTower    = "放置塔 #%d: %s  +%.1fs",
		logPlaceFailed   = "⚠️ 放置塔失敗: %s (伺服器拒絕)",
		logUpgrade       = "升級塔 #%d: %s  +%.1fs",
		logUpgradeUnknown= "升級塔 [id:%s] (未追蹤)  +%.1fs",
		logSell          = "刪除塔 #%d: %s  +%.1fs",
		logSellUnknown   = "刪除塔 [id:%s] (未追蹤)  +%.1fs",
		logAbility       = "塔能力 #%d %s: %s  +%.1fs",
		logAbilityUnknown= "塔能力 [id:%s] %s (未追蹤)  +%.1fs",
		logTowerItem     = "  #%d %s [id=%s] +%.1fs",
	},
	en = {
		titleMain        = "Noob Tower | Tracker",
		titleParam       = "  ⚙️ Parameters",
		titleSave        = "  💾 Save Script",
		titleManage      = "  📁 Script Manager",
		btnCopy          = "📋 Copy",
		btnCopied        = "✅ Copied",
		btnSave          = "💾 Save",
		btnParam         = "⚙️ Params",
		btnRefresh       = "🔄 Refresh",
		btnReset         = "🔄 Reset",
		btnDebug         = "🔍 Tower List",
		btnConfirmSave   = "✅ Confirm",
		btnCancel        = "❌ Cancel",
		toggleOn         = "ON",
		toggleOff        = "OFF",
		lblInterface     = "📜 Interface",
		lblAutoScroll    = "Auto Scroll",
		lblGameInfo      = "ℹ️ Game Info",
		lblTrackerOp     = "🛠️ Tracker Ops",
		lblScriptParam   = "📝 Script Params",
		lblAutoReplay    = "Auto Replay",
		lblFileName      = "Script name:",
		phFileName       = "Enter script name...",
		infoFmt          = "Map: %s\nDifficulty: %s\nModifier: %s",
		logNoOps         = "⚠️ No operations recorded",
		logSaved         = "✅ Saved: %s",
		logSaveFailed    = "❌ Save failed: %s",
		logNoScripts     = "No saved scripts",
		logCopied        = "📋 Copied: %s",
		logDeleted       = "🗑️ Deleted: %s",
		logCopyOk        = "✅ Script copied to clipboard!",
		logCopyConsole   = "⚠️ Script printed to console (F9)",
		logInvalidName   = "⚠️ Please enter a valid script name",
		logReset         = "🔄 Tracker reset",
		logTowerListHdr  = "=== Tower List ===",
		logNoRecord      = "  (empty)",
		logReady         = "⏳ Ready sent, select difficulty...",
		logSkipWave      = "Skip wave  +%.1fs",
		logSpeedSet      = "Speed: %dx  +%.1fs",
		logDiffStart     = "Difficulty: %s → Timer started",
		logDiffUpdate    = "Difficulty updated: %s",
		logModAdd        = "Modifier added: %s",
		logModRemove     = "Modifier removed: %s, current: %s",
		logWaitReady     = "⏳ Waiting for Ready...",
		logFlow          = "📋 Flow: Ready → Select difficulty → Timer starts",
		logGameEnd       = "🏁 Game ended  Total: %dm %ds (%.1fs)",
		logStarted       = "🎉 Tracker started! Map: %s  Difficulty: %s  Modifier: %s",
		logInitFailed    = "❌ Tracker init failed (not in game?)",
		logPlaceTower    = "Place #%d: %s  +%.1fs",
		logPlaceFailed   = "⚠️ Place failed: %s (rejected)",
		logUpgrade       = "Upgrade #%d: %s  +%.1fs",
		logUpgradeUnknown= "Upgrade [id:%s] (untracked)  +%.1fs",
		logSell          = "Sell #%d: %s  +%.1fs",
		logSellUnknown   = "Sell [id:%s] (untracked)  +%.1fs",
		logAbility       = "Ability #%d %s: %s  +%.1fs",
		logAbilityUnknown= "Ability [id:%s] %s (untracked)  +%.1fs",
		logTowerItem     = "  #%d %s [id=%s] +%.1fs",
	}
}

local function T(key) return Lang[currentLang][key] or key end

local i18nElements   = {}
local i18nToggleBtns = {}
local infoLabel  -- forward declaration

local function bindText(obj, key, prop)
	prop = prop or "Text"
	obj[prop] = T(key)
	table.insert(i18nElements, { obj = obj, key = key, prop = prop })
end

local function updateInfoLabel()
	if infoLabel then
		infoLabel.Text = T("infoFmt"):format(gameSettings.mapId, gameSettings.difficulty, gameSettings.modifier)
	end
end

local function updateI18n()
	for _, b in ipairs(i18nElements) do
		b.obj[b.prop] = T(b.key)
	end
	for _, tb in ipairs(i18nToggleBtns) do
		local isOn = tb.getState()
		tb.btn.Text       = isOn and T("toggleOn") or T("toggleOff")
		tb.btn.TextColor3 = isOn and Theme.TextDark or Theme.TextDim
	end
	updateInfoLabel()
end

-- === 追蹤狀態 ===
local PlaceTowerRemote   = nil
local UpgradeTowerRemote = nil
local SellTowerRemote    = nil
local SkipWaveRemote     = nil
local GameSpeedRemote    = nil
local GamemodeRemote     = nil
local ReadyRemote        = nil
local GameRunningValue   = nil
local TowerAbilityRemote = nil

local nextOrder    = 1
local orderToInfo  = {}   -- order -> { order, name, id, position, time }
local idToOrder    = {}   -- gameId(number) -> order
local upgradeLog   = {}   -- { gameId, order, time }
local sellLog      = {}   -- { gameId, order, wave, waveTime }
local skipWaveLog  = {}   -- { time }
local speedChangeLog = {} -- { speed, time }
local abilityLog   = {}   -- { gameId, order, abilityName, elapsed }
local lastDetectedSpeed = 1

local DEBUG_MODE = false

-- === 遊戲狀態追蹤 ===
local isGameRunning = false
local gameStartTime = nil
local gameEndElapsed = nil

-- === 腳本生成設定 ===
local timeRoundUp          = false
local customComment        = ""
local script_SpeedMultiplier = 1
local autoScrollEnabled    = true
local SCRIPT_SAVE_PATH     = "Tsetingnil_script/NTD/Script"
local NTD_API_URL          = "https://raw.githubusercontent.com/Tseting-nil/Noob-Tower-Defense/refs/heads/main/%E5%AF%86%E9%91%B0%E7%B3%BB%E7%B5%B1.lua"

local uiVisible = true

local function getElapsed()
	if not gameStartTime then return 0 end
	return tick() - gameStartTime
end

-- ============================================================
-- UI 建立
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NTDTrackerUI"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UISizes.mainFrame
mainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Theme.Background
mainFrame.BackgroundTransparency = 0.05
mainFrame.Active = true
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = Theme.CornerRadius
corner.Parent = mainFrame

local shadow = Instance.new("UIStroke")
shadow.Thickness = 1.5
shadow.Color = Theme.Border
shadow.Transparency = 0.2
shadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
shadow.Parent = mainFrame

-- 標題欄
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Theme.Surface
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
titleBar.Name = "TitleBar"

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = Theme.CornerRadius
titleCorner.Parent = titleBar

local titleBarCover = Instance.new("Frame")
titleBarCover.Size = UDim2.new(1, 0, 0, 10)
titleBarCover.Position = UDim2.new(0, 0, 1, -10)
titleBarCover.BackgroundColor3 = Theme.Surface
titleBarCover.BorderSizePixel = 0
titleBarCover.Parent = titleBar

local titleSeparator = Instance.new("Frame")
titleSeparator.Size = UDim2.new(1, 0, 0, 1)
titleSeparator.Position = UDim2.new(0, 0, 1, -1)
titleSeparator.BackgroundColor3 = Theme.Border
titleSeparator.BorderSizePixel = 0
titleSeparator.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -90, 1, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Theme.Accent
title.Font = Theme.FontBold
title.TextSize = Theme.SizeLarge
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0, 10, 0, 0)
title.Parent = titleBar
bindText(title, "titleMain")

local langBtn = Instance.new("TextButton")
langBtn.Size = UDim2.new(0, 35, 0, 35)
langBtn.Position = UDim2.new(1, -80, 0, 5)
langBtn.Text = currentLang == "zh" and "EN" or "中"
langBtn.BackgroundColor3 = Theme.SurfaceHighlight
langBtn.TextColor3 = Theme.Accent
langBtn.Font = Theme.FontBold
langBtn.TextSize = 13
langBtn.BorderSizePixel = 0
langBtn.Parent = titleBar
do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = langBtn end

langBtn.MouseButton1Click:Connect(function()
	if currentLang == "zh" then
		currentLang = "en"
		langBtn.Text = "中"
	else
		currentLang = "zh"
		langBtn.Text = "EN"
	end
	updateI18n()
end)

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
minimizeBtn.Position = UDim2.new(1, -40, 0, 5)
minimizeBtn.Text = "—"
minimizeBtn.BackgroundColor3 = Theme.SurfaceHighlight
minimizeBtn.TextColor3 = Theme.Text
minimizeBtn.Font = Theme.FontBold
minimizeBtn.TextSize = 22
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar
do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = minimizeBtn end

-- 滾動框架
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -100)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 4
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarImageColor3 = Theme.Border
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8)
listLayout.Parent = scrollFrame

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

task.spawn(function()
	while true do
		task.wait(0.1)
		if scrollFrame and autoScrollEnabled then
			pcall(function()
				scrollFrame.CanvasPosition = Vector2.new(0, scrollFrame.CanvasSize.Y.Offset)
			end)
		end
	end
end)

-- 按鈕列
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -20, 0, 40)
buttonContainer.Position = UDim2.new(0, 10, 1, -45)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

local buttonLayout = Instance.new("UIListLayout")
buttonLayout.FillDirection = Enum.FillDirection.Horizontal
buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
buttonLayout.Padding = UDim.new(0, 6)
buttonLayout.Parent = buttonContainer

local function makeBtn(textKey, bgColor, txtColor, order, widthScale)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(widthScale or 0.25, -5, 1, 0)
	btn.BackgroundColor3 = bgColor
	btn.TextColor3 = txtColor
	btn.Font = Theme.FontBold
	btn.TextSize = Theme.SizeMedium
	btn.BorderSizePixel = 0
	btn.LayoutOrder = order
	btn.Parent = buttonContainer
	local c = Instance.new("UICorner"); c.CornerRadius = Theme.CornerRadius; c.Parent = btn
	bindText(btn, textKey)
	return btn
end

local copyBtn   = makeBtn("btnCopy",  Theme.Success,          Theme.TextDark, 1, 0.34)
local saveBtn   = makeBtn("btnSave",  Theme.Accent,           Theme.Text,     2, 0.34)
local Parameter = makeBtn("btnParam", Theme.SurfaceHighlight, Theme.Text,     3, 0.32)

local resetBtn
local debugBtn

-- ============================================================
-- addLog 函數
-- ============================================================
local logOrder = 1

local function addLog(text, color)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color or Theme.Text
	label.Font = Theme.Font
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextWrapped = true
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.LayoutOrder = logOrder
	label.Parent = scrollFrame
	logOrder = logOrder + 1
end

-- ============================================================
-- 參數面板 UI
-- ============================================================
local parameterFrame = Instance.new("Frame")
parameterFrame.Size = UISizes.parameterFrame
parameterFrame.Position = UISizes.parameterFramePosition
parameterFrame.BackgroundColor3 = Theme.Background
parameterFrame.BackgroundTransparency = 0.05
parameterFrame.Active = true
parameterFrame.BorderSizePixel = 0
parameterFrame.ClipsDescendants = true
parameterFrame.Visible = false
parameterFrame.ZIndex = 10
parameterFrame.Parent = screenGui
do local c = Instance.new("UICorner"); c.CornerRadius = Theme.CornerRadius; c.Parent = parameterFrame end
do local s = Instance.new("UIStroke"); s.Thickness = 1.5; s.Color = Theme.Border; s.Transparency = 0.2; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = parameterFrame end

local paramTitleBar = Instance.new("Frame")
paramTitleBar.Size = UDim2.new(1, 0, 0, 45)
paramTitleBar.BackgroundColor3 = Theme.Surface
paramTitleBar.BorderSizePixel = 0
paramTitleBar.ZIndex = 11
paramTitleBar.Parent = parameterFrame
do local c = Instance.new("UICorner"); c.CornerRadius = Theme.CornerRadius; c.Parent = paramTitleBar end
do local f = Instance.new("Frame"); f.Size = UDim2.new(1,0,0,10); f.Position = UDim2.new(0,0,1,-10); f.BackgroundColor3 = Theme.Surface; f.BorderSizePixel = 0; f.ZIndex = 11; f.Parent = paramTitleBar end

local paramTitle = Instance.new("TextLabel")
paramTitle.Size = UDim2.new(0.8, 0, 1, 0)
paramTitle.BackgroundTransparency = 1
paramTitle.TextColor3 = Theme.Text
paramTitle.Font = Theme.FontBold
paramTitle.TextSize = Theme.SizeLarge
paramTitle.TextXAlignment = Enum.TextXAlignment.Left
paramTitle.ZIndex = 12
paramTitle.Parent = paramTitleBar
bindText(paramTitle, "titleParam")

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.Text = "×"
closeBtn.BackgroundColor3 = Theme.Error
closeBtn.TextColor3 = Theme.Text
closeBtn.Font = Theme.FontBold
closeBtn.TextSize = 24
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 12
closeBtn.Parent = paramTitleBar
do local c = Instance.new("UICorner"); c.CornerRadius = Theme.CornerRadius; c.Parent = closeBtn end

local paramScrollFrame = Instance.new("ScrollingFrame")
paramScrollFrame.Size = UDim2.new(1, -20, 1, -55)
paramScrollFrame.Position = UDim2.new(0, 10, 0, 50)
paramScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
paramScrollFrame.ScrollBarThickness = 4
paramScrollFrame.BackgroundTransparency = 1
paramScrollFrame.ZIndex = 11
paramScrollFrame.Parent = parameterFrame

local paramListLayout = Instance.new("UIListLayout")
paramListLayout.SortOrder = Enum.SortOrder.LayoutOrder
paramListLayout.Padding = UDim.new(0, 8)
paramListLayout.Parent = paramScrollFrame

paramListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	paramScrollFrame.CanvasSize = UDim2.new(0, 0, 0, paramListLayout.AbsoluteContentSize.Y + 10)
end)

-- ============================================================
-- 儲存面板 UI
-- ============================================================
local saveFrame = Instance.new("Frame")
saveFrame.Size = UISizes.saveFrame
saveFrame.Position = UISizes.saveFramePosition
saveFrame.BackgroundColor3 = Theme.Background
saveFrame.BackgroundTransparency = 0.05
saveFrame.Active = true
saveFrame.BorderSizePixel = 0
saveFrame.ClipsDescendants = true
saveFrame.Visible = false
saveFrame.ZIndex = 10
saveFrame.Parent = screenGui
do local c = Instance.new("UICorner"); c.CornerRadius = Theme.CornerRadius; c.Parent = saveFrame end
do local s = Instance.new("UIStroke"); s.Thickness = 1.5; s.Color = Theme.Border; s.Transparency = 0.2; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = saveFrame end

local saveTitleBar = Instance.new("Frame")
saveTitleBar.Size = UDim2.new(1, 0, 0, 45)
saveTitleBar.BackgroundColor3 = Theme.Surface
saveTitleBar.BorderSizePixel = 0
saveTitleBar.ZIndex = 11
saveTitleBar.Parent = saveFrame
do local c = Instance.new("UICorner"); c.CornerRadius = Theme.CornerRadius; c.Parent = saveTitleBar end
do local f = Instance.new("Frame"); f.Size = UDim2.new(1,0,0,10); f.Position = UDim2.new(0,0,1,-10); f.BackgroundColor3 = Theme.Surface; f.BorderSizePixel = 0; f.ZIndex = 11; f.Parent = saveTitleBar end

local saveTitle = Instance.new("TextLabel")
saveTitle.Size = UDim2.new(0.8, 0, 1, 0)
saveTitle.BackgroundTransparency = 1
saveTitle.TextColor3 = Theme.Text
saveTitle.Font = Theme.FontBold
saveTitle.TextSize = Theme.SizeLarge
saveTitle.TextXAlignment = Enum.TextXAlignment.Left
saveTitle.ZIndex = 12
saveTitle.Parent = saveTitleBar
bindText(saveTitle, "titleSave")

local saveCloseBtn = Instance.new("TextButton")
saveCloseBtn.Size = UDim2.new(0, 35, 0, 35)
saveCloseBtn.Position = UDim2.new(1, -40, 0, 5)
saveCloseBtn.Text = "×"
saveCloseBtn.BackgroundColor3 = Theme.Error
saveCloseBtn.TextColor3 = Theme.Text
saveCloseBtn.Font = Theme.FontBold
saveCloseBtn.TextSize = 24
saveCloseBtn.BorderSizePixel = 0
saveCloseBtn.ZIndex = 12
saveCloseBtn.Parent = saveTitleBar
do local c = Instance.new("UICorner"); c.CornerRadius = Theme.CornerRadius; c.Parent = saveCloseBtn end

local fileNameLabel = Instance.new("TextLabel")
fileNameLabel.Size = UDim2.new(1, -20, 0, 20)
fileNameLabel.Position = UDim2.new(0, 10, 0, 55)
fileNameLabel.BackgroundTransparency = 1
fileNameLabel.TextColor3 = Theme.TextDim
fileNameLabel.Font = Theme.Font
fileNameLabel.TextSize = Theme.SizeNormal
fileNameLabel.TextXAlignment = Enum.TextXAlignment.Left
fileNameLabel.ZIndex = 12
fileNameLabel.Parent = saveFrame
bindText(fileNameLabel, "lblFileName")

local fileNameInput = Instance.new("TextBox")
fileNameInput.Size = UDim2.new(1, -20, 0, 35)
fileNameInput.Position = UDim2.new(0, 10, 0, 80)
fileNameInput.BackgroundColor3 = Theme.SurfaceHighlight
fileNameInput.PlaceholderColor3 = Theme.TextDim
fileNameInput.Text = ""
fileNameInput.TextColor3 = Theme.Text
fileNameInput.Font = Theme.Font
fileNameInput.TextSize = Theme.SizeNormal
fileNameInput.BorderSizePixel = 0
fileNameInput.ClearTextOnFocus = false
fileNameInput.ZIndex = 12
fileNameInput.Parent = saveFrame
do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = fileNameInput end
bindText(fileNameInput, "phFileName", "PlaceholderText")

local saveBtnContainer = Instance.new("Frame")
saveBtnContainer.Size = UDim2.new(1, -20, 0, 40)
saveBtnContainer.Position = UDim2.new(0, 10, 0, 130)
saveBtnContainer.BackgroundTransparency = 1
saveBtnContainer.ZIndex = 12
saveBtnContainer.Parent = saveFrame
do local l = Instance.new("UIListLayout"); l.FillDirection = Enum.FillDirection.Horizontal; l.Padding = UDim.new(0,10); l.Parent = saveBtnContainer end

local confirmSaveBtn = Instance.new("TextButton")
confirmSaveBtn.Size = UDim2.new(0.5, -5, 1, 0)
confirmSaveBtn.BackgroundColor3 = Theme.Success
confirmSaveBtn.TextColor3 = Theme.TextDark
confirmSaveBtn.Font = Theme.FontBold
confirmSaveBtn.TextSize = Theme.SizeNormal
confirmSaveBtn.BorderSizePixel = 0
confirmSaveBtn.LayoutOrder = 1
confirmSaveBtn.ZIndex = 12
confirmSaveBtn.Parent = saveBtnContainer
do local c = Instance.new("UICorner"); c.CornerRadius = Theme.CornerRadius; c.Parent = confirmSaveBtn end
bindText(confirmSaveBtn, "btnConfirmSave")

local cancelSaveBtn = Instance.new("TextButton")
cancelSaveBtn.Size = UDim2.new(0.5, -5, 1, 0)
cancelSaveBtn.BackgroundColor3 = Theme.SurfaceHighlight
cancelSaveBtn.TextColor3 = Theme.Text
cancelSaveBtn.Font = Theme.FontBold
cancelSaveBtn.TextSize = Theme.SizeNormal
cancelSaveBtn.BorderSizePixel = 0
cancelSaveBtn.LayoutOrder = 2
cancelSaveBtn.ZIndex = 12
cancelSaveBtn.Parent = saveBtnContainer
do local c = Instance.new("UICorner"); c.CornerRadius = Theme.CornerRadius; c.Parent = cancelSaveBtn end
bindText(cancelSaveBtn, "btnCancel")

-- ============================================================
-- 腳本管理面板
-- ============================================================
local refreshScriptList  -- 前向宣告

local manageFrame = Instance.new("Frame")
manageFrame.Size = UISizes.manageFrame
manageFrame.Position = UISizes.manageFramePosition
manageFrame.BackgroundColor3 = Theme.Background
manageFrame.BackgroundTransparency = 0.05
manageFrame.Active = true
manageFrame.BorderSizePixel = 0
manageFrame.ClipsDescendants = true
manageFrame.Visible = false
manageFrame.ZIndex = 10
manageFrame.Parent = screenGui
do local c = Instance.new("UICorner"); c.CornerRadius = Theme.CornerRadius; c.Parent = manageFrame end
do local s = Instance.new("UIStroke"); s.Thickness = 1.5; s.Color = Theme.Border; s.Transparency = 0.2; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = manageFrame end

local manageTitleBar = Instance.new("Frame")
manageTitleBar.Size = UDim2.new(1, 0, 0, 45)
manageTitleBar.BackgroundColor3 = Theme.Surface
manageTitleBar.BorderSizePixel = 0
manageTitleBar.ZIndex = 11
manageTitleBar.Parent = manageFrame
do local c = Instance.new("UICorner"); c.CornerRadius = Theme.CornerRadius; c.Parent = manageTitleBar end
do local f = Instance.new("Frame"); f.Size = UDim2.new(1,0,0,10); f.Position = UDim2.new(0,0,1,-10); f.BackgroundColor3 = Theme.Surface; f.BorderSizePixel = 0; f.ZIndex = 11; f.Parent = manageTitleBar end

local manageTitle = Instance.new("TextLabel")
manageTitle.Size = UDim2.new(0.6, 0, 1, 0)
manageTitle.BackgroundTransparency = 1
manageTitle.TextColor3 = Theme.Text
manageTitle.Font = Theme.FontBold
manageTitle.TextSize = Theme.SizeLarge
manageTitle.TextXAlignment = Enum.TextXAlignment.Left
manageTitle.ZIndex = 12
manageTitle.Parent = manageTitleBar
bindText(manageTitle, "titleManage")

local refreshScriptsBtn = Instance.new("TextButton")
refreshScriptsBtn.Size = UDim2.new(0, 80, 0, 30)
refreshScriptsBtn.Position = UDim2.new(1, -125, 0, 7)
refreshScriptsBtn.BackgroundColor3 = Theme.Accent
refreshScriptsBtn.TextColor3 = Theme.Text
refreshScriptsBtn.Font = Theme.Font
refreshScriptsBtn.TextSize = 14
refreshScriptsBtn.BorderSizePixel = 0
refreshScriptsBtn.ZIndex = 12
refreshScriptsBtn.Parent = manageTitleBar
do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = refreshScriptsBtn end
bindText(refreshScriptsBtn, "btnRefresh")

local manageCloseBtn = Instance.new("TextButton")
manageCloseBtn.Size = UDim2.new(0, 35, 0, 35)
manageCloseBtn.Position = UDim2.new(1, -40, 0, 5)
manageCloseBtn.Text = "×"
manageCloseBtn.BackgroundColor3 = Theme.Error
manageCloseBtn.TextColor3 = Theme.Text
manageCloseBtn.Font = Theme.FontBold
manageCloseBtn.TextSize = 24
manageCloseBtn.BorderSizePixel = 0
manageCloseBtn.ZIndex = 12
manageCloseBtn.Parent = manageTitleBar
do local c = Instance.new("UICorner"); c.CornerRadius = Theme.CornerRadius; c.Parent = manageCloseBtn end

local manageScrollFrame = Instance.new("ScrollingFrame")
manageScrollFrame.Size = UDim2.new(1, -20, 1, -55)
manageScrollFrame.Position = UDim2.new(0, 10, 0, 50)
manageScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
manageScrollFrame.ScrollBarThickness = 4
manageScrollFrame.BackgroundTransparency = 1
manageScrollFrame.ZIndex = 11
manageScrollFrame.Parent = manageFrame

local manageListLayout = Instance.new("UIListLayout")
manageListLayout.SortOrder = Enum.SortOrder.LayoutOrder
manageListLayout.Padding = UDim.new(0, 6)
manageListLayout.Parent = manageScrollFrame

manageListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	manageScrollFrame.CanvasSize = UDim2.new(0, 0, 0, manageListLayout.AbsoluteContentSize.Y + 10)
end)

-- ============================================================
-- 參數面板 Helper 函數
-- ============================================================
local function createLabel(key, parent, order)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 25)
	label.BackgroundTransparency = 1
	label.TextColor3 = Theme.TextDim
	label.Font = Theme.FontBold
	label.TextSize = Theme.SizeNormal
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.LayoutOrder = order
	label.ZIndex = 13
	label.Parent = parent
	bindText(label, key)
	return label
end

local function createToggle(labelKey, parent, order, defaultValue, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 40)
	frame.BackgroundTransparency = 1
	frame.LayoutOrder = order
	frame.ZIndex = 12
	frame.Parent = parent

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.75, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = Theme.Text
	lbl.Font = Theme.Font
	lbl.TextSize = Theme.SizeNormal
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 13
	lbl.Parent = frame
	bindText(lbl, labelKey)

	local isOn = defaultValue
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 55, 0, 28)
	btn.Position = UDim2.new(1, -60, 0.5, -14)
	btn.BackgroundColor3 = isOn and Theme.Success or Theme.SurfaceHighlight
	btn.Text = isOn and T("toggleOn") or T("toggleOff")
	btn.TextColor3 = isOn and Theme.TextDark or Theme.TextDim
	btn.Font = Theme.FontBold
	btn.TextSize = Theme.SizeNormal
	btn.BorderSizePixel = 0
	btn.ZIndex = 13
	btn.Parent = frame
	do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 14); c.Parent = btn end

	table.insert(i18nToggleBtns, { btn = btn, getState = function() return isOn end })

	btn.MouseButton1Click:Connect(function()
		isOn = not isOn
		btn.BackgroundColor3 = isOn and Theme.Success or Theme.SurfaceHighlight
		btn.Text = isOn and T("toggleOn") or T("toggleOff")
		btn.TextColor3 = isOn and Theme.TextDark or Theme.TextDim
		if callback then callback(isOn) end
	end)
	return btn
end


-- ============================================================
-- 參數面板控件
-- ============================================================
createLabel("lblInterface", paramScrollFrame, 1)
createToggle("lblAutoScroll", paramScrollFrame, 2, true, function(v) autoScrollEnabled = v end)

createLabel("lblGameInfo", paramScrollFrame, 3)

infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 100)
infoLabel.BackgroundColor3 = Theme.Surface
infoLabel.BackgroundTransparency = 0.5
infoLabel.TextColor3 = Theme.Success
infoLabel.Font = Theme.Font
infoLabel.TextSize = 15
infoLabel.TextWrapped = true
infoLabel.LayoutOrder = 10
infoLabel.ZIndex = 13
infoLabel.Parent = paramScrollFrame
do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = infoLabel end
updateInfoLabel()

createLabel("lblTrackerOp", paramScrollFrame, 11)

local trackerBtnContainer = Instance.new("Frame")
trackerBtnContainer.Size = UDim2.new(1, 0, 0, 40)
trackerBtnContainer.BackgroundTransparency = 1
trackerBtnContainer.LayoutOrder = 12
trackerBtnContainer.ZIndex = 12
trackerBtnContainer.Parent = paramScrollFrame
do local l = Instance.new("UIListLayout"); l.FillDirection = Enum.FillDirection.Horizontal; l.Padding = UDim.new(0,8); l.Parent = trackerBtnContainer end

resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0.5, -4, 1, 0)
resetBtn.BackgroundColor3 = Theme.SurfaceHighlight
resetBtn.TextColor3 = Theme.Warning
resetBtn.Font = Theme.FontBold
resetBtn.TextSize = Theme.SizeNormal
resetBtn.BorderSizePixel = 0
resetBtn.LayoutOrder = 1
resetBtn.ZIndex = 13
resetBtn.Parent = trackerBtnContainer
do local c = Instance.new("UICorner"); c.CornerRadius = Theme.CornerRadius; c.Parent = resetBtn end
bindText(resetBtn, "btnReset")

debugBtn = Instance.new("TextButton")
debugBtn.Size = UDim2.new(0.5, -4, 1, 0)
debugBtn.BackgroundColor3 = Theme.SurfaceHighlight
debugBtn.TextColor3 = Theme.TextDim
debugBtn.Font = Theme.FontBold
debugBtn.TextSize = Theme.SizeNormal
debugBtn.BorderSizePixel = 0
debugBtn.LayoutOrder = 2
debugBtn.ZIndex = 13
debugBtn.Parent = trackerBtnContainer
do local c = Instance.new("UICorner"); c.CornerRadius = Theme.CornerRadius; c.Parent = debugBtn end
bindText(debugBtn, "btnDebug")

createLabel("lblScriptParam", paramScrollFrame, 13)
createToggle("lblAutoReplay", paramScrollFrame, 14, ScriptSettings.AutoReplay, function(v)
	ScriptSettings.AutoReplay = v
end)

-- ============================================================
-- 拖移功能
-- ============================================================
local function makeDraggable(uiElement)
	local state = { dragging = false, dragStart = nil, startPos = nil, isLocked = false }
	local renderConn = nil

	local function update()
		if not state.dragging then return end
		local delta = UserInputService:GetMouseLocation() - state.dragStart
		uiElement.Position = UDim2.new(
			state.startPos.X.Scale, state.startPos.X.Offset + delta.X,
			state.startPos.Y.Scale, state.startPos.Y.Offset + delta.Y)
	end

	uiElement.InputBegan:Connect(function(input)
		if state.isLocked then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			state.dragging = true
			state.dragStart = UserInputService:GetMouseLocation()
			state.startPos = uiElement.Position
			if not renderConn then renderConn = RunService.RenderStepped:Connect(update) end
		end
	end)

	uiElement.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			state.dragging = false
			if renderConn then renderConn:Disconnect(); renderConn = nil end
		end
	end)
end

makeDraggable(parameterFrame)
makeDraggable(saveFrame)
makeDraggable(manageFrame)

local tbDrag = { dragging = false }
local tbConn = nil
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		tbDrag.dragging = true
		tbDrag.dragStart = UserInputService:GetMouseLocation()
		tbDrag.startPos = mainFrame.Position
		if not tbConn then
			tbConn = RunService.RenderStepped:Connect(function()
				if not tbDrag.dragging then return end
				local d = UserInputService:GetMouseLocation() - tbDrag.dragStart
				mainFrame.Position = UDim2.new(tbDrag.startPos.X.Scale, tbDrag.startPos.X.Offset + d.X,
					tbDrag.startPos.Y.Scale, tbDrag.startPos.Y.Offset + d.Y)
			end)
		end
	end
end)
titleBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		tbDrag.dragging = false
		if tbConn then tbConn:Disconnect(); tbConn = nil end
	end
end)

-- ============================================================
-- 收合功能
-- ============================================================
local minimized = false
local function toggleMinimize()
	minimized = not minimized
	scrollFrame.Visible   = not minimized
	copyBtn.Visible       = not minimized
	saveBtn.Visible       = not minimized
	Parameter.Visible     = not minimized
	minimizeBtn.Text      = minimized and "+" or "—"
	game:GetService("TweenService"):Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
		Size = minimized and UISizes.mainFrameMinimized or UISizes.mainFrameExpanded
	}):Play()
end
minimizeBtn.MouseButton1Click:Connect(toggleMinimize)

-- ============================================================
-- 面板互斥
-- ============================================================
local function closeAllPanels()
	parameterFrame.Visible = false
	saveFrame.Visible      = false
	manageFrame.Visible    = false
end

local function openSavePanel()
	closeAllPanels()
	local defaultName = string.format("%s_%s_%s",
		gameSettings.mapId or "Map",
		gameSettings.difficulty or "Diff",
		os.date("%Y%m%d_%H%M%S"))
	defaultName = defaultName:gsub("[^%w_%-]", "_")
	fileNameInput.Text = defaultName
	saveFrame.Visible = true
end

-- ============================================================
-- 檔案 I/O
-- ============================================================
local function listScripts()
	local scripts = {}
	pcall(function()
		if listfiles then
			for _, fp in ipairs(listfiles(SCRIPT_SAVE_PATH)) do
				if fp:match("%.lua$") then
					local name = fp:match("([^/\\]+)%.lua$")
					if name then table.insert(scripts, { name = name, path = fp }) end
				end
			end
		end
	end)
	table.sort(scripts, function(a, b) return a.name > b.name end)
	return scripts
end

local function saveScriptToFile(fileName, content)
	local fullPath = SCRIPT_SAVE_PATH .. "/" .. fileName .. ".lua"
	local ok, err = pcall(function()
		if writefile then writefile(fullPath, content) else error("writefile 不可用") end
	end)
	if ok then addLog(T("logSaved"):format(fileName), Theme.Success); return true, fullPath
	else  addLog(T("logSaveFailed"):format(tostring(err)), Theme.Error); return false, err end
end

function refreshScriptList()
	for _, child in pairs(manageScrollFrame:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end
	local scripts = listScripts()
	if #scripts == 0 then
		local el = Instance.new("TextLabel")
		el.Size = UDim2.new(1,-10,0,40)
		el.BackgroundTransparency = 1
		el.Text = T("logNoScripts")
		el.TextColor3 = Theme.TextDim
		el.Font = Theme.Font
		el.TextSize = Theme.SizeNormal
		el.ZIndex = 12
		el.Parent = manageScrollFrame
		return
	end
	for i, script in ipairs(scripts) do
		local item = Instance.new("Frame")
		item.Size = UDim2.new(1,-5,0,45)
		item.BackgroundColor3 = Theme.SurfaceHighlight
		item.BackgroundTransparency = 0.3
		item.BorderSizePixel = 0
		item.LayoutOrder = i
		item.ZIndex = 12
		item.Parent = manageScrollFrame
		do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = item end

		local nl = Instance.new("TextLabel")
		nl.Size = UDim2.new(1,-100,1,0)
		nl.Position = UDim2.new(0,10,0,0)
		nl.BackgroundTransparency = 1
		nl.Text = script.name
		nl.TextColor3 = Theme.Text
		nl.Font = Theme.Font
		nl.TextSize = 14
		nl.TextXAlignment = Enum.TextXAlignment.Left
		nl.TextTruncate = Enum.TextTruncate.AtEnd
		nl.ZIndex = 13
		nl.Parent = item

		local cpBtn = Instance.new("TextButton")
		cpBtn.Size = UDim2.new(0,35,0,30); cpBtn.Position = UDim2.new(1,-90,0,7)
		cpBtn.Text = "📋"; cpBtn.BackgroundColor3 = Theme.Accent; cpBtn.TextColor3 = Theme.Text
		cpBtn.Font = Theme.FontBold; cpBtn.TextSize = 16; cpBtn.BorderSizePixel = 0
		cpBtn.ZIndex = 13; cpBtn.Parent = item
		do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = cpBtn end

		local dlBtn = Instance.new("TextButton")
		dlBtn.Size = UDim2.new(0,35,0,30); dlBtn.Position = UDim2.new(1,-50,0,7)
		dlBtn.Text = "🗑️"; dlBtn.BackgroundColor3 = Theme.Error; dlBtn.TextColor3 = Theme.Text
		dlBtn.Font = Theme.FontBold; dlBtn.TextSize = 16; dlBtn.BorderSizePixel = 0
		dlBtn.ZIndex = 13; dlBtn.Parent = item
		do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = dlBtn end

		local fp = script.path
		cpBtn.MouseButton1Click:Connect(function()
			local content = pcall(function() if readfile then return readfile(fp) end end)
			if content then
				pcall(function() setclipboard(content) end)
				addLog(T("logCopied"):format(script.name), Theme.Accent)
			end
		end)
		dlBtn.MouseButton1Click:Connect(function()
			pcall(function() if delfile then delfile(fp) end end)
			addLog(T("logDeleted"):format(script.name), Theme.Warning)
			refreshScriptList()
		end)
	end
end

-- ============================================================
-- 生成腳本
-- ============================================================
local function generateScript()
	if nextOrder <= 1 and #upgradeLog == 0 and #skipWaveLog == 0 then
		addLog(T("logNoOps"), Theme.Warning)
		return nil
	end

	local usedTowers = {}
	for order = 1, nextOrder - 1 do
		local info = orderToInfo[order]
		if info and info.UnitType then
			local found = false
			for _, n in ipairs(usedTowers) do if n == info.UnitType then found = true; break end end
			if not found then table.insert(usedTowers, info.UnitType) end
		end
	end

	local operations = {}
	for order = 1, nextOrder - 1 do
		local info = orderToInfo[order]
		if info then
			table.insert(operations, {
				type    = "place",
				order   = order,
				elapsed = info.Elapsed or 0,
				info    = info,
			})
		end
	end
	for _, up in ipairs(upgradeLog) do
		table.insert(operations, {
			type    = "upgrade",
			order   = up.order,
			elapsed = up.elapsed or 0,
			gameId  = up.gameId,
		})
	end
	for _, sl in ipairs(sellLog) do
		table.insert(operations, {
			type    = "sell",
			order   = sl.order,
			elapsed = sl.elapsed or 0,
			gameId  = sl.gameId,
		})
	end
	for _, sk in ipairs(skipWaveLog) do
		table.insert(operations, { type = "skipwave", elapsed = sk.elapsed or 0 })
	end
	for _, sp in ipairs(speedChangeLog) do
		table.insert(operations, { type = "speed", speed = sp.speed, elapsed = sp.elapsed or 0 })
	end
	for _, ab in ipairs(abilityLog) do
		table.insert(operations, {
			type        = "towerability",
			order       = ab.order,
			elapsed     = ab.elapsed or 0,
			gameId      = ab.gameId,
			abilityName = ab.abilityName,
		})
	end
	table.sort(operations, function(a, b)
		return a.elapsed < b.elapsed
	end)

	local fullLines = {}

	table.insert(fullLines, "--[[")
	table.insert(fullLines, "")
	table.insert(fullLines, string.format("Map: %s  |  Difficulty: %s  |  Modifier: %s", gameSettings.mapId, gameSettings.difficulty, gameSettings.modifier))
	if gameEndElapsed then
		local mins = math.floor(gameEndElapsed / 60)
		local secs = math.floor(gameEndElapsed % 60)
		table.insert(fullLines, string.format("Time: %dm %ds (%.1fs)", mins, secs, gameEndElapsed))
	end
	table.insert(fullLines, "")
	if customComment ~= "" then
		table.insert(fullLines, customComment)
		table.insert(fullLines, "")
	end
	if #usedTowers > 0 then
		table.insert(fullLines, "Towers used:")
		for _, name in ipairs(usedTowers) do
			table.insert(fullLines, string.format("  - %s", name))
		end
		table.insert(fullLines, "")
	end
	if script_SpeedMultiplier ~= 1 then
		table.insert(fullLines, string.format("Speed Multiplier: %dx", script_SpeedMultiplier))
		table.insert(fullLines, "")
	end
	table.insert(fullLines, "]]")
	table.insert(fullLines, "")

	table.insert(fullLines, "-- Load NTD API")
	table.insert(fullLines, "local NTD = getgenv().NTD")
	table.insert(fullLines, "if not NTD then")
	table.insert(fullLines, string.format('    loadstring(game:HttpGet("%s"))()', NTD_API_URL))
	table.insert(fullLines, "    NTD = getgenv().NTD")
	table.insert(fullLines, "end")
	table.insert(fullLines, "")

	table.insert(fullLines, "-- ========== LOBBY ==========")
	table.insert(fullLines, "if NTD.IsLobby() then")
	if ScriptSettings.AutoReplay then
		table.insert(fullLines, "\tNTD.AutoReplay(true)")
	end
	if #usedTowers > 0 then
		local towerList = {}
		for _, name in ipairs(usedTowers) do
			table.insert(towerList, string.format('"%s"', name))
		end
		if #towerList == 1 then
			table.insert(fullLines, string.format('\tNTD.EquipTower(%s)', towerList[1]))
		else
			table.insert(fullLines, string.format('\tNTD.EquipTower({ %s })', table.concat(towerList, ", ")))
		end
	end
	if gameSettings.mapId and gameSettings.mapId ~= "Unknown" then
		local modesArg
		if gameSettings.modifier ~= "None" and gameSettings.modifier ~= "" then
			local modeNames = {}
			for m in gameSettings.modifier:gmatch("[^,]+") do
				table.insert(modeNames, '"' .. m:match("^%s*(.-)%s*$") .. '"')
			end
			if #modeNames == 1 then
				modesArg = modeNames[1]
			else
				modesArg = "{ " .. table.concat(modeNames, ", ") .. " }"
			end
		elseif gameSettings.difficulty ~= "Unknown" then
			modesArg = '"' .. gameSettings.difficulty .. '"'
		else
			modesArg = '"Randomiser"'
		end
		table.insert(fullLines, string.format('\tNTD.SelectMap("%s", %s)', gameSettings.mapId, modesArg))
	else
		table.insert(fullLines, '\tNTD.SelectMap("Plains") -- fill in map name')
	end
	table.insert(fullLines, "")

	table.insert(fullLines, "-- ========== IN-GAME ==========")
	table.insert(fullLines, "elseif NTD.IsInGame() then")
	table.insert(fullLines, "")

	if ScriptSettings.AutoReplay then
		table.insert(fullLines, string.format("\tNTD.AutoReplay(%s)", ScriptSettings.AutoReplay and "true" or "false"))
	end
	if gameSettings.difficulty ~= "Unknown" then
		table.insert(fullLines, string.format('\tNTD.Difficulty("%s")', gameSettings.difficulty))
	end
	table.insert(fullLines, "")

	table.insert(fullLines, "\t-- Operations (Elapsed seconds from game start)")

	for _, op in ipairs(operations) do
		local rawE = op.elapsed or 0
		local e
		if timeRoundUp then
			e = math.ceil(rawE * 10) / 10
		else
			e = math.floor(rawE * 10) / 10
		end

		if op.type == "place" then
			local info = op.info
			local x = info.Position and info.Position.X or 0
			local y = info.Position and info.Position.Y or 0
			local z = info.Position and info.Position.Z or 0
			table.insert(fullLines, string.format(
				'\tNTD.AddPlaceTower("%s", %.3f, %.3f, %.3f, 0, %.1f) -- #%d +%.1fs',
				info.UnitType, x, y, z, e, info.Index, e))
		elseif op.type == "upgrade" then
			if op.order then
				table.insert(fullLines, string.format(
					"\tNTD.AddUpgradeTower(%d, %.1f) -- #%d +%.1fs",
					op.order, e, op.order, e))
			else
				table.insert(fullLines, string.format(
					"\t-- WARN: upgrade untracked tower [ID:%s] +%.1fs", tostring(op.gameId), e))
			end
		elseif op.type == "sell" then
			if op.order then
				table.insert(fullLines, string.format(
					"\tNTD.AddSellTower(%d, %.1f) -- #%d +%.1fs",
					op.order, e, op.order, e))
			else
				table.insert(fullLines, string.format(
					"\t-- WARN: sell untracked tower [ID:%s] +%.1fs", tostring(op.gameId), e))
			end
		elseif op.type == "skipwave" then
			table.insert(fullLines, string.format(
				"\tNTD.AddSkipWave(%.1f) -- +%.1fs", e, e))
		elseif op.type == "speed" then
			table.insert(fullLines, string.format(
				"\tNTD.AddSetSpeed(%d, %.1f) -- Speed %dx +%.1fs",
				op.speed, e, op.speed, e))
		elseif op.type == "towerability" then
			if op.order then
				table.insert(fullLines, string.format(
					'\tNTD.AddTowerAbility(%d, "%s", %.1f) -- #%d +%.1fs',
					op.order, op.abilityName, e, op.order, e))
			else
				table.insert(fullLines, string.format(
					'\t-- WARN: towerability untracked tower [ID:%s] %s +%.1fs',
					tostring(op.gameId), op.abilityName, e))
			end
		end
	end

	table.insert(fullLines, "")
	if gameEndElapsed then
		local rawE = gameEndElapsed
		local e = timeRoundUp and (math.ceil(rawE * 10) / 10) or (math.floor(rawE * 10) / 10)
		table.insert(fullLines, string.format("\tNTD.AddEnd(%.1f) -- Time %02d:%02d", e, math.floor(e / 60), math.floor(e % 60)))
	end
	table.insert(fullLines, "\tNTD.ExecuteQueue()")
	table.insert(fullLines, '\tprint("[NTD] Queue loaded, waiting for game start...")')
	table.insert(fullLines, "end")

	local fullScriptContent = table.concat(fullLines, "\n")

	local script = {}
	table.insert(script, "--[[")
	table.insert(script, "")
	table.insert(script, "Make Script By: Place Tracker")
	table.insert(script, "loadstring(game:HttpGet('https://raw.githubusercontent.com/Tseting-nil/Noob-Tower-Defense/refs/heads/main/Tool/%E6%94%BE%E7%BD%AE%E8%BF%BD%E8%B9%A4%E5%99%A8.lua'))()")
	table.insert(script, "")
	table.insert(script, 'How to use Place Tracker: USE "IN-Game not lobby" to make a Script')
	table.insert(script, "!!!! Reload your script after key verification is successful !!!!")
	table.insert(script, "")
	table.insert(script, string.format("Map: %s  |  Difficulty: %s  |  Modifier: %s", gameSettings.mapId, gameSettings.difficulty, gameSettings.modifier))
	if gameEndElapsed then
		local mins = math.floor(gameEndElapsed / 60)
		local secs = math.floor(gameEndElapsed % 60)
		table.insert(script, string.format("Time: %dm %ds (%.1fs)", mins, secs, gameEndElapsed))
	end
	table.insert(script, "")
	if #usedTowers > 0 then
		table.insert(script, "Towers used:")
		for _, name in ipairs(usedTowers) do
			table.insert(script, string.format("  - %s", name))
		end
		table.insert(script, "")
	end
	table.insert(script, "]]")
	table.insert(script, "")
	table.insert(script, "-- ========== FULL SCRIPT ==========")
	table.insert(script, "local fullScript = [=[")
	table.insert(script, fullScriptContent)
	table.insert(script, "]=" .. "]")
	table.insert(script, "")
	table.insert(script, "-- ========== Start ==========")
	table.insert(script, "local NTD = getgenv().NTD")
	table.insert(script, "if not NTD then")
	table.insert(script, string.format('    loadstring(game:HttpGet("%s"))()', NTD_API_URL))
	table.insert(script, "    NTD = getgenv().NTD")
	table.insert(script, "end")
	table.insert(script, "")
	table.insert(script, "NTD.SaveLocalScript(fullScript)")
	table.insert(script, "loadstring(fullScript)()")

	return table.concat(script, "\n")
end

-- ============================================================
-- 按鈕事件
-- ============================================================
copyBtn.MouseButton1Click:Connect(function()
	local s = generateScript()
	if s then
		local ok = pcall(setclipboard, s)
		if ok then
			addLog(T("logCopyOk"), Color3.fromRGB(100, 255, 100))
			copyBtn.Text = T("btnCopied")
			copyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
			print("\n========== 生成的排程腳本 ==========")
			print(s)
			print("=====================================\n")
			task.wait(2)
			copyBtn.Text = T("btnCopy")
			copyBtn.BackgroundColor3 = Theme.Success
		else
			addLog(T("logCopyConsole"), Theme.Warning)
			print(s)
		end
	end
end)

saveBtn.MouseButton1Click:Connect(openSavePanel)

confirmSaveBtn.MouseButton1Click:Connect(function()
	local fileName = fileNameInput.Text:gsub("[^%w_%-]", "_")
	if fileName == "" or fileName:match("^_+$") then
		addLog(T("logInvalidName"), Theme.Warning)
		return
	end
	local s = generateScript()
	if s then
		local ok = saveScriptToFile(fileName, s)
		if ok then saveFrame.Visible = false end
	end
end)

cancelSaveBtn.MouseButton1Click:Connect(function() saveFrame.Visible = false end)
saveCloseBtn.MouseButton1Click:Connect(function() saveFrame.Visible = false end)
manageCloseBtn.MouseButton1Click:Connect(function() manageFrame.Visible = false end)
closeBtn.MouseButton1Click:Connect(function() parameterFrame.Visible = false end)
refreshScriptsBtn.MouseButton1Click:Connect(function() refreshScriptList() end)

Parameter.MouseButton1Click:Connect(function()
	if not parameterFrame.Visible then
		closeAllPanels()
		parameterFrame.Position = UDim2.new(
			mainFrame.Position.X.Scale, mainFrame.Position.X.Offset + mainFrame.AbsoluteSize.X + 10,
			mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset)
	end
	parameterFrame.Visible = not parameterFrame.Visible
end)

resetBtn.MouseButton1Click:Connect(function()
	nextOrder = 1
	orderToInfo = {}
	idToOrder = {}
	upgradeLog = {}
	sellLog = {}
	skipWaveLog = {}
	speedChangeLog = {}
	abilityLog = {}
	lastDetectedSpeed = 1
	isGameRunning = false
	gameStartTime = nil
	gameEndElapsed = nil

	pcall(function()
		local Values = ReplicatedStorage:WaitForChild("Values", 3)
		if Values then
			gameSettings.mapId      = Values:FindFirstChild("Map")      and Values.Map.Value      or "Unknown"
			gameSettings.difficulty = Values:FindFirstChild("Gamemode") and Values.Gamemode.Value or "Unknown"
		end
	end)

	for _, child in pairs(scrollFrame:GetChildren()) do child:Destroy() end
	listLayout:Destroy()
	listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 8)
	listLayout.Parent = scrollFrame
	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
	end)
	logOrder = 1

	updateInfoLabel()
	addLog(T("logReset"), Color3.fromRGB(100, 200, 255))
end)

debugBtn.MouseButton1Click:Connect(function()
	addLog(T("logTowerListHdr"), Color3.fromRGB(100, 200, 255))
	if nextOrder <= 1 then
		addLog(T("logNoRecord"), Theme.TextDim)
	else
		for order = 1, nextOrder - 1 do
			local info = orderToInfo[order]
			if info then
				addLog(T("logTowerItem"):format(info.order, info.UnitType, tostring(info.GameID), info.Elapsed or 0),
					Color3.fromRGB(200, 200, 200))
			end
		end
	end
end)

-- F8 切換顯示
UserInputService.InputBegan:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.F8 and not gp then
		uiVisible = not uiVisible
		mainFrame.Visible = uiVisible
		if not uiVisible then closeAllPanels() end
	end
end)

-- 全局點擊關閉下拉選單
UserInputService.InputBegan:Connect(function(input, gp)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	if gp then return end
	if currentOpenDropdownList and currentOpenDropdownList.Visible then
		local mp = UserInputService:GetMouseLocation()
		local lp = currentOpenDropdownList.AbsolutePosition
		local ls = currentOpenDropdownList.AbsoluteSize
		if not (mp.X >= lp.X and mp.X <= lp.X + ls.X and mp.Y >= lp.Y and mp.Y <= lp.Y + ls.Y) then
			currentOpenDropdownList.Visible = false
			currentOpenDropdownList = nil
		end
	end
end)

-- ============================================================
-- hookmetamethod — 追蹤遊戲操作
-- ============================================================
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
	local method = getnamecallmethod()
	local args = { ... }

	-- === 放置塔 (InvokeServer) ===
	if method == "InvokeServer" and PlaceTowerRemote and self == PlaceTowerRemote then
		local placeArgs = args[1]
		local towerName = (type(placeArgs) == "table" and placeArgs.towerToPlace) or "Unknown"
		local targetPos = (type(placeArgs) == "table" and placeArgs.position) or nil

		local result = oldNamecall(self, ...)

		task.spawn(function()
			local elapsed = getElapsed()

			if type(result) == "table" and result.id then
				local info = {
					order       = nextOrder,
					name        = towerName,
					id          = result.id,
					position    = targetPos,
					Index       = nextOrder,
					UnitType    = towerName,
					DisplayName = towerName,
					Position    = targetPos,
					GameID      = result.id,
					Rotation    = 0,
					Elapsed     = elapsed,
				}
				orderToInfo[nextOrder] = info
				idToOrder[result.id]   = nextOrder
				addLog(T("logPlaceTower"):format(nextOrder, towerName, elapsed), Color3.fromRGB(100, 255, 100))
				if DEBUG_MODE then
					print(string.format("[NTD Tracker] 放置 #%d %s id=%s +%.1fs",
						nextOrder, towerName, tostring(result.id), elapsed))
				end
				nextOrder = nextOrder + 1
			else
				addLog(T("logPlaceFailed"):format(towerName), Theme.Warning)
			end
		end)

		return result
	end

	-- === 升級塔 (InvokeServer) ===
	if method == "InvokeServer" and UpgradeTowerRemote and self == UpgradeTowerRemote then
		local idStr   = args[1]
		local towerId = tonumber(idStr)

		local result = oldNamecall(self, ...)

		task.spawn(function()
			if result ~= true then return end

			local order   = towerId and idToOrder[towerId]
			local info    = order and orderToInfo[order]
			local elapsed = getElapsed()

			table.insert(upgradeLog, {
				gameId  = towerId,
				order   = order,
				elapsed = elapsed,
			})

			if info then
				addLog(T("logUpgrade"):format(info.order, info.UnitType, elapsed), Color3.fromRGB(255, 255, 100))
				if DEBUG_MODE then
					print(string.format("[NTD Tracker] 升級 #%d %s id=%s +%.1fs",
						info.order, info.UnitType, idStr, elapsed))
				end
			else
				addLog(T("logUpgradeUnknown"):format(idStr, elapsed), Color3.fromRGB(255, 200, 100))
			end
		end)

		return result
	end

	-- === 刪除塔 (InvokeServer) ===
	if method == "InvokeServer" and SellTowerRemote and self == SellTowerRemote then
		local idStr   = args[1]
		local towerId = tonumber(idStr)

		local result = oldNamecall(self, ...)

		task.spawn(function()
			if result ~= true then return end

			local order   = towerId and idToOrder[towerId]
			local info    = order and orderToInfo[order]
			local elapsed = getElapsed()

			table.insert(sellLog, {
				gameId  = towerId,
				order   = order,
				elapsed = elapsed,
			})

			if info then
				addLog(T("logSell"):format(info.order, info.UnitType, elapsed), Color3.fromRGB(255, 100, 100))
				if DEBUG_MODE then
					print(string.format("[NTD Tracker] 刪除 #%d %s id=%s +%.1fs",
						info.order, info.UnitType, idStr, elapsed))
				end
			else
				addLog(T("logSellUnknown"):format(idStr, elapsed), Color3.fromRGB(255, 100, 100))
			end
		end)

		return result
	end

	-- === Ready (FireServer) ===
	if method == "FireServer" and ReadyRemote and self == ReadyRemote then
		addLog(T("logReady"), Color3.fromRGB(255, 200, 100))
		return oldNamecall(self, ...)
	end

	-- === 跳過波次 (FireServer) ===
	if method == "FireServer" and SkipWaveRemote and self == SkipWaveRemote then
		local elapsed = getElapsed()
		table.insert(skipWaveLog, { elapsed = elapsed })
		addLog(T("logSkipWave"):format(elapsed), Color3.fromRGB(150, 150, 255))
		return oldNamecall(self, ...)
	end

	-- === 速度設定 (FireServer) ===
	if method == "FireServer" and GameSpeedRemote and self == GameSpeedRemote then
		local speed = args[1] or 1
		local elapsed = getElapsed()
		if speed ~= lastDetectedSpeed then
			table.insert(speedChangeLog, { speed = speed, elapsed = elapsed })
			addLog(T("logSpeedSet"):format(speed, elapsed), Color3.fromRGB(255, 200, 150))
			lastDetectedSpeed = speed
		end
		return oldNamecall(self, ...)
	end

	-- === 塔能力 (InvokeServer) ===
	if method == "InvokeServer" and TowerAbilityRemote and self == TowerAbilityRemote then
		local idStr       = args[1]
		local abilityName = args[2] or "Unknown"
		local towerId     = tonumber(idStr)

		local result = oldNamecall(self, ...)

		task.spawn(function()
			local order   = towerId and idToOrder[towerId]
			local info    = order and orderToInfo[order]
			local elapsed = getElapsed()

			table.insert(abilityLog, {
				gameId      = towerId,
				order       = order,
				abilityName = abilityName,
				elapsed     = elapsed,
			})

			if info then
				addLog(T("logAbility"):format(info.order, info.UnitType, abilityName, elapsed), Color3.fromRGB(180, 100, 255))
				if DEBUG_MODE then
					print(string.format("[NTD Tracker] 塔能力 #%d %s %s id=%s +%.1fs",
						info.order, info.UnitType, abilityName, idStr, elapsed))
				end
			else
				addLog(T("logAbilityUnknown"):format(idStr, abilityName, elapsed), Color3.fromRGB(180, 100, 255))
			end
		end)

		return result
	end

	-- === 難易度設定 (FireServer) ===
	if method == "FireServer" and GamemodeRemote and self == GamemodeRemote then
		local difficulty = args[1] or "Unknown"
		gameSettings.difficulty = difficulty

		gameStartTime  = tick()
		isGameRunning  = true

		addLog(T("logDiffStart"):format(difficulty), Color3.fromRGB(100, 255, 100))
		updateInfoLabel()
		return oldNamecall(self, ...)
	end

	return oldNamecall(self, ...)
end)

-- ============================================================
-- 初始化追蹤系統
-- ============================================================
local function InitTracker()
	print("[NTD Tracker] 初始化中...")
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Tseting-nil/Noob-Tower-Defense/refs/heads/main/Tool/%E5%A1%94%E8%83%BD%E5%8A%9B%E4%BB%8B%E9%9D%A2.lua"))()
	local ok, err = pcall(function()
		local Remotes   = ReplicatedStorage:WaitForChild("Remotes",  10)
		local Functions = Remotes:WaitForChild("Functions",          10)
		local Events    = Remotes:WaitForChild("Events",             10)
		local Values    = ReplicatedStorage:WaitForChild("Values",   10)

		PlaceTowerRemote   = Functions:WaitForChild("PlaceTower",      10)
		UpgradeTowerRemote = Functions:WaitForChild("UpgradeTower",    10)
		SellTowerRemote    = Functions:WaitForChild("SellTower",       10)
		TowerAbilityRemote = Functions:WaitForChild("TowerAbility",    10)
		SkipWaveRemote     = Events:WaitForChild("SkipWave",           10)
		GameSpeedRemote    = Events:WaitForChild("InitChangeSpeed",    10)
		GamemodeRemote     = Events:WaitForChild("Gamemode",           10)
		ReadyRemote        = Events:WaitForChild("Ready",              10)
		GameRunningValue   = Values:WaitForChild("GameRunning",        10)

		gameSettings.mapId = Values:FindFirstChild("Map") and Values.Map.Value or "Unknown"

		local GamemodeValue = Values:FindFirstChild("Gamemode")
		if GamemodeValue then
			gameSettings.difficulty = GamemodeValue.Value
			GamemodeValue.Changed:Connect(function(v)
				if gameSettings.difficulty ~= v then
					gameSettings.difficulty = v
					addLog(T("logDiffUpdate"):format(v), Color3.fromRGB(200, 150, 255))
					updateInfoLabel()
				end
			end)
		end

		local ModifiersFolder = Values:FindFirstChild("Modifiers")
		if ModifiersFolder then
			local function updateModifier()
				local children = ModifiersFolder:GetChildren()
				if #children == 0 then
					gameSettings.modifier = "None"
				else
					local names = {}
					for _, child in ipairs(children) do
						table.insert(names, child.Name)
					end
					gameSettings.modifier = table.concat(names, ", ")
				end
				updateInfoLabel()
			end
			updateModifier()
			ModifiersFolder.ChildAdded:Connect(function(child)
				updateModifier()
				addLog(T("logModAdd"):format(child.Name), Color3.fromRGB(255, 180, 80))
			end)
			ModifiersFolder.ChildRemoved:Connect(function(child)
				updateModifier()
				addLog(T("logModRemove"):format(child.Name, gameSettings.modifier), Color3.fromRGB(180, 180, 180))
			end)
		end
	end)

	if not ok then
		warn("[NTD Tracker] 初始化失敗:", err)
		addLog(T("logInitFailed"), Theme.Error)
		return false
	end

	updateInfoLabel()

	addLog(T("logWaitReady"), Color3.fromRGB(255, 200, 100))
	addLog(T("logFlow"), Color3.fromRGB(180, 180, 255))

	GameRunningValue.Changed:Connect(function(v)
		if v == false and isGameRunning then
			local endElapsed = getElapsed()
			gameEndElapsed = endElapsed
			isGameRunning = false
			gameStartTime = nil
			local mins = math.floor(endElapsed / 60)
			local secs = math.floor(endElapsed % 60)
			addLog(T("logGameEnd"):format(mins, secs, endElapsed), Color3.fromRGB(255, 255, 100))
		end
	end)

	addLog(T("logStarted"):format(gameSettings.mapId, gameSettings.difficulty, gameSettings.modifier), Color3.fromRGB(100, 255, 100))
	print("[NTD Tracker] ✅ 初始化完成")
	return true
end

-- ============================================================

InitTracker()
