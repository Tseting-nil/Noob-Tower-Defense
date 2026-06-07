-- ============================================================================ --
-- Webhook 模組 (Noob Tower Defense)
-- ----------------------------------------------------------------------------
-- 用法：
--   local Webhook = loadstring(readfile("...Webhook.lua"))()   -- 或 HttpGet
--   Webhook:SetURL("https://discord.com/api/webhooks/<id>/<token>")
--   Webhook:SetConfig({ botName = "X", footerText = "Y", color = 0x57F287, cooldown = 2 })
--
--   Webhook:SendSummon({ {tower="FrostNoob", rarity="Legendary", shiny=true} }, { ping=true })
--   Webhook:SendCrateOP("Gem", 100)
--   Webhook:SendMaster({ {tower="X", mastery="Master II"} })
--   Webhook:SendSessionSummary({ total=120, towers={ [key]={rarity=,shiny=,tower=,count=} } })
--   Webhook:Test()          -- 送出上線/加入通知（測試用）
--
-- 本模組「不會」自動送出任何東西；一切由呼叫端驅動。
-- ============================================================================ --

local HttpService = game:GetService("HttpService")
local Players     = game:GetService("Players")
local player      = Players.LocalPlayer

-- 解析 executor 的 http request 函數（不同 executor 名稱不同）
local httpRequest = (syn and syn.request)
    or (http and http.request)
    or (fluxus and fluxus.request)
    or http_request
    or request

local Webhook = {
    Config = {
        url        = "",                          -- Discord webhook URL（由呼叫端設定）
        botName    = "Tseting Script",
        footerText = "Tseting-nil Webhook Send",
        color      = 0x57F287,                    -- 預設綠（embed 顏色，整數）
        cooldown   = 2,                           -- 防洗版：兩次送出最小間隔（秒）
        pingText   = "@everyone",                 -- 頂級稀有 ping 用文字
        shinyLabel = "閃亮",                       -- 閃亮前綴（呼叫端可依語言覆寫）
        -- rarityNames：稀有度→顯示名 對照表（呼叫端 SetConfig 傳入；未設則用原始英文 key）
    },

    Game = {
        name        = "Noob Tower Defense",
        placeId     = game.PlaceId,
        jobId       = game.JobId,
        userId      = player.UserId,
        displayName = player.DisplayName,
        username    = player.Name,
        avatarUrl   = "",
    },

    -- 稀有度 → embed 顏色
    RarityColor = {
        Common    = 0xB0B0B0,
        Rare      = 0x3B9DFF,
        Epic      = 0xB14CFF,
        Legendary = 0xFFB347,
        Mythic    = 0xFF4C7D,
        Secret    = 0xFF0033,
        Exclusive = 0xFFD700,
    },

    _queue      = {},
    _processing = false,
    _lastSend   = 0,
    _avatarDone = false,
}

-- ---------------------------------------------------------------------------- --
-- 設定
function Webhook:SetURL(url)
    self.Config.url = tostring(url or "")
    return self
end

function Webhook:SetConfig(tbl)
    if type(tbl) ~= "table" then return self end
    for k, v in pairs(tbl) do
        if v ~= nil then self.Config[k] = v end
    end
    return self
end

-- 只檢查「有沒有填 URL」，不限定 Discord 格式（其他 webhook 服務也能用）
function Webhook:IsValid()
    local url = self.Config.url
    return type(url) == "string" and (url:gsub("%s", "")) ~= ""
end

-- ---------------------------------------------------------------------------- --
-- 玩家頭像（僅抓一次，lazy）
function Webhook:_FetchAvatar()
    if self._avatarDone then return end
    self._avatarDone = true
    if not httpRequest then return end
    local ok, res = pcall(function()
        return httpRequest({
            Url = "https://thumbnails.roblox.com/v1/users/avatar-headshot"
                .. "?userIds=" .. tostring(self.Game.userId)
                .. "&size=150x150&format=Png&isCircular=false",
            Method = "GET",
        })
    end)
    if ok and res and res.Body then
        local ok2, data = pcall(function() return HttpService:JSONDecode(res.Body) end)
        if ok2 and data and data.data and data.data[1] then
            self.Game.avatarUrl = data.data[1].imageUrl
        end
    end
end

-- ---------------------------------------------------------------------------- --
-- 送出佇列（串行 + 冷卻，避免 Discord 429 限流）
function Webhook:_enqueue(payload)
    table.insert(self._queue, payload)
    if self._processing then return end
    self._processing = true
    task.spawn(function()
        while #self._queue > 0 do
            local p    = table.remove(self._queue, 1)
            local wait = (self.Config.cooldown or 0) - (os.clock() - self._lastSend)
            if wait > 0 then task.wait(wait) end
            if httpRequest and self.Config.url ~= "" then
                pcall(function()
                    httpRequest({
                        Url     = self.Config.url,
                        Method  = "POST",
                        Headers = { ["Content-Type"] = "application/json" },
                        Body    = HttpService:JSONEncode(p),
                    })
                end)
            end
            self._lastSend = os.clock()
        end
        self._processing = false
    end)
end

-- ---------------------------------------------------------------------------- --
-- 工具
local function _formatName(s)
    return (tostring(s):gsub("(%l)(%u)", "%1 %2"))
end

-- 轉義 Discord markdown 的底線，避免 _ 被當成斜體而在顯示時消失
local function _esc(s)
    return (tostring(s):gsub("_", "\\_"))
end

-- Discord 限制：description 4096 / field value 1024
local function _clamp(str, max)
    if #str <= max then return str end
    return str:sub(1, max - 24) .. "\n…（已截斷）"
end

-- 組 embed（自動帶上作者頭像/名稱/footer/時間戳）
function Webhook:_buildEmbed(opts)
    local embed = {
        author = {
            name     = self.Game.displayName .. " (@" .. self.Game.username .. ")",
            icon_url = self.Game.avatarUrl ~= "" and self.Game.avatarUrl or nil,
            url      = "https://www.roblox.com/users/" .. tostring(self.Game.userId) .. "/profile",
        },
        color     = opts.color or self.Config.color,
        footer    = { text = self.Config.footerText },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }
    if opts.title       then embed.title       = opts.title end
    if opts.description then embed.description = _clamp(opts.description, 4000) end
    if opts.fields      then embed.fields      = opts.fields end
    if opts.thumbnail   then embed.thumbnail   = { url = opts.thumbnail } end
    return embed
end

-- 通用送出
function Webhook:Send(opts)
    opts = opts or {}
    if not self:IsValid() then return false, "invalid url" end
    self:_FetchAvatar()
    local payload = {
        username = self.Config.botName,
        embeds   = { self:_buildEmbed(opts) },
    }
    if opts.content then payload.content = opts.content end
    self:_enqueue(payload)
    return true
end

-- ---------------------------------------------------------------------------- --
-- 事件 helper

-- 稀有度顯示名（呼叫端有傳 Config.rarityNames 就用翻譯，否則用原始 key）
function Webhook:_rarityLabel(rarity)
    local names = self.Config.rarityNames
    if type(names) == "table" and names[rarity] then
        return names[rarity]
    end
    return tostring(rarity)
end

-- embed 文字（呼叫端有傳 Config.Text 就用翻譯，否則用內建中文預設）
function Webhook:_text(key, default)
    local t = self.Config.Text
    if type(t) == "table" and t[key] ~= nil then return t[key] end
    return default
end

-- entries = { {tower=, rarity=, shiny=, count=?}, ... }
function Webhook:SendSummon(entries, opts)
    opts = opts or {}
    if type(entries) ~= "table" or #entries == 0 then return false end
    local lines, topColor = {}, nil
    for _, e in ipairs(entries) do
        local rname = self:_rarityLabel(e.rarity or "?")
        local tag   = e.shiny and ((self.Config.shinyLabel or "閃亮") .. "_" .. rname) or rname
        local count = (e.count and e.count > 1) and (" ×" .. e.count) or ""
        lines[#lines + 1] = string.format("**[%s]** %s%s",
            _esc(tag), _formatName(e.tower or "?"), count)
        topColor = self.RarityColor[e.rarity] or topColor
    end
    return self:Send({
        title       = opts.title or (self:_text("summon", "抽取結果") .. " (" .. #entries .. ")"),
        description = table.concat(lines, "\n"),
        color       = opts.color or topColor,
        content     = opts.ping and self.Config.pingText or nil,
    })
end

function Webhook:SendCrateOP(itemName, amount)
    return self:Send({
        title  = self:_text("crateOP", "通行證箱子 — 高級獎池 (OP)"),
        fields = {
            { name = self:_text("item", "物品"),   value = tostring(itemName), inline = true },
            { name = self:_text("amount", "數量"), value = tostring(amount),   inline = true },
        },
    })
end

-- entries = { {tower=, mastery=}, ... }
function Webhook:SendMaster(entries, opts)
    opts = opts or {}
    if type(entries) ~= "table" or #entries == 0 then return false end
    local lines = {}
    for _, e in ipairs(entries) do
        lines[#lines + 1] = string.format("**%s** → %s",
            _formatName(e.tower or "?"), tostring(e.mastery or "?"))
    end
    return self:Send({
        title       = opts.title or (self:_text("master", "AutoMaster") .. " (" .. #entries .. ")"),
        description = table.concat(lines, "\n"),
    })
end

-- 上線/加入通知（測試按鈕用）
function Webhook:SendJoin()
    return self:Send({
        title  = self:_text("join", "上線通知"),
        fields = {
            { name = self:_text("game", "遊戲"), value = self.Game.name,                inline = true },
            { name = "PlaceId", value = "`" .. tostring(self.Game.placeId) .. "`",      inline = true },
            { name = "JobId",   value = "```" .. tostring(self.Game.jobId) .. "```",    inline = false },
        },
    })
end
Webhook.Test = Webhook.SendJoin

-- stats = { total=, towers = { [key] = { rarity=, shiny=, tower=, count= } } }
function Webhook:SendSessionSummary(stats, opts)
    opts = opts or {}
    if type(stats) ~= "table" then return false end
    local lines = { self:_text("total", "總抽取次數：") .. (stats.total or 0) }
    if type(stats.towers) == "table" then
        local order = { Common = 1, Rare = 2, Epic = 3, Legendary = 4, Mythic = 5, Secret = 6, Exclusive = 7 }
        local list = {}
        for _, rec in pairs(stats.towers) do list[#list + 1] = rec end
        table.sort(list, function(a, b)
            local ra, rb = order[a.rarity] or 99, order[b.rarity] or 99
            if ra ~= rb then return ra < rb end
            local sa, sb = a.shiny and 1 or 0, b.shiny and 1 or 0
            if sa ~= sb then return sa < sb end
            return tostring(a.tower) < tostring(b.tower)
        end)
        for _, rec in ipairs(list) do
            local rname = self:_rarityLabel(rec.rarity)
            local tag = rec.shiny
                and ((self.Config.shinyLabel or "閃亮") .. "_" .. rname .. "_" .. tostring(rec.tower))
                or  (rname .. "_" .. tostring(rec.tower))
            local suffix = (opts.markDelete and opts.markDelete(rec.rarity, rec.shiny)) and (" " .. self:_text("deleted", "(刪除)")) or ""
            lines[#lines + 1] = string.format("[%s] ×%d%s", _esc(tag), rec.count, suffix)
        end
    end
    return self:Send({
        title       = opts.title or self:_text("session", "本次 Session 統計"),
        description = table.concat(lines, "\n"),
    })
end

return Webhook
