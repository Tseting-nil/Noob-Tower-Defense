local ReGui = loadstring(game:HttpGet("https://gist.githubusercontent.com/Tseting-nil/169b7303e1418cb301bad5ab427e9351/raw/93e90190f628387b545eef62b49e4ce146d1dad8/GUI:ReGui"))()

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DEBUG = false
local function dbg(...)
	if DEBUG then
		print("[塔能力DBG]", ...)
	end
end

local lang = getgenv().ScriptLeng or "en"

local i18n = {
	zh = {
		Title = " 塔能力控制台",
		langBtn     = "Change language",
		abilityFmt  = "能力：%s  ／  冷卻 %ds",
		readyText   = "🟢 就緒",
		timerFmt    = "⏳  %.0f s",
		autoLabel   = "自動",
		btnFmt      = "⚡ %s",
	},
	en = {
		Title = " Tower Ability Console",
		langBtn     = "更換語言",
		abilityFmt  = "Ability: %s  /  CD %ds",
		readyText   = "🟢 Ready",
		timerFmt    = "⏳  %.0f s",
		autoLabel   = "Auto",
		btnFmt      = "⚡ %s",
	},
}

local function t(key, ...)
	local str = (i18n[lang] or i18n.zh)[key] or key
	if select("#", ...) > 0 then
		return string.format(str, ...)
	end
	return str
end

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Functions = Remotes:WaitForChild("Functions")
local Data = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Data")

local PlaceTowerRemote = Functions:WaitForChild("PlaceTower")
local SellTowerRemote = Functions:WaitForChild("SellTower")
local TowerAbilityRemote = Functions:WaitForChild("TowerAbility")

local TowerAbilitiesData = {}
local TowersData = {}
pcall(function()
	TowerAbilitiesData = require(Data:WaitForChild("TowerAbilities"))
end)
pcall(function()
	TowersData = require(Data:WaitForChild("Towers"))
end)

local abilityCache = {}
local function fetchAbilityKeys(towerName)
	if abilityCache[towerName] then
		return abilityCache[towerName]
	end
	local keys = {}
	local td = TowersData[towerName]
	if type(td) == "table" then
		local stats = (td.Levels and td.Levels[1] and td.Levels[1].Stats) or td.Stats
		if stats and type(stats.Ability) == "table" then
			for _, k in pairs(stats.Ability) do
				if type(k) == "string" then
					table.insert(keys, k)
				end
			end
		end
	end
	abilityCache[towerName] = keys
	return keys
end

local function findAbilityTowers(abilityKey)
	local result = {}
	local seen = {}
	for towerName in pairs(TowersData) do
		if not seen[towerName] then
			seen[towerName] = true
			if table.find(fetchAbilityKeys(towerName), abilityKey) then
				table.insert(result, towerName)
			end
		end
	end
	for towerName, keys in pairs(abilityCache) do
		if not seen[towerName] and table.find(keys, abilityKey) then
			table.insert(result, towerName)
		end
	end
	table.sort(result)
	return result
end

local nextOrder = 1
local towerList = {}     -- towerList[gameId] = { name, order, abilityKeys, cooldowns, savedAutoStates }
local towerCards = {}    -- towerCards[gameId] = { header, widgets = {...} }
local windowVisible = false

-- UI
local pendingUIActions = {}

local Window = ReGui:Window({
	Title = t("Title"),
	Size = UDim2.fromOffset(370, 450),
	NoScroll = true,
	NoFocusOnAppearing = true,
	Visible = false,
	CloseCallback = function(win)
		win:SetVisible(false)
		windowVisible = false
		return false
	end,
})
Window:Center()

local Content = Window:ScrollingCanvas({
	Fill = true
})

local langBtn
langBtn = Content:Button({
	Text = t("langBtn"),
	Callback = function()
		lang = (lang == "zh") and "en" or "zh"
		pcall(function() langBtn:SetText(t("langBtn")) end)
		for gameId in pairs(towerCards) do
			table.insert(pendingUIActions, { type = "remove", gameId = gameId })
		end
		for gameId in pairs(towerList) do
			table.insert(pendingUIActions, { type = "build", gameId = gameId })
		end
	end,
})
Content:Separator()

local function showWindow()
	if windowVisible then
		return
	end
	windowVisible = true
	Window:SetVisible(true)
end

local function buildTowerCard(gameId)
	if towerCards[gameId] then
		return
	end
	local info = towerList[gameId]
	if not info or not info.abilityKeys or #info.abilityKeys == 0 then
		return
	end

	local header = Content:CollapsingHeader({
		Title = string.format("#%d  %s  [id:%s]", info.order, tostring(info.name), tostring(gameId)),
		Collapsed = false,
	})

	local widgets = {}

	local saved = info.savedAutoStates or {}

	for _, key in ipairs(info.abilityKeys) do
		local abi = TowerAbilitiesData[key]
		if not abi then
			dbg("找不到能力資料，使用預設:", key)
			abi = { Name = key, Cooldown = 30 }
		end

		local capturedGid = gameId
		local capturedKey = key
		local capturedCd = abi.Cooldown
		local autoState = { enabled = saved[key] == true }

		header:Label({
			Text = t("abilityFmt", abi.Name, abi.Cooldown),
			TextColor3 = Color3.fromRGB(150, 210, 255),
			NoTheme = true,
		})

		local bar = header:SliderProgress({
			Value = abi.Cooldown,
			Minimum = 0,
			Maximum = abi.Cooldown,
			ReadOnly = true,
		})
		bar:SetValueText(t("readyText"))

		local row = header:Row()
		local btn = row:Button({
			Text = t("btnFmt", abi.Name),
			Callback = function()
				task.spawn(function()
					local ok, result = pcall(function()
						return TowerAbilityRemote:InvokeServer(tostring(capturedGid), capturedKey)
					end)
					if ok and result ~= false and towerList[capturedGid] then
						towerList[capturedGid].cooldowns[capturedKey] = tick()
					end
				end)
			end,
		})

		local autoBox = row:Radiobox({
			Label = t("autoLabel"),
			Value = autoState.enabled,
			Callback = function(_, val)
				autoState.enabled = val == true
			end,
		})

		header:Separator()

		table.insert(widgets, {
			bar = bar,
			btn = btn,
			autoBox = autoBox,
			autoState = autoState,
			autoFiredAt = nil,
			key = capturedKey,
			cd = capturedCd,
		})
	end

	info.savedAutoStates = nil

	towerCards[gameId] = {
		header = header,
		widgets = widgets,
	}
end

local function removeTowerCard(gameId)
	local card = towerCards[gameId]
	if not card then
		return
	end
	if towerList[gameId] then
		local saved = {}
		for _, w in ipairs(card.widgets) do
			saved[w.key] = w.autoState.enabled
		end
		towerList[gameId].savedAutoStates = saved
	end
	card.header:Remove()
	towerCards[gameId] = nil
end

local updateTimer = 0
RunService.Heartbeat:Connect(function(dt)
	while #pendingUIActions > 0 do
		local act = table.remove(pendingUIActions, 1)
		if act.type == "show" then
			showWindow()
		elseif act.type == "build" then
			buildTowerCard(act.gameId)
		elseif act.type == "remove" then
			removeTowerCard(act.gameId)
		end
	end

	-- 更新進度條0.1秒
	updateTimer = updateTimer + dt
	if updateTimer < 0.1 then
		return
	end
	updateTimer = 0

	for gameId, info in pairs(towerList) do
		local card = towerCards[gameId]
		if not card then
			continue
		end
		for _, w in ipairs(card.widgets) do
			local t0 = info.cooldowns[w.key]

			if not t0 then
				if w.autoState.enabled then
					info.cooldowns[w.key] = tick() - w.cd - 1
				end
				continue
			end

			local elapsed = tick() - t0
			local remaining = math.max(0, w.cd - elapsed)
			local fill = math.min(elapsed, w.cd)

			w.bar:SetValue(fill)
			w.bar:SetValueText(remaining > 0 and t("timerFmt", remaining) or t("readyText"))
			w.btn:SetDisabled(remaining > 0)

			if w.autoState.enabled and remaining == 0 and elapsed >= w.cd + 0.5 and w.autoFiredAt ~= t0 then
				w.autoFiredAt = t0               -- 防止同幀重複觸發
				info.cooldowns[w.key] = tick()   -- 立即重置冷卻
				dbg("⚡ Auto 觸發 gid=", gameId, "key=", w.key)
				task.spawn(function()
					pcall(function()
						TowerAbilityRemote:InvokeServer(tostring(gameId), w.key)
					end)
				end)
			end
		end
	end
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
	if checkcaller() then
		return oldNamecall(self, ...)
	end

	local method = getnamecallmethod()
	if method ~= "InvokeServer" then
		return oldNamecall(self, ...)
	end

	if self ~= PlaceTowerRemote and self ~= SellTowerRemote and self ~= TowerAbilityRemote then
		return oldNamecall(self, ...)
	end

	local args = { ... }
	local result = oldNamecall(self, ...)

	local capturedSelf = self
	task.spawn(function()
		local okPost, errPost = pcall(function()
			if capturedSelf == PlaceTowerRemote then
				local pa = args[1]
				local rawName = type(pa) == "table" and pa.towerToPlace
				local towerName = type(rawName) == "string" and rawName or "Unknown"

				if type(result) == "table" and result.id then
					local gameId = result.id
					dbg("放塔 name=", towerName, "gid=", gameId)
					towerList[gameId] = {
						name = towerName,
						order = nextOrder,
						abilityKeys = fetchAbilityKeys(towerName),
						cooldowns = {},
					}
					nextOrder = nextOrder + 1
					table.insert(pendingUIActions, { type = "build", gameId = gameId })
				end

			elseif capturedSelf == SellTowerRemote then
				if result == true then
					local idStr = args[1]
					local towerId = type(idStr) == "number" and idStr
						or (type(idStr) == "string" and tonumber(idStr))
						or nil
					if towerId then
						dbg("售出 gid=", towerId)
						table.insert(pendingUIActions, { type = "remove", gameId = towerId })
						towerList[towerId] = nil
					end
				end

			elseif capturedSelf == TowerAbilityRemote then
				local abilityKey = type(args[2]) == "string" and args[2] or nil
				local idStr = args[1]
				local towerId = type(idStr) == "number" and idStr
					or (type(idStr) == "string" and tonumber(idStr))
					or nil

				table.insert(pendingUIActions, { type = "show" })

				-- result ~= false：伺服器可能回傳 nil 而非 true，不應視為失敗
				if towerId and abilityKey and result ~= false then
					-- 若塔不在追蹤清單（腳本載入前已放置），動態建立條目
					if not towerList[towerId] then
						dbg("動態追蹤未記錄的塔 gid=", towerId)
						towerList[towerId] = {
							name        = "?",
							order       = nextOrder,
							abilityKeys = {},
							cooldowns   = {},
						}
						nextOrder = nextOrder + 1
					end
					local info = towerList[towerId]
					info.cooldowns[abilityKey] = tick()
					local alreadyKnown = table.find(info.abilityKeys, abilityKey) ~= nil
					if not alreadyKnown then
						dbg("發現新能力 key=", abilityKey, "tower=", info.name)
						table.insert(info.abilityKeys, abilityKey)
						local cache = abilityCache[info.name] or {}
						if not table.find(cache, abilityKey) then
							table.insert(cache, abilityKey)
						end
						abilityCache[info.name] = cache
						table.insert(pendingUIActions, { type = "remove", gameId = towerId })
						table.insert(pendingUIActions, { type = "build", gameId = towerId })
					end
				end
			end
		end)
		if not okPost then
			dbg("hook post 錯誤:", errPost)
		end
	end)

	return result
end)