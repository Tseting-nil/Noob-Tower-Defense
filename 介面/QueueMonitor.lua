-- ============================================================
--                 新手塔房 | 佇列監視器 GUI (Queue Monitor)
-- ============================================================
-- 說明：此腳本為獨立工具，透過讀取 NTD.Scripttable.queue 的資料，
--       並掛鉤 NTD.ExecuteQueue 與 Mainfunction.ExecuteOperation 等函數，
--       在不破壞/修改原先重播核心邏輯的前提下，為使用者提供一個美觀且
--       可即時追蹤進度的佇列監視 GUI。
-- ============================================================

local Scripttable, Mainfunction = ...

-- === i18n 國際化設定 ===
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
					if lang == "ENGLISH" then
						currentLang = "en"
					end
				end
			end
		end
	end)
end

local i18n = {
	zh = {
		warn_no_api = "[NTD Monitor] ❌ 找不到 NTD API，無法啟動監視器！",
		default_tower = "塔 #%d",
		title = "新手塔房 | 佇列監視器",
		progress_wait = "進度：等待佇列啟動...",
		op_place = "放置 %s (#%d)",
		op_upgrade = "升級 %s (#%d)",
		op_sell = "售出 %s (#%d)",
		op_ability = "塔能力 %s (#%d)",
		op_gamesetting = "設定 %s：%s",
		op_mapwait = "等待地圖變更 (%s)",
		op_skipwave = "手動跳波",
		op_speed = "設定速度：%dx",
		op_end = "結束標記",
		gate_completed = "已完成",
		gate_failed = "失敗",
		gate_running = "執行中...",
		game_victory = "已結束 (勝利)",
		game_defeat = "已結束 (失敗)",
		game_unknown = "已結束 (未知)",
		time_countdown = "倒數：%.1fs",
		time_elapsed = "時間：%.1fs",
		summary_format = "進度：%d/%d (%.1f%%) | %s | 金幣：$%s",
		queue_empty = "佇列為空，請載入腳本...",
		log_new_game = "[NTD Monitor] 🔄 偵測到新對局開始 (GameStartTime 改變)，重置佇列狀態！",
		log_game_ended = "[NTD Monitor] ℹ️ 對局結束或回到大廳，重置佇列狀態",
		log_started = "[NTD Monitor] ✅ 佇列監視器啟動完成，已成功掛鉤所有動作函數！",
	},
	en = {
		warn_no_api = "[NTD Monitor] ❌ Cannot find NTD API, failed to start monitor!",
		default_tower = "Tower #%d",
		title = "Newbie TD | Queue Monitor",
		progress_wait = "Progress: Waiting for queue...",
		op_place = "Place %s (#%d)",
		op_upgrade = "Upgrade %s (#%d)",
		op_sell = "Sell %s (#%d)",
		op_ability = "Ability %s (#%d)",
		op_gamesetting = "Setting %s: %s",
		op_mapwait = "Wait Map (%s)",
		op_skipwave = "Manual Skip Wave",
		op_speed = "Set Speed: %dx",
		op_end = "End Marker",
		gate_completed = "Completed",
		gate_failed = "Failed",
		gate_running = "Running...",
		game_victory = "Finished (Victory)",
		game_defeat = "Finished (Defeat)",
		game_unknown = "Finished (Unknown)",
		time_countdown = "Countdown: %.1fs",
		time_elapsed = "Time: %.1fs",
		summary_format = "Progress: %d/%d (%.1f%%) | %s | Coins: $%s",
		queue_empty = "Queue is empty, please load script...",
		log_new_game = "[NTD Monitor] 🔄 New game detected (GameStartTime changed), resetting queue status!",
		log_game_ended = "[NTD Monitor] ℹ️ Game ended or back to lobby, resetting queue status",
		log_started = "[NTD Monitor] ✅ Queue monitor started, successfully hooked all actions!",
	}
}

local L = i18n[currentLang] or i18n.zh

-- 1. 偵測並等待 NTD API 載入完成
if not Scripttable or not Mainfunction then
	repeat task.wait(0.5) until getgenv().NTD and getgenv().NTDAPI
	local NTD = getgenv().NTD
	Scripttable = NTD.Scripttable
	Mainfunction = NTD.Mainfunction
end

if not Scripttable or not Mainfunction then
	warn(L.warn_no_api)
	return
end

local function getNTD()
	local NTD = getgenv().NTD
	if NTD and getgenv().NTDAPI then
		return NTD.Scripttable or Scripttable, NTD.Mainfunction or Mainfunction
	end
	return Scripttable, Mainfunction
end

-- ============================================================
-- 服務與常數定義
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer

-- === UI 主題 ===
local Theme = {
	Background = Color3.fromRGB(25, 27, 30),
	Surface = Color3.fromRGB(35, 38, 42),
	SurfaceHighlight = Color3.fromRGB(45, 48, 52),
	Border = Color3.fromRGB(60, 65, 70),
	Text = Color3.fromRGB(230, 230, 230),
	TextDim = Color3.fromRGB(150, 150, 150),
	TextDark = Color3.fromRGB(20, 20, 20),
	Accent = Color3.fromRGB(60, 160, 255),       -- 亮藍 (Running)
	Success = Color3.fromRGB(100, 220, 120),     -- 綠色 (Completed)
	SuccessBg = Color3.fromRGB(25, 45, 30),
	Warning = Color3.fromRGB(255, 180, 60),      -- 橘色
	Error = Color3.fromRGB(255, 80, 80),         -- 紅色 (Failed)
	ErrorBg = Color3.fromRGB(45, 25, 25),
	CornerRadius = UDim.new(0, 8),
	Font = Enum.Font.GothamMedium,
	FontBold = Enum.Font.GothamBold,
}

-- === 執行狀態變數 ===
local current_index = 1
local uiRows = {}
local autoScrollEnabled = true
local isMinimized = false

-- ============================================================
-- 輔助函式：計時與讀錢
-- ============================================================
local function formatNumber(amount)
	local formatted = tostring(amount)
	while true do
		local k
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if k == 0 then break end
	end
	return formatted
end

local function readCash()
	local Scripttable, Mainfunction = getNTD()
	if Mainfunction and Mainfunction.GetMoney then
		local money = Mainfunction.GetMoney()
		if money then return money end
	end
	local ok, cash = pcall(function()
		local leaderstats = localPlayer:FindFirstChild("leaderstats")
		local cNode = leaderstats and (leaderstats:FindFirstChild("Coins") or leaderstats:FindFirstChild("Cash"))
		if not cNode then return 0 end
		return tonumber(cNode.Value) or 0
	end)
	return ok and cash or 0
end

local function getElapsed()
	local NTD = getgenv().NTD
	if NTD and getgenv().NTDAPI then
		local ok, el = pcall(function() return NTD.GetQueueElapsed() end)
		if ok and el then return el end
	end
	local gst = workspace:GetAttribute("GameStartTime")
	if type(gst) == "number" and gst > 0 then
		return workspace:GetServerTimeNow() - gst
	end
	return 0
end

-- 依 order 尋找對應放置塔的顯示名稱
local function getTowerNameForOrder(order)
	if not order then return "Unknown" end
	local Scripttable, Mainfunction = getNTD()
	
	-- 複製佇列並依據 API 原生 SortQueue 邏輯排序，以確保靜態映射到正確的 place 動作
	local tempQueue = {}
	for i, op in ipairs(Scripttable.queue) do
		local opCopy = {
			type = op.type,
			phase = op.phase,
			elapsed = op.elapsed,
			unitType = op.unitType,
			_seq = i
		}
		table.insert(tempQueue, opCopy)
	end
	
	local hasCostGate = false
	for _, op in ipairs(tempQueue) do
		if type(op.elapsed) == "string" then hasCostGate = true; break end
	end
	table.sort(tempQueue, function(a, b)
		local ap = a.phase or 1
		local bp = b.phase or 1
		if ap ~= bp then return ap < bp end
		if hasCostGate then
			return a._seq < b._seq
		end
		return a.elapsed < b.elapsed
	end)
	
	local placeCount = 0
	for _, op in ipairs(tempQueue) do
		if op.type == "place" then
			placeCount = placeCount + 1
			if placeCount == order then
				return op.unitType
			end
		end
	end
	
	return string.format(L.default_tower, order)
end

-- ============================================================
-- 狀態管理與進度更新
-- ============================================================
local function resetStatuses()
	local Scripttable, Mainfunction = getNTD()
	current_index = 1
	for _, op in ipairs(Scripttable.queue) do
		op.status = "pending"
	end

	for idx, op in ipairs(Scripttable.queue) do
		op.status = "running"
		current_index = idx
		break
	end
end

-- 熱重載或中途開啟時的狀態自癒恢復機制
local function syncRunningQueue()
	local Scripttable, Mainfunction = getNTD()
	for _, op in ipairs(Scripttable.queue) do
		op.status = "pending"
	end

	-- 尋找最後一個已被確認綁定 (已放置) 的 order
	local place_count = 0
	local max_completed_idx = 0
	for idx, op in ipairs(Scripttable.queue) do
		if op.type == "place" then
			place_count = place_count + 1
			if Scripttable.orderToId and Scripttable.orderToId[place_count] then
				op.status = "completed"
				max_completed_idx = idx
			end
		end
	end

	-- 將此索引之前的所有項目標記為 completed
	for i = 1, max_completed_idx do
		local op = Scripttable.queue[i]
		op.status = "completed"
	end

	-- 設定下一個順序項為 running
	current_index = max_completed_idx + 1
	local found_running = false
	for i = current_index, #Scripttable.queue do
		local op = Scripttable.queue[i]
		op.status = "running"
		current_index = i
		found_running = true
		break
	end
	if not found_running then
		current_index = #Scripttable.queue + 1
	end
end

-- ============================================================
-- GUI 界面建立與佈局
-- ============================================================
local guiParent = get_hidden_gui or gethui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NTDQueueMonitorUI"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = guiParent and guiParent() or game:GetService("CoreGui")

-- 確保只保留一個 UI 實例
local oldUI = screenGui.Parent:FindFirstChild(screenGui.Name)
if oldUI and oldUI ~= screenGui then
	oldUI:Destroy()
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 330, 0, 420)
mainFrame.Position = UDim2.new(0.72, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Theme.Background
mainFrame.BackgroundTransparency = 0.05
mainFrame.Active = true
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

do
	local c = Instance.new("UICorner")
	c.CornerRadius = Theme.CornerRadius
	c.Parent = mainFrame
end
do
	local s = Instance.new("UIStroke")
	s.Thickness = 1.5
	s.Color = Theme.Border
	s.Transparency = 0.2
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = mainFrame
end

-- === 標題欄 ===
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Theme.Surface
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
titleBar.Name = "TitleBar"

do
	local c = Instance.new("UICorner")
	c.CornerRadius = Theme.CornerRadius
	c.Parent = titleBar
end

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
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = L.title
title.Parent = titleBar

-- === 拖拽功能實作 ===
local dragging = false
local dragStart = nil
local startPos = nil
local dragConn = nil

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = UserInputService:GetMouseLocation()
		startPos = mainFrame.Position
		if not dragConn then
			dragConn = RunService.RenderStepped:Connect(function()
				if not dragging then return end
				local delta = UserInputService:GetMouseLocation() - dragStart
				mainFrame.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)
			end)
		end
	end
end)

titleBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
		if dragConn then
			dragConn:Disconnect()
			dragConn = nil
		end
	end
end)

-- === 展開 / 折疊 按鈕 ===
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -75, 0, 7)
minimizeBtn.BackgroundColor3 = Theme.SurfaceHighlight
minimizeBtn.TextColor3 = Theme.Text
minimizeBtn.Font = Theme.FontBold
minimizeBtn.TextSize = 14
minimizeBtn.Text = "[-]"
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar
do
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 6)
	c.Parent = minimizeBtn
end

-- === 關閉 按鈕 ===
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
closeBtn.TextColor3 = Theme.Text
closeBtn.Font = Theme.FontBold
closeBtn.TextSize = 14
closeBtn.Text = "X"
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar
do
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 6)
	c.Parent = closeBtn
end

closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- === 滾動容器 ===
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -16, 1, -85)
scrollFrame.Position = UDim2.new(0, 8, 0, 50)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 4
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarImageColor3 = Theme.Border
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = scrollFrame

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 5)
end)

-- === 狀態摘要欄 ===
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0, 30)
statusBar.Position = UDim2.new(0, 0, 1, -30)
statusBar.BackgroundColor3 = Theme.Surface
statusBar.BorderSizePixel = 0
statusBar.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 1, 0)
statusLabel.Position = UDim2.new(0, 10, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Theme.TextDim
statusLabel.Font = Theme.Font
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Text = L.progress_wait
statusLabel.Parent = statusBar

-- 自動折疊與展開處理
minimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		mainFrame.Size = UDim2.new(0, 330, 0, 45)
		scrollFrame.Visible = false
		statusBar.Visible = false
		minimizeBtn.Text = "[+]"
	else
		mainFrame.Size = UDim2.new(0, 330, 0, 420)
		scrollFrame.Visible = true
		statusBar.Visible = true
		minimizeBtn.Text = "[-]"
	end
end)

-- ============================================================
-- UI 渲染生成器
-- ============================================================
local function initUIList()
	local Scripttable, Mainfunction = getNTD()
	-- 清空既有項目
	for _, row in pairs(uiRows) do
		row:Destroy()
	end
	uiRows = {}

	local queue = Scripttable.queue or {}
	for idx, op in ipairs(queue) do
		local rowFrame = Instance.new("Frame")
		rowFrame.Size = UDim2.new(1, -4, 0, 38)
		rowFrame.BackgroundColor3 = Theme.Surface
		rowFrame.BorderSizePixel = 0
		rowFrame.LayoutOrder = idx
		rowFrame.Parent = scrollFrame

		local rowCorner = Instance.new("UICorner")
		rowCorner.CornerRadius = UDim.new(0, 5)
		rowCorner.Parent = rowFrame

		local rowStroke = Instance.new("UIStroke")
		rowStroke.Thickness = 1
		rowStroke.Color = Theme.Border
		rowStroke.Transparency = 0.5
		rowStroke.Parent = rowFrame

		-- 狀態符號 (Icon)
		local iconLbl = Instance.new("TextLabel")
		iconLbl.Size = UDim2.new(0, 25, 1, 0)
		iconLbl.Position = UDim2.new(0, 6, 0, 0)
		iconLbl.BackgroundTransparency = 1
		iconLbl.TextColor3 = Theme.Text
		iconLbl.Font = Theme.FontBold
		iconLbl.TextSize = 14
		iconLbl.Text = "⏳"
		iconLbl.Parent = rowFrame
		iconLbl.Name = "Icon"

		-- 操作詳情 (Text)
		local detailLbl = Instance.new("TextLabel")
		detailLbl.Size = UDim2.new(1, -120, 1, 0)
		detailLbl.Position = UDim2.new(0, 36, 0, 0)
		detailLbl.BackgroundTransparency = 1
		detailLbl.TextColor3 = Theme.Text
		detailLbl.Font = Theme.Font
		detailLbl.TextSize = 13
		detailLbl.TextXAlignment = Enum.TextXAlignment.Left
		detailLbl.TextTruncate = Enum.TextTruncate.AtEnd
		detailLbl.Parent = rowFrame
		detailLbl.Name = "Detail"

		-- 建立各類型靜態文字
		local detailStr = ""
		if op.type == "place" then
			-- 新手塔房順序是執行期排的，反查其 order 為 sorted 順序
			local placeIdx = 0
			for _, tempOp in ipairs(queue) do
				if tempOp.type == "place" then
					placeIdx = placeIdx + 1
					if tempOp == op then break end
				end
			end
			detailStr = string.format(L.op_place, op.unitType, placeIdx)
		elseif op.type == "upgrade" then
			local tName = getTowerNameForOrder(op.order)
			detailStr = string.format(L.op_upgrade, tName, op.order)
		elseif op.type == "sell" then
			local tName = getTowerNameForOrder(op.order)
			detailStr = string.format(L.op_sell, tName, op.order)
		elseif op.type == "towerability" then
			local tName = getTowerNameForOrder(op.order)
			detailStr = string.format(L.op_ability, tName, op.order)
		elseif op.type == "skipwave" then
			detailStr = L.op_skipwave
		elseif op.type == "speed" then
			detailStr = string.format(L.op_speed, op.speed)
		elseif op.type == "gamesetting" then
			detailStr = string.format(L.op_gamesetting, op.settingName, tostring(op.value))
		elseif op.type == "mapWait" then
			detailStr = string.format(L.op_mapwait, op.name or "---")
		elseif op.type == "end" then
			detailStr = L.op_end
		else
			detailStr = tostring(op.type)
		end
		detailLbl.Text = string.format("#%d %s", idx, detailStr)

		-- 閘門條件 / 進度顯示 (Gate/Progress)
		local gateLbl = Instance.new("TextLabel")
		gateLbl.Size = UDim2.new(0, 80, 1, 0)
		gateLbl.Position = UDim2.new(1, -85, 0, 0)
		gateLbl.BackgroundTransparency = 1
		gateLbl.TextColor3 = Theme.TextDim
		gateLbl.Font = Theme.Font
		gateLbl.TextSize = 11
		gateLbl.TextXAlignment = Enum.TextXAlignment.Right
		gateLbl.Parent = rowFrame
		gateLbl.Name = "Gate"

		uiRows[idx] = rowFrame
	end
end

-- ============================================================
-- UI 自動滾動聚焦
-- ============================================================
local function scrollToActiveOp()
	if not autoScrollEnabled or isMinimized then return end
	local activeRow = uiRows[current_index]
	if activeRow and scrollFrame then
		pcall(function()
			local relativeY = activeRow.AbsolutePosition.Y - scrollFrame.AbsolutePosition.Y + scrollFrame.CanvasPosition.Y
			local frameHeight = scrollFrame.AbsoluteSize.Y
			local targetY = relativeY - (frameHeight / 2)
			targetY = math.clamp(targetY, 0, scrollFrame.CanvasSize.Y.Offset)
			
			TweenService:Create(scrollFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				CanvasPosition = Vector2.new(0, targetY)
			}):Play()
		end)
	end
end

-- ============================================================
-- UI 定時更新循環 (1秒多次更新)
-- ============================================================
local function updateUIList()
	local Scripttable, Mainfunction = getNTD()
	local queue = Scripttable.queue or {}
	if #uiRows ~= #queue then
		initUIList()
	end

	local completedCount = 0
	local elapsed = getElapsed()
	local cash = readCash()

	for idx, op in ipairs(queue) do
		local row = uiRows[idx]
		if row then
			local icon = row:FindFirstChild("Icon")
			local detail = row:FindFirstChild("Detail")
			local gate = row:FindFirstChild("Gate")
			local stroke = row:FindFirstChild("UIStroke")

			local status = op.status or "pending"

			-- 根據狀態更新顏色與圖示
			if status == "completed" then
				completedCount = completedCount + 1
				row.BackgroundColor3 = Theme.SuccessBg
				if icon then icon.Text = "✅" icon.TextColor3 = Theme.Success end
				if detail then detail.TextColor3 = Theme.Text end
				if gate then gate.Text = L.gate_completed gate.TextColor3 = Theme.Success end
				if stroke then stroke.Color = Theme.Success stroke.Transparency = 0.6 end
			elseif status == "failed" then
				row.BackgroundColor3 = Theme.ErrorBg
				if icon then icon.Text = "❌" icon.TextColor3 = Theme.Error end
				if detail then detail.TextColor3 = Theme.Text end
				if gate then gate.Text = L.gate_failed gate.TextColor3 = Theme.Error end
				if stroke then stroke.Color = Theme.Error stroke.Transparency = 0.6 end
			elseif status == "running" then
				row.BackgroundColor3 = Theme.SurfaceHighlight
				if icon then icon.Text = "▶️" icon.TextColor3 = Theme.Accent end
				if detail then detail.TextColor3 = Theme.Accent end
				if stroke then stroke.Color = Theme.Accent stroke.Transparency = 0.3 end

				-- 即時閘門進度計算
				local gateText = ""
				if type(op.elapsed) == "number" then
					local targetTime = op.elapsed
					gateText = string.format("%.1fs / %.1fs", elapsed, targetTime)
				elseif type(op.elapsed) == "string" then
					local targetCash = tonumber((op.elapsed:gsub("[^%d%-]", ""))) or 0
					gateText = string.format("$%d / $%d", cash, targetCash)
				else
					gateText = L.gate_running
				end
				if gate then gate.Text = gateText gate.TextColor3 = Theme.Accent end
			else -- pending
				row.BackgroundColor3 = Theme.Surface
				if icon then icon.Text = "⏳" icon.TextColor3 = Theme.TextDim end
				if detail then detail.TextColor3 = Theme.TextDim end
				if stroke then stroke.Color = Theme.Border stroke.Transparency = 0.8 end

				-- 顯示設定的靜態閘門條件
				local gateText = ""
				if type(op.elapsed) == "number" then
					gateText = string.format("[⏳ %.1fs]", op.elapsed)
				elseif type(op.elapsed) == "string" then
					gateText = "[$" .. op.elapsed .. "]"
				end
				if gate then gate.Text = gateText gate.TextColor3 = Theme.TextDim end
			end
		end
	end

	-- 更新摘要
	local total = #queue
	if total > 0 then
		local pct = (completedCount / total) * 100
		
		-- 檢查對局是否結束
		local isOver = false
		local resultText = ""
		local inGame = Mainfunction.IsInGame and Mainfunction.IsInGame()
		local GameRunning = getgenv().NTD and getgenv().NTD.Gametable and getgenv().NTD.Gametable.InGame and getgenv().NTD.Gametable.InGame.GameRunning
		if inGame and GameRunning and not GameRunning.Value then
			isOver = true
			-- 從 UI 的 GameOver 框嘗試讀取勝/敗結果
			local ok, text = pcall(function()
				local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
				local main = playerGui and playerGui:FindFirstChild("UI")
				local gameOver = main and main:FindFirstChild("Game") and main.Game:FindFirstChild("GameOver")
				if gameOver and gameOver.Visible then
					for _, desc in ipairs(gameOver:GetDescendants()) do
						if desc:IsA("TextLabel") and desc.Visible then
							local t = desc.Text:lower()
							if t:find("victory") or t:find("勝利") or t:find("win") then
								return "victory"
							elseif t:find("defeat") or t:find("失敗") or t:find("lost") or t:find("lose") then
								return "defeat"
							end
						end
					end
				end
				return "unknown"
			end)
			local res = ok and text or "unknown"
			if res == "victory" then
				resultText = L.game_victory
			elseif res == "defeat" then
				resultText = L.game_defeat
			else
				resultText = L.game_unknown
			end
		end

		local timeStr = ""
		if isOver then
			timeStr = resultText
		elseif Scripttable.queueEndElapsed then
			local remaining = Scripttable.queueEndElapsed - elapsed
			timeStr = string.format(L.time_countdown, remaining)
		else
			timeStr = string.format(L.time_elapsed, elapsed)
		end
		statusLabel.Text = string.format(L.summary_format, 
			completedCount, total, pct, timeStr, formatNumber(cash))
	else
		statusLabel.Text = L.queue_empty
	end
end

-- ============================================================
-- 掛鉤重播主入口與 API 函數
-- ============================================================
local hookedExecuteQueue = nil
local hookedExecuteOperation = nil
local hookedRawPlaceTower = nil
local hookedRawUpgradeTower = nil
local hookedRawSellTower = nil

local function ensureHooks()
	local Scripttable, Mainfunction = getNTD()
	if not Mainfunction or not Scripttable then return end

	-- 1. 掛鉤 ExecuteQueue：重新啟動佇列時重置狀態
	local NTD = getgenv().NTD
	if NTD and NTD.ExecuteQueue and NTD.ExecuteQueue ~= hookedExecuteQueue then
		local rawExecuteQueue = NTD.ExecuteQueue
		NTD.ExecuteQueue = function(...)
			resetStatuses()
			pcall(updateUIList)
			return rawExecuteQueue(...)
		end
		hookedExecuteQueue = NTD.ExecuteQueue
	end

	-- 2. 掛鉤 ExecuteOperation：即時更新正執行的動作狀態
	if Mainfunction.ExecuteOperation and Mainfunction.ExecuteOperation ~= hookedExecuteOperation then
		local rawExecuteOperation = Mainfunction.ExecuteOperation
		Mainfunction.ExecuteOperation = function(op)
			local Scripttable, Mainfunction = getNTD()
			local idx = nil
			for k, v in ipairs(Scripttable.queue) do
				if v == op then
					idx = k
					break
				end
			end
			if idx then
				current_index = idx
				op.status = "running"
				pcall(updateUIList)
				pcall(scrollToActiveOp)
			end

			local ok, res = pcall(rawExecuteOperation, op)

			if idx then
				-- 非 place, upgrade, sell 的一般操作可直接由執行回傳結果決定
				if op.type ~= "place" and op.type ~= "upgrade" and op.type ~= "sell" then
					op.status = ok and "completed" or "failed"
					current_index = idx + 1
					local nextOp = Scripttable.queue[current_index]
					if nextOp then
						nextOp.status = "running"
					end
					pcall(updateUIList)
					pcall(scrollToActiveOp)
				else
					-- place, upgrade, sell 若立馬成功便可標記完成
					if ok and res ~= false then
						op.status = "completed"
						current_index = idx + 1
						local nextOp = Scripttable.queue[current_index]
						if nextOp then
							nextOp.status = "running"
						end
						pcall(updateUIList)
						pcall(scrollToActiveOp)
					end
				end
			end

			if not ok then
				error(res)
			end
			return res
		end
		hookedExecuteOperation = Mainfunction.ExecuteOperation
	end

	-- 3. 掛鉤底層放置，用以追蹤重試邏輯中的執行狀態
	if Mainfunction.RawPlaceTower and Mainfunction.RawPlaceTower ~= hookedRawPlaceTower then
		local rawPlaceTower = Mainfunction.RawPlaceTower
		Mainfunction.RawPlaceTower = function(...)
			local ok, result = rawPlaceTower(...)
			local Scripttable, Mainfunction = getNTD()
			local op = Scripttable.queue[current_index]
			if op and op.type == "place" then
				if ok then
					op.status = "completed"
					current_index = current_index + 1
					local nextOp = Scripttable.queue[current_index]
					if nextOp then
						nextOp.status = "running"
					end
					pcall(updateUIList)
					pcall(scrollToActiveOp)
				else
					op.status = "failed"
					pcall(updateUIList)
				end
			end
			return ok, result
		end
		hookedRawPlaceTower = Mainfunction.RawPlaceTower
	end

	-- 4. 掛鉤底層升級
	if Mainfunction.RawUpgradeTower and Mainfunction.RawUpgradeTower ~= hookedRawUpgradeTower then
		local rawUpgradeTower = Mainfunction.RawUpgradeTower
		Mainfunction.RawUpgradeTower = function(...)
			local success = rawUpgradeTower(...)
			local Scripttable, Mainfunction = getNTD()
			local op = Scripttable.queue[current_index]
			if op and op.type == "upgrade" then
				if success then
					op.status = "completed"
					current_index = current_index + 1
					local nextOp = Scripttable.queue[current_index]
					if nextOp then
						nextOp.status = "running"
					end
					pcall(updateUIList)
					pcall(scrollToActiveOp)
				else
					op.status = "failed"
					pcall(updateUIList)
				end
			end
			return success
		end
		hookedRawUpgradeTower = Mainfunction.RawUpgradeTower
	end

	-- 5. 掛鉤底層售出
	if Mainfunction.RawSellTower and Mainfunction.RawSellTower ~= hookedRawSellTower then
		local rawSellTower = Mainfunction.RawSellTower
		Mainfunction.RawSellTower = function(...)
			local success = rawSellTower(...)
			local Scripttable, Mainfunction = getNTD()
			local op = Scripttable.queue[current_index]
			if op and op.type == "sell" then
				if success then
					op.status = "completed"
					current_index = current_index + 1
					local nextOp = Scripttable.queue[current_index]
					if nextOp then
						nextOp.status = "running"
					end
					pcall(updateUIList)
					pcall(scrollToActiveOp)
				else
					op.status = "failed"
					pcall(updateUIList)
				end
			end
			return success
		end
		hookedRawSellTower = Mainfunction.RawSellTower
	end
end

-- === 自動重製與新局偵測 ===
local lastGameStart = workspace:GetAttribute("GameStartTime")

local function onGameStartTimeChanged()
	local Scripttable, Mainfunction = getNTD()
	local gst = workspace:GetAttribute("GameStartTime")
	if type(gst) == "number" and gst > 0 then
		if gst ~= lastGameStart then
			lastGameStart = gst
			print(L.log_new_game)
			resetStatuses()
			pcall(updateUIList)
			pcall(scrollToActiveOp)
		end
	else
		if lastGameStart ~= nil then
			lastGameStart = nil
			print(L.log_game_ended)
			resetStatuses()
			pcall(updateUIList)
		end
	end
end

workspace:GetAttributeChangedSignal("GameStartTime"):Connect(onGameStartTimeChanged)

-- 執行掛鉤與同步
ensureHooks()
initUIList()
if getElapsed() > 0 then
	syncRunningQueue()
else
	resetStatuses()
end

-- === UI 刷新與動態掛鉤背景循環 ===
task.spawn(function()
	while screenGui.Parent do
		pcall(ensureHooks)
		pcall(updateUIList)
		task.wait(0.2)
	end
end)

print(L.log_started)
