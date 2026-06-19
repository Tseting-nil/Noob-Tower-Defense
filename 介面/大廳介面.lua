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

-- ===== Langtable：i18n（語言獨立表格）=====
-- 語言相關全收進 Langtable：currentLang(語言選擇) / L(中英字串) / T(當前語言存取表)。
-- 仍保留 local currentLang、local T 兩個薄別名，讓既有上百處 T.xxx / currentLang 引用零改動。
local Langtable = {}

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

Langtable.L = {
	zh = {
		title             = "大廳腳本",
		tab_main          = "主頁",
		tab_summon       = "抽取",
    tab_shop          = "商店",
    tab_localscript   = "本地腳本管理",
    tab_webhook       = "Webhook",
		author            = "作者: Tseting-nil",
		shop_coins          = "金幣: %s",
		shop_coincrate      = "金幣箱子",
		shop_auto_coincrate = "自動購買金幣箱子",
		shop_speed          = "購買速度 = %.1f",
		shop_no_coins       = "金幣不足，已停止購買",
		shop_opencrate_sep  = "開啟箱子",
		shop_auto_opencrate = "自動開啟箱子",
		shop_no_crates      = "箱子不足，已停止開啟",
		shop_open_result    = "開箱結果",
		shop_clear          = "清除",
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
		show_item            = "顯示抽取物品",
		crate_filter_header  = "抽取通知過濾",
		crate_filter_loading = "讀取獎池內容中…",
		crate_stop_exclusive = "抽到獨家後停止",
		gamepass_save        = "儲存",
		gamepass_load        = "載入",
		gamepass_cfg_saved   = "已儲存通行證設定",
		gamepass_cfg_loaded  = "已載入通行證設定",
		gamepass_cfg_none    = "找不到通行證設定檔",
		gamepass_cfg_savefail = "通行證設定儲存失敗",
		msg_stop_exclusive   = "抽到獨家「%s」，已停止抽取",
		crate_pool_basic     = "普通",
		crate_pool_op        = "高級",
		crate_pool_field     = "獎池",
		crate_potion5        = "T5 藥水",
		crate_notify_tower   = "「%s」 [%s] %s",          -- 獎池, 稀有度, 名稱
		crate_notify_item    = "「%s」 %s ×%s",           -- 獎池, 名稱, 數量
		webhook_embed_crate_draw = "通行證箱子抽取",
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
		rarity_Mythic        = "神話",
		rarity_Secret        = "秘密",
		rarity_Exclusive     = "獨家",
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
		-- Webhook 介面
		webhook_url_input     = "輸入Webhook URL",
		webhook_url_unset     = "未設定 Webhook URL",
		webhook_url_label     = "Webhook URL: ",
		webhook_sep_settings  = "設置",
		webhook_master        = "總開關",
		webhook_mode_indep    = "獨立發送",
		webhook_mode_merge    = "合併發送",
		webhook_test          = "測試發送",
		webhook_send_stats    = "傳送統計",
		webhook_clear_stats   = "清除統計",
		webhook_sep_items     = "Webhook項目",
		webhook_item_crate    = "通行證箱子抽取",
		webhook_item_master   = "AutoMaster 完成",
		webhook_summon_header = "抽取塔通知設定",
		webhook_col_rarity    = "稀有度",
		webhook_col_normal    = "正常",
		webhook_col_inormal   = "獨立_正常",
		webhook_col_shiny     = "閃亮",
		webhook_col_ishiny    = "獨立_閃亮",
		webhook_adv_header    = "進階設定",
		webhook_bot_name      = "Bot 名稱",
		webhook_cooldown      = "冷卻秒數",
		webhook_sep_ping      = "頂級稀有 ping (@everyone)",
		webhook_sep_config    = "設定檔",
		webhook_save          = "儲存設定",
		webhook_load          = "載入設定",
		webhook_msg_no_url     = "尚未設定 Webhook URL",
		webhook_msg_test       = "已送出測試（上線通知）",
		webhook_msg_sent       = "已傳送總統計",
		webhook_msg_cleared    = "已清除總統計",
		webhook_msg_saved      = "已儲存 Webhook 設定",
		webhook_msg_save_fail  = "Webhook 設定儲存失敗",
		webhook_msg_no_config  = "找不到 Webhook 設定檔",
		webhook_msg_bad_config = "Webhook 設定檔格式錯誤",
		webhook_msg_loaded     = "已載入 Webhook 設定",
		-- Webhook embed 內容（送進 Discord）
		webhook_embed_summon   = "抽取結果",
		webhook_embed_crate    = "通行證箱子 — 高級獎池 (OP)",
		webhook_embed_item     = "物品",
		webhook_embed_amount   = "數量",
		webhook_embed_master   = "AutoMaster",
		webhook_embed_join     = "上線通知",
		webhook_embed_game     = "遊戲",
		webhook_embed_total    = "總抽取次數：",
		webhook_embed_deleted  = "(刪除)",
		webhook_title_total    = "總統計",
		webhook_title_run      = "本次抽取統計",
		webhook_title_master   = "AutoMaster 統計",
		-- Potion 分頁
		tab_potion        = "藥水",
		potion_exp        = "經驗",
		potion_coin       = "金幣",
		potion_dmg        = "傷害",
		potion_shiny      = "閃亮",
		potion_lucky      = "幸運",
		potion_refresh    = "重新整理",
		potion_level      = "製作等級",
		potion_gems       = "寶石",
		potion_corner     = [[等級\藥水]],
		-- Potion 自動製作
		potion_craft_sep     = "(藥水 | 等級)",
		potion_auto_craft    = "自動製作藥水",
		potion_craft_start   = "開始製作 %s",
		potion_craft_full    = "製作槽已滿，等待空位…",
		potion_craft_nogem   = "寶石不足 %d/%d",
		potion_craft_nolevel = "製作等級不足 %d/%d",
		potion_craft_noprev  = "上一級藥水不足 %s %d/3",
		potion_craft_fail    = "製作失敗：%s",
		potion_craft_nolobby = "尚未進入大廳…",
		potion_cfg_saved     = "已儲存藥水設定",
		potion_cfg_loaded    = "已載入藥水設定",
		potion_cfg_savefail  = "藥水設定儲存失敗",
		potion_cfg_none      = "找不到此玩家的藥水設定",
	},
	en = {
		title             = "Lobby Script",
		tab_main          = "Main",
		tab_summon       = "Summon",
    tab_shop          = "Shop",
    tab_localscript   = "Local Script Manager",
    tab_webhook       = "Webhook",
		author            = "Author: Tseting-nil",
		shop_coins          = "Coins: %s",
		shop_coincrate      = "Coin Crate",
		shop_auto_coincrate = "Auto Buy Coin Crate",
		shop_speed          = "Buy Speed = %.1f",
		shop_no_coins       = "Not enough coins, stopped",
		shop_opencrate_sep  = "Open Crates",
		shop_auto_opencrate = "Auto Open Crates",
		shop_no_crates      = "Not enough crates, stopped",
		shop_open_result    = "Open Results",
		shop_clear          = "Clear",
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
		show_item            = "Show Drawn Item",
		crate_filter_header  = "Draw Notify Filter",
		crate_filter_loading = "Loading crate rewards…",
		crate_stop_exclusive = "Stop after Exclusive",
		gamepass_save        = "Save",
		gamepass_load        = "Load",
		gamepass_cfg_saved   = "Gamepass config saved",
		gamepass_cfg_loaded  = "Gamepass config loaded",
		gamepass_cfg_none    = "Gamepass config not found",
		gamepass_cfg_savefail = "Gamepass config save failed",
		msg_stop_exclusive   = "Got Exclusive %s, stopped drawing",
		crate_pool_basic     = "Basic",
		crate_pool_op        = "Premium",
		crate_pool_field     = "Pool",
		crate_potion5        = "T5 Potion",
		crate_notify_tower   = "[%s] [%s] %s",            -- pool, rarity, name
		crate_notify_item    = "[%s] %s x%s",             -- pool, name, amount
		webhook_embed_crate_draw = "Battlepass Crate Draw",
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
		rarity_Mythic        = "Mythic",
		rarity_Secret        = "Secret",
		rarity_Exclusive     = "Exclusive",
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
		-- Webhook interface
		webhook_url_input     = "Enter Webhook URL",
		webhook_url_unset     = "Webhook URL not set",
		webhook_url_label     = "Webhook URL: ",
		webhook_sep_settings  = "Settings",
		webhook_master        = "Master",
		webhook_mode_indep    = "Independent",
		webhook_mode_merge    = "Merged",
		webhook_test          = "Test",
		webhook_send_stats    = "Send Stats",
		webhook_clear_stats   = "Clear Stats",
		webhook_sep_items     = "Webhook Items",
		webhook_item_crate    = "Battlepass Crate Draw",
		webhook_item_master   = "AutoMaster Done",
		webhook_summon_header = "Summon Notify Settings",
		webhook_col_rarity    = "Rarity",
		webhook_col_normal    = "Normal",
		webhook_col_inormal   = "Indep_Normal",
		webhook_col_shiny     = "Shiny",
		webhook_col_ishiny    = "Indep_Shiny",
		webhook_adv_header    = "Advanced",
		webhook_bot_name      = "Bot Name",
		webhook_cooldown      = "Cooldown (s)",
		webhook_sep_ping      = "Top-tier ping (@everyone)",
		webhook_sep_config    = "Config File",
		webhook_save          = "Save",
		webhook_load          = "Load",
		webhook_msg_no_url     = "Webhook URL not set",
		webhook_msg_test       = "Test sent (join notification)",
		webhook_msg_sent       = "Total stats sent",
		webhook_msg_cleared    = "Total stats cleared",
		webhook_msg_saved      = "Webhook config saved",
		webhook_msg_save_fail  = "Webhook config save failed",
		webhook_msg_no_config  = "Webhook config not found",
		webhook_msg_bad_config = "Webhook config format error",
		webhook_msg_loaded     = "Webhook config loaded",
		-- Webhook embed content (sent to Discord)
		webhook_embed_summon   = "Summon Result",
		webhook_embed_crate    = "Battlepass Crate — Premium (OP)",
		webhook_embed_item     = "Item",
		webhook_embed_amount   = "Amount",
		webhook_embed_master   = "AutoMaster",
		webhook_embed_join     = "Online Notification",
		webhook_embed_game     = "Game",
		webhook_embed_total    = "Total pulls: ",
		webhook_embed_deleted  = "(delete)",
		webhook_title_total    = "Total Stats",
		webhook_title_run      = "This Run Stats",
		webhook_title_master   = "AutoMaster Stats",
		-- Potion tab
		tab_potion        = "Potions",
		potion_exp        = "XP",
		potion_coin       = "Coins",
		potion_dmg        = "Damage",
		potion_shiny      = "Shiny",
		potion_lucky      = "Luck",
		potion_refresh    = "Refresh",
		potion_level      = "Crafting Lvl",
		potion_gems       = "Gems",
		potion_corner     = [[Tier\Potion]],
		-- Potion auto craft
		potion_craft_sep     = "(Potion | Tier)",
		potion_auto_craft    = "Auto Craft Potion",
		potion_craft_start   = "Crafting %s",
		potion_craft_full    = "Craft slots full, waiting…",
		potion_craft_nogem   = "Not enough gems %d/%d",
		potion_craft_nolevel = "Crafting level too low %d/%d",
		potion_craft_noprev  = "Need 3x %s (%d/3)",
		potion_craft_fail    = "Craft failed: %s",
		potion_craft_nolobby = "Not in lobby yet…",
		potion_cfg_saved     = "Potion config saved",
		potion_cfg_loaded    = "Potion config loaded",
		potion_cfg_savefail  = "Potion config save failed",
		potion_cfg_none      = "No saved potion config",
	},
}
Langtable.currentLang = currentLang
Langtable.T = Langtable.L[currentLang]
local T = Langtable.T  -- 存取別名（資料存於 Langtable.T）

-- ===== 新增功能 i18n（社群獎勵一鍵領 / 每日登入 / 商人自動掃貨）=====
-- 直接併入 T，避免動到上方龐大的 L 表
do
  local EXT = {
    zh = {
      auto_daily_login   = "自動領每日登入獎勵",
      claim_social       = "一鍵領社群獎勵",
      msg_daily_done     = "已領每日登入獎勵",
      msg_social_done    = "社群獎勵：領取 %d 項",
      msg_social_none    = "沒有可領的社群獎勵（可能皆已領）",
      shop_sep_merchant  = "商人",
      shop_auto_merchant = "自動掃貨（普通商人）",
      shop_auto_endless  = "自動掃貨（無盡商人）",
      shop_auto_refresh  = "掃完自動刷新（耗寶石）",
      shop_buy_hotdeal   = "購買 Hot Deal",
      msg_merchant_sweep = "商人：買了 %d 件",
      msg_hotdeal_ok     = "已購買 Hot Deal",
    },
    en = {
      auto_daily_login   = "Auto Claim Daily Login Reward",
      claim_social       = "Claim All Social Rewards",
      msg_daily_done     = "Daily login reward claimed",
      msg_social_done    = "Social rewards: claimed %d",
      msg_social_none    = "No social rewards to claim (maybe all claimed)",
      shop_sep_merchant  = "Merchant",
      shop_auto_merchant = "Auto Buy (Merchant)",
      shop_auto_endless  = "Auto Buy (Endless Merchant)",
      shop_auto_refresh  = "Auto Refresh When Cleared (Gems)",
      shop_buy_hotdeal   = "Buy Hot Deal",
      msg_merchant_sweep = "Merchant: bought %d",
      msg_hotdeal_ok     = "Hot Deal purchased",
    },
  }
  for k, v in pairs(EXT[currentLang] or EXT.zh) do T[k] = v end
end

local isMobile = game:GetService("UserInputService").TouchEnabled
	and not game:GetService("UserInputService").KeyboardEnabled
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
    -- 顯示抽取物品（每抽通知）設定
    Crate = {
      ShowItem        = false,   -- 主開關：每抽用 Msg 通知
      StopOnExclusive = false,   -- 抽到獨家(Exclusive)後自動停止抽取
    },
    -- 各獎池逐格獎勵（每期不同 → 啟動時動態解析填入）；每格 = { name, isTower, rarity, amount, index, notify }
    reward = { Basic = {}, Op = {} },
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
  Shop = {
    AutoBuyCoinCrate = false,
    BuyInterval = 1,
    BuyIndex = 1,        -- BuyCoinCrate 的參數＝選項序號：1=x1 / 2=x3 / 3=x10
    BuyTier  = "x1",     -- 對應 CoinCrate 的成本鍵
    CoinCrate = {x1 = {Coins = 1500 ,enabled = false}, x3 = {Coins = 4500, enabled = false}, x10 = {Coins = 15000, enabled = false}},
    -- 自動開箱（UseItem:InvokeServer(箱子名, 次數)；次數 1 或 3）
    AutoOpenCrate = false,
    OpenCrateName = nil,  -- 選中的箱子（啟動時取第一個）
    OpenAmount    = 1,    -- 一次開幾個 (1/3)
  },
  Localscript = {
    path = "Tsetingnil_script/NTD/Script", -- 用正斜線：腳本以 / 路徑儲存，部分手機執行器不會正規化 \
    Excluded = {"_Venus", "_Saturn", "_Mars"},
    ScriptListTable = nil,
    -- 自動刪除設定檔路徑
    ConfigDir  = [[Tsetingnil_script\NTD\Config]],
    ConfigPath = [[Tsetingnil_script\NTD\Config\Summon_AutoDelete.json]],
    WebhookConfigPath = [[Tsetingnil_script\NTD\Config\lobby_Webhook_Config.json]],
    PotionConfigPath  = [[Tsetingnil_script\NTD\Config\lobby_Potion_Config.json]],
    GamepassConfigPath = [[Tsetingnil_script\NTD\Config\lobby_Gamepass_Config.json]],
  },
  Potion = {
    T1 = {exp = 0, coin = 0, dmg = 0, shiny = 0, lucky = 0, time = 5 , spend = 25, level = 0},
    T2 = {exp = 0, coin = 0, dmg = 0, shiny = 0, lucky = 0, time = 60, spend = 50, level = 0},
    T3 = {exp = 0, coin = 0, dmg = 0, shiny = 0, lucky = 0, time = 420, spend = 75, level = 0},
    T4 = {exp = 0, coin = 0, dmg = 0, shiny = 0, lucky = 0, time = 1800, spend = 100, level = 25},
    T5 = {exp = 0, coin = 0, dmg = 0, shiny = 0, lucky = 0, time = 7200, spend = 250, level = 50},
    T6 = {exp = 0, coin = 0, dmg = 0, shiny = 0, lucky = 0},  -- 僅顯示數量（製作仍 T1-T5）
    MaxTier = 6,  -- 表格顯示到 T6（遊戲現有最高階）
    level = 1,
    gems = 0,
  },
  Webhook = {
    -- 常數 / 模組來源
    Rarities      = { Common = true, Rare = true, Epic = true, Legendary = true, Mythic = true, Secret = true },
    ShinyRarities = { Common = true, Rare = true, Epic = true, Legendary = true, Mythic = true, Secret = true },  -- 哪些稀有度有閃亮變體（決定 Webhook 表格是否顯示閃亮欄）
    TopRarities   = { Mythic = true, Secret = true, Exclusive = true },
    UIRarities    = { "Common", "Rare", "Epic", "Legendary", "Mythic", "Secret" },
    UIPing        = { "Mythic", "Secret" },
    ModuleURL     = "https://raw.githubusercontent.com/Tseting-nil/Noob-Tower-Defense/refs/heads/main/Webhook.lua",
    ModulePaths   = {
      "Tsetingnil_script/NTD/API/Webhook.lua",
      "Tsetingnil_script\\NTD\\API\\Webhook.lua",
    },
    -- 狀態 / 設定
    url      = "",
    enabled  = false,  -- 總開關：關閉時所有自動發送都停止
    merge    = true,   -- true=合併發送 / false=獨立即時
    items    = { CrateOP = false, AutoMaster = false },
    Summon   = {},     -- 每稀有度開關（下方 for 迴圈填入）
    ping     = { Mythic = false, Secret = false, Exclusive = false },  -- 頂級稀有 @everyone
    botName  = nil,
    cooldown = 2,
    buffer   = { master = {} },                 -- AutoMaster 合併緩衝
    stats    = { total = 0, towers = {} },      -- 總統計（兩模式都累計；手動傳送/清除）
    runStats = { total = 0, towers = {} },      -- 獨立計數（只合併；自動抽取停止時自動送+清）
    UIReady  = false,
  }
}
local Mainfunction = {}

-- ===== 新增功能狀態（社群獎勵 / 每日登入 / 商人掃貨）=====
Scripttable.DailyLogin = false
Scripttable.ClaimSocialRunning = false
Scripttable.Shop.AutoMerchant = false
Scripttable.Shop.AutoEndless = false
Scripttable.Shop.AutoRefreshMerchant = false

-- ========================================================================== --
-- Webhook 初始化（資料模型已在 Scripttable.Webhook 定義）
-- 每稀有度開關初始化
for r in pairs(Scripttable.Webhook.Rarities) do
  Scripttable.Webhook.Summon[r] = {
    Normal = false, Shiny = false,
    IndependentNormal = false, IndependentShiny = false,
  }
end

-- 載入 Webhook 模組（優先 ModuleURL，否則本地檔；都失敗用空殼避免 UI 崩潰）
local Webhook
do
  if getgenv().NTD_WebhookModule then
    Webhook = getgenv().NTD_WebhookModule
  else
    local loaded
    local url = Scripttable.Webhook.ModuleURL
    if url ~= "" then
      local ok, mod = pcall(function() return loadstring(game:HttpGet(url))() end)
      if ok and type(mod) == "table" then loaded = mod end
    end
    if not loaded and isfile and readfile then
      for _, p in ipairs(Scripttable.Webhook.ModulePaths) do
        local okf = pcall(isfile, p)
        if okf and isfile(p) then
          local ok, mod = pcall(function() return loadstring(readfile(p))() end)
          if ok and type(mod) == "table" then loaded = mod break end
        end
      end
    end
    Webhook = loaded
    if Webhook then getgenv().NTD_WebhookModule = Webhook end
  end
end
if type(Webhook) ~= "table" then
  warn("[Webhook] 模組載入失敗，Webhook 功能停用")
  Webhook = setmetatable({ Config = {}, Game = {} }, {
    __index = function() return function() return false end end,
  })
end

-- 把大廳的 i18n 稀有度名稱傳給模組（webhook 內容跟著語言走；塔名無翻譯維持原文）
do
  local rarityNames = {}
  for r in pairs(Scripttable.Webhook.Rarities) do
    rarityNames[r] = T["rarity_" .. r] or r
  end
  Webhook:SetConfig({
    rarityNames = rarityNames,
    shinyLabel  = T.rarity_shiny or "閃亮",
    Text = {  -- embed 內容翻譯
      summon  = T.webhook_embed_summon,
      crateOP = T.webhook_embed_crate,
      item    = T.webhook_embed_item,
      amount  = T.webhook_embed_amount,
      master  = T.webhook_embed_master,
      join    = T.webhook_embed_join,
      game    = T.webhook_embed_game,
      total   = T.webhook_embed_total,
      deleted = T.webhook_embed_deleted,
      session = T.webhook_title_total,
    },
  })
end

-- 計數工具：以 (稀有度+閃亮+塔名) 為單位累加到指定統計表
Mainfunction.statAdd = function(s, rarity, shiny, tower)
  s.total = s.total + 1
  local key = (shiny and "S|" or "N|") .. tostring(rarity) .. "|" .. tostring(tower)
  local rec = s.towers[key]
  if not rec then
    rec = { rarity = rarity, shiny = shiny, tower = tower, count = 0 }
    s.towers[key] = rec
  end
  rec.count = rec.count + 1
end

-- 每抽計數：總統計(兩模式都算)；獨立計數(只合併模式)
Mainfunction.webhookStat = function(rarity, shiny, tower)
  local W = Scripttable.Webhook
  Mainfunction.statAdd(W.stats, rarity, shiny, tower)
  if W.merge then Mainfunction.statAdd(W.runStats, rarity, shiny, tower) end
end

-- 即時提醒條件：獨立通知(任何模式) 或 獨立發送模式 + 正常/閃亮
Mainfunction.webhookShouldSend = function(rarity, shiny)
  local cfg = Scripttable.Webhook.Summon[rarity]
  if not cfg then return false end
  if shiny then
    if cfg.IndependentShiny then return true end
    if (not Scripttable.Webhook.merge) and cfg.Shiny then return true end
  else
    if cfg.IndependentNormal then return true end
    if (not Scripttable.Webhook.merge) and cfg.Normal then return true end
  end
  return false
end

-- 自動刪除標記：有開自動刪除且該 (稀有度,閃亮) 在刪除清單 → 統計行加「(刪除)」
Mainfunction.webhookMarkDelete = function(rarity, shiny)
  local AD = Scripttable.Summon.AutoDelete
  if not (AD and AD.enable) then return false end
  local key = shiny and ("Shiny_" .. rarity) or rarity
  return AD.HIGH_TIER[key] == true
end

-- 合併模式：自動抽取停止 → 送出「獨立計數」，送出成功才清空（總統計不動）
Mainfunction.webhookFlushRun = function()
  local W = Scripttable.Webhook
  if (W.runStats.total or 0) <= 0 then return end
  if Webhook:SendSessionSummary(W.runStats, { title = T.webhook_title_run, markDelete = Mainfunction.webhookMarkDelete }) then
    W.runStats = { total = 0, towers = {} }
  end
end

-- 處理 AutoMaster 完成（不進統計；維持原本即時/緩衝）
Mainfunction.webhookHandleMaster = function(tower, mastery)
  local W = Scripttable.Webhook
  if not W.enabled then return end
  if not W.items.AutoMaster then return end
  if W.merge then
    table.insert(W.buffer.master, { tower = tower, mastery = mastery })
  else
    Webhook:SendMaster({ { tower = tower, mastery = mastery } })
  end
end

Mainfunction.webhookFlushMaster = function()
  local W = Scripttable.Webhook
  if #W.buffer.master == 0 then return end
  local batch = W.buffer.master
  W.buffer.master = {}
  Webhook:SendMaster(batch, { title = T.webhook_title_master .. " (" .. #batch .. ")" })
end

-- 監看自動程序停止 → 合併模式自動送「獨立計數」、AutoMaster 緩衝沖出
task.spawn(function()
  local prevSummon, prevMaster = false, false
  while true do
    local nowSummon = Scripttable.Summon.AutoRunning == true
    local nowMaster = Scripttable.AutoMaster == true
    if Scripttable.Webhook.enabled then
      if prevSummon and not nowSummon then Mainfunction.webhookFlushRun() end
      if prevMaster and not nowMaster then Mainfunction.webhookFlushMaster() end
    end
    prevSummon, prevMaster = nowSummon, nowMaster
    task.wait(0.5)
  end
end)

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


-- ===== 社群獎勵一鍵領（ClaimReward）=====
-- Roblox 無法在 server 端驗證「按讚/追蹤/收藏/通知/邀請」→ server 多半直接給；
-- Group 例外（server 用 GetRank 驗證，需真的在群組）。一次性獎勵：已領的（currentPlrData.Rewards[key]）跳過。
Mainfunction.ClaimSocialRewards = function()
  if Scripttable.ClaimSocialRunning then return end
  Scripttable.ClaimSocialRunning = true
  local ClaimReward = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("ClaimReward")
  local Constants = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("Constants"))
  -- 動態取得獎勵清單（每期可能不同），失敗則用已知清單
  local keys = {}
  local okR, Rewards = pcall(require, ReplicatedStorage.Modules.Data.Rewards)
  if okR and type(Rewards) == "table" then
    for k in pairs(Rewards) do keys[#keys + 1] = k end
  else
    keys = { "Like", "Favourite", "Notifications", "Invite", "Follow", "Group" }
  end
  local claimed = (Constants.currentPlrData and Constants.currentPlrData.Rewards) or {}
  -- 直呼 remote 會繞過遊戲 UI handler → 手動鏡像 UpdateRewards 的 UI（Verify/Invite→Verified）
  local List
  pcall(function() List = UI.Frames.Rewards.Container.Info.List end)
  local function markClaimedUI(key)
    if not List then return end
    local entry = List:FindFirstChild(key)
    local c = entry and entry:FindFirstChild("Container")
    if not c then return end
    if c:FindFirstChild("Invite")   then c.Invite.Visible = false end
    if c:FindFirstChild("Verify")   then c.Verify.Visible = false end
    if c:FindFirstChild("Verified") then c.Verified.Visible = true end
  end
  local count = 0
  for _, key in ipairs(keys) do
    if claimed[key] ~= true then
      local ok, res = pcall(function() return ClaimReward:InvokeServer(key) end)
      if ok and res then
        count = count + 1
        claimed[key] = true            -- claimed 即 currentPlrData.Rewards，同步資料層
        pcall(markClaimedUI, key)       -- 同步畫面層
        print("[Social] 領取 " .. tostring(key))
      else
        print("[Social] 失敗/未達成 " .. tostring(key))
      end
      task.wait(0.4)  -- 輕微間隔，避免一次連發
    end
  end
  if count > 0 then
    Msg:Success(string.format(T.msg_social_done, count))
  else
    Msg:Warning(T.msg_social_none)
  end
  Scripttable.ClaimSocialRunning = false
end

-- ===== 自動領每日登入獎勵（ClaimDailyReward）=====
-- 一天一次；開啟後嘗試領取，未到/已領 server 回傳 false，等待後重試（跨午夜長掛也能領）。
Mainfunction.DailyLogin = function()
  local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("ClaimDailyReward")
  -- 直呼 remote 會繞過遊戲 UI handler → 成功後手動鏡像遊戲 u19 的每日簽到 UI
  -- （回傳 data.Day = 下次可領的天；data.Day-1 即剛領的天，標記 Claimed；跨週 Day=1 則整排重置）
  local function markDailyUI(data)
    if type(data) ~= "table" or not data.Day then return end
    local Rewards
    pcall(function() Rewards = UI.Frames.DailyRewards.Container.Info.Container.Rewards end)
    if not Rewards then return end
    local prev = data.Day - 1
    if prev == 0 then
      prev = 7
      for _, v in ipairs(Rewards:GetChildren()) do
        if v:IsA("Frame") then
          v.Frame.Container.Claimed.Visible = false
          v.Frame.Container.Locked.Visible = true
        end
      end
    end
    if prev ~= 7 then
      local r = Rewards:FindFirstChild(tostring(prev))
      if r then r.Frame.Container.Claimed.Visible = true; r.Frame.Container.Locked.Visible = false end
    end
    local cur = Rewards:FindFirstChild(tostring(data.Day))
    if cur then cur.Frame.Container.Locked.Visible = false end
  end
  while Scripttable.DailyLogin do
    local pok, success, data = pcall(function() return Remote:InvokeServer() end)
    if pok and success then
      pcall(markDailyUI, data)
      Msg:Success(T.msg_daily_done)
    end
    -- 領到或未到都等久一點再試（每日冷卻以小時計）；可被關閉即時中止
    for _ = 1, 60 do
      if not Scripttable.DailyLogin then return end
      task.wait(5)
    end
  end
end

-- ===== 商人自動掃貨（BuyMerchant / BuyEndlessShop / BuyHotDeal）=====
-- 商品 = merchantContainer 底下的 Frame，.Name 即 item id；已買的 Container.Info.Bought.Visible=true。
-- 直接呼叫 remote（非點按鈕），server 自行擋買不起的（回傳 false）→ 這裡只逐件嘗試。
do
  local function merchantContainer()
    local m = UI.Frames:FindFirstChild("Merchant")
    m = m and m:FindFirstChild("Container")
    m = m and m:FindFirstChild("Info")
    return m and m:FindFirstChild("Container")
  end
  local function endlessContainer()
    local m = UI.Frames:FindFirstChild("EndlessMerchant")
    m = m and m:FindFirstChild("Container")
    m = m and m:FindFirstChild("Info")
    return m and m:FindFirstChild("Merchant")
  end

  -- 掃一次容器內所有未購商品，回傳成功買到的件數
  local function sweep(getContainer, remoteName)
    local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild(remoteName)
    local container = getContainer()
    if not container then return 0 end
    local bought = 0
    for _, f in ipairs(container:GetChildren()) do
      if f:IsA("Frame") and f.Name ~= "Template" then
        local boughtFlag = f:FindFirstChild("Container")
          and f.Container:FindFirstChild("Info")
          and f.Container.Info:FindFirstChild("Bought")
        if not (boughtFlag and boughtFlag.Visible) then
          local ok, success = pcall(function() return Remote:InvokeServer(f.Name) end)
          if ok and success then
            bought = bought + 1
            if boughtFlag then boughtFlag.Visible = true end  -- 標記已買，避免同輪重複
            task.wait(0.35)
          end
        end
      end
    end
    return bought
  end

  Mainfunction.AutoMerchant = function()
    local RefreshEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("BuyRefreshMerchant")
    while Scripttable.Shop.AutoMerchant do
      local total = sweep(merchantContainer, "BuyMerchant")
      -- 掃完且開了自動刷新 → 花寶石刷新換新貨，再掃；server 沒寶石會擋（會持續耗寶石，請謹慎）
      if total == 0 and Scripttable.Shop.AutoRefreshMerchant then
        RefreshEvent:FireServer()
        task.wait(1.2)
        total = sweep(merchantContainer, "BuyMerchant")
      end
      if total > 0 then Msg:Success(string.format(T.msg_merchant_sweep, total)) end
      task.wait(Scripttable.Shop.BuyInterval or 1)
    end
  end

  Mainfunction.AutoEndlessMerchant = function()
    while Scripttable.Shop.AutoEndless do
      local total = sweep(endlessContainer, "BuyEndlessShop")
      if total > 0 then Msg:Success(string.format(T.msg_merchant_sweep, total)) end
      task.wait(Scripttable.Shop.BuyInterval or 1)
    end
  end

  Mainfunction.BuyHotDeal = function()
    local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("BuyHotDeal")
    local ok, success, msg = pcall(function() return Remote:InvokeServer() end)
    if ok and success then
      Msg:Success(T.msg_hotdeal_ok)
    elseif ok and success == false and msg then
      Msg:Warning(tostring(msg))
    end
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
				local Basic_Claimable = Reward.Basic.Container.Item.Claimable -- 普通(免費)可領取提示
				local Basic_Claimed = Reward.Basic.Container.Item.Frame.Container.Claimed -- 普通(免費)已領取圖標
				local Premium_Locked = Reward.Premium.Container.Item.Frame.Container.Locked -- 付費鎖定圖標
				local Premium_Clicker = Reward.Premium.Container.Item.Frame.Container.Clicker -- 付費可領取圖標
				local Premium_Claimable = Reward.Premium.Container.Item.Claimable -- 付費可領取提示
				local Premium_Claimed = Reward.Premium.Container.Item.Frame.Container.Claimed -- 付費已領取圖標
				local tier = tonumber(Reward.Name)
				if tier then
					local BasicCanClaim = not Basic_Claimed.Visible and (Basic_Clicker.Visible or Basic_Claimable.Visible)
					local PremiumCanClaim = not Premium_Claimed.Visible and not Premium_Locked.Visible and (Premium_Clicker.Visible or Premium_Claimable.Visible)
					--print("檢查等級獎勵 " .. tostring(tier) .. "：", "普通可領取=" .. tostring(BasicCanClaim), "普通已領取=" .. tostring(Basic_Claimed.Visible), "高級可領取=" .. tostring(PremiumCanClaim), "高級已領取=" .. tostring(Premium_Claimed.Visible))
					if PremiumCanClaim then
						ReplicatedStorage.Remotes.Functions.ClaimTier:InvokeServer(tier)
						Premium_Clicker.Visible = false
            Premium_Claimable.Visible = false
						Premium_Claimed.Visible = true
						Basic_Clicker.Visible = false
            Basic_Claimable.Visible = false
						Basic_Claimed.Visible = true
						print("領取等級 " .. tier .. " 高級獎勵")
					elseif BasicCanClaim then
						ReplicatedStorage.Remotes.Functions.ClaimTier:InvokeServer(tier)
						Basic_Clicker.Visible = false
            Basic_Claimable.Visible = false
						Basic_Claimed.Visible = true
						print("領取等級 " .. tier .. " 普通獎勵")
					end
					if tier == 30 and not BasicCanClaim and not PremiumCanClaim then
						Msg:Success(T.msg_pass_done)
						print("已領取所有等級獎勵")
						return
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

-- ========== AutoMaster ==========
Scripttable.AutoMaster = false

-- getgc 一次掃齊所有需要的物件（合併原本兩趟 getgc）：
--   資料模組：towersData(getTowerData+Rarities) / itemsModule(Items+Rarities) / battlepassModule(Crates+Tiers)
--   Handler 更新函數：Gametable.updateUnitsList / Gametable.updateUnitsInfo / Gametable.updateMasteryTab（以常數比對）
-- 原本兩趟 getgc(true) 各自收集全部 GC 物件，且第二趟對每個 function 都跑 getconstants、又無提早結束 → 啟動卡頓。
-- 改成「單趟 + 找齊即 break + 常數做成集合一次比對」，並 task.defer 到 UI 建完後才掃，避免擋住面板出現。

task.defer(function()
  local needFuncs = true
  for _, obj in ipairs(getgc(true)) do
    local t = type(obj)
    if t == "table" then
      if not Gametable.TowersData and rawget(obj, "getTowerData") and rawget(obj, "Rarities") then
        Gametable.TowersData = obj
      end
      if not Gametable.ItemsData and rawget(obj, "Items") and rawget(obj, "Rarities") then
        Gametable.ItemsData = obj
      end
      if not Gametable.BattlepassData and rawget(obj, "Crates") and rawget(obj, "Tiers") then
        Gametable.BattlepassData = obj
      end
    elseif t == "function" and needFuncs then
      local ok, consts = pcall(getconstants, obj)
      if ok and consts then
        -- 常數做成集合，一次掃描即可同時比對三個函數（取代原本每個函數各跑一輪 ipairs）
        local set = {}
        for _, c in ipairs(consts) do set[c] = true end
        if not Gametable.updateUnitsList and set.MutationKey and set.HoverIndex then
          Gametable.updateUnitsList = obj
        end
        if not Gametable.updateUnitsInfo and set.previousSelectedUnit and set.SHINY_PRICE_MULTIPLIER then
          Gametable.updateUnitsInfo = obj
        end
        if not Gametable.updateMasteryTab and set.GlobalCounts and set.cycleIndex then
          Gametable.updateMasteryTab = obj
        end
        needFuncs = not (Gametable.updateUnitsList and Gametable.updateUnitsInfo and Gametable.updateMasteryTab)
      end
    end
    -- 全部找齊就停，不必掃完整個 GC 清單
    if Gametable.TowersData and Gametable.ItemsData and Gametable.BattlepassData and not needFuncs then break end
  end
end)

Mainfunction.AutoMaster = function()
	-- getgc 掃描是背景進行（task.defer），等 Gametable.TowersData 就緒再開始；正常情況早已完成
	local waited = 0
	while not Gametable.TowersData and waited < 5 do task.wait(0.1); waited = waited + 0.1 end
	if not Gametable.TowersData then
		Msg:Warning(string.format(T.msg_master_fail, "towersData"))
		Scripttable.AutoMaster = false
		return
	end
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
				local nextData = Gametable.TowersData.Masteries[mastery + 1]
				if nextData and data.Level >= nextData.Level then
					local success = MasterRemote:InvokeServer(id)
					if success == true then
						data.Mastery = mastery + 1
						data.Level = 1
						data.XP = 0
						if Gametable.updateMasteryTab then pcall(Gametable.updateMasteryTab) end
						if Gametable.updateUnitsInfo then pcall(Gametable.updateUnitsInfo) end
						if Gametable.updateUnitsList then pcall(Gametable.updateUnitsList) end
						Msg:Success(string.format(T.msg_master_ok, data.Tower, nextData.Name))
						Mainfunction.webhookHandleMaster(data.Tower, nextData.Name)
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

Mainfunction.getRarity = function(towerName)
  if not Gametable.TowersData then return "Unknown" end
  local ok, data = pcall(Gametable.TowersData.getTowerData, towerName)
  if ok and type(data) == "table" then return data.Rarity end
  return "Unknown"
end

Mainfunction.formatTowerName = function(s)
  return s:gsub("(%l)(%u)", "%1 %2")
end

-- ===== 通行證箱子：抽取物品解析 / 過濾 / 通知 ===== --
-- 後備解析：getgc 沒抓到 battlepassModule 時改讀 UI 那一格（塔→Hover.Title 是 id，可查稀有度；道具→只有顯示名）
Mainfunction.resolveCrateRewardUI = function(crateType, rewardIndex)
  local ok, crateUI = pcall(function() return UI.Frames.Pass.Tabs.Crate.Container end)
  if not ok or not crateUI then return nil end
  local container = (crateType == "OP") and crateUI:FindFirstChild("OP") or crateUI:FindFirstChild("Basic")
  local slot = container and container:FindFirstChild(tostring(rewardIndex))
  if not slot then return nil end
  local rawName = slot.Hover.Title.Text
  local info = { pool = crateType, index = rewardIndex, item = rawName }
  local okTd, td = pcall(function() return Gametable.TowersData and Gametable.TowersData.getTowerData(rawName) end)
  if okTd and type(td) == "table" and td.Rarity then
    info.isTower = true
    info.name    = Mainfunction.formatTowerName(rawName)
    info.rarity  = td.Rarity
  else
    info.isTower = false
    info.name    = rawName
    local amt = slot.Frame.Container:FindFirstChild("Amount")
    if amt and amt.Visible and #amt.Text > 0 then
      info.amount = (amt.Text:gsub("[+,]", ""))
    end
  end
  return info
end

-- 主解析：直接讀 battlepassModule.Crates[池][index] = {Type, Item, Amount, Chance}
-- 回傳 { pool, isTower, name, rarity, amount, item }；找不到資料 → 退回 UI 解析
Mainfunction.resolveCrateReward = function(crateType, rewardIndex)
  local crates = Gametable.BattlepassData and Gametable.BattlepassData.Crates
  local reward = crates and crates[crateType] and crates[crateType][rewardIndex]
  if type(reward) ~= "table" then
    return Mainfunction.resolveCrateRewardUI(crateType, rewardIndex)
  end
  local info = { pool = crateType, index = rewardIndex, isTower = reward.Type == "Tower", item = reward.Item, amount = reward.Amount }
  if info.isTower then
    info.name   = Mainfunction.formatTowerName(reward.Item)
    info.rarity = Mainfunction.getRarity(reward.Item)
    info.amount = nil                       -- 塔無數量
  elseif reward.Item == "Potion5" then
    info.name   = T.crate_potion5           -- 遊戲內為循環顯示的 T5 藥水
    info.rarity = "Mythic"
  else
    local idata = Gametable.ItemsData and Gametable.ItemsData.Items and Gametable.ItemsData.Items[reward.Item]
    info.name   = (idata and idata.Name) or tostring(reward.Item)
    info.rarity = idata and idata.Rarity or nil
  end
  return info
end

-- 過濾：查 Scripttable.Gamepass.reward[池][index].notify（清單於啟動時依實際獎池動態建立）
Mainfunction.crateNotable = function(info)
  local key  = (info.pool == "OP") and "Op" or "Basic"
  local pool = Scripttable.Gamepass.reward[key]
  local entry = pool and info.index and pool[info.index]
  if entry then return entry.notify == true end
  return info.pool == "OP"   -- reward 表還沒建好時的後備：先通知 OP
end

-- 過濾 UI（在 reward 表建立後才填入；每期獎勵不同所以動態產生）
Mainfunction.buildCrateFilterUI = function()
  local header = Scripttable.crateFilterHeader
  if not header then return end
  if Scripttable.crateFilterLoading then Scripttable.crateFilterLoading.Visible = false end
  for _, key in ipairs({ "Basic", "Op" }) do
    local list = Scripttable.Gamepass.reward[key]
    if list and #list > 0 then
      header:Separator({ Text = (key == "Op") and T.crate_pool_op or T.crate_pool_basic })
      local tbl = header:Table({ MaxColumns = 2 })   -- 兩欄等寬對齊
      local row
      for i = 1, #list do
        if (i % 2) == 1 then row = tbl:NextRow() end
        local entry = list[i]
        local label
        if entry.isTower and entry.rarity then
          label = string.format("[%s] %s", (T["rarity_" .. entry.rarity] or entry.rarity), entry.name)
        elseif entry.amount ~= nil then
          label = string.format("%s ×%s", entry.name, tostring(entry.amount))
        else
          label = entry.name
        end
        entry._ctrl = row:NextColumn():Radiobox({
          Value = entry.notify == true,
          Label = tostring(label),
          TextSize = 14,
          Callback = function(self, v) entry.notify = v end,
        })
      end
    end
  end
end

-- ===== 通行證設定存檔（lobby_Gamepass_Config.json）：顯示開關 / 獨家停止 / 逐格通知 ===== --

-- 把已存的逐格通知（以物品 id 為 key）套回 reward 表
Mainfunction.applyGamepassNotify = function()
  local saved = Scripttable.Gamepass._savedNotify
  if type(saved) ~= "table" then return end
  for _, key in ipairs({ "Basic", "Op" }) do
    local s = saved[key]
    if type(s) == "table" then
      for _, entry in ipairs(Scripttable.Gamepass.reward[key]) do
        local v = s[tostring(entry.item)]
        if type(v) == "boolean" then entry.notify = v end
      end
    end
  end
end

-- 依目前 Scripttable 值刷新 UI 控件（控件還沒建立則略過）
Mainfunction.refreshGamepassUI = function()
  local G = Scripttable.Gamepass
  if Scripttable.gpShowItemCtrl then pcall(function() Scripttable.gpShowItemCtrl:SetValue(G.Crate.ShowItem) end) end
  if Scripttable.gpStopCtrl     then pcall(function() Scripttable.gpStopCtrl:SetValue(G.Crate.StopOnExclusive) end) end
  for _, key in ipairs({ "Basic", "Op" }) do
    for _, entry in ipairs(G.reward[key]) do
      if entry._ctrl then pcall(function() entry._ctrl:SetValue(entry.notify == true) end) end
    end
  end
end

Mainfunction.SaveGamepassConfig = function(silent)
  for _, dir in ipairs({ "Tsetingnil_script", "Tsetingnil_script\\NTD", "Tsetingnil_script\\NTD\\Config" }) do
    if isfolder and makefolder and not isfolder(dir) then pcall(makefolder, dir) end
  end
  local G = Scripttable.Gamepass
  local notify = { Basic = {}, Op = {} }
  for _, key in ipairs({ "Basic", "Op" }) do
    for _, entry in ipairs(G.reward[key]) do
      notify[key][tostring(entry.item)] = entry.notify == true
    end
  end
  local snap = {
    ShowItem        = G.Crate.ShowItem,
    StopOnExclusive = G.Crate.StopOnExclusive,
    notify          = notify,
  }
  local ok, encoded = pcall(function() return HttpService:JSONEncode(snap) end)
  if not ok then
    if not silent then Msg:Warning(T.gamepass_cfg_savefail) end
    return false
  end
  local ok2, err = pcall(writefile, Scripttable.Localscript.GamepassConfigPath, encoded)
  if ok2 then
    if not silent then Msg:Success(T.gamepass_cfg_saved) end
    return true
  end
  if not silent then Msg:Warning(T.gamepass_cfg_savefail .. ": " .. tostring(err)) end
  return false
end

Mainfunction.LoadGamepassConfig = function(silent)
  local path = Scripttable.Localscript.GamepassConfigPath
  if not (isfile and readfile and isfile(path)) then
    if not silent then Msg:Warning(T.gamepass_cfg_none) end
    return false
  end
  local rok, raw = pcall(readfile, path)
  if not rok or not raw or raw == "" then
    if not silent then Msg:Warning(T.gamepass_cfg_none) end
    return false
  end
  local dok, data = pcall(function() return HttpService:JSONDecode(raw) end)
  if not dok or type(data) ~= "table" then
    if not silent then Msg:Warning(T.gamepass_cfg_none) end
    return false
  end
  local G = Scripttable.Gamepass
  if type(data.ShowItem)        == "boolean" then G.Crate.ShowItem = data.ShowItem end
  if type(data.StopOnExclusive) == "boolean" then G.Crate.StopOnExclusive = data.StopOnExclusive end
  if type(data.notify)          == "table"   then G._savedNotify = data.notify end
  Mainfunction.applyGamepassNotify()   -- reward 已建立才有效（啟動時為空，留待建表後再套）
  Mainfunction.refreshGamepassUI()     -- 控件已建立才有效
  if not silent then Msg:Success(T.gamepass_cfg_loaded) end
  return true
end

-- 啟動時先讀檔（在 UI 建立前 → 控件初值直接吃載入值；逐格通知於建表後套用）
Mainfunction.LoadGamepassConfig(true)

-- 螢幕通知（名稱／數量／池子，塔再帶稀有度）
Mainfunction.crateNotify = function(info)
  local poolLabel = (info.pool == "OP") and T.crate_pool_op or T.crate_pool_basic
  local label
  if info.isTower then
    local rname = (info.rarity and (T["rarity_" .. info.rarity] or info.rarity)) or "?"
    label = string.format(T.crate_notify_tower, poolLabel, rname, info.name)
  else
    label = string.format(T.crate_notify_item, poolLabel, info.name, tostring(info.amount or "?"))
  end
  print("[DrawBox] " .. label)
  Msg:Success(label)
end

-- Webhook：受總開關 + items.CrateOP 控制；用模組的公開 Webhook:Send 自組 embed（含獎池欄）
Mainfunction.webhookCrateDraw = function(info)
  local Wt = Scripttable.Webhook
  if not (Wt.enabled and Wt.items.CrateOP) then return end
  if not Webhook:IsValid() then return end
  local poolLabel = (info.pool == "OP") and T.crate_pool_op or T.crate_pool_basic
  local fields = {
    { name = T.webhook_embed_item, value = tostring(info.name), inline = true },
  }
  if (not info.isTower) and info.amount ~= nil then
    fields[#fields + 1] = { name = T.webhook_embed_amount, value = "+" .. tostring(info.amount), inline = true }
  end
  if info.rarity then
    fields[#fields + 1] = { name = T.webhook_col_rarity, value = (T["rarity_" .. info.rarity] or info.rarity), inline = true }
  end
  fields[#fields + 1] = { name = T.crate_pool_field, value = poolLabel, inline = true }
  local ping = info.rarity and Wt.ping[info.rarity]
  Webhook:Send({
    title   = T.webhook_embed_crate_draw,
    fields  = fields,
    color   = (info.rarity and Webhook.RarityColor and Webhook.RarityColor[info.rarity]) or nil,
    content = (ping and Webhook.Config and Webhook.Config.pingText) or nil,
  })
end

-- Hook
Gametable.SpinRemote    = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("SpinBattlepassCrate")
Gametable.EnchantRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("Enchant")
Gametable.SummonRemote  = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("Summon")
Scripttable.lastSpinData = nil
Scripttable.PityConfig = {
	{ key = "Legendary", label = currentLang == "zh" and "傳奇" or "Legendary", max = 50    },
	{ key = "Mythic",    label = currentLang == "zh" and "神話" or "Mythic",    max = 400   },
	{ key = "Secret",    label = currentLang == "zh" and "秘密" or "Secret",    max = 10000 },
}

Scripttable.summonResultQueue = {}
game:GetService("RunService").Heartbeat:Connect(function()
	if #Scripttable.summonResultQueue == 0 then return end
	local items = Scripttable.summonResultQueue
	Scripttable.summonResultQueue = {}
	for _, data in ipairs(items) do
		local pity, result = data.pity, data.result
		if type(pity) == "table" then
			for _, cfg in ipairs(Scripttable.PityConfig) do
				if cfg.bar and pity[cfg.key] ~= nil then
					local v   = tonumber(pity[cfg.key]) or 0
					local pct = v / cfg.max * 100
					cfg.bar:SetValue(pct)
					cfg.bar:SetValueText(string.format("%d / %d (%.2f%%)", v, cfg.max, pct))
				end
			end
		end
		local n = Scripttable.Summon.notify
		if type(result) == "table" then
			local W = Scripttable.Webhook
			local wbImmediate, wbOrder, wbPing = {}, {}, false
			for _, entry in ipairs(result) do
				local tower    = entry.tower or "?"
				local shiny    = entry.shiny == true
				local rarity   = Mainfunction.getRarity(tower)

				-- 螢幕通知
				if n.enable then
					local rarityHit = n.HIGH_TIER[rarity] == true
					local shinyHit  = shiny and n.NOTIFY_SHINY
					if rarityHit or shinyHit then
						local displayName = Mainfunction.formatTowerName(tower)
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

				-- Webhook 統計（含塔名）
				Mainfunction.webhookStat(rarity, shiny, tower)

				-- Webhook 即時提醒：獨立通知(任何模式) 或 獨立發送+正常/閃亮；同批同塔合併 ×N
				if W.enabled and Mainfunction.webhookShouldSend(rarity, shiny) then
					local key = (shiny and "S|" or "N|") .. rarity .. "|" .. tower
					local rec = wbImmediate[key]
					if not rec then
						rec = { tower = tower, rarity = rarity, shiny = shiny, count = 0 }
						wbImmediate[key] = rec
						wbOrder[#wbOrder + 1] = rec
					end
					rec.count = rec.count + 1
					if W.ping[rarity] then wbPing = true end
				end
			end
			-- 整批一次送出（重複的塔以 ×N 呈現，不拆成多則）
			if #wbOrder > 0 then
				Webhook:SendSummon(wbOrder, { ping = wbPing })
			end
		end
	end
end)

Scripttable.oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
	if getnamecallmethod() == "PromptSetFavorite" then
		print("[Hook] PromptSetFavorite 被攔截，blockFavouritePrompt =", Scripttable.blockFavouritePrompt)
		if Scripttable.blockFavouritePrompt then
			return
		end
	end
	if getnamecallmethod() == "InvokeServer" then
		if self == Gametable.SpinRemote then
			local ok, data = Scripttable.oldNamecall(self, ...)
			if ok and type(data) == "table" then
				Scripttable.lastSpinData = data
			end
			return ok, data
		end
		if self == Gametable.EnchantRemote then
			local result = Scripttable.oldNamecall(self, ...)
			if Scripttable.Skip_Enchanting then
				task.spawn(function()
					local SkipBtn = UI.Frames.Enchanting.Tabs.Container.Info.Container.Info.Buttons.Skip
					local t = 0
					repeat task.wait(0.1)
t += 0.1 until SkipBtn.Visible or t >= 10
					if SkipBtn.Visible then
						firesignal(SkipBtn.Button.Activated)
					end
				end)
			end
			return result
		end
		if self == Gametable.SummonRemote then
			local result, pity = Scripttable.oldNamecall(self, ...)
			Scripttable.summonResultQueue[#Scripttable.summonResultQueue + 1] = { result = result, pity = pity }
			return result, pity
		end
	end
	return Scripttable.oldNamecall(self, ...)
end)

-- 抽取通行證箱子（直接呼叫 Remote，不經 UI 按鈕）
-- 為何不用 firesignal(spinBtn.Activated)：
--   遊戲的 attemptCrateSpin 連線會 SpinBattlepassCrate:InvokeServer() 並播放含 task.wait 的動畫，兩者都會 yield。
--   舊版用 firesignal 觸發開抽、又在動畫途中再 firesignal 同一個 signal 來「跳過」，
--   等於在第一個 handler 還掛在 yield（InvokeServer / 動畫）時重入同一條連線，
--   執行器嘗試 resume 一條非 suspended 的 thread → "cannot resume non-suspended coroutine"（PassUi:487/529）。
--   直接呼叫 Remote 就沒有動畫、沒有重入，也最快；namecall hook 仍會抓到 Scripttable.lastSpinData，OP 容器在初始化時已填好。
Mainfunction.Gamepass_DrawBox = function()
	local Constants = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("Constants"))
	local Functions = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions")
	local SpinRemote = Functions:WaitForChild("SpinBattlepassCrate")
	local BuyRemote  = Functions:WaitForChild("BuyBattlepassCrateSpin")

	local spinCount = 0
	local opCount = 0

	while Scripttable.Gamepass.Draw_Box do
		local spins = Constants.currentPlrData.Battlepass.Crate.Spins
		if spins <= 0 then
			local bought = BuyRemote:InvokeServer()
			if bought then
				Constants.currentPlrData.Battlepass.Crate.Spins += 1
			else
				Msg:Warning(string.format(T.msg_no_shards, spinCount))
				Scripttable.Gamepass.Draw_Box = false
				break
			end
		end

		-- 直接抽：回傳 (成功, 資料)，資料含 crateType / rewardIndex / spins / pity
		local ok, spinData = SpinRemote:InvokeServer()
		spinCount = spinCount + 1

		if not (ok and type(spinData) == "table") then
			-- 伺服器拒絕（碎片/抽數不足）→ 停止
			Msg:Warning(string.format(T.msg_no_shards, spinCount - 1))
			Scripttable.Gamepass.Draw_Box = false
			break
		end

		-- 同步本地資料（剩餘抽數、保底），讓下一輪買箱判斷正確
		do
			local crate = Constants.currentPlrData.Battlepass.Crate
			if spinData.spins ~= nil then crate.Spins = spinData.spins end
			if spinData.pity  ~= nil then crate.Pity  = spinData.pity  end
		end

		-- 解析抽到的獎勵 → 通知 / Webhook（共用過濾）；resolve 包 pcall 防資料異常中斷連抽
		if spinData.crateType == "OP" then opCount += 1 end
		local rok, info = pcall(Mainfunction.resolveCrateReward, spinData.crateType, spinData.rewardIndex)
		if not rok then info = nil end
		if info then
			if Mainfunction.crateNotable(info) then
				pcall(function()
					if Scripttable.Gamepass.Crate.ShowItem then Mainfunction.crateNotify(info) end
					Mainfunction.webhookCrateDraw(info)   -- 內部再檢查 Webhook 總開關 / CrateOP
				end)
			end
			-- 抽到獨家(Exclusive)自動停止（不受通知過濾影響）
			if Scripttable.Gamepass.Crate.StopOnExclusive and info.rarity == "Exclusive" then
				local m = string.format(T.msg_stop_exclusive, tostring(info.name))
				print("[DrawBox] " .. m)
				Msg:Success(m)
				if Scripttable.drawBoxToggle then pcall(function() Scripttable.drawBoxToggle:SetValue(false) end) end
				Scripttable.Gamepass.Draw_Box = false
				break
			end
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
	T.tab_summon,
  T.tab_shop,
  T.tab_localscript,
  T.tab_potion,
  T.tab_webhook
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

local Tab_Shop = Tabs[3]:ScrollingCanvas({
	Fill = true,
	UiPadding = UDim.new(0, 0)
})

local Tab_Localscript = Tabs[4]:ScrollingCanvas({
	Fill = true,
	UiPadding = UDim.new(0, 0)
})

local Tab_Potion = Tabs[5]:ScrollingCanvas({
  Fill = true,
  UiPadding = UDim.new(0, 0)
})

local Tab_Webhook = Tabs[6]:ScrollingCanvas({
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

-- 自動領每日登入獎勵（7 日簽到）
Tab_main:Radiobox({
	Value = false,
	Label = T.auto_daily_login,
	TextSize = radioTextSize,
	Disabled = false,
	Callback = function(self, Value)
		Scripttable.DailyLogin = Value
		if Value then task.spawn(Mainfunction.DailyLogin) end
	end,
})

-- 一鍵領社群獎勵（按讚/追蹤/收藏/通知/邀請/群組）
Tab_main:Button({
	Text = T.claim_social,
	DoubleClick = false,
	Callback = function() task.spawn(Mainfunction.ClaimSocialRewards) end,
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

Scripttable.drawBoxToggle = DrawBox:Radiobox({
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

-- 顯示抽取物品（主開關）+ 抽到獨家後停止
local CrateOpts = Tab_main:Row()
Scripttable.gpShowItemCtrl = CrateOpts:Radiobox({
  Value = Scripttable.Gamepass.Crate.ShowItem,
  Label = T.show_item,
  TextSize = radioTextSize,
  Callback = function(self, Value)
    Scripttable.Gamepass.Crate.ShowItem = Value
  end,
})
Scripttable.gpStopCtrl = CrateOpts:Radiobox({
  Value = Scripttable.Gamepass.Crate.StopOnExclusive,
  Label = T.crate_stop_exclusive,
  TextSize = radioTextSize,
  Callback = function(self, Value)
    Scripttable.Gamepass.Crate.StopOnExclusive = Value
  end,
})

-- 抽取通知過濾（逐格開關，Msg 與 Webhook 共用）
-- 每期獎勵不同 → 內容於啟動時依實際獎池動態填入（見「初始化」段的 Mainfunction.buildCrateFilterUI）
Scripttable.crateFilterHeader = Tab_main:CollapsingHeader({ Title = T.crate_filter_header, Collapsed = true })
Scripttable.crateFilterLoading = Scripttable.crateFilterHeader:Label({ Text = T.crate_filter_loading })

-- 儲存 / 載入通行證設定（lobby_Gamepass_Config.json）
local GamepassCfgRow = Scripttable.crateFilterHeader:Row({ Expanded = true })
GamepassCfgRow:SmallButton({
  Text     = T.gamepass_save,
  Callback = function() Mainfunction.SaveGamepassConfig() end,
})
GamepassCfgRow:SmallButton({
  Text     = T.gamepass_load,
  Callback = function() Mainfunction.LoadGamepassConfig() end,
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

--[[ 復古塔暫時關閉
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
]] -- 復古塔 end

do
  local AD = Scripttable.Summon.AutoDelete
  AD.Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("AutoDelete")
  AD.Frame = Scripttable.Summon.Gui:FindFirstChild("AutoDelete")
  pcall(function()
    AD.Colours = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("Colours"))
  end)
end

Mainfunction.colourNativeToggle = function(rarity, kind, isOn)
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
Mainfunction.applyAutoDelete = function(rarity, kind)
  local AD = Scripttable.Summon.AutoDelete
  local ok, ret = pcall(function()
    return AD.Remote:InvokeServer(rarity, kind)
  end)
  if ok then
    print(string.format("[AutoDelete] %s %s -> %s", rarity, kind, tostring(ret)))
    Mainfunction.colourNativeToggle(rarity, kind, ret == true)
  end
end

Mainfunction.syncAutoDelete = function()
  local AD = Scripttable.Summon.AutoDelete
  task.spawn(function()
    for _, r in ipairs({ "Common", "Rare", "Epic", "Legendary" }) do
      if AD.HIGH_TIER[r] then Mainfunction.applyAutoDelete(r, "Normal") end
      if AD.HIGH_TIER["Shiny_" .. r] then Mainfunction.applyAutoDelete(r, "Shiny") end
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
    Mainfunction.syncAutoDelete()
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
        task.spawn(Mainfunction.applyAutoDelete, rarity, "Normal")
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
        task.spawn(Mainfunction.applyAutoDelete, rarity, "Shiny")
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
for _, cfg in ipairs(Scripttable.PityConfig) do
  cfg.bar = Tab_Summon:ProgressBar({
    Label    = cfg.label,
    Value    = 0,
    MinValue = 0,
    MaxValue = 100,
    Format   = "%d",
  })
end

-- ========================================================================== --
-- Tab_Shop（商店）


-- 自動購買金幣箱子：BuyCoinCrate:InvokeServer(選項序號)，序號由下拉選單選 (1=x1 / 2=x3 / 3=x10)
-- 金幣不足自動停：買之前先用 Shop.CoinCrate[檔].Coins 與當前金幣比對
Mainfunction.AutoBuyCoinCrate = function()
  local BuyRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("BuyCoinCrate")
  while Scripttable.Shop.AutoBuyCoinCrate do
    local idx  = Scripttable.Shop.BuyIndex or 1
    local tier = Scripttable.Shop.CoinCrate[Scripttable.Shop.BuyTier or "x1"]
    local cost = (tier and tier.Coins) or 0
    local coinObj = Gametable.LocalPlayer:FindFirstChild("Coins")
    local coins = (coinObj and coinObj.Value) or 0
    if coins < cost then
      Scripttable.Shop.AutoBuyCoinCrate = false
      if Scripttable.shopCoinCrateToggle then pcall(function() Scripttable.shopCoinCrateToggle:SetValue(false) end) end
      Msg:Warning(T.shop_no_coins)
      break
    end
    pcall(function() BuyRemote:InvokeServer(idx) end)
    task.wait(Scripttable.Shop.BuyInterval)
  end
end

-- 即時金幣顯示
Mainfunction.shopCommaNumber = function(n)
  local s = tostring(math.floor(tonumber(n) or 0))
  local k
  repeat s, k = s:gsub("^(-?%d+)(%d%d%d)", "%1,%2") until k == 0
  return s
end
local ShopCoinsLabel = Tab_Shop:Label({ Text = string.format(T.shop_coins, "0") })
task.spawn(function()
  while true do
    local coinObj = Gametable.LocalPlayer:FindFirstChild("Coins")
    local txt = string.format(T.shop_coins, Mainfunction.shopCommaNumber(coinObj and coinObj.Value or 0))
    if ShopCoinsLabel.Text ~= txt then ShopCoinsLabel.Text = txt end  -- 只在變動才寫
    task.wait(0.3)
  end
end)

Tab_Shop:Separator({ Text = T.shop_coincrate })

-- 自動購買開關
Scripttable.shopCoinCrateToggle = Tab_Shop:Radiobox({
  Value = false,
  Label = T.shop_auto_coincrate,
  TextSize = radioTextSize,
  Callback = function(self, Value)
    Scripttable.Shop.AutoBuyCoinCrate = Value
    if Value then
      task.spawn(Mainfunction.AutoBuyCoinCrate)
    end
  end,
})

-- 購買速度（前）+ 檔位下拉 x1/x3/x10（後），同一排
-- 下拉每項 = { index = 給 BuyCoinCrate 的序號, key = 成本鍵 }
Scripttable.shopItems   = { "x1", "x3", "x10" }              -- combo 第 N 項 → 標籤
Scripttable.shopOptions = {                                  -- 標籤 → { index, key }
  x1  = { index = 1, key = "x1"  },
  x3  = { index = 2, key = "x3"  },
  x10 = { index = 3, key = "x10" },
}
local ShopRow = Tab_Shop:Row()
ShopRow:SliderFloat({
  Label = "",
  Value = Scripttable.Shop.BuyInterval,
  Minimum = 0.2,
  Maximum = 2,
  Format = T.shop_speed,
  Callback = function(self, Value)
    Scripttable.Shop.BuyInterval = tonumber(string.format("%.1f", Value))
  end,
})
ShopRow:Combo({
  Label = " ",
  Selected = 1,
  Items = Scripttable.shopItems,
  Callback = function(self, label)
    -- label 可能是字串("x3")或 combo 索引(數字)
    local lbl = (type(label) == "number") and Scripttable.shopItems[label] or tostring(label)
    local opt = Scripttable.shopOptions[lbl]
    if opt then
      Scripttable.Shop.BuyIndex = opt.index
      Scripttable.Shop.BuyTier  = opt.key
    end
  end,
})

-- ---- 自動開啟箱子 ----
-- 從 LocalPlayer.Crates 讀箱子清單與數量（穩定排序）
Mainfunction.readCrates = function()
  local out = {}
  local folder = Gametable.LocalPlayer:FindFirstChild("Crates")
  if folder then
    for _, obj in ipairs(folder:GetChildren()) do
      local ok, val = pcall(function() return obj.Value end)
      out[#out + 1] = { name = obj.Name, count = (ok and type(val) == "number") and math.floor(val) or 0 }
    end
    table.sort(out, function(a, b) return a.name < b.name end)
  end
  return out
end

-- 依最大數量決定位數（2 或 3 位…超過再加），數量補零對齊
Mainfunction.crateDigits = function(crates)
  local maxc = 0
  for _, c in ipairs(crates) do if c.count > maxc then maxc = c.count end end
  return math.max(2, #tostring(maxc))
end
Mainfunction.crateLabel = function(name, count, width)
  return string.format("%s  %0" .. width .. "d", name, count)
end
-- GetItems：每次打開下拉即時回傳「箱子 數量」標籤
Mainfunction.crateItems = function()
  local crates = Mainfunction.readCrates()
  local width = Mainfunction.crateDigits(crates)
  local items = {}
  for _, c in ipairs(crates) do
    items[#items + 1] = Mainfunction.crateLabel(c.name, c.count, width)
  end
  return items
end

-- 解析開到的獎勵：UseItem 回傳的 data.reward 是 cratesModule.Crates[箱子].Rewards[索引]
-- 的「索引」（無 Rewards 池的箱子 → 索引本身就是塔名），再用 itemsModule/towersData 轉成名稱/稀有度
Scripttable.rarityHex = {
  Common = "#B0B0B0", Rare = "#3B9DFF", Epic = "#B14CFF", Legendary = "#FFB347",
  Mythic = "#FF4C7D", Secret = "#FF0033", Exclusive = "#FFD700",
}
-- 箱子定義模組（直接 require：ReplicatedStorage.Modules.Data.Crates；快取）
Mainfunction.getCratesModule = function()
  if Scripttable.cratesModule == nil then
    local ok, mod = pcall(function()
      return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("Crates"))
    end)
    Scripttable.cratesModule = (ok and type(mod) == "table") and mod or false
  end
  return Scripttable.cratesModule or nil
end

Mainfunction.resolveOpenedReward = function(crateName, rewardVal)
  local mod     = Mainfunction.getCratesModule()
  local crates  = mod and mod.Crates
  local crate   = (type(crates) == "table") and crates[crateName] or nil
  local rewards = (type(crate) == "table") and crate.Rewards or nil
  local r       = (type(rewards) == "table") and rewards[rewardVal] or nil
  if type(r) ~= "table" then r = { Type = "Tower", Item = rewardVal } end  -- 無池(如 MysteryBox) → 索引即塔名
  local info = { amount = r.Amount }
  if r.Type == "Tower" then
    info.isTower = true
    info.name = Mainfunction.formatTowerName(tostring(r.Item))
    info.rarity = Mainfunction.getRarity(r.Item)
  else
    local idata = Gametable.ItemsData and Gametable.ItemsData.Items and Gametable.ItemsData.Items[r.Item]
    info.name = (idata and idata.Name) or tostring(r.Item)
    info.rarity = idata and idata.Rarity or nil
  end
  return info
end

-- 寫一行到開箱 Console（RichText 依稀有度上色）
Mainfunction.shopConsoleWrite = function(info)
  if not Scripttable.shopConsole then return end
  local amount = info.amount and (" ×" .. Mainfunction.shopCommaNumber(info.amount)) or ""
  local line
  if info.rarity then
    local rname = T["rarity_" .. info.rarity] or info.rarity
    local hex = Scripttable.rarityHex[info.rarity] or "#FFFFFF"
    line = string.format('<font color="%s">[%s] %s%s</font>', hex, rname, info.name, amount)
  else
    line = tostring(info.name) .. amount
  end
  pcall(function() Scripttable.shopConsole:AppendText(line) end)
end

-- 自動開箱：UseItem:InvokeServer(箱子名, 次數) → 回傳 (success, data)
--   剩餘數量 < 次數 → 自動停；成功時把 data.reward 解析後寫進 Console
Mainfunction.AutoOpenCrate = function()
  local UseItem = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("UseItem")
  while Scripttable.Shop.AutoOpenCrate do
    local name = Scripttable.Shop.OpenCrateName
    local amt  = Scripttable.Shop.OpenAmount or 1
    local folder = Gametable.LocalPlayer:FindFirstChild("Crates")
    local obj = name and folder and folder:FindFirstChild(name)
    local count = (obj and obj.Value) or 0
    if not name or count < amt then
      Scripttable.Shop.AutoOpenCrate = false
      if Scripttable.shopOpenCrateToggle then pcall(function() Scripttable.shopOpenCrateToggle:SetValue(false) end) end
      Msg:Warning(T.shop_no_crates)
      break
    end
    local ok, success, data = pcall(function() return UseItem:InvokeServer(name, amt) end)
    if ok and success and type(data) == "table" and data.reward ~= nil then
      -- 多抽 → data.reward 是索引陣列；單抽 → 單一索引
      local list = (type(data.reward) == "table") and data.reward or { data.reward }
      for _, rv in ipairs(list) do
        Mainfunction.shopConsoleWrite(Mainfunction.resolveOpenedReward(name, rv))
      end
    end
    task.wait(Scripttable.Shop.BuyInterval)  -- 共用「購買速度」
  end
end

Tab_Shop:Separator({ Text = T.shop_opencrate_sep })

-- Row：選箱子（前）+ 選開的次數 ×1/×3（後）
Scripttable.openItems = { "×1", "×3" }
local CrateRow = Tab_Shop:Row()
Scripttable.crateCombo = CrateRow:Combo({
  Label = " ",
  Selected = 1,
  Items = Mainfunction.crateItems(),     -- 初始
  GetItems = Mainfunction.crateItems,    -- 打開時即時刷新
  Callback = function(self, label)
    local name = tostring(label):match("^(%S+)")   -- 取「箱子名 數量」前段
    local folder = Gametable.LocalPlayer:FindFirstChild("Crates")
    if name and folder and folder:FindFirstChild(name) then
      Scripttable.Shop.OpenCrateName = name        -- 只接受真實存在的箱子名
    end
  end,
})
CrateRow:Combo({
  Label = " ",
  Selected = 1,
  Items = Scripttable.openItems,
  Callback = function(self, label)
    local lbl = (type(label) == "number") and Scripttable.openItems[label] or tostring(label)
    Scripttable.Shop.OpenAmount = tonumber(tostring(lbl):match("%d+")) or 1
  end,
})

-- 開關
Scripttable.shopOpenCrateToggle = Tab_Shop:Radiobox({
  Value = false,
  Label = T.shop_auto_opencrate,
  TextSize = radioTextSize,
  Callback = function(self, Value)
    Scripttable.Shop.AutoOpenCrate = Value
    if Value then task.spawn(Mainfunction.AutoOpenCrate) end
  end,
})

-- 開箱結果 Console（顯示開到的物品；RichText 上色、自動捲到底、上限 300 行）
do
  local ResultRow = Tab_Shop:Row({ Expanded = true })
  ResultRow:Label({ Text = T.shop_open_result })
  ResultRow:SmallButton({
    Text     = T.shop_clear,
    Callback = function() if Scripttable.shopConsole then pcall(function() Scripttable.shopConsole:Clear() end) end end,
  })
end
Scripttable.shopConsole = Tab_Shop:Console({
  Value       = "",
  ReadOnly    = true,
  RichText    = true,
  Border      = true,
  AutoScroll  = true,
  TextWrapped = true,
  Size        = UDim2.new(1, 0, 0, isMobile and 120 or 160),
})

-- 預設/修正選中箱子 + 即時更新下拉預覽（箱子 當前數量）
task.spawn(function()
  while true do
    local crates = Mainfunction.readCrates()
    if #crates > 0 then
      -- 目前選的若不是有效箱子（含啟動時 nil）→ 預設第一個
      local valid = false
      for _, c in ipairs(crates) do
        if c.name == Scripttable.Shop.OpenCrateName then valid = true break end
      end
      if not valid then Scripttable.Shop.OpenCrateName = crates[1].name end
      -- 更新預覽文字
      local width = Mainfunction.crateDigits(crates)
      local name = Scripttable.Shop.OpenCrateName
      local count = 0
      for _, c in ipairs(crates) do if c.name == name then count = c.count break end end
      pcall(function() Scripttable.crateCombo:SetValueText(Mainfunction.crateLabel(name, count, width)) end)
    end
    task.wait(0.3)
  end
end)

-- ========================================================================== --
-- Tab_Shop（商人自動掃貨）

Tab_Shop:Separator({ Text = T.shop_sep_merchant })

-- 普通商人自動掃貨
Tab_Shop:Radiobox({
  Value = false,
  Label = T.shop_auto_merchant,
  TextSize = radioTextSize,
  Callback = function(self, Value)
    Scripttable.Shop.AutoMerchant = Value
    if Value then task.spawn(Mainfunction.AutoMerchant) end
  end,
})

-- 掃完自動刷新（會持續花寶石，預設關）
Tab_Shop:Radiobox({
  Value = false,
  Label = T.shop_auto_refresh,
  TextSize = radioTextSize,
  Callback = function(self, Value)
    Scripttable.Shop.AutoRefreshMerchant = Value
  end,
})

-- 無盡商人自動掃貨
Tab_Shop:Radiobox({
  Value = false,
  Label = T.shop_auto_endless,
  TextSize = radioTextSize,
  Callback = function(self, Value)
    Scripttable.Shop.AutoEndless = Value
    if Value then task.spawn(Mainfunction.AutoEndlessMerchant) end
  end,
})

-- 購買 Hot Deal（單次）
Tab_Shop:Button({
  Text = T.shop_buy_hotdeal,
  DoubleClick = false,
  Callback = function() task.spawn(Mainfunction.BuyHotDeal) end,
})

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
						excluded = true
break
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
				-- 按鈕列放在 Console 上方：手機端 Console 過高會把下方按鈕擠出視窗，置頂可確保可見
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
				InfoModal:Console({
					Value    = content,
					ReadOnly = true,
					RichText = true,
					Border   = true,
					Size     = UDim2.new(1, 0, 0, isMobile and 110 or 150),
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

-- ========================================================================== --
-- Tab_Potion

-- 遊戲藥水類型前綴 → Scripttable.Potion 欄位名
-- (Items.Potions 以「<類型>Potion<階級>」字串為 key，例 LuckPotion3 = 167)
Scripttable.Potion.FieldMap = {
  XP     = "exp",
  Coins  = "coin",
  Damage = "dmg",
  Shiny  = "shiny",
  Luck   = "lucky",
}

-- 表格列順序（上到下）；field 對應 Scripttable.Potion.T*.<field>
Scripttable.Potion.Rows = {
  { field = "exp",   key = "potion_exp"   },
  { field = "coin",  key = "potion_coin"  },
  { field = "dmg",   key = "potion_dmg"   },
  { field = "shiny", key = "potion_shiny" },
  { field = "lucky", key = "potion_lucky" },
}

-- 自動製作：類型對照（顯示名 ↔ 遊戲前綴 / Potion 欄位）
Scripttable.Potion.CraftTypes = {
  { label = T.potion_exp,   prefix = "XP",     field = "exp"   },
  { label = T.potion_coin,  prefix = "Coins",  field = "coin"  },
  { label = T.potion_dmg,   prefix = "Damage", field = "dmg"   },
  { label = T.potion_shiny, prefix = "Shiny",  field = "shiny" },
  { label = T.potion_lucky, prefix = "Luck",   field = "lucky" },
}
-- Combo 用的純標籤陣列
Scripttable.Potion.CraftTypeLabels = {}
for _, e in ipairs(Scripttable.Potion.CraftTypes) do
  table.insert(Scripttable.Potion.CraftTypeLabels, e.label)
end
-- 當前選擇 + 自動開關（預設 幸運 T1）
Scripttable.Potion.Craft = { auto = false, running = false, type = Scripttable.Potion.CraftTypes[5], tier = 1 }

Mainfunction.getPotionConstants = function()
  if Scripttable.Potion.ConstantsCache then return Scripttable.Potion.ConstantsCache end
  local ok, mod = pcall(function()
    return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("Constants"))
  end)
  if ok then Scripttable.Potion.ConstantsCache = mod end
  return Scripttable.Potion.ConstantsCache
end

-- 從背包讀藥水數量 → 寫入 Scripttable.Potion.T*.{exp/coin/dmg/shiny/lucky}
-- 主來源：LocalPlayer.Potions 的直接接口（<類型>Potion<階級> 的 Value）
-- 備案：直接接口不存在時改用 getgc 的 Constants.currentPlrData.Items.Potions
Mainfunction.updPotion = function()
  -- 先把所有 T* 的數量欄位歸零（藥水歸 0 時來源會直接移除該項，必須先清再填）
  for tierName, tier in pairs(Scripttable.Potion) do
    if type(tier) == "table" and tierName:match("^T%d$") then
      for _, field in pairs(Scripttable.Potion.FieldMap) do
        tier[field] = 0
      end
    end
  end

  local potionsFolder = Gametable.LocalPlayer:FindFirstChild("Potions")
  if potionsFolder then
    -- 直接接口：逐一讀 <類型>Potion<階級>.Value
    for _, obj in ipairs(potionsFolder:GetChildren()) do
      local typeName, tierNum = tostring(obj.Name):match("^(%a+)Potion(%d+)$")
      local field = typeName and Scripttable.Potion.FieldMap[typeName]
      local tier  = tierNum and Scripttable.Potion["T" .. tierNum]
      if field and tier then
        local ok, val = pcall(function() return obj.Value end)
        if ok and type(val) == "number" then
          tier[field] = val
        end
      end
    end
  else
    -- 備案：getgc Constants
    local Constants = Mainfunction.getPotionConstants()
    local data = Constants and Constants.currentPlrData
    local potions = data and data.Items and data.Items.Potions
    if type(potions) ~= "table" then return false end
    for name, count in pairs(potions) do
      local typeName, tierNum = tostring(name):match("^(%a+)Potion(%d+)$")
      local field = typeName and Scripttable.Potion.FieldMap[typeName]
      local tier  = tierNum and Scripttable.Potion["T" .. tierNum]
      if field and tier and type(count) == "number" then
        tier[field] = count
      end
    end
  end

  -- 同步製作等級 / 寶石（Scripttable.Potion 既有欄位）
  local lvl = Gametable.LocalPlayer:FindFirstChild("CraftingLvl")
  local gem = Gametable.LocalPlayer:FindFirstChild("Gems")
  if lvl then Scripttable.Potion.level = lvl.Value end
  if gem then Scripttable.Potion.gems  = gem.Value end

  return true
end

-- 把 Scripttable.Potion 的數值寫進表格 cell（updPotion 負責抓資料，這裡只負責顯示）
Mainfunction.refreshPotionCells = function()
  for _, row in ipairs(Scripttable.Potion.Rows) do
    for t = 1, Scripttable.Potion.MaxTier do
      local tier = Scripttable.Potion["T" .. t]
      local cell = Scripttable.Potion.Cells[row.field] and Scripttable.Potion.Cells[row.field][t]
      if tier and cell then
        local txt = tostring(tier[row.field] or 0)
        if cell.Text ~= txt then cell.Text = txt end  -- 只在變動才寫，避免每秒輪詢觸發 ReGui 重排
      end
    end
  end
  local info = string.format("%s: %s   %s: %s",
    T.potion_level, tostring(Scripttable.Potion.level or 0),
    T.potion_gems,  tostring(Scripttable.Potion.gems  or 0))
  if Scripttable.Potion.InfoLabel.Text ~= info then
    Scripttable.Potion.InfoLabel.Text = info
  end
end

-- 自動製作藥水
Mainfunction.autoCraftPotion = function()
  if Scripttable.Potion.Craft.running then return end
  Scripttable.Potion.Craft.running = true
  local CraftPotion = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("CraftPotion")
  local lastReason
  local function blocked(reason)
    if reason ~= lastReason then
      lastReason = reason
      Msg:Warning(reason)
    end
  end

  while Scripttable.Potion.Craft.auto do
    local sel    = Scripttable.Potion.Craft
    local tier   = sel.tier
    local prefix = sel.type.prefix
    local key    = prefix .. "Potion" .. tier
    local Constants = Mainfunction.getPotionConstants()
    local pd = Constants and Constants.currentPlrData

    if not pd then
      blocked(T.potion_craft_nolobby)
    else
      -- 1. 時間：CraftQueue 內仍在燒的槽位（EndTime > os.time()），<3 才有空位
      local queue = (pd.Times and pd.Times.CraftQueue) or {}
      local brewing = 0
      for _, c in pairs(queue) do
        if type(c) == "table" and c.EndTime and c.EndTime > os.time() then
          brewing = brewing + 1
        end
      end
      -- 2. 寶石
      local gemObj = Gametable.LocalPlayer:FindFirstChild("Gems")
      local gems   = (gemObj and gemObj.Value) or 0
      local cost   = (Scripttable.Potion["T" .. tier] and Scripttable.Potion["T" .. tier].spend) or 0
      -- 2.1 製作等級（Potion.T4/T5 才有限制，T1-T3 level=0 永遠通過）
      local lvlObj   = Gametable.LocalPlayer:FindFirstChild("CraftingLvl")
      local myLevel  = (lvlObj and lvlObj.Value) or 0
      local reqLevel = (Scripttable.Potion["T" .. tier] and Scripttable.Potion["T" .. tier].level) or 0
      -- 3. 上一級藥水 x3（T1 免）
      local prevKey, prevCount = nil, math.huge
      if tier > 1 then
        prevKey   = prefix .. "Potion" .. (tier - 1)
        prevCount = (pd.Items and pd.Items.Potions and pd.Items.Potions[prevKey]) or 0
      end

      if brewing >= 3 then
        blocked(T.potion_craft_full)
      elseif myLevel < reqLevel then
        blocked(string.format(T.potion_craft_nolevel, myLevel, reqLevel))
      elseif gems < cost then
        blocked(string.format(T.potion_craft_nogem, gems, cost))
      elseif tier > 1 and prevCount < 3 then
        blocked(string.format(T.potion_craft_noprev, prevKey, prevCount))
      else
        local pOk, success, msg = pcall(function() return CraftPotion:InvokeServer(key) end)
        if pOk and success ~= false then
          lastReason = nil  -- 製作成功，重置受阻提示
          Msg:Success(string.format(T.potion_craft_start, key))
        else
          local detail = pOk and msg or success  -- 伺服器訊息 或 pcall 錯誤
          blocked(string.format(T.potion_craft_fail, tostring(detail)))
        end
      end
    end
    task.wait(2)
  end
  Scripttable.Potion.Craft.running = false
end

-- 檔案結構：{ ["<UserId>"] = { type="Luck", tier=3, auto=false }, ... }
Mainfunction.SavePotionConfig = function(silent)
  for _, dir in ipairs({ "Tsetingnil_script", "Tsetingnil_script\\NTD", "Tsetingnil_script\\NTD\\Config" }) do
    if isfolder and makefolder and not isfolder(dir) then pcall(makefolder, dir) end
  end
  local path = Scripttable.Localscript.PotionConfigPath
  -- 先讀回整份（全玩家），只覆寫自己那筆，不動別人的
  local all = {}
  if isfile and readfile and isfile(path) then
    local rok, raw = pcall(readfile, path)
    if rok and raw and raw ~= "" then
      local dok, data = pcall(function() return HttpService:JSONDecode(raw) end)
      if dok and type(data) == "table" then all = data end
    end
  end
  all[tostring(Gametable.LocalPlayer.UserId)] = {
    type = Scripttable.Potion.Craft.type.prefix,
    tier = Scripttable.Potion.Craft.tier,
    auto = Scripttable.Potion.Craft.auto,
  }
  local ok, encoded = pcall(function() return HttpService:JSONEncode(all) end)
  if not ok then
    if not silent then Msg:Warning(T.potion_cfg_savefail) end
    return false
  end
  local wok, err = pcall(writefile, path, encoded)
  if wok then
    if not silent then Msg:Success(T.potion_cfg_saved) end
    return true
  end
  if not silent then Msg:Warning(T.potion_cfg_savefail .. ": " .. tostring(err)) end
  return false
end

-- 載入自己（UserId）那筆設定，套用到 Craft 並同步下拉 / 開關
Mainfunction.LoadPotionConfig = function(silent)
  local path = Scripttable.Localscript.PotionConfigPath
  if not (isfile and readfile and isfile(path)) then
    if not silent then Msg:Warning(T.potion_cfg_none) end
    return false
  end
  local rok, raw = pcall(readfile, path)
  if not rok or not raw or raw == "" then
    if not silent then Msg:Warning(T.potion_cfg_none) end
    return false
  end
  local dok, data = pcall(function() return HttpService:JSONDecode(raw) end)
  if not dok or type(data) ~= "table" then
    if not silent then Msg:Warning(T.potion_cfg_none) end
    return false
  end
  local cfg = data[tostring(Gametable.LocalPlayer.UserId)]
  if type(cfg) ~= "table" then
    if not silent then Msg:Warning(T.potion_cfg_none) end  -- 此玩家尚未存過
    return false
  end
  -- 類型（prefix → CraftTypes entry）+ 同步下拉
  if type(cfg.type) == "string" then
    for i, e in ipairs(Scripttable.Potion.CraftTypes) do
      if e.prefix == cfg.type then
        Scripttable.Potion.Craft.type = e
        if Scripttable.Potion.TypeCombo then Scripttable.Potion.TypeCombo:SetValue(i) end
        break
      end
    end
  end
  -- 階級 + 同步下拉
  if type(cfg.tier) == "number" and cfg.tier >= 1 and cfg.tier <= 5 then
    Scripttable.Potion.Craft.tier = cfg.tier
    if Scripttable.Potion.TierCombo then Scripttable.Potion.TierCombo:SetValue(cfg.tier) end
  end
  -- 自動開關：SetValue 會觸發 callback（設 auto + 視需要啟動迴圈）
  if type(cfg.auto) == "boolean" then
    if Scripttable.Potion.AutoToggle then
      Scripttable.Potion.AutoToggle:SetValue(cfg.auto)
    else
      Scripttable.Potion.Craft.auto = cfg.auto
      if cfg.auto then task.spawn(Mainfunction.autoCraftPotion) end
    end
  end
  if not silent then Msg:Success(T.potion_cfg_loaded) end
  return true
end

-- 頂部：製作等級 / 寶石 + 重新整理按鈕
Scripttable.Potion.InfoLabel = Tab_Potion:Label({ Text = "" })
Tab_Potion:Button({
  Text = T.potion_refresh,
  Callback = function()
    task.spawn(function()
      Mainfunction.updPotion()
      Mainfunction.refreshPotionCells()
    end)
  end,
})

-- 表格本體（等級為直/列，藥水種類為橫/欄）
Scripttable.Potion.Table = Tab_Potion:Table({ RowBackground = true, Border = true })

-- 標題列：左上角 + 各藥水類型（橫）
Scripttable.Potion.HeaderRow = Scripttable.Potion.Table:HeaderRow()
Scripttable.Potion.HeaderRow:Column():Label({ Text = T.potion_corner })
for _, row in ipairs(Scripttable.Potion.Rows) do
  Scripttable.Potion.HeaderRow:Column():Label({ Text = T[row.key] or row.field })
end

-- 資料列：每個等級一列（直），左欄=Tn，後面各類型數量
Scripttable.Potion.Cells = {}  -- Cells[field][tier] = Label
for _, row in ipairs(Scripttable.Potion.Rows) do
  Scripttable.Potion.Cells[row.field] = {}
end
for t = 1, Scripttable.Potion.MaxTier do
  local R = Scripttable.Potion.Table:NextRow()
  R:Column():Label({ Text = "T" .. t })
  for _, row in ipairs(Scripttable.Potion.Rows) do
    Scripttable.Potion.Cells[row.field][t] = R:Column():Label({ Text = "0" })
  end
end

Tab_Potion:Separator({ Text = T.potion_craft_sep })

Scripttable.Potion.CraftRow = Tab_Potion:Row()
-- 類型下拉（預設 幸運 = CraftTypes[5]）
Scripttable.Potion.TypeCombo = Scripttable.Potion.CraftRow:Combo({
  Label    = " ",
  Selected = 5,
  Items    = Scripttable.Potion.CraftTypeLabels,
  Callback = function(self, label)
    for i, e in ipairs(Scripttable.Potion.CraftTypes) do
      if e.label == label or i == label then Scripttable.Potion.Craft.type = e return end
    end
  end,
})
-- 階級下拉
Scripttable.Potion.TierCombo = Scripttable.Potion.CraftRow:Combo({
  Label    = " ",
  Selected = 1,
  Items    = { "T1", "T2", "T3", "T4", "T5" },
  Callback = function(self, label)
    Scripttable.Potion.Craft.tier = tonumber(string.match(tostring(label), "%d")) or 1
  end,
})

-- 自動製作開關 + 手動儲存（同一排，儲存在開關右邊；開關本身不調用儲存）
Scripttable.Potion.AutoRow = Tab_Potion:Row()
Scripttable.Potion.AutoToggle = Scripttable.Potion.AutoRow:Radiobox({
  Value    = false,
  Label    = T.potion_auto_craft,
  TextSize = radioTextSize,
  Callback = function(self, v)
    Scripttable.Potion.Craft.auto = v
    if v then task.spawn(Mainfunction.autoCraftPotion) end
  end,
})
Scripttable.Potion.AutoRow:SmallButton({
  Text     = T.autodelete_save,
  Callback = function() Mainfunction.SavePotionConfig() end,
})

-- 啟動時載入自己（UserId）的設定
Mainfunction.LoadPotionConfig(true)

-- ========================================================================== --
-- Tab_Webhook
local W = Scripttable.Webhook

-- 遮罩 URL（顯示用）
Mainfunction.maskWebhook = function(url)
  local id, token = url:match("https://discord%.com/api/webhooks/(%d+)/(.+)")
  if id and token then
    return id:sub(1, 4) .. "..." .. id:sub(-4) .. " / " .. token:sub(1, 4) .. "..." .. token:sub(-4)
  end
  -- 非 Discord URL：通用遮罩，避免整串密鑰顯示在面板
  if #url <= 16 then return url end
  return url:sub(1, 12) .. "..." .. url:sub(-6)
end

-- 設定存檔
Mainfunction.SaveWebhookConfig = function(silent)
  for _, dir in ipairs({ "Tsetingnil_script", "Tsetingnil_script\\NTD", "Tsetingnil_script\\NTD\\Config" }) do
    if isfolder and makefolder and not isfolder(dir) then pcall(makefolder, dir) end
  end
  local snap = {
    url = W.url, enabled = W.enabled, merge = W.merge,
    items = W.items, Summon = W.Summon, ping = W.ping,
    botName = W.botName, cooldown = W.cooldown,
  }
  local ok, encoded = pcall(function() return HttpService:JSONEncode(snap) end)
  if not ok then
    if not silent then Msg:Warning(T.webhook_msg_save_fail) end
    return false
  end
  local ok2, err = pcall(writefile, Scripttable.Localscript.WebhookConfigPath, encoded)
  if ok2 then
    if not silent then Msg:Success(T.webhook_msg_saved) end
    return true
  end
  if not silent then Msg:Warning(T.webhook_msg_save_fail .. ": " .. tostring(err)) end
  return false
end

-- 設定載入（只覆寫既有鍵，忽略檔案中的未知欄位）
Mainfunction.LoadWebhookConfig = function(silent)
  if not (isfile and readfile and isfile(Scripttable.Localscript.WebhookConfigPath)) then
    if not silent then Msg:Warning(T.webhook_msg_no_config) end
    return false
  end
  local ok, raw = pcall(readfile, Scripttable.Localscript.WebhookConfigPath)
  if not ok or not raw or raw == "" then
    if not silent then Msg:Warning(T.webhook_msg_no_config) end
    return false
  end
  local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
  if not ok2 or type(data) ~= "table" then
    if not silent then Msg:Warning(T.webhook_msg_bad_config) end
    return false
  end
  if type(data.url)      == "string"  then W.url      = data.url end
  if type(data.enabled)  == "boolean" then W.enabled  = data.enabled end
  if type(data.merge)    == "boolean" then W.merge    = data.merge end
  if type(data.botName)  == "string"  then W.botName  = data.botName end
  if type(data.cooldown) == "number"  then W.cooldown = data.cooldown end
  if type(data.items) == "table" then
    for k in pairs(W.items) do
      if type(data.items[k]) == "boolean" then W.items[k] = data.items[k] end
    end
  end
  if type(data.ping) == "table" then
    for k in pairs(W.ping) do
      if type(data.ping[k]) == "boolean" then W.ping[k] = data.ping[k] end
    end
  end
  if type(data.Summon) == "table" then
    for r, cfg in pairs(W.Summon) do
      local d = data.Summon[r]
      if type(d) == "table" then
        for key in pairs(cfg) do
          if type(d[key]) == "boolean" then cfg[key] = d[key] end
        end
      end
    end
  end
  -- 套用到模組
  Webhook:SetURL(W.url)
  Webhook:SetConfig({
    botName    = W.botName,
    cooldown   = W.cooldown,
  })
  if not silent then Msg:Success(T.webhook_msg_loaded) end
  return true
end

-- 啟動時嘗試載入
Mainfunction.LoadWebhookConfig(true)

-- URL 狀態 + 輸入
Mainfunction.webhookStatusText = function()
  return (W.url ~= "" and (T.webhook_url_label .. Mainfunction.maskWebhook(W.url))) or T.webhook_url_unset
end

local Webhook_Lable = Tab_Webhook:Label({ Text = Mainfunction.webhookStatusText() })

local Webhook_InputText = Tab_Webhook:InputText({
  Value       = W.url,
  Label       = T.webhook_url_input,
  Placeholder = "https://discord.com/api/webhooks/...",
  Callback    = function(self, text)
    W.url = text
    Webhook:SetURL(text)
    Webhook_Lable.Text = Mainfunction.webhookStatusText()
  end,
})

-- 設置
Tab_Webhook:Separator({ Text = T.webhook_sep_settings })

-- 第一排：總開關 + 模式（獨立 / 合併 互斥）
local Row_Webhook_Mode = Tab_Webhook:Row()
local Webhook_Toggle = Row_Webhook_Mode:Radiobox({
  Value    = W.enabled,
  Label    = T.webhook_master,
  TextSize = radioTextSize,
  Callback = function(self, Value) W.enabled = Value end,
})

Scripttable.modeGuard = false
local Radio_Indep, Radio_Merge

Mainfunction.setMode = function(merge)
  if Scripttable.modeGuard then return end
  Scripttable.modeGuard = true
  W.merge = merge
  W.runStats = { total = 0, towers = {} }  -- 換模式重置獨立計數
  if Radio_Indep then Radio_Indep:SetValue(not merge) end
  if Radio_Merge then Radio_Merge:SetValue(merge) end
  Scripttable.modeGuard = false
end
Radio_Indep = Row_Webhook_Mode:Radiobox({
  Value    = not W.merge,
  Label    = T.webhook_mode_indep,
  TextSize = radioTextSize,
  Callback = function(self, v) if not Scripttable.modeGuard then Mainfunction.setMode(not v) end end,
})
Radio_Merge = Row_Webhook_Mode:Radiobox({
  Value    = W.merge,
  Label    = T.webhook_mode_merge,
  TextSize = radioTextSize,
  Callback = function(self, v) if not Scripttable.modeGuard then Mainfunction.setMode(v) end end,
})

-- 第二排：測試發送 / 傳送統計 / 清除統計（皆只看 URL，不受總開關限制）
local Row_Webhook_Act = Tab_Webhook:Row()
Row_Webhook_Act:Button({
  Text = T.webhook_test,
  Callback = function()
    if not Webhook:IsValid() then
      Msg:Warning(T.webhook_msg_no_url)
      return
    end
    if Webhook:Test() then
      Msg:Success(T.webhook_msg_test)
    end
  end,
})
Row_Webhook_Act:Button({
  Text = T.webhook_send_stats,
  Callback = function()
    if not Webhook:IsValid() then
      Msg:Warning(T.webhook_msg_no_url)
      return
    end
    if Webhook:SendSessionSummary(W.stats, { title = T.webhook_title_total, markDelete = Mainfunction.webhookMarkDelete }) then
      Msg:Success(T.webhook_msg_sent)
    end
  end,
})
Row_Webhook_Act:Button({
  Text = T.webhook_clear_stats,
  Callback = function()
    W.stats = { total = 0, towers = {} }
    Msg:Success(T.webhook_msg_cleared)
  end,
})

-- Webhook 項目
Tab_Webhook:Separator({ Text = T.webhook_sep_items })
local ROW_Webhook_Send = Tab_Webhook:Row()
local Item_CrateOP = ROW_Webhook_Send:Radiobox({
  Value    = W.items.CrateOP,
  Label    = T.webhook_item_crate,
  TextSize = radioTextSize,
  Callback = function(self, Value) W.items.CrateOP = Value end,
})
local Item_AutoMaster = ROW_Webhook_Send:Radiobox({
  Value    = W.items.AutoMaster,
  Label    = T.webhook_item_master,
  TextSize = radioTextSize,
  Callback = function(self, Value) W.items.AutoMaster = Value end,
})

-- 抽取塔通知設定（下拉表：稀有度 × 4 開關）
local SummonHeader = Tab_Webhook:CollapsingHeader({ Title = T.webhook_summon_header, Collapsed = true })
local SummonTable  = SummonHeader:Table({ RowBackground = true, Border = true })

local HRow = SummonTable:HeaderRow()
HRow:Column():Label({ Text = T.webhook_col_rarity })
HRow:Column():Label({ Text = T.webhook_col_normal })
HRow:Column():Label({ Text = T.webhook_col_inormal })
HRow:Column():Label({ Text = T.webhook_col_shiny })
HRow:Column():Label({ Text = T.webhook_col_ishiny })

-- 空 label 的 radiobox 只有那顆小圓點可點，欄位其餘空白區不吃點擊（觸控幾乎按不到）。
-- 把 checkbox 物件撐滿整格 → 整個格子都能點（Object.Activated 涵蓋整塊）。
Mainfunction.fillCell = function(box)
  if box then
    box.AutomaticSize = Enum.AutomaticSize.Y
    box.Size = UDim2.new(1, 0, 0, 0)
  end
  return box
end

local SummonCtrls = {}
for _, rarity in ipairs(W.UIRarities) do
  local cfg      = W.Summon[rarity]
  local hasShiny = W.ShinyRarities[rarity] == true
  local Row      = SummonTable:NextRow()
  local ctrls    = {}
  SummonCtrls[rarity] = ctrls

  Row:Column():Label({ Text = (T["rarity_" .. rarity] or rarity) })

  -- 正常
  ctrls.Normal = Mainfunction.fillCell(Row:Column():Radiobox({
    Value = cfg.Normal, Label = "",
    Callback = function(self, v) cfg.Normal = v end,
  }))

  -- 獨立_正常
  ctrls.IndependentNormal = Mainfunction.fillCell(Row:Column():Radiobox({
    Value = cfg.IndependentNormal, Label = "",
    Callback = function(self, v) cfg.IndependentNormal = v end,
  }))

  -- 閃亮
  local shinyCol = Row:Column()
  if hasShiny then
    ctrls.Shiny = Mainfunction.fillCell(shinyCol:Radiobox({
      Value = cfg.Shiny, Label = "",
      Callback = function(self, v) cfg.Shiny = v end,
    }))
  else
    shinyCol:Label({ Text = "—" })
  end

  -- 獨立_閃亮
  local indShinyCol = Row:Column()
  if hasShiny then
    ctrls.IndependentShiny = Mainfunction.fillCell(indShinyCol:Radiobox({
      Value = cfg.IndependentShiny, Label = "",
      Callback = function(self, v) cfg.IndependentShiny = v end,
    }))
  else
    indShinyCol:Label({ Text = "—" })
  end
end

-- 進階設定
local AdvHeader = Tab_Webhook:CollapsingHeader({ Title = T.webhook_adv_header, Collapsed = true })

local Adv_Bot = AdvHeader:InputText({
  Value    = W.botName or "",
  Label    = T.webhook_bot_name,
  Callback = function(self, t)
    W.botName = (t ~= "" and t) or nil
    Webhook:SetConfig({ botName = (t ~= "" and t) or "Tseting Script" })
  end,
})
local Adv_Cooldown = AdvHeader:SliderInt({
  Label    = T.webhook_cooldown,
  Value    = W.cooldown,
  Minimum  = 0,
  Maximum  = 10,
  Format   = "%d s",
  Callback = function(self, v)
    W.cooldown = v
    Webhook:SetConfig({ cooldown = v })
  end,
})

AdvHeader:Separator({ Text = T.webhook_sep_ping })
local PingCtrls = {}
local PingRow = AdvHeader:Row()
for _, r in ipairs(W.UIPing) do
  PingCtrls[r] = PingRow:Radiobox({
    Value    = W.ping[r],
    Label    = (T["rarity_" .. r] or r),
    TextSize = radioTextSize,
    Callback = function(self, v) W.ping[r] = v end,
  })
end

-- 載入後把所有 UI 控件刷新成目前 W 值（免重載腳本）
Mainfunction.webhookRefreshUI = function()
  Webhook_InputText:SetValue(W.url)
  Webhook_Toggle:SetValue(W.enabled)
  -- 模式：用 guard 直接設值，避免觸發 Mainfunction.setMode 重置獨立計數
  Scripttable.modeGuard = true
  Radio_Indep:SetValue(not W.merge)
  Radio_Merge:SetValue(W.merge)
  Scripttable.modeGuard = false
  Item_CrateOP:SetValue(W.items.CrateOP)
  Item_AutoMaster:SetValue(W.items.AutoMaster)
  for rarity, c in pairs(SummonCtrls) do
    local cfg = W.Summon[rarity]
    if c.Normal            then c.Normal:SetValue(cfg.Normal) end
    if c.Shiny             then c.Shiny:SetValue(cfg.Shiny) end
    if c.IndependentNormal then c.IndependentNormal:SetValue(cfg.IndependentNormal) end
    if c.IndependentShiny  then c.IndependentShiny:SetValue(cfg.IndependentShiny) end
  end
  for r, c in pairs(PingCtrls) do c:SetValue(W.ping[r]) end
  Adv_Bot:SetValue(W.botName or "")
  Adv_Cooldown:SetValue(W.cooldown)
end

-- 共用儲存/載入（載入會刷新所有 UI 控件，免重載腳本）
Tab_Webhook:Separator({ Text = T.webhook_sep_config })
local Webhook_SaveRow = Tab_Webhook:Row({ Expanded = true })
Webhook_SaveRow:SmallButton({
  Text = T.webhook_save,
  Callback = function() Mainfunction.SaveWebhookConfig() end,
})
Webhook_SaveRow:SmallButton({
  Text = T.webhook_load,
  Callback = function()
    if Mainfunction.LoadWebhookConfig() then Mainfunction.webhookRefreshUI() end
  end,
})


-- ========================================================================== --
-- 初始化

Scripttable.Summon.AutoDelete.UIReady = true
Scripttable.Webhook.UIReady = true

-- 初始化保底進度（從 currentPlrData.Summons 讀現有進度，不必先抽取）
-- 資料為三個平行陣列：_PityKeys[i] / Pities[i] / _PityThresholds[i] 對應同一稀有度
task.spawn(function()
  local ok, Constants = pcall(require, ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("Constants"))
  if not ok then
    warn("[Pity Init] require Constants 失敗:", Constants)
    return
  end

  -- 等到 _PityKeys 與 Pities 都就緒（光等 Summons 存在不夠，子欄位可能晚一步才填）
  local keys, pities, thresholds
  for _ = 1, 40 do
    local s = Constants.currentPlrData and Constants.currentPlrData.Summons
    if s and type(s._PityKeys) == "table" and type(s.Pities) == "table" then
      keys, pities, thresholds = s._PityKeys, s.Pities, s._PityThresholds
      break
    end
    task.wait(0.5)
  end
  if not (keys and pities) then
    warn("[Pity Init] 等不到 currentPlrData.Summons._PityKeys / Pities（逾時，未讀到本地資料）")
    return
  end

  -- Pities 可能是 index 陣列，也可能用稀有度名稱當 key → 先把真正的 key 全印出來判定
  print("[Pity Init] Pities 原始內容：")
  local pityEmpty = true
  for k, val in pairs(pities) do
    pityEmpty = false
    print(string.format("[Pity Init]   Pities[%s] (%s) = %s", tostring(k), typeof(k), tostring(val)))
  end
  if pityEmpty then
    print("[Pity Init]   （Pities 是空表 → 此帳號目前各稀有度保底皆為 0）")
  end

  -- 印出讀到的本地資料（current 同時試 index 與名稱）
  print("[Pity Init] 已讀到本地保底資料：")
  for i, key in ipairs(keys) do
    local cur = pities[i] or pities[key]
    print(string.format("[Pity Init]   [%d] %s = %s / %s",
      i, tostring(key), tostring(cur), tostring(thresholds and (thresholds[i] or thresholds[key]) or "?")))
  end

  -- 以 Scripttable.PityConfig.key 對應（不靠陣列順序）；current/max 都同時試 index 與名稱
  for _, cfg in ipairs(Scripttable.PityConfig) do
    if cfg.bar then
      local matched = false
      for i, key in ipairs(keys) do
        if key == cfg.key then
          matched = true
          local v   = tonumber(pities[i] or pities[key]) or 0
          local max = tonumber(thresholds and (thresholds[i] or thresholds[key])) or cfg.max
          local pct = (max and max > 0) and (v / max * 100) or 0
          local pok, perr = pcall(function()
            cfg.bar:SetValue(pct)
            cfg.bar:SetValueText(string.format("%d / %d (%.2f%%)", v, max, pct))
          end)
          if pok then
            print(string.format("[Pity Init] 套用 %s → %d / %d (%.2f%%)", cfg.key, v, max, pct))
          else
            warn(string.format("[Pity Init] 套用 %s 失敗：%s", cfg.key, tostring(perr)))
          end
          break
        end
      end
      if not matched then
        warn(string.format("[Pity Init] _PityKeys 內找不到 %s", cfg.key))
      end
    end
  end
end)

-- 建立通行證箱子獎勵清單 + 過濾 UI（每期獎勵不同 → 動態解析填入 Scripttable.Gamepass.reward）
task.spawn(function()
  -- 等資料模組就緒（getgc 背景掃描）；逾時也照下去，解析器有 UI 後備
  for _ = 1, 40 do
    if Gametable.BattlepassData and Gametable.TowersData then break end
    task.wait(0.5)
  end
  if not Mainfunction.resolveCrateReward("Basic", 1) then
    warn("[Crate Filter] 解析不到獎池內容，過濾清單未建立")
    return
  end

  -- 逐格解析（遇到第一個空格即停）；game 池鍵 Basic/OP → reward 鍵 Basic/Op
  local map = { Basic = "Basic", OP = "Op" }
  for gamePool, key in pairs(map) do
    local list = {}
    for i = 1, 12 do
      local info = Mainfunction.resolveCrateReward(gamePool, i)
      if not info then break end
      info.notify = (gamePool == "OP")   -- 預設：OP 池全開、普通池全關
      list[i] = info
      print(string.format("[Crate Filter] %s[%d] = %s%s", key, i,
        tostring(info.name),
        info.isTower and (" (" .. tostring(info.rarity) .. " 塔)") or
        (info.amount and (" ×" .. tostring(info.amount)) or "")))
    end
    Scripttable.Gamepass.reward[key] = list
  end

  Mainfunction.applyGamepassNotify()   -- 套用存檔的逐格通知（若有）
  Mainfunction.buildCrateFilterUI()
  print(string.format("[Crate Filter] 已建立：Basic %d 格、Op %d 格",
    #Scripttable.Gamepass.reward.Basic, #Scripttable.Gamepass.reward.Op))
end)

-- 藥水初始化
task.spawn(function()
  Mainfunction.updPotion()
  Mainfunction.refreshPotionCells()
end)

-- 輪尋更新（每秒同步背包藥水數量）
task.spawn(function()
  while true do
    task.wait(0.5)
    Mainfunction.updPotion()
    Mainfunction.refreshPotionCells()
  end
end)