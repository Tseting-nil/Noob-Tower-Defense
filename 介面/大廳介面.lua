-- 側邊通知模組
if not getgenv().NotificationModule then
	loadstring(game:HttpGet("https://gist.githubusercontent.com/Tseting-nil/08653e6aa9fc12a9f097bfb10e6654e7/raw/00001d614d928fc5dafce59133a012dd78419afd/%25E5%2581%25B4%25E9%2582%258A%25E9%2580%259A%25E7%259F%25A5%25E6%25A8%25A1%25E7%25B5%2584.lua"))()
end

local Msg = getgenv().NotificationModule
-- ===== --
-- 遊戲函數
local HttpService = game:GetService("HttpService")

-- i18n
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

local L = {
	zh = {
		title             = "大廳腳本",
		tab_main          = "主頁",
		tab_collect       = "收取",
		author            = "作者: Tseting-nil",
		sep_auto_collect  = "自動領取",
		sep_battlepass    = "戰鬥通行證",
		sep_misc          = "雜項",
		sep_standard      = "標準",
		sep_retro         = "復古",
    auto_turntable    = "每日轉盤獎勵",
		auto_playtime     = "自動領取在線時間獎勵",
		auto_level_reward = "自動領取等級獎勵",
		auto_task_reward  = "自動領取任務獎勵",
		draw_box          = "抽取通行證箱子",
		draw_speed        = "抽取速度 = %.1f",
		skip_draw_anim    = "跳過抽取動畫",
		skip_enchant      = "跳過附魔等待",
		block_popup       = "去除煩人的彈窗",
		auto_x10          = "自動x10",
		single_pull       = "單抽出奇蹟!!",
		cooldown_ready    = "可抽取",
		cooldown_waiting  = "冷卻中",
		msg_claimed       = "已領取: %d 個獎勵",
		msg_no_rewards    = "無可領取獎勵",
		msg_pass_done     = "完成自動領取通行證獎勵",
		msg_no_shards     = "碎片不足或伺服器拒絕，停止（共抽了 %d 次）",
		msg_op_reward     = "高級獎池 抽取到 %s %s",
		msg_draw_done     = "完成，共抽了 %d 次，OP %d 次",
		msg_cooldown      = "等待冷卻 %d 秒",
		msg_block_popup   = "已封鎖最愛彈窗",
		msg_turntable_done = "已領取每日轉盤獎勵",
	},
	en = {
		title             = "Lobby Script",
		tab_main          = "Main",
		tab_collect       = "Collect",
		author            = "Author: Tseting-nil",
		sep_auto_collect  = "Auto Collect",
		sep_battlepass    = "Battle Pass",
		sep_misc          = "Misc",
		sep_standard      = "Standard",
		sep_retro         = "Retro",
    auto_turntable    = "Auto Collect DailySpin Rewards",
		auto_playtime     = "Auto Collect Playtime Rewards",
		auto_level_reward = "Auto Collect Level Rewards",
		auto_task_reward  = "Auto Collect Quest Rewards",
		draw_box          = "Draw Battle Pass Crate",
		draw_speed        = "Draw Speed = %.1f",
		skip_draw_anim    = "Skip Draw Animation",
		skip_enchant      = "Skip Enchant Wait",
		block_popup       = "Block Annoying Popups",
		auto_x10          = "Auto x10",
		single_pull       = "Single Pull Miracle!!",
		cooldown_ready    = "Ready",
		cooldown_waiting  = "On Cooldown",
		msg_claimed       = "Claimed: %d rewards",
		msg_no_rewards    = "No rewards to collect",
		msg_pass_done     = "Auto collect battle pass rewards complete",
		msg_no_shards     = "Insufficient shards or server rejected, stopped (total: %d spins)",
		msg_op_reward     = "Premium pool drew %s %s",
		msg_draw_done     = "Done, total %d spins, OP %d",
		msg_cooldown      = "Cooldown %d seconds",
		msg_block_popup   = "Favourite popup blocked",
		msg_turntable_done = "Daily Spin reward collected",
	},
}
local T = L[currentLang]
local radioTextSize = currentLang == "en" and 14 or 16

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Gametable = {
	LocalPlayer = game:GetService("Players").LocalPlayer,
	GUI = game:GetService("Players").LocalPlayer.PlayerGui,
}
local UI
for _, v in ipairs(Gametable.GUI:GetChildren()) do
	if v:IsA("ScreenGui") and v.Name == "UI" then
		if v:FindFirstChild("Frames") then
			UI = v
			break
		end
	end
end
local Scripttable = {
  turntable = false,
	playtimeRewards = {
		enable = false,
		GUI = UI.Frames.Playtime
	},
  Gamepass = {
    Level_Reward = false,
    Task_Reward = false,
    DrawBox = false,
    Drawspeed = 1,
    Skip_DrawBox_Animation = true,
  },
	Summon = {
    ISCooldown = false,
    Cooldown = 4,
		Retro_enable = false,
		Standard_enable = false,
	},
	blockFavouritePrompt = true,
  Skip_Enchanting = false
}
local Mainfunction = {}

Mainfunction.turntable = function()
  local SpinWheel = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("SpinWheel")
  while Scripttable.turntable do
    local Timer = workspace.Lobby.Chests.DailySpin.UI.Timer.Frame.Title.Text
    if Timer == "Ready!" then
      local conns = getconnections(SpinWheel.OnClientEvent)
      if conns[1] then
        conns[1].Function()
        print("[Turntable] " .. T.msg_turntable_done)
      end
      return
    end
    task.wait(5)
  end
end


Mainfunction.playtimeRewards = function()
	local Rewards_UI = Scripttable.playtimeRewards.GUI.Container.Info.Container.Rewards
	local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("ClaimPlaytimeReward")

	while Scripttable.playtimeRewards.enable do
		local toCollect = {}
		for i = 1, 12 do
			local Reward = Rewards_UI:FindFirstChild(tostring(i))

			if Reward then
				local Container = Reward.Frame.Container
				local Timer = Container.Timer
				local Claimed = Container.Claimed.Visible

				if Timer and Timer.Text == "00:00" and not Claimed then
					toCollect[# toCollect + 1] = tostring(i)
				end
			end
		end

		if # toCollect > 0 then
			local result = Remote:InvokeServer(toCollect)
			if result then
				for _, claimedIndex in result do
					local Reward = Rewards_UI:FindFirstChild(tostring(claimedIndex))
					if Reward then
						Reward.Frame.Container.Claimed.Visible = true
						Reward:SetAttribute("Claimed", true)
					end
				end
				Msg:Success(string.format(T.msg_claimed, #result))
				print("已領取:", # result, "個獎勵")
			end
			if toCollect[# toCollect] == "12" then
        print("無可領取獎勵")
        Msg:Warning(T.msg_no_rewards)
				return
			end
		end

		task.wait(5)
	end
end

Mainfunction.Gamepass_Level_Reward = function()
	while Scripttable.Gamepass.Level_Reward do
		local list = UI.Frames.Pass.Tabs.Pass.Container.Tiers.Canvas.List
		for _, Reward in ipairs(list:GetChildren()) do
			if Reward:IsA("Frame") and Reward.Name ~= "Template" then
				local Basic_Clicker = Reward.Basic.Container.Item.Frame.Container.Clicker -- 普通(免費)可領取圖標
				local Basic_Claimed = Reward.Basic.Container.Item.Frame.Container.Claimed -- 普通(免費)已領取圖標
				local Premium_Locked = Reward.Premium.Container.Item.Frame.Container.Locked -- 付費檢查
				local Premium_Clicker = Reward.Premium.Container.Item.Frame.Container.Clicker -- 付費可領取圖標
				local Premium_Claimed = Reward.Premium.Container.Item.Frame.Container.Claimed -- 付費已領取圖標
				local tier = tonumber(Reward.Name)
				if tier then
					if Premium_Clicker.Visible and not Premium_Claimed.Visible then
						ReplicatedStorage.Remotes.Functions.ClaimTier:InvokeServer(tier)
						Premium_Clicker.Visible = false
						Premium_Claimed.Visible = true
						Basic_Clicker.Visible = false
						Basic_Claimed.Visible = true
            print("領取等級 ".. tier .. " 獎勵")
            if tier == 30 then
              Msg:Success(T.msg_pass_done)
              return
            end
					elseif Basic_Clicker.Visible and not Basic_Claimed.Visible then
						ReplicatedStorage.Remotes.Functions.ClaimTier:InvokeServer(tier)
						Basic_Clicker.Visible = false
						Basic_Claimed.Visible = true
            print("領取等級 ".. tier .. " 普通獎勵")
            if tier == 30 then
              Msg:Success(T.msg_pass_done)
              return
            end
					else
            if tier == 30 then
              Msg:Success(T.msg_pass_done)
              return
            end
          end
				end
			end
		end
    task.wait(5)
	end
end

Mainfunction.Gamepass_Task_Reward = function()
	while Scripttable.Gamepass.Task_Reward do
		local QuestsUI = UI.Frames.Pass.Tabs.Quests.Container.Quests
		local function processCategory(category, categoryName)
			for _, Quest in ipairs(category:GetChildren()) do
				if Quest:IsA("Frame") and Quest.Name ~= "Template" then
					local Frame = Quest:FindFirstChild("Frame")
					if Frame then
						local Claimed = Frame.Container.Claim.Claimed -- 已領取圖標
						local Locked = Frame.Container.Claim.Locked -- 鎖定圖標
						local bar = Frame.Container.Progress.Bar.Title -- 進度條文字 "X/Y" <- 千進位逗號
						local text = string.gsub(bar.Text, ",", "")
						local current = tonumber(string.match(text, "(%d+)"))
						local index = Quest:GetAttribute("Index")
						local max = Quest:GetAttribute("MaxAmount")
						if current and max and index and current >= max and not Claimed.Visible and not Locked.Visible then
              -- print(categoryName .. " 可領取 Index=" .. tostring(index))
              ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("ClaimQuest"):InvokeServer(categoryName, index)
              Claimed.Visible = true
            end
					end
				end
			end
		end
    -- 每日、每週、賽季
		processCategory(QuestsUI.Daily, "Daily")
		processCategory(QuestsUI.Weekly, "Weekly")
		processCategory(QuestsUI.Season, "Season")
    task.wait(5)
	end
end

-- Hook
local _SpinRemote    = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("SpinBattlepassCrate")
local _EnchantRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("Enchant")
local _lastSpinData = nil
local _oldNamecall
_oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
	if getnamecallmethod() == "PromptSetFavorite" then
		print("[Hook] PromptSetFavorite 被攔截，blockFavouritePrompt =", Scripttable.blockFavouritePrompt)
		if Scripttable.blockFavouritePrompt then
			return
		end
	end
	if getnamecallmethod() == "InvokeServer" then
		if self == _SpinRemote then
			local ok, data = _oldNamecall(self, ...)
			if ok and type(data) == "table" then
				_lastSpinData = data
			end
			return ok, data
		end
		if self == _EnchantRemote then
			local result = _oldNamecall(self, ...)
			if Scripttable.Skip_Enchanting then
				task.spawn(function()
					local SkipBtn = UI.Frames.Enchanting.Tabs.Container.Info.Container.Info.Buttons.Skip
					local t = 0
					repeat task.wait(0.1); t += 0.1 until SkipBtn.Visible or t >= 10
					if SkipBtn.Visible then
						firesignal(SkipBtn.Button.Activated)
						-- print("[Enchant] 跳過動畫")
					end
				end)
			end
			return result
		end
	end
	return _oldNamecall(self, ...)
end)

-- 抽取通行證箱子
Mainfunction.Gamepass_DrawBox = function()
	local Constants = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("Constants"))
	local shards = UI.Frames.Pass.Tabs.Crate.Container.Buttons.Shards
	local spinBtn = shards.Button
	local skipVisible = shards.Container.Skip
	local OPContainer = shards.Parent.Parent.OP

	local spinCount = 0
	local opCount = 0

	while Scripttable.Gamepass.Draw_Box do
		local spins = Constants.currentPlrData.Battlepass.Crate.Spins
		if spins <= 0 then
			local bought = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("BuyBattlepassCrateSpin"):InvokeServer()
			if bought then
				Constants.currentPlrData.Battlepass.Crate.Spins += 1
			else
				Msg:Warning(string.format(T.msg_no_shards, spinCount))
				Scripttable.Gamepass.Draw_Box = false
				break
			end
		end

		_lastSpinData = nil
		firesignal(spinBtn.Activated)
		spinCount = spinCount + 1

		-- 等待 spinningCrate 旗標清除（動畫結束）
		local timeout = 0
		local skipped = false
		repeat
			task.wait(0.1)
			timeout = timeout + 0.1
			if Scripttable.Gamepass.Skip_DrawBox_Animation and not skipped and skipVisible.Visible then
				firesignal(spinBtn.Activated)
				skipped = true
			end
		until not Constants.spinningCrate or timeout >= 12

		-- 檢查是否抽到 OP 池
		local spinData = _lastSpinData
		if spinData and spinData.crateType == "OP" then
			opCount += 1
			local slot = OPContainer:FindFirstChild(tostring(spinData.rewardIndex))
			local itemName = slot and slot.Hover.Title.Text or "未知"  -- 物品具體名稱
			local amount = "?" -- 數量
			if slot then
				for _, child in slot:GetDescendants() do
					if child:IsA("TextLabel") and #child.Text > 0 and child ~= slot.Hover.Title then
						amount = child.Text
						break
					end
				end
			end
			Msg:Success(string.format(T.msg_op_reward, itemName, amount))
			print("[DrawBox] 高級獎池 抽取到 " .. itemName .. " " .. amount)
		end

		task.wait(Scripttable.Gamepass.Drawspeed)
	end
	if spinCount > 0 then
		Msg:Success(string.format(T.msg_draw_done, spinCount, opCount))
	end
end

-- 抽取Retro
Mainfunction.Summon_Retro = function(x)
  if Scripttable.Summon.ISCooldown then
    Msg:Warning(string.format(T.msg_cooldown, Scripttable.Summon.Cooldown))
    return
  end
	ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("Summon"):InvokeServer(x, "Retro")
end

-- 抽取Standard
Mainfunction.Summon_Standard = function(x)
  if Scripttable.Summon.ISCooldown then
    Msg:Warning(string.format(T.msg_cooldown, Scripttable.Summon.Cooldown))
    return
  end
	ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("Summon"):InvokeServer(x, "Standard")
end

-- ========================================================================== --
-- GUI

local ReGui = loadstring(game:HttpGet("https://gist.githubusercontent.com/Tseting-nil/169b7303e1418cb301bad5ab427e9351/raw/93e90190f628387b545eef62b49e4ce146d1dad8/GUI:ReGui"))()

local TabsWindow = ReGui:TabsWindow({
	Title = T.title,
	Visible = true,
	Size = UDim2.fromOffset(450, 300)
})

local Tabs = {}

for _, Name in ipairs({
	T.tab_main,
	T.tab_collect
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

-- ========================================================================== --
-- Tab_main

local Tab_main = Tabs[1]:ScrollingCanvas({
	Fill = true,
	UiPadding = UDim.new(0, 0)
})

local Tab_Summon = Tabs[2]:ScrollingCanvas({
	Fill = true,
	UiPadding = UDim.new(0, 0)
})

Tab_main:Label({
	Text = T.author
})

Tab_main:Separator({
	Text = T.sep_auto_collect
})

Tab_main:Radiobox({
	Value = false,
	Label = T.auto_turntable,
	TextSize = radioTextSize,
	Disabled = false,
	Callback = function(self, Value)
    Scripttable.turntable = Value
		if Scripttable.turntable then
      task.spawn(Mainfunction.turntable)
    end
	end,
})

Tab_main:Radiobox({
	Value = false,
	Label = T.auto_playtime,
	TextSize = radioTextSize,
	Disabled = false,
	Callback = function(self, Value)
		Scripttable.playtimeRewards.enable = Value
		if Scripttable.playtimeRewards.enable then
			task.spawn(Mainfunction.playtimeRewards)
		end
	end,
})

Tab_main:Separator({
	Text = T.sep_battlepass
})

Tab_main:Radiobox({
	Value = false,
	Label = T.auto_level_reward,
	TextSize = radioTextSize,
	Disabled = false,
	Callback = function(self, Value)
		Scripttable.Gamepass.Level_Reward = Value
		if Scripttable.Gamepass.Level_Reward then
			task.spawn(Mainfunction.Gamepass_Level_Reward)
		end
	end,
})

Tab_main:Radiobox({
	Value = false,
	Label = T.auto_task_reward,
	TextSize = radioTextSize,
	Disabled = false,
	Callback = function(self, Value)
		Scripttable.Gamepass.Task_Reward = Value
		if Scripttable.Gamepass.Task_Reward then
			task.spawn(Mainfunction.Gamepass_Task_Reward)
		end
	end,
})

local DrawBox = Tab_main:Row()

DrawBox:Radiobox({
	Value = false,
	Label = T.draw_box,
	TextSize = radioTextSize,
	Disabled = false,
	Callback = function(self, Value)
		Scripttable.Gamepass.Draw_Box = Value
		if Scripttable.Gamepass.Draw_Box then
			task.spawn(Mainfunction.Gamepass_DrawBox)
		end
	end,
})

DrawBox:SliderFloat({
  Label = "",
  Value = 1,
  Minimum = 0.1,
  Maximum = 3,
  Format = T.draw_speed,
  Callback = function(self, Value)
    Value = tonumber(string.format("%.1f", Value))
    Scripttable.Gamepass.Drawspeed = Value
  end,
})

Tab_main:Radiobox({
	Value = true,
	Label = T.skip_draw_anim,
	TextSize = radioTextSize,
	Disabled = false,
	Callback = function(self, Value)
		Scripttable.Gamepass.Skip_DrawBox_Animation = Value
	end,
})

Tab_main:Separator({
	Text = T.sep_misc
})

Tab_main:Radiobox({
	Value = false,
	Label = T.skip_enchant,
	TextSize = radioTextSize,
	Disabled = false,
	Callback = function(self, Value)
		Scripttable.Skip_Enchanting = Value
	end,
})

Tab_main:Radiobox({
	Value = true,
	Label = T.block_popup,
	TextSize = radioTextSize,
	Disabled = false,
	Callback = function(self, Value)
		Scripttable.blockFavouritePrompt = Value
		if Value then
			Msg:Success(T.msg_block_popup)
		end
	end,
})

-- ========================================================================== --
-- Tab_Summon
local Cooldown = Tab_Summon:Label({ Text = T.cooldown_ready })
task.spawn(function()
  while true do
    if Scripttable.Summon.ISCooldown then
      Cooldown.Text = T.cooldown_waiting
    else
      Cooldown.Text = T.cooldown_ready
    end
    task.wait(0.1)
  end
end)

Tab_Summon:Separator({
	Text = T.sep_standard
})

local Row_Retro = Tab_Summon:Row()

Row_Retro:Button({
	Text = T.single_pull,
	Callback = function()
    if Scripttable.Summon.ISCooldown then
      Msg:Warning(string.format(T.msg_cooldown, Scripttable.Summon.Cooldown))
      return
    end
		Mainfunction.Summon_Retro(1)
    Scripttable.Summon.ISCooldown = true
    task.wait(Scripttable.Summon.Cooldown)
    Scripttable.Summon.ISCooldown = false
	end,
	DoubleClick = false,
})

Row_Retro:Radiobox({
	Value = false,
	Label = T.auto_x10,
	TextSize = radioTextSize,
	Disabled = false,
	Callback = function(self, Value)
		Scripttable.Summon.Retro_enable = Value
		if Scripttable.Summon.Retro_enable then
			task.spawn(function()
				while Scripttable.Summon.Retro_enable do
					Mainfunction.Summon_Retro(10)
          Scripttable.Summon.ISCooldown = true
          task.wait(Scripttable.Summon.Cooldown)
          Scripttable.Summon.ISCooldown = false
				end
			end)
		end
	end,
})

Tab_Summon:Separator({
	Text = T.sep_retro
})

local Row_Standard = Tab_Summon:Row()

Row_Standard:Button({
	Text = T.single_pull,
	Callback = function()
    if Scripttable.Summon.ISCooldown then
      Msg:Warning(string.format(T.msg_cooldown, Scripttable.Summon.Cooldown))
      return
    end
		Mainfunction.Summon_Standard(1)
    Scripttable.Summon.ISCooldown = true
    task.wait(Scripttable.Summon.Cooldown)
    Scripttable.Summon.ISCooldown = false
	end,
	DoubleClick = false,
})

Row_Standard:Radiobox({
	Value = false,
	Label = T.auto_x10,
	TextSize = radioTextSize,
	Disabled = false,
	Callback = function(self, Value)
		Scripttable.Summon.Standard_enable = Value
		if Scripttable.Summon.Standard_enable then
			task.spawn(function()
				while Scripttable.Summon.Standard_enable do
					Mainfunction.Summon_Standard(10)
          Scripttable.Summon.ISCooldown = true
          task.wait(Scripttable.Summon.Cooldown)
          Scripttable.Summon.ISCooldown = false
				end
			end)
		end
	end,
})
