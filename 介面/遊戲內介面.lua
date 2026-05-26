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
    tab_main       = "Main",
    tab_localscript = "本地腳本",
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
		localscript_save_running    = "儲存正在運行的腳本",
		localscript_save            = "儲存",
		localscript_save_name_title = "輸入儲存名稱",
		localscript_save_name_ph    = "腳本名稱...",
		localscript_save_success    = "已儲存",
		localscript_save_error      = "儲存失敗",
		localscript_save_no_running = "無正在運行的腳本",
	},
	en = {
		windowTitle    = "In-Game UI",
    tab_main       = "Main",
    tab_localscript = "Local Script",
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
		localscript_save_running    = "Save Running Script",
		localscript_save            = "Save",
		localscript_save_name_title = "Enter Save Name",
		localscript_save_name_ph    = "Script name...",
		localscript_save_success    = "Saved",
		localscript_save_error      = "Save failed",
		localscript_save_no_running = "No running script",
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

local windowSize = currentLang == "en" and UDim2.new(0, 300, 0, 220) or UDim2.new(0, 250, 0, 220)

local TabsWindow =  ReGui:TabsWindow({
	Title = L.windowTitle,
	Size = windowSize,
	NoScroll = true,
  NoResize = true,
})

local Tabs = {}

for _, Name in ipairs({
	L.tab_main,
  L.tab_localscript
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

local Tab_Localscript = Tabs[2]:ScrollingCanvas({
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
    task.wait(1)
  end
end)

-- ========================================================================== --
-- Tab_Localscript
local Localscript = {
  path = [[Tsetingnil_script\NTD\Script]],
  ScriptListTable = nil,
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
			if name:match("%.lua$") then
				scripts[#scripts + 1] = { name = name, path = filePath }
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
				InfoModal:Console({
					Value    = content,
					ReadOnly = true,
					RichText = true,
					Border   = true,
					Size     = UDim2.new(1, 0, 0, 150),
				})
				InfoModal:Button({
					Text     = L.localscript_info_close,
					Callback = function() InfoModal:ClosePopup() end,
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
		local mainPath = "Tsetingnil_script\\NTD\\main_" .. userId .. ".lua"
		local ok3, raw = pcall(readfile, mainPath)
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
		InfoModal:Console({
			Value    = content,
			ReadOnly = true,
			RichText = true,
			Border   = true,
			Size     = UDim2.new(1, 0, 0, 150),
		})
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
						local savePath = "Tsetingnil_script\\NTD\\Script\\" .. name .. ".lua"
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
						if not isfolder("Tsetingnil_script\\NTD") then makefolder("Tsetingnil_script\\NTD") end
						if not isfolder("Tsetingnil_script\\NTD\\Script") then makefolder("Tsetingnil_script\\NTD\\Script") end
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
	end,
})

Localscript.ScriptListTable = Tab_Localscript:Table({
	RowBackground = true,
	Border = true,
})

BuildScriptList()