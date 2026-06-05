-- 側邊通知模組
if not getgenv().NotificationModule then
	loadstring(game:HttpGet("https://gist.githubusercontent.com/Tseting-nil/08653e6aa9fc12a9f097bfb10e6654e7/raw/00001d614d928fc5dafce59133a012dd78419afd/%25E5%2581%25B4%25E9%2582%258A%25E9%2580%259A%25E7%259F%25A5%25E6%25A8%25A1%25E7%25B5%2584.lua"))()
end

local Msg = getgenv().NotificationModule
-- ===== --
-- 遊戲函數
local HttpService = game:GetService("HttpService")

-- 反AFK
local AntiAFK = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
	AntiAFK:CaptureController()
	AntiAFK:ClickButton2(Vector2.new())
	task.wait(2)
end)

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
    tab_localscript   = "本地腳本管理",
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
		summon_notify        = "通知",
		summon_notify_shiny  = "閃亮 %s  %s",
		summon_notify_rarity = "%s  %s",
		autodelete_header    = "自動刪除抽取物件",
		autodelete_enable    = "自動刪除",
		autodelete_applied   = "已套用自動刪除設定",
		autodelete_off       = "已關閉自動刪除",
		autodelete_save      = "儲存",
		autodelete_load      = "載入",
		autodelete_saved     = "已儲存自動刪除設定",
		autodelete_loaded    = "已載入自動刪除設定",
		autodelete_save_fail = "儲存失敗: %s",
		autodelete_no_config = "找不到自動刪除設定檔",
		rarity_Common        = "常見",
		rarity_Rare          = "稀有",
		rarity_Epic          = "史詩",
		rarity_Legendary     = "傳奇",
		rarity_shiny         = "閃亮",
		skip_enchant      = "跳過附魔等待",
		block_popup       = "去除煩人的彈窗",
		auto_x10          = "自動x10",
    auto_x20          = "自動x20",
		single_pull       = "單抽出奇蹟!!",
		cooldown_ready    = "狀態: 可抽取",
		cooldown_waiting  = "狀態: 冷卻中",
    Skip_Summon       = "跳過抽取動畫",
		msg_claimed       = "已領取: %d 個獎勵",
		msg_no_rewards    = "無可領取獎勵",
		msg_pass_done     = "完成自動領取通行證獎勵",
		msg_no_shards     = "碎片不足或伺服器拒絕，停止（共抽了 %d 次）",
		msg_op_reward     = "高級獎池 抽取到 %s %s",
		msg_draw_done     = "完成，共抽了 %d 次，OP %d 次",
		msg_cooldown      = "等待冷卻 %d 秒",
		msg_block_popup   = "已封鎖最愛彈窗",
		msg_turntable_done    = "已領取每日轉盤獎勵",
    pity_separator        = "保底進度",
    msg_nocoin            = "金幣不足",
		msg_auto_conflict     = "另一個自動抽取正在執行中",
		localscript_path      = "路徑: ",
		localscript_list      = "腳本列表",
		localscript_refresh   = "重新整理",
		localscript_run       = "執行",
		localscript_no_scripts = "目錄中無腳本",
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
		sep_auto_master    = "自動 Master",
		auto_master        = "自動 Master",
		msg_master_ok      = "%s → %s",
		msg_master_fail    = "Master 失敗：%s",
	},
	en = {
		title             = "Lobby Script",
		tab_main          = "Main",
		tab_collect       = "Collect",
    tab_localscript   = "Local Script Manager",
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
		summon_notify        = "Notify",
		summon_notify_shiny  = "Shiny %s  %s",
		summon_notify_rarity = "%s  %s",
		autodelete_header    = "Auto Delete Summons",
		autodelete_enable    = "Auto Delete",
		autodelete_applied   = "Auto-delete settings applied",
		autodelete_off       = "Auto-delete disabled",
		autodelete_save      = "Save",
		autodelete_load      = "Load",
		autodelete_saved     = "Auto-delete config saved",
		autodelete_loaded    = "Auto-delete config loaded",
		autodelete_save_fail = "Save failed: %s",
		autodelete_no_config = "No auto-delete config found",
		rarity_Common        = "Common",
		rarity_Rare          = "Rare",
		rarity_Epic          = "Epic",
		rarity_Legendary     = "Legendary",
		rarity_shiny         = "Shiny",
		skip_enchant      = "Skip Enchant Wait",
		block_popup       = "Block Annoying Popups",
		auto_x10          = "Auto x10",
		single_pull       = "Single Pull Miracle!!",
		cooldown_ready    = "State: Ready",
		cooldown_waiting  = "State: On Cooldown",
    Skip_Summon       = "Skip Summon Animation",
		msg_claimed       = "Claimed: %d rewards",
		msg_no_rewards    = "No rewards to collect",
		msg_pass_done     = "Auto collect battle pass rewards complete",
		msg_no_shards     = "Insufficient shards or server rejected, stopped (total: %d spins)",
		msg_op_reward     = "Premium pool drew %s %s",
		msg_draw_done     = "Done, total %d spins, OP %d",
		msg_cooldown      = "Cooldown %d seconds",
		msg_block_popup   = "Favourite popup blocked",
		msg_turntable_done    = "Daily Spin reward collected",
    pity_separator        = "Pity Progress",
    msg_nocoin            = "Not enough coins",
		msg_auto_conflict     = "Another auto-summon is already running",
		localscript_path      = "Path: ",
		localscript_list      = "Script List",
		localscript_refresh   = "Refresh",
		localscript_run       = "Run",
		localscript_no_scripts = "No scripts in directory",
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
		sep_auto_master    = "Auto Master",
		auto_master        = "Auto Master",
		msg_master_ok      = "%s → %s",
		msg_master_fail    = "Master failed: %s",
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
    Skip = false,
    ISCooldown = false,
    Cooldown = 4,
		Retro_enable = false,
		Standard_enable = false,
    Gui = UI.Frames.Summon,
    notify = {
      enable = true,
      HIGH_TIER = {
        Common    = false,
        Rare      = false,
        Epic      = false,
        Legendary = false,
        Mythic    = true,
        Secret    = true,
        Exclusive = true,
      },
      NOTIFY_SHINY = true,
    },
    AutoDelete = {
      enable = false,
      HIGH_TIER = {
        Common    = false,
        Rare      = false,
        Epic      = false,
        Legendary = false,
        Shiny_Common    = false,
        Shiny_Rare      = false,
        Shiny_Epic      = false,
        Shiny_Legendary = false,
      },
      UIReady = false,
    }
	},
	blockFavouritePrompt = true,
  Skip_Enchanting = false,
  Localscript = {
    path = [[Tsetingnil_script\NTD\Script]],
    Excluded = {"_Venus", "_Saturn", "_Mars"},
    ScriptListTable = nil,
    -- 自動刪除設定檔路徑
    ConfigDir  = [[Tsetingnil_script\NTD\Config]],
    ConfigPath = [[Tsetingnil_script\NTD\Config\Summon_AutoDelete.json]],
  }
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

-- getgc 抓 towersData
local _TowersData
for _, obj in ipairs(getgc(true)) do
  if type(obj) == "table"
      and rawget(obj, "getTowerData")
      and rawget(obj, "Rarities") then
    _TowersData = obj
    break
  end
end

-- ========== AutoMaster ==========
Scripttable.AutoMaster = false

-- 撈 Handler UI 更新函數
local _updateUnitsList, _updateUnitsInfo, _updateMasteryTab
for _, obj in ipairs(getgc(true)) do
	if type(obj) == "function" then
		local ok, consts = pcall(getconstants, obj)
		if not ok or not consts then continue end
		if not _updateUnitsList then
			local a, b = false, false
			for _, c in ipairs(consts) do
				if c == "MutationKey" then a = true end
				if c == "HoverIndex" then b = true end
			end
			if a and b then _updateUnitsList = obj end
		end
		if not _updateUnitsInfo then
			local a, b = false, false
			for _, c in ipairs(consts) do
				if c == "previousSelectedUnit" then a = true end
				if c == "SHINY_PRICE_MULTIPLIER" then b = true end
			end
			if a and b then _updateUnitsInfo = obj end
		end
		if not _updateMasteryTab then
			local a, b = false, false
			for _, c in ipairs(consts) do
				if c == "GlobalCounts" then a = true end
				if c == "cycleIndex" then b = true end
			end
			if a and b then _updateMasteryTab = obj end
		end
	end
end

Mainfunction.AutoMaster = function()
	local Constants = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("Constants"))
	local MasterRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("MasterUnit")

	while Scripttable.AutoMaster do
		local towers = Constants.currentPlrData
			and Constants.currentPlrData.Items
			and Constants.currentPlrData.Items.Towers

		if towers then
			for id, data in pairs(towers) do
				if not Scripttable.AutoMaster then break end
				local mastery = data.Mastery or 1
				local nextData = _TowersData.Masteries[mastery + 1]
				if nextData and data.Level >= nextData.Level then
					local success = MasterRemote:InvokeServer(id)
					if success == true then
						data.Mastery = mastery + 1
						data.Level = 1
						data.XP = 0
						if _updateMasteryTab then pcall(_updateMasteryTab) end
						if _updateUnitsInfo then pcall(_updateUnitsInfo) end
						if _updateUnitsList then pcall(_updateUnitsList) end
						Msg:Success(string.format(T.msg_master_ok, data.Tower, nextData.Name))
					else
						Msg:Warning(string.format(T.msg_master_fail, data.Tower))
					end
					task.wait(0.6)
				end
			end
		end
		task.wait(5)
	end
end

local function _getRarity(towerName)
  if not _TowersData then return "Unknown" end
  local ok, data = pcall(_TowersData.getTowerData, towerName)
  if ok and type(data) == "table" then return data.Rarity end
  return "Unknown"
end

local function _formatTowerName(s)
  return s:gsub("(%l)(%u)", "%1 %2")
end

-- Hook
local _SpinRemote    = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("SpinBattlepassCrate")
local _EnchantRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("Enchant")
local _SummonRemote  = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("Summon")
local _lastSpinData = nil
local _PityConfig = {
	{ key = "Legendary", label = currentLang == "zh" and "傳奇" or "Legendary", max = 50    },
	{ key = "Mythic",    label = currentLang == "zh" and "神話" or "Mythic",    max = 400   },
	{ key = "Secret",    label = currentLang == "zh" and "秘密" or "Secret",    max = 10000 },
}

local _summonResultQueue = {}
game:GetService("RunService").Heartbeat:Connect(function()
	if #_summonResultQueue == 0 then return end
	local items = _summonResultQueue
	_summonResultQueue = {}
	for _, data in ipairs(items) do
		local pity, result = data.pity, data.result
		if type(pity) == "table" then
			for _, cfg in ipairs(_PityConfig) do
				if cfg.bar and pity[cfg.key] ~= nil then
					local v   = tonumber(pity[cfg.key]) or 0
					local pct = v / cfg.max * 100
					cfg.bar:SetValue(pct)
					cfg.bar:SetValueText(string.format("%d / %d (%.2f%%)", v, cfg.max, pct))
				end
			end
		end
		local n = Scripttable.Summon.notify
		if n.enable and type(result) == "table" then
			for _, entry in ipairs(result) do
				local tower    = entry.tower or "?"
				local shiny    = entry.shiny == true
				local rarity   = _getRarity(tower)
				local rarityHit = n.HIGH_TIER[rarity] == true
				local shinyHit  = shiny and n.NOTIFY_SHINY
				if rarityHit or shinyHit then
					local displayName = _formatTowerName(tower)
					local label
					if shiny then
						label = string.format(T.summon_notify_shiny, rarity, displayName)
					else
						label = string.format(T.summon_notify_rarity, rarity, displayName)
					end
					print("[Summon Notify] " .. label)
					Msg:Success(label)
				end
			end
		end
	end
end)

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
					end
				end)
			end
			return result
		end
		if self == _SummonRemote then
			local result, pity = _oldNamecall(self, ...)
			_summonResultQueue[#_summonResultQueue + 1] = { result = result, pity = pity }
			return result, pity
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

-- 抽取召喚 ("Standard","Retro")
Mainfunction.Summon = function(x, BannerType)
  if Scripttable.Summon.ISCooldown then
    Msg:Warning(string.format(T.msg_cooldown, Scripttable.Summon.Cooldown))
    return
  end
  local Coin = Gametable.LocalPlayer.Coins.Value
  local singleCost = (BannerType == "Retro") and 200 or 100
  local cost = x == 1 and singleCost or math.floor(singleCost * x * 0.9)
  if Coin < cost then
    Msg:Warning(T.msg_nocoin)
    return "Not enough coins"
  end
  local banner_name = BannerType or "Standard"
  if Scripttable.Summon.Skip then
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("Summon"):InvokeServer(x, banner_name)
    return
  end
  local banner_btn = Scripttable.Summon.Gui.Container.Banners[banner_name].Button
  firesignal(banner_btn.Activated)
  local summon_key = x == 1 and "Summon1" or x == 10 and "Summon2" or "Summon3"
  local Summon_btn = Scripttable.Summon.Gui.Container.Buttons[summon_key].Button
  firesignal(Summon_btn.Activated)
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
	T.tab_collect,
  T.tab_localscript
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

local Tab_Localscript = Tabs[3]:ScrollingCanvas({
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

Tab_main:Separator({ Text = T.sep_auto_master })

Tab_main:Radiobox({
	Value = false,
	Label = T.auto_master,
	TextSize = radioTextSize,
	Callback = function(self, Value)
		Scripttable.AutoMaster = Value
		if Value then
			task.spawn(Mainfunction.AutoMaster)
		end
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
		Mainfunction.Summon(1, "Standard")
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
		if Value then
			if Scripttable.Summon.AutoRunning then
        Msg:Warning(T.msg_auto_conflict)
				self:SetValue(false)
				return
			end
			Scripttable.Summon.AutoRunning = true
			Scripttable.Summon.Retro_enable = true
			task.spawn(function()
				while Scripttable.Summon.Retro_enable do
					local start = Mainfunction.Summon(10, "Standard")
          if start == "Not enough coins" then
            self:SetValue(false)
            return
          end
					Scripttable.Summon.ISCooldown = true
					task.wait(Scripttable.Summon.Cooldown)
					Scripttable.Summon.ISCooldown = false
				end
				Scripttable.Summon.AutoRunning = false
			end)
		else
      Scripttable.Summon.AutoRunning = false
			Scripttable.Summon.Retro_enable = false
		end
	end,
})

Row_Retro:Radiobox({
	Value = false,
	Label = T.auto_x20,
	TextSize = radioTextSize,
	Disabled = false,
	Callback = function(self, Value)
		if Value then
			if Scripttable.Summon.AutoRunning then
        Msg:Warning(T.msg_auto_conflict)
				self:SetValue(false)
				return
			end
			Scripttable.Summon.AutoRunning = true
			Scripttable.Summon.Retro_enable = true
			task.spawn(function()
				while Scripttable.Summon.Retro_enable do
					local start = Mainfunction.Summon(20, "Standard")
          if start == "Not enough coins" then
            self:SetValue(false)
            return
          end
					Scripttable.Summon.ISCooldown = true
					task.wait(Scripttable.Summon.Cooldown)
					Scripttable.Summon.ISCooldown = false
				end
				Scripttable.Summon.AutoRunning = false
			end)
		else
      Scripttable.Summon.AutoRunning = false
			Scripttable.Summon.Retro_enable = false
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
		Mainfunction.Summon(1, "Retro")
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
		if Value then
			if Scripttable.Summon.AutoRunning then
        Msg:Warning(T.msg_auto_conflict)
				self:SetValue(false)
				return
			end
			Scripttable.Summon.AutoRunning = true
			Scripttable.Summon.Standard_enable = true
			task.spawn(function()
				while Scripttable.Summon.Standard_enable do
					local start = Mainfunction.Summon(10, "Retro")
					if start == "Not enough coins" then
						self:SetValue(false)
            return
					end
					Scripttable.Summon.ISCooldown = true
					task.wait(Scripttable.Summon.Cooldown)
					Scripttable.Summon.ISCooldown = false
				end
				Scripttable.Summon.AutoRunning = false
			end)
		else
      Scripttable.Summon.AutoRunning = false
			Scripttable.Summon.Standard_enable = false
		end
	end,
})

Row_Standard:Radiobox({
	Value = false,
	Label = T.auto_x20,
	TextSize = radioTextSize,
	Disabled = false,
	Callback = function(self, Value)
		if Value then
			if Scripttable.Summon.AutoRunning then
        Msg:Warning(T.msg_auto_conflict)
				self:SetValue(false)
				return
			end
			Scripttable.Summon.AutoRunning = true
			Scripttable.Summon.Standard_enable = true
			task.spawn(function()
				while Scripttable.Summon.Standard_enable do
					local start = Mainfunction.Summon(20, "Retro")
					if start == "Not enough coins" then
						self:SetValue(false)
            return
					end
					Scripttable.Summon.ISCooldown = true
					task.wait(Scripttable.Summon.Cooldown)
					Scripttable.Summon.ISCooldown = false
				end
				Scripttable.Summon.AutoRunning = false
			end)
		else
      Scripttable.Summon.AutoRunning = false
			Scripttable.Summon.Standard_enable = false
		end
	end,
})

do
  local AD = Scripttable.Summon.AutoDelete
  AD.Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("AutoDelete")
  AD.Frame = Scripttable.Summon.Gui:FindFirstChild("AutoDelete")
  pcall(function()
    AD.Colours = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("Colours"))
  end)
end

local function _colourNativeToggle(rarity, kind, isOn)
  local AD = Scripttable.Summon.AutoDelete
  if not (AD.Frame and AD.Colours) then return end
  pcall(function()
    local entry = AD.Frame.Info.List:FindFirstChild(rarity)
    if not entry then return end
    local toggle = entry.Container.Toggle:FindFirstChild(kind)
    if not toggle then return end
    local colour = isOn and AD.Colours.Green or AD.Colours.Red
    for _, d in ipairs(toggle:GetDescendants()) do
      if d:IsA("UIGradient") and d.Name == "ButtonGrad" then
        d.Color = colour
      end
    end
  end)
end

-- 翻轉伺服器某 (rarity, kind) 的自動刪除，並依回傳值替原生按鈕上色（綠=開 / 紅=關）
local function _applyAutoDelete(rarity, kind)
  local AD = Scripttable.Summon.AutoDelete
  local ok, ret = pcall(function()
    return AD.Remote:InvokeServer(rarity, kind)
  end)
  if ok then
    print(string.format("[AutoDelete] %s %s -> %s", rarity, kind, tostring(ret)))
    _colourNativeToggle(rarity, kind, ret == true)
  end
end

local function _syncAutoDelete()
  local AD = Scripttable.Summon.AutoDelete
  task.spawn(function()
    for _, r in ipairs({ "Common", "Rare", "Epic", "Legendary" }) do
      if AD.HIGH_TIER[r] then _applyAutoDelete(r, "Normal") end
      if AD.HIGH_TIER["Shiny_" .. r] then _applyAutoDelete(r, "Shiny") end
    end
  end)
end

Mainfunction.SaveConfig = function()
  for _, dir in ipairs({ "Tsetingnil_script", "Tsetingnil_script\\NTD", Scripttable.Localscript.ConfigDir }) do
    if isfolder and makefolder and not isfolder(dir) then
      pcall(makefolder, dir)
    end
  end
  local ok, encoded = pcall(function()
    return HttpService:JSONEncode(Scripttable.Summon.AutoDelete.HIGH_TIER)
  end)
  if not ok then
    Msg:Warning(string.format(T.autodelete_save_fail, tostring(encoded)))
    return false
  end
  local ok2, err = pcall(writefile, Scripttable.Localscript.ConfigPath, encoded)
  if ok2 then
    Msg:Success(T.autodelete_saved)
    return true
  end
  Msg:Warning(string.format(T.autodelete_save_fail, tostring(err)))
  return false
end

-- 讀取 AutoDelete.HIGH_TIER
Mainfunction.LoadConfig = function(silent)
  if not (isfile and readfile and isfile(Scripttable.Localscript.ConfigPath)) then
    if not silent then Msg:Warning(T.autodelete_no_config) end
    return false
  end
  local ok, raw = pcall(readfile, Scripttable.Localscript.ConfigPath)
  if not ok or not raw or raw == "" then
    if not silent then Msg:Warning(T.autodelete_no_config) end
    return false
  end
  local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
  if not ok2 or type(data) ~= "table" then
    if not silent then Msg:Warning(T.autodelete_no_config) end
    return false
  end
  local HT = Scripttable.Summon.AutoDelete.HIGH_TIER
  -- 只覆寫既有鍵，忽略檔案中的未知欄位
  for key in pairs(HT) do
    if type(data[key]) == "boolean" then
      HT[key] = data[key]
    end
  end
  if not silent then Msg:Success(T.autodelete_loaded) end
  return true
end

Mainfunction.LoadConfig(true)

local Row_SummonOptions = Tab_Summon:Row()

Row_SummonOptions:Radiobox({
  Value    = false,
  Label    = T.Skip_Summon,
  TextSize = radioTextSize,
  Callback = function(self, Value)
    Scripttable.Summon.Skip = Value
  end,
})

Row_SummonOptions:Radiobox({
  Value    = true,
  Label    = T.summon_notify,
  TextSize = radioTextSize,
  Callback = function(self, Value)
    Scripttable.Summon.notify.enable = Value
  end,
})

-- 自動刪除總開關（與跳過抽取動畫、通知同一 Row）
Row_SummonOptions:Radiobox({
  Value    = Scripttable.Summon.AutoDelete.enable,
  Label    = T.autodelete_enable,
  TextSize = radioTextSize,
  Callback = function(self, Value)
    Scripttable.Summon.AutoDelete.enable = Value
    if not Scripttable.Summon.AutoDelete.UIReady then return end
    _syncAutoDelete()
    if Value then
      Msg:Success(T.autodelete_applied)
    else
      Msg:Warning(T.autodelete_off)
    end
  end,
})

local AutoDeleteHeader = Tab_Summon:CollapsingHeader({
  Title     = T.autodelete_header,
  Collapsed = true,
})

local AutoDeleteTable = AutoDeleteHeader:Table({ MaxColumns = 2 })
for _, rarity in ipairs({ "Common", "Rare", "Epic", "Legendary" }) do
  local Row = AutoDeleteTable:NextRow()
  -- 左欄：一般
  Row:NextColumn():Radiobox({
    Value    = Scripttable.Summon.AutoDelete.HIGH_TIER[rarity],
    Label    = T["rarity_" .. rarity],
    TextSize = radioTextSize,
    Callback = function(self, Value)
      Scripttable.Summon.AutoDelete.HIGH_TIER[rarity] = Value
      if Scripttable.Summon.AutoDelete.enable then
        task.spawn(_applyAutoDelete, rarity, "Normal")
      end
    end,
  })
  -- 右欄：閃亮
  local shinyKey = "Shiny_" .. rarity
  Row:NextColumn():Radiobox({
    Value    = Scripttable.Summon.AutoDelete.HIGH_TIER[shinyKey],
    Label    = T.rarity_shiny .. " " .. T["rarity_" .. rarity],
    TextSize = radioTextSize,
    Callback = function(self, Value)
      Scripttable.Summon.AutoDelete.HIGH_TIER[shinyKey] = Value
      if Scripttable.Summon.AutoDelete.enable then
        task.spawn(_applyAutoDelete, rarity, "Shiny")
      end
    end,
  })
end

local AutoDeleteBtns = AutoDeleteHeader:Row({ Expanded = true })
AutoDeleteBtns:SmallButton({
  Text     = T.autodelete_save,
  Callback = function() Mainfunction.SaveConfig() end,
})
AutoDeleteBtns:SmallButton({
  Text     = T.autodelete_load,
  Callback = function() Mainfunction.LoadConfig() end,
})

Tab_Summon:Separator({ Text = T.pity_separator })
for _, cfg in ipairs(_PityConfig) do
  cfg.bar = Tab_Summon:ProgressBar({
    Label    = cfg.label,
    Value    = 0,
    MinValue = 0,
    MaxValue = 100,
    Format   = "%d",
  })
end

-- ========================================================================== --
-- Tab_Localscript

Mainfunction.BuildScriptList = function()
	Scripttable.Localscript.ScriptListTable:ClearRows()
	local path = Scripttable.Localscript.path
	local ok, files = pcall(listfiles, path)
	local scripts = {}
	if ok and files then
		for _, filePath in ipairs(files) do
			local name = filePath:match("([^/\\]+)$") or filePath
			if name:match("%.lua$") or name:match("%.txt$") then
				local excluded = false
				for _, suffix in ipairs(Scripttable.Localscript.Excluded) do
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
		local EmptyRow = Scripttable.Localscript.ScriptListTable:NextRow()
		EmptyRow:Column():Label({ Text = T.localscript_no_scripts })
		return
	end
	for _, script in ipairs(scripts) do
		local Row = Scripttable.Localscript.ScriptListTable:NextRow()

		-- 名稱欄：無 UIFlexItem → 佔剩餘空間
		local NameCol = Row:Column()
		NameCol:Label({ Text = script.name })

		-- 操作欄：固定 150px（資訊 + 運行 + 刪除並排）
		local ActionsCol = Row:Column()
		local actionsFrame = ActionsCol.RawObject
		local actionsFlex = Instance.new("UIFlexItem", actionsFrame)
		actionsFlex.FlexMode = Enum.UIFlexMode.None
		actionsFrame.Size = UDim2.new(0, 150, 1, 0)

		local ActionRow = ActionsCol:Row({ Expanded = true })

		ActionRow:SmallButton({
			Text = T.localscript_info,
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
						content = #out > 0 and table.concat(out, "\n") or T.localscript_info_no_block
					else
						content = T.localscript_info_no_block
					end
				else
					content = T.localscript_info_read_fail
				end
				local InfoModal = TabsWindow:PopupModal({ Title = script.name })
				InfoModal:Console({
					Value    = content,
					ReadOnly = true,
					RichText = true,
					Border   = true,
					Size     = UDim2.new(1, 0, 0, 150),
				})
				local BtnRow = InfoModal:Row({ Expanded = true })
				BtnRow:Button({
					Text     = T.localscript_info_close,
					Callback = function() InfoModal:ClosePopup() end,
				})
				BtnRow:Button({
					Text     = T.localscript_info_copy,
					Callback = function()
						if raw and pcall(setclipboard, raw) then
							Msg:Success(T.localscript_info_copied)
						end
					end,
				})
			end,
		})

		ActionRow:Button({
			Text = T.localscript_run,
			Callback = function()
				task.spawn(function()
					local ok2, err = pcall(function()
						loadstring(readfile(script.path))()
					end)
					if not ok2 then
						Msg:Warning(T.localscript_error .. ": " .. tostring(err))
					else
						Msg:Success(T.localscript_done .. ": " .. script.name)
					end
				end)
			end,
		})

		ActionRow:Button({
			Text = T.localscript_delete,
			Callback = function(delBtn)
				-- 第一次確認
				local Popup1 = Tab_Localscript:PopupModal({
					RelativeTo = delBtn,
				})
				Popup1:Separator({ Text = T.localscript_confirm_title })
				Popup1:Label({ Text = script.name, TextWrapped = true })
				local Row1 = Popup1:Row({ Expanded = true })
				Row1:Button({
					Text = T.localscript_confirm_yes,
					Callback = function()
						Popup1:ClosePopup()
						-- 第二次確認
						local Popup2 = Tab_Localscript:PopupModal({
							RelativeTo = delBtn,
						})
						Popup2:Separator({ Text = T.localscript_confirm_title2 })
						local Row2 = Popup2:Row({ Expanded = true })
						Row2:Button({
							Text = T.localscript_delete_final,
							Callback = function()
								Popup2:ClosePopup()
								local ok2, err = pcall(delfile, script.path)
								if ok2 then
									Msg:Success(T.localscript_deleted .. ": " .. script.name)
									Mainfunction.BuildScriptList()
								else
									Msg:Warning(T.localscript_delete_error .. ": " .. tostring(err))
								end
							end,
						})
						Row2:Button({
							Text = T.localscript_confirm_no,
							Callback = function()
								Popup2:ClosePopup()
							end,
						})
					end,
				})
				Row1:Button({
					Text = T.localscript_confirm_no,
					Callback = function()
						Popup1:ClosePopup()
					end,
				})
			end,
		})
	end
end

Tab_Localscript:Label({
	Text = T.localscript_path .. Scripttable.Localscript.path,
	TextSize = radioTextSize,
})

Tab_Localscript:Separator({ Text = T.localscript_list })

Tab_Localscript:Button({
	Text = T.localscript_refresh,
	Callback = function()
		Mainfunction.BuildScriptList()
		Msg:Success(T.localscript_refreshed)
	end,
})

Scripttable.Localscript.ScriptListTable = Tab_Localscript:Table({
	RowBackground = true,
	Border = true,
})

Mainfunction.BuildScriptList()

Scripttable.Summon.AutoDelete.UIReady = true