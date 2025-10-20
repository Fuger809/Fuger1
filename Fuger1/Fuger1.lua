local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/Cityrage/goldfarm_boogabooga/refs/heads/main/rayfield'))()
local HWID = game:GetService("RbxAnalyticsService"):GetClientId()
local HWIDtable = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fuger809/Script545/refs/heads/main/Solo.lua"))()




local Window = Rayfield:CreateWindow({
   Name = "Whitelist",
   Icon = "baseline", -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "BloomHub",
   LoadingSubtitle = "Loading...",
   Theme = "Amethyst", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

})


local Tab = Window:CreateTab("Whitelist", "cable") -- Title, Image


local Button = Tab:CreateButton({
   Name = "Get HWID",
   Callback = function()
       Rayfield:Notify({
          Title = "Your HWID is",
          Content = ""..HWID.."",
          Duration = 6.5,
          Image = "bookmark-check",
        })
     wait(0.3)
     Rayfield:Notify({
          Title = "Hwid",
          Content = "Copied to clipboard",
          Duration = 3,
          Image = "bookmark-check",
        })
     setclipboard(HWID)
   end,
})


local Button = Tab:CreateButton({
   Name = "Load script",
   Callback = function()
        for i,v in pairs(HWIDtable) do
          if v == HWID then
            Rayfield:Destroy()
-- ========= [ Fluent UI и менеджеры ] =========
local Library = loadstring(game:HttpGetAsync("https://github.com/1dontgiveaf/Fluent-Renewed/releases/download/v1.0/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/1dontgiveaf/Fluent-Renewed/refs/heads/main/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/1dontgiveaf/Fluent-Renewed/refs/heads/main/Addons/InterfaceManager.luau"))()

-- ========= [ Services / utils ] =========
local HttpService       = game:GetService("HttpService")
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local Workspace         = game:GetService("Workspace")
local UIS               = game:GetService("UserInputService")
local Lighting          = game:GetService("Lighting")

local plr  = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum  = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local function ensureChar()
    char = plr.Character or plr.CharacterAdded:Wait()
    hum  = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
end
plr.CharacterAdded:Connect(function() task.defer(ensureChar) end)

-- ========= [ Packets (без ошибок, если модуля нет) ] =========
local packets do
    local ok, mod = pcall(function() return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Packets")) end)
    packets = ok and mod or {}
end
local function swingtool(eids)
    if type(eids) ~= "table" then eids = { eids } end
    if packets and packets.SwingTool and packets.SwingTool.send then
        pcall(function() packets.SwingTool.send(eids) end)
    end
end
local function pickup(eid)
    if packets and packets.Pickup and packets.Pickup.send then
        pcall(function() packets.Pickup.send(eid) end)
    end
end

-- ========= [ Window / Tabs ] =========
local Window = Library:CreateWindow{
    Title = "Fuger Hub -- Booga Booga Reborn",
    SubTitle = "by Fuger XD",
    Size = UDim2.fromOffset(840, 560),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
}
local Tabs = {}
Tabs.Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })

-- менеджеры
SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- ========= [ Helpers ] =========
local function sanitize(name)
    name = tostring(name or ""):gsub("[%c\\/:*?\"<>|]+",""):gsub("^%s+",""):gsub("%s+$","")
    return name == "" and "default" or name
end

-- ========= [ ROUTE persist ] =========
local function routePath(cfg) return "FluentScriptHub/specific-game/"..sanitize(cfg)..".route.json" end
local ROUTE_AUTOSAVE = "FluentScriptHub/specific-game/_route_autosave.json"

local function encodeRoute(points)
    local t = {}
    for i,p in ipairs(points or {}) do
        t[i] = { x=p.pos.X, y=p.pos.Y, z=p.pos.Z, wait=p.wait or 0, js=p.jump_start or nil, je=p.jump_end or nil }
    end
    return t
end
local function decodeRoute(t)
    local out = {}
    for _,r in ipairs(t or {}) do
        table.insert(out, { pos=Vector3.new(r.x,r.y,r.z), wait=(r.wait and r.wait>0) and r.wait or nil, jump_start=r.js or nil, jump_end=r.je or nil })
    end
    return out
end
local function Route_SaveToFile(path, points)
    if not writefile then return false end
    local ok, json = pcall(function() return HttpService:JSONEncode(encodeRoute(points)) end)
    if not ok then return false end
    local ok2 = pcall(writefile, path, json)
    return ok2 == true or ok2 == nil
end
local function Route_LoadFromFile(path, Route, redraw)
    if not (isfile and readfile) or not isfile(path) then return false end
    local ok, json = pcall(readfile, path); if not ok then return false end
    local ok2, arr = pcall(function() return HttpService:JSONDecode(json) end); if not ok2 then return false end
    table.clear(Route.points)
    if redraw and type(redraw.clearDots) == "function" then redraw.clearDots() end
    for _,p in ipairs(decodeRoute(arr)) do
        table.insert(Route.points, p) -- фикс
        if redraw and type(redraw.dot) == "function" then redraw.dot(Color3.fromRGB(255,230,80), p.pos, 0.7) end
    end
    return true
end

-- ========= [ Общие инвентарь/еды ] =========
function findInventoryList()
    local pg = plr:FindFirstChild("PlayerGui"); if not pg then return nil end
    local mg = pg:FindFirstChild("MainGui");    if not mg then return nil end
    local rp = mg:FindFirstChild("RightPanel"); if not rp then return nil end
    local inv = rp:FindFirstChild("Inventory"); if not inv then return nil end
    return inv:FindFirstChild("List")
end
function getSlotByName(itemName)
    local list = findInventoryList()
    if not list then return nil end
    for _,child in ipairs(list:GetChildren()) do
        if child:IsA("ImageLabel") and child.Name == itemName then
            return child.LayoutOrder
        end
    end
    return nil
end
function consumeBySlot(slot)
    if not slot then return false end
    if packets and packets.UseBagItem     and packets.UseBagItem.send     then pcall(function() packets.UseBagItem.send(slot) end);     return true end
    if packets and packets.ConsumeBagItem and packets.ConsumeBagItem.send then pcall(function() packets.ConsumeBagItem.send(slot) end); return true end
    if packets and packets.ConsumeItem    and packets.ConsumeItem.send    then pcall(function() packets.ConsumeItem.send(slot) end);    return true end
    if packets and packets.UseItem        and packets.UseItem.send        then pcall(function() packets.UseItem.send(slot) end);        return true end
    return false
end
_G.fruittoitemid = _G.fruittoitemid or {
    Bloodfruit=94, Bluefruit=377, Lemon=99, Coconut=1, Jelly=604, Banana=606, Orange=602,
    Oddberry=32, Berry=35, Strangefruit=302, Strawberry=282, Sunfruit=128, Pumpkin=80,
    ["Prickly Pear"]=378, Apple=243, Barley=247, Cloudberry=101, Carrot=147
}
function getItemIdByName(name) local t=_G.fruittoitemid return t and t[name] or nil end
function consumeById(id)
    if not id then return false end
    if packets and packets.ConsumeItem and packets.ConsumeItem.send then pcall(function() packets.ConsumeItem.send(id) end); return true end
    if packets and packets.UseItem     and packets.UseItem.send     then pcall(function() packets.UseItem.send({itemID=id}) end); return true end
    if packets and packets.Eat         and packets.Eat.send         then pcall(function() packets.Eat.send(id) end); return true end
    if packets and packets.EatFood     and packets.EatFood.send     then pcall(function() packets.EatFood.send(id) end); return true end
    return false
end

-- ========= [ TAB: Configs ] =========
Tabs.Configs = Window:AddTab({ Title = "Configs", Icon = "save" })
local cfgName = "default"
local cfgInput = Tabs.Configs:AddInput("cfg_name_input",{ Title="Config name", Default=cfgName })
cfgInput:OnChanged(function(v) cfgName = sanitize(v) end)
Tabs.Configs:CreateButton({
    Title="Quick Save",
    Callback=function()
        local n = sanitize(cfgName)
        pcall(function() SaveManager:Save(n) end)
        Route_SaveToFile(routePath(n), (_G.__ROUTE and _G.__ROUTE.points) or {})
        Route_SaveToFile(ROUTE_AUTOSAVE, (_G.__ROUTE and _G.__ROUTE.points) or {})
        Library:Notify{ Title="Configs", Content="Saved "..n.." (+route)", Duration=3 }
    end
})
Tabs.Configs:CreateButton({
    Title="Quick Load",
    Callback=function()
        local n = sanitize(cfgName)
        pcall(function() SaveManager:Load(n) end)
        if _G.__ROUTE then
            local ok = Route_LoadFromFile(routePath(n), _G.__ROUTE, _G.__ROUTE._redraw)
            Library:Notify{ Title="Configs", Content="Loaded "..n..(ok and " +route" or " (no route file)"), Duration=3 }
        else
            Library:Notify{ Title="Configs", Content="Loaded "..n, Duration=3 }
        end
    end
})
local auto = Tabs.Configs:CreateToggle("autoload_cfg",{ Title="Autoload this config", Default=true })
auto:OnChanged(function(v)
    local n = sanitize(cfgName)
    if v then pcall(function() SaveManager:SaveAutoloadConfig(n) end)
    else pcall(function() SaveManager:DeleteAutoloadConfig() end) end
end)

-- ========= [ TAB: Survival (Auto-Eat) — lagless ] =========
local RS = game:GetService("RunService")

Tabs.Survival = Tabs.Survival or Window:AddTab({ Title="Survival", Icon="apple" })
local ae_toggle = Tabs.Survival:CreateToggle("ae_toggle", { Title="Auto Eat (Hunger)", Default=false })
local ae_food   = Tabs.Survival:CreateDropdown("ae_food", { Title="Food to eat",
    Values={"Bloodfruit","Berry","Bluefruit","Coconut","Strawberry","Pumpkin","Apple","Lemon","Orange","Banana"},
    Default="Bloodfruit" })
local ae_thresh = Tabs.Survival:CreateSlider("ae_thresh", { Title="Setpoint / Threshold (%)", Min=1, Max=100, Rounding=0, Default=70 })
local ae_mode   = Tabs.Survival:CreateDropdown("ae_mode", { Title="Scale mode", Values={"Fullness 100→0","Hunger 0→100"}, Default="Fullness 100→0" })
local ae_debug  = Tabs.Survival:CreateToggle("ae_debug", { Title="Debug logs (F9)", Default=false })
local ae_rate   = Tabs.Survival:CreateSlider("ae_rate",  { Title="Max bites / sec", Min=1, Max=20, Rounding=0, Default=8 })
local ae_scan   = Tabs.Survival:CreateSlider("ae_scan",  { Title="Scan interval (s)", Min=0.05, Max=0.60, Rounding=2, Default=0.18 })

-- быстрые нормализации
local function normPct(n) if type(n)~="number" then return nil end if n<=1.5 then n=n*100 end return math.clamp(n,0,100) end

-- подбираем самый дешёвый источник голода 1 раз, потом используем
local HungerReader = nil
local function chooseHungerReader()
    -- 1) значения/атрибуты — самые дешёвые
    for _,v in ipairs(plr:GetDescendants()) do
        if v.Name=="Hunger" and (v:IsA("NumberValue") or v:IsA("IntValue")) then
            return function() return normPct(v.Value) end
        end
    end
    local attrOK = plr:GetAttribute("Hunger")
    if typeof(attrOK)=="number" then
        return function() return normPct(plr:GetAttribute("Hunger")) end
    end
    -- 2) бар — дешевле, чем парсить все текстовые лейблы
    local pg=plr:FindFirstChild("PlayerGui")
    if pg then
        local mg=pg:FindFirstChild("MainGui")
        if mg then
            local bars=mg:FindFirstChild("Bars")
            local hb=bars and bars:FindFirstChild("Hunger")
            if hb and hb:IsA("Frame") and hb.Size and hb.Size.X and typeof(hb.Size.X.Scale)=="number" then
                return function() return normPct(hb.Size.X.Scale) end
            end
        end
    end
    -- 3) fallback: редкий поиск по текстам (дорого) — но только если ничего не нашли
    return function()
        local pg=plr:FindFirstChild("PlayerGui"); if not pg then return 100 end
        for _,inst in ipairs(pg:GetDescendants()) do
            if inst:IsA("TextLabel") then
                local txt=(inst.Text or ""):lower()
                if txt:find("голод") or inst.Name:lower():find("hunger") or (inst.Parent and inst.Parent.Name:lower():find("hunger")) then
                    local num=tonumber(txt:match("([-+]?%d+%.?%d*)"))
                    if num and num>=0 and num<=100 then return num end
                end
            end
        end
        return 100
    end
end

local function readHungerPercent()
    if not HungerReader then HungerReader = chooseHungerReader() end
    local ok,val = pcall(HungerReader)
    if ok and type(val)=="number" then return val end
    HungerReader = chooseHungerReader()
    return 100
end

-- поиск слота 1 раз на цикл
local function getFoodSlotCached(name)
    local list = findInventoryList()
    if not list then return nil end
    for _,child in ipairs(list:GetChildren()) do
        if child:IsA("ImageLabel") and child.Name == name then
            return child.LayoutOrder
        end
    end
    return nil
end

-- очередь “укус/использование” с ограничением частоты (без спама и лагов)
local BiteQ = { last=0 }
local function tryBite(foodName)
    local minGap = 1 / math.max(1, ae_rate.Value)   -- сек на один “укус”
    local now = tick()
    if now - BiteQ.last < minGap then return false end

    local did = false
    local slot = getFoodSlotCached(foodName)
    if slot ~= nil then did = consumeBySlot(slot) end
    if not did then
        local id = getItemIdByName(foodName)
        if id ~= nil then did = consumeById(id) end
    end

    if did then
        BiteQ.last = now
        if ae_debug.Value then print("[AutoEat] bite") end
        -- отдаём кадр: не держим долго текущий поток
        RS.Heartbeat:Wait()
        return true
    end
    return false
end

-- основной цикл: лёгкий, неблокирующий
task.spawn(function()
    local scanAccum = 0
    local scanStep = 0.05
    while true do
        if ae_toggle.Value and hum ~= nil and hum.Parent ~= nil then
            scanAccum += scanStep
            local interval = ae_scan.Value
            if scanAccum >= interval then
                scanAccum = 0

                local target = ae_thresh.Value
                local mode   = ae_mode.Value
                local cur    = readHungerPercent()

                local need = (mode=="Fullness 100→0" and cur<target) or (mode=="Hunger 0→100" and cur>target)
                if need then
                    -- небольшой “доводчик” к целевому уровню, но без лупов в одном кадре
                    local band = 0.6
                    local tries = 0
                    while ae_toggle.Value and tries < 6 do
                        -- сверяемся после каждого укуса
                        if (mode=="Fullness 100→0" and cur>=target-band) or (mode=="Hunger 0→100" and cur<=target+band) then
                            break
                        end
                        if not tryBite(ae_food.Value or "Bloodfruit") then
                            -- если нечего есть — выходим
                            break
                        end
                        tries += 1
                        -- переоценка голода через 1 кадр, чтобы не блокировать
                        RS.Heartbeat:Wait()
                        cur = readHungerPercent()
                    end
                end
            end
        end
        task.wait(scanStep)
    end
end)




-- ========= [ TAB: Farming (посадка/сбор + BV + Area Auto Build) — PRIORITY GROWN + LOCAL FAST PLANT ] =========
-- Базовые сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local plr = Players.LocalPlayer
local root -- HumanoidRootPart

local function ensureRoot()
    local ch = plr and plr.Character
    if ch then return ch:FindFirstChild("HumanoidRootPart") end
    return nil
end

local function bindCharacter()
    if not plr then return end
    if plr.Character then
        root = plr.Character:FindFirstChild("HumanoidRootPart")
    end
    plr.CharacterAdded:Connect(function(ch)
        root = ch:WaitForChild("HumanoidRootPart", 10)
    end)
end
bindCharacter()

-- ========= [ UI ] =========
Tabs.Farming = Window:AddTab({ Title = "Farming", Icon = "shovel" })

-- посадка/сбор
local planttoggle     = Tabs.Farming:CreateToggle("planttoggle",    { Title = "Auto Plant (nearby Plant Boxes)", Default = false })
local plantrange      = Tabs.Farming:CreateSlider("plantrange",     { Title = "Plant range (studs)", Min = 8, Max = 150, Rounding = 0, Default = 30 })
local plantdelay      = Tabs.Farming:CreateSlider("plantdelay",     { Title = "Plant delay (s)", Min = 0.01, Max = 0.25, Rounding = 2, Default = 0.05 })
local fruitdropdownUI = Tabs.Farming:CreateDropdown("fruitdropdown",{ Title = "Seed / Fruit", Values = {
    "Bloodfruit","Bluefruit","Lemon","Coconut","Jelly","Banana","Orange","Oddberry",
    "Berry","Strangefruit","Strawberry","Sunfruit","Pumpkin","Prickly Pear","Apple",
    "Barley","Cloudberry","Carrot"
}, Default = "Bloodfruit" })

local harvesttoggle   = Tabs.Farming:CreateToggle("harvesttoggle",  { Title = "Auto Harvest (bushes)", Default = false })
local harvestrange    = Tabs.Farming:CreateSlider("harvestrange",   { Title = "Harvest range (studs)", Min = 8, Max = 150, Rounding = 0, Default = 30 })

-- движение
local tweenrange      = Tabs.Farming:CreateSlider("tweenrange",     { Title = "Follow range (studs)", Min = 10, Max = 300, Rounding = 0, Default = 120 })
local tweenplantboxtoggle = Tabs.Farming:CreateToggle("tweenplantboxtoggle", { Title = "Move to nearest empty Plant Box (BV)", Default = false })
local tweenbushtoggle     = Tabs.Farming:CreateToggle("tweenbushtoggle",     { Title = "Move to nearest Fruit Bush (BV)", Default = false })

-- leash
local leash_on       = Tabs.Farming:CreateToggle("leash_on",       { Title = "Stay in farm area (leash)", Default = true })
local leash_radius   = Tabs.Farming:CreateSlider("leash_radius",   { Title = "Leash radius (studs)", Min = 20, Max = 400, Rounding = 0, Default = 120 })
local LEASH = { center = nil, radius = 120 }
local function setLeashCenter() if root then LEASH.center = root.Position; LEASH.radius = tonumber(leash_radius.Value) or 120 end end
leash_radius:OnChanged(function(v) LEASH.radius = tonumber(v) or 120 end)

-- взаимное исключение BV-режимов
local function _off(x) if x and x.SetValue then x:SetValue(false) end end
tweenplantboxtoggle:OnChanged(function(v) if v then setLeashCenter(); _off(tweenbushtoggle) end end)
tweenbushtoggle:OnChanged(function(v)   if v then setLeashCenter(); _off(tweenplantboxtoggle) end end)

-- ========= [ Безопасные вызовы пакетов ] =========
local sendInteract do
    local ok = packets and packets.InteractStructure and packets.InteractStructure.send
    if ok then
        local raw = packets.InteractStructure.send
        sendInteract = function(payload) local _ = raw(payload) end
    else
        sendInteract = function() end
    end
end

local sendPickup do
    local a = packets and packets.Pickup and packets.Pickup.send
    local b = _G and (_G.pickup or _G.Pickup) or pickup
    if b then sendPickup = function(eid) b(eid) end
    elseif a then sendPickup = function(eid) local _ = packets.Pickup.send(eid) end
    else sendPickup = function() end end
end

local plantedboxes = {}
local function plant(entityid, itemID)
    sendInteract({ entityID = entityid, itemID = itemID })
    plantedboxes[entityid] = true
end
local function safePickup(eid) sendPickup(eid) end

-- ========= [ Кэш и сканеры ] =========
local ovParams = OverlapParams and OverlapParams.new() or Instance.new("OverlapParams")
ovParams.FilterType = Enum.RaycastFilterType.Exclude
ovParams.FilterDescendantsInstances = { plr and plr.Character }

local NEAR = { pbs = {}, bushes = {}, lastPBScan = 0, lastBushScan = 0 }
local SCAN_COOLDOWN = { pb = 0.1, bush = 0.1 }

local function scanPlantBoxes(range)
    local now = time()
    if now - NEAR.lastPBScan < SCAN_COOLDOWN.pb then return NEAR.pbs end
    NEAR.lastPBScan = now
    table.clear(NEAR.pbs)

    root = ensureRoot()
    if not root or not root.Parent then return NEAR.pbs end

    local parts = Workspace:GetPartBoundsInRadius(root.Position, range, ovParams)
    local added = {}
    for _, part in ipairs(parts) do
        local d = part:FindFirstAncestor("Plant Box")
        if d and d:IsA("Model") and not added[d] then
            added[d] = true
            local eid = d:GetAttribute("EntityID")
            local pp  = d.PrimaryPart or d:FindFirstChildWhichIsA("BasePart")
            if eid and pp then
                local dist = (pp.Position - root.Position).Magnitude
                table.insert(NEAR.pbs, { entityid = eid, deployable = d, dist = dist, pos = pp.Position })
            end
        end
    end
    table.sort(NEAR.pbs, function(a,b) return a.dist < b.dist end)
    return NEAR.pbs
end

local fruitQuery = (fruitdropdownUI.Value or ""):lower()
fruitdropdownUI:OnChanged(function(v) fruitQuery = (v or ""):lower() end)

local function scanBushes(range, q)
    local now = time()
    if now - NEAR.lastBushScan < SCAN_COOLDOWN.bush then return NEAR.bushes end
    NEAR.lastBushScan = now
    table.clear(NEAR.bushes)

    root = ensureRoot()
    if not root or not root.Parent then return NEAR.bushes end

    q = (q or fruitQuery or ""):lower()
    local parts = Workspace:GetPartBoundsInRadius(root.Position, range, ovParams)
    local seen = {}
    for _, part in ipairs(parts) do
        local model = part:FindFirstAncestorOfClass("Model")
        if model and not seen[model] then
            seen[model] = true
            local name = (model.Name or ""):lower()
            if q == "" or name:find(q, 1, true) then
                local pp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                if pp then
                    local eid = model:GetAttribute("EntityID")
                    if eid then
                        local dist = (pp.Position - root.Position).Magnitude
                        table.insert(NEAR.bushes, { entityid = eid, model = model, dist = dist, pos = pp.Position })
                    end
                end
            end
        end
    end
    table.sort(NEAR.bushes, function(a,b) return a.dist < b.dist end)
    return NEAR.bushes
end

-- ========= [ Утилиты для локальной быстрой посадки ] =========
local function shuffle(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

local function emptyPBsInRadius(radius)
    local res = {}
    local me = ensureRoot()
    if not me or not me.Parent then return res end
    local list = scanPlantBoxes(radius)
    for _,box in ipairs(list) do
        if not box.deployable:FindFirstChild("Seed") then
            res[#res+1] = box
        end
    end
    return res
end

-- быстрая посадка рядом с игроком (рандом по грядкам)
-- maxN: сколько посадить за вызов; gap: задержка между посадками
local lastLocalPlant = 0
local function burstPlantNearby(maxN, gap, radius)
    if not planttoggle.Value then return end
    local now = time()
    gap = gap or (tonumber(plantdelay.Value) or 0.05)
    if now - lastLocalPlant < gap * 0.5 then return end

    local boxes = emptyPBsInRadius(radius or 16)
    if #boxes == 0 then return end

    boxes = shuffle(boxes)
    local itemID = _G.fruittoitemid and _G.fruittoitemid[fruitdropdownUI.Value] or 94
    local planted = 0
    for i=1, math.min(maxN or 6, #boxes) do
        plant(boxes[i].entityid, itemID)
        planted += 1
        if gap > 0 then task.wait(gap) end
    end
    lastLocalPlant = time()
end

-- ========= [ BV Controller ] =========
local BV = { stopTol = 0.8, baseSpeed = 18.0, accel = 28.0 }
local BVCTRL = { bv = nil, rp = nil }

local function _clearBV(rp)
    for _,o in ipairs(rp:GetChildren()) do if o:IsA("BodyVelocity") then o:Destroy() end end
end

local function ensureBV()
    local rp = ensureRoot()
    if not rp then return nil end
    if (not BVCTRL.bv) or (not BVCTRL.bv.Parent) or (BVCTRL.rp ~= rp) then
        if BVCTRL.bv then BVCTRL.bv:Destroy() end
        _clearBV(rp)
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9, 0, 1e9)
        bv.Velocity = Vector3.new()
        bv.Parent = rp
        BVCTRL.bv, BVCTRL.rp = bv, rp
    end
    return BVCTRL.bv
end

local function stopBV()
    if BVCTRL.bv then BVCTRL.bv.Velocity = Vector3.new() end
end

local function stepBVTo(targetXZ, dt)
    local rp = ensureRoot(); local bv = ensureBV()
    if not rp or not bv then return false end

    local cur = rp.Position
    local to2 = Vector3.new(targetXZ.X - cur.X, 0, targetXZ.Z - cur.Z)
    local dist = to2.Magnitude
    if dist <= BV.stopTol then stopBV(); return true end

    local dir = dist > 0 and to2.Unit or Vector3.new()
    local desired = dir * math.min(BV.baseSpeed, 18)
    local vel = bv.Velocity
    local k = math.clamp(BV.accel * (dt or 1/60), 0, 1)
    bv.Velocity = vel + (desired - vel) * k
    return false
end

-- ========= [ Цели для BV ] =========
local function nearestEmptyPB(range)
    local pbs = scanPlantBoxes(range)
    for _, box in ipairs(pbs) do
        if not box.deployable:FindFirstChild("Seed") then
            return box
        end
    end
    return nil
end

local function clampToLeash(pos)
    if leash_on.Value and LEASH.center then
        local away = (pos - LEASH.center).Magnitude
        if away > (LEASH.radius + 5) then
            local dir = (pos - LEASH.center).Unit
            return LEASH.center + dir * (LEASH.radius - 2)
        end
    end
    return pos
end

-- ========= [ Основной плантер (батчи) ] =========
local PLANT_BATCH, PLANT_GAP = 25, 0.035
spawn(function()
    while true do
        root = ensureRoot()
        if planttoggle.Value and root and root.Parent then
            local range = tonumber(plantrange.Value) or 30
            local delay = tonumber(plantdelay.Value) or 0.05
            local itemID = _G.fruittoitemid and _G.fruittoitemid[fruitdropdownUI.Value] or 94
            local plantboxes = scanPlantBoxes(range)
            local planted = 0
            for _, box in ipairs(plantboxes) do
                if not box.deployable:FindFirstChild("Seed") then
                    plant(box.entityid, itemID)
                    planted += 1
                    if planted % PLANT_BATCH == 0 then task.wait(PLANT_GAP) end
                else
                    plantedboxes[box.entityid] = true
                end
            end
            task.wait(math.max(0.12, delay))
        else
            task.wait(0.15)
        end
    end
end)

-- ========= [ Авто-сбор (батчи) ] =========
local HARVEST_BATCH, HARVEST_GAP = 25, 0.05
spawn(function()
    while true do
        root = ensureRoot()
        if harvesttoggle.Value and root and root.Parent then
            local harvRange = tonumber(harvestrange.Value) or 30
            local bushes = scanBushes(harvRange, fruitQuery)
            local picked = 0
            for _, b in ipairs(bushes) do
                safePickup(b.entityid); picked += 1
                if picked % HARVEST_BATCH == 0 then task.wait(HARVEST_GAP) end
            end
            task.wait(0.12)
        else
            task.wait(0.15)
        end
    end
end)

-- ========= [ Глобальная цель BV + приоритет: выросшие ягоды ] =========
local targetPos -- current Vector3
RunService.Heartbeat:Connect(function(dt)
    root = ensureRoot()
    if (not root) or (not root.Parent) then stopBV(); return end

    -- локальная быстрая посадка рядом с игроком (НЕ мешает твин/движению)
    burstPlantNearby(5, (tonumber(plantdelay.Value) or 0.05), 14)

    if not tweenplantboxtoggle.Value and not tweenbushtoggle.Value then
        stopBV(); return
    end

    local range = tonumber(tweenrange.Value) or 120
    if not targetPos then
        -- ВСЕГДА сначала пробуем выросшие кусты
        local bushes = scanBushes(range, fruitQuery)
        if #bushes > 0 then
            targetPos = bushes[1].pos
        else
            -- если кустов нет – можно идти к пустому боксу (если выбран соответствующий тумблер)
            if tweenplantboxtoggle.Value or tweenbushtoggle.Value then
                local pb = nearestEmptyPB(range)
                targetPos = pb and pb.pos or nil
            end
        end
        if targetPos then
            if leash_on.Value and LEASH.center and (targetPos - LEASH.center).Magnitude > (LEASH.radius + 5) then
                targetPos = nil
            else
                targetPos = clampToLeash(targetPos)
            end
        end
    end

    if targetPos then
        local flat = Vector3.new(targetPos.X, root.Position.Y, targetPos.Z)
        local done = stepBVTo(flat, dt)
        -- по пути еще пробуем посадить рядом
        burstPlantNearby(3, 0.06, 12)
        if done then targetPos = nil end
    else
        stopBV()
    end
end)

-- ========= [ Tween mover (grown-first) — SAFE, no-freeze ] =========
local tween_grown_toggle = Tabs.Farming:CreateToggle("tween_grown_toggle", {
    Title = "Move to grown Fruit Bush (Tween)", Default = false
})
local tween_grown_range = Tabs.Farming:CreateSlider("tween_grown_range", {
    Title = "Tween search range (studs)", Min = 10, Max = 300, Rounding = 0, Default = 120
})
local tween_speed = Tabs.Farming:CreateSlider("tween_grown_speed", {
    Title = "Tween speed (stud/s)", Min = 6, Max = 60, Rounding = 1, Default = 20.0
})

tween_grown_toggle:OnChanged(function(v)
    if v then
        if root then LEASH.center = root.Position end
        if tweenplantboxtoggle.Value then tweenplantboxtoggle:SetValue(false) end
        if tweenbushtoggle.Value then tweenbushtoggle:SetValue(false) end
    end
end)

local activeTween, hbConn
local function cancelTween()
    if hbConn then hbConn:Disconnect() hbConn = nil end
    if activeTween then pcall(function() activeTween:Cancel() end); activeTween = nil end
end

local function safeTweenTo(target, speed)
    root = ensureRoot()
    if not root or not root.Parent then return false end
    cancelTween()

    local start = root.Position
    local flatTarget = Vector3.new(target.X, start.Y, target.Z)
    local total = (flatTarget - start)
    local dist  = total.Magnitude
    if dist < 0.6 then return true end

    local maxSeg = 22
    local steps  = math.max(1, math.ceil(dist / maxSeg))
    local dir    = total.Unit

    for i = 1, steps do
        if not tween_grown_toggle.Value or not root or not root.Parent then cancelTween(); return false end

        local segTarget = (i < steps) and (start + dir * (maxSeg * i)) or flatTarget
        segTarget = Vector3.new(segTarget.X, root.Position.Y, segTarget.Z)

        local segDist = (segTarget - root.Position).Magnitude
        if segDist > 0.55 then
            local dur = math.max(0.05, segDist / math.max(6, speed))
            cancelTween()
            activeTween = TweenService:Create(root, TweenInfo.new(dur, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                CFrame = CFrame.new(segTarget)
            })

            hbConn = RunService.Stepped:Connect(function()
                if not root or not root.Parent then cancelTween() return end
                if leash_on.Value and LEASH.center then
                    if (root.Position - LEASH.center).Magnitude > (LEASH.radius + 18) then
                        cancelTween()
                    end
                end
            end)

            local done = false
            activeTween.Completed:Once(function() done = true; cancelTween() end)
            activeTween:Play()

            local t0 = time()
            while tween_grown_toggle.Value and not done do
                if time() - t0 > 3.5 then cancelTween(); break end
                task.wait()
            end
            if not done then return false end
        end
        task.wait(0.02)
    end
    return true
end

spawn(function()
    while true do
        root = ensureRoot()
        if tween_grown_toggle.Value and root and root.Parent then
            local range = tonumber(tween_grown_range.Value) or 120
            local speed = tonumber(tween_speed.Value) or 20.0

            -- приоритет — выросшие кусты
            local bushes = scanBushes(range, fruitQuery)
            local target
            if #bushes > 0 then
                target = bushes[1].pos
            else
                local pb = nearestEmptyPB(range)
                if pb then target = pb.pos end
            end

            if target then
                target = clampToLeash(target)
                safeTweenTo(target, speed)
                -- и во время твин-движения быстро досаживаем рядом
                burstPlantNearby(4, 0.06, 12)
                task.wait(0.10)
            else
                task.wait(0.20)
            end
        else
            cancelTween()
            task.wait(0.20)
        end
    end
end)
-- ========= [ Конец Farming ] ========= 

-- ========= [ TAB: Auto Loot ] =========
Tabs.Loot = Window:AddTab({ Title = "Auto Loot", Icon = "package" })
local LOOT_ITEM_NAMES = {
    "Berry","Bloodfruit","Bluefruit","Lemon","Strawberry","Gold","Raw Gold","Crystal Chunk",
    "Coin","Coins","Coin Stack","Essence","Emerald","Raw Emerald","Pink Diamond",
    "Raw Pink Diamond","Void Shard","Jelly","Magnetite","Raw Magnetite","Adurite","Raw Adurite",
    "Ice Cube","Stone","Iron","Raw Iron","Steel","Hide","Leaves","Log","Wood","Pie"
}
local loot_on        = Tabs.Loot:CreateToggle("loot_on",      { Title="Auto Loot", Default=false })
local loot_range     = Tabs.Loot:CreateSlider("loot_range",   { Title="Range (studs)", Min=5, Max=150, Rounding=0, Default=40 })
local loot_batch     = Tabs.Loot:CreateSlider("loot_batch",   { Title="Max pickups / tick", Min=1, Max=50, Rounding=0, Default=12 })
local loot_cd        = Tabs.Loot:CreateSlider("loot_cd",      { Title="Tick cooldown (s)", Min=0.03, Max=0.4, Rounding=2, Default=0.08 })
local loot_chests    = Tabs.Loot:CreateToggle("loot_chests",  { Title="Also loot chests (Contents)", Default=true })
local loot_blacklist = Tabs.Loot:CreateToggle("loot_black",   { Title="Use selection as Blacklist (else Whitelist)", Default=false })
local loot_debug     = Tabs.Loot:CreateToggle("loot_debug",   { Title="Debug (F9)", Default=false })
local loot_dropdown  = Tabs.Loot:CreateDropdown("loot_items", { Title="Items (multi)", Values = LOOT_ITEM_NAMES, Multi=true, Default = { Leaves = true, Log = true } })

local function safePickup2(eid)
    local ok = pcall(function() pickup(eid) end)
    if not ok and packets and packets.Pickup and packets.Pickup.send then
        pcall(function() packets.Pickup.send(eid) end)
    end
end
local DROP_FOLDERS = { "Items","Drops","WorldDrops","Loot","Dropped","Resources" }
local watchedFolders, conns = {}, {}
local cache = {}
local function normalizedName(inst)
    local a
    if inst.GetAttribute then
        a = inst:GetAttribute("ItemName") or inst:GetAttribute("Name") or inst:GetAttribute("DisplayName")
    end
    if typeof(a) == "string" and a ~= "" then return a end
    return inst.Name
end
local function addDrop(inst)
    if cache[inst] then return end
    local eid = inst.GetAttribute and inst:GetAttribute("EntityID")
    if not eid then return end
    local name = normalizedName(inst)
    local getPos
    if inst:IsA("Model") then
        local pp = inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart"); if not pp then return end
        getPos = function() return pp.Position end
    elseif inst:IsA("BasePart") or inst:IsA("MeshPart") then
        getPos = function() return inst.Position end
    else
        return
    end
    cache[inst] = { eid = eid, name = name, getPos = getPos }
end
local function removeDrop(inst) cache[inst] = nil end
local function hookFolder(folder)
    if not folder or watchedFolders[folder] then return end
    watchedFolders[folder] = true
    for _,ch in ipairs(folder:GetChildren()) do addDrop(ch) end
    conns[#conns+1] = folder.ChildAdded:Connect(addDrop)
    conns[#conns+1] = folder.ChildRemoved:Connect(removeDrop)
end
local function hookChests()
    local dep = workspace:FindFirstChild("Deployables")
    if not dep then return end
    for _,mdl in ipairs(dep:GetChildren()) do
        if mdl:IsA("Model") then
            local contents = mdl:FindFirstChild("Contents")
            if contents and not watchedFolders[contents] then
                hookFolder(contents)
            end
        end
    end
    conns[#conns+1] = dep.ChildAdded:Connect(function(mdl)
        task.defer(function()
            if mdl:IsA("Model") then
                local contents = mdl:FindFirstChild("Contents")
                if contents then hookFolder(contents) end
            end
        end)
    end)
end
for _,n in ipairs(DROP_FOLDERS) do hookFolder(workspace:FindFirstChild(n)) end
hookChests()
task.spawn(function()
    while true do
        for _,n in ipairs(DROP_FOLDERS) do
            local f = workspace:FindFirstChild(n)
            if f and not watchedFolders[f] then hookFolder(f) end
        end
        if loot_chests.Value then hookChests() end
        task.wait(1.0)
    end
end)
local function selectedSet()
    local sel, val = {}, loot_dropdown.Value
    if typeof(val) == "table" then
        for k,v in pairs(val) do if v then sel[string.lower(k)] = true end end
    end
    return sel
end
task.spawn(function()
    while true do
        if loot_on.Value and root then
            local set       = selectedSet()
            local useBlack  = loot_blacklist.Value
            local range     = loot_range.Value
            local maxPer    = math.max(1, math.floor(loot_batch.Value))
            local candidates = {}
            for inst,info in pairs(cache) do
                if inst.Parent then
                    local isContents = false
                    if not loot_chests.Value then
                        local p = inst.Parent
                        while p and p ~= workspace do
                            if p.Name == "Contents" then isContents = true; break end
                            p = p.Parent
                        end
                    end
                    if not isContents then
                        local pos = info.getPos()
                        local d   = (pos - root.Position).Magnitude
                        if d <= range then
                            local nm   = info.name or "Unknown"
                            local pass = true
                            if next(set) ~= nil then
                                local inSel = set[string.lower(nm)] == true
                                pass = (useBlack and (not inSel)) or ((not useBlack) and inSel)
                            end
                            if pass then candidates[#candidates+1] = { eid = info.eid, dist = d, name = nm } end
                        end
                    end
                end
            end
            if #candidates > 1 then table.sort(candidates, function(a,b) return a.dist < b.dist end) end
            if loot_debug.Value then
                print(("[AutoLoot] candidates=%d (mode=%s, chests=%s)")
                    :format(#candidates, useBlack and "Blacklist" or "Whitelist", tostring(loot_chests.Value)))
            end
            for i = 1, math.min(maxPer, #candidates) do
                safePickup2(candidates[i].eid)
                if loot_debug.Value then
                    print(("[AutoLoot] pickup #%d: %s [%.1f]"):format(i, candidates[i].name, candidates[i].dist))
                end
                task.wait(0.01)
            end
            task.wait(loot_cd.Value)
        else
            task.wait(0.15)
        end
    end
end)

-- ========= [ TAB: Anti-AFK — chat + click + micro-move ] =========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:FindService("TextChatService")
local LP = Players.LocalPlayer

Tabs.AFK = Window:AddTab({ Title = "Anti-AFK", Icon = "moon" })

local afk_enable   = Tabs.AFK:CreateToggle("afk_enable",   { Title = "Enable Anti-AFK", Default = true })
local afk_min      = Tabs.AFK:CreateSlider("afk_min",      { Title = "Min interval (s)", Min=25, Max=120, Rounding=0, Default=45 })
local afk_max      = Tabs.AFK:CreateSlider("afk_max",      { Title = "Max interval (s)", Min=30, Max=180, Rounding=0, Default=75 })

local use_chat     = Tabs.AFK:CreateToggle("afk_use_chat", { Title = "Send chat ping", Default = true })
local chat_pool    = Tabs.AFK:AddInput("afk_chat_pool",    { Title = "Chat messages (comma-sep)", Default = " . , ping,hm", Finished = false })
local team_only    = Tabs.AFK:CreateToggle("afk_team_only",{ Title = "Team channel if exists", Default = false })

local use_click    = Tabs.AFK:CreateToggle("afk_use_click",{ Title = "Fake mouse click (center)", Default = true })
local click_down   = Tabs.AFK:CreateSlider("afk_click_len",{ Title = "Click hold (ms)", Min=10, Max=200, Rounding=0, Default=40 })

local use_move     = Tabs.AFK:CreateToggle("afk_use_move", { Title = "Micro move fallback", Default = true })

local afk_debug    = Tabs.AFK:CreateToggle("afk_debug",    { Title = "Debug prints (F9)", Default = false })

-- helpers
local function randRange(a,b) if a>b then a,b=b,a end return a + math.random()*(b-a) end
local function dprint(...) if afk_debug.Value then print("[AntiAFK]", ...) end end

-- Chat send (new TextChatService -> old ChatRemote fallback)
local function sendChatOnce(msg, team)
    msg = tostring(msg or ""):sub(1,120)
    if msg == "" then return false end
    -- TextChatService (modern)
    if TextChatService and TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel
        if team then
            channel = TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXTeam")
        end
        channel = channel or (TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral"))
        if channel and channel.SendAsync then
            local ok = pcall(function() channel:SendAsync(msg) end)
            if ok then dprint("TextChatService ->", team and "Team" or "All", msg) return true end
        end
    end
    -- Legacy
    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    local say = chatEvents and chatEvents:FindFirstChild("SayMessageRequest")
    if say and say.FireServer then
        local ch = team and "Team" or "All"
        local ok = pcall(function() say:FireServer(msg, ch) end)
        if ok then dprint("LegacyChat ->", ch, msg) return true end
    end
    return false
end

local function pickMessage()
    local s = tostring(chat_pool.Value or "")
    local pool = {}
    for tok in s:gmatch("[^,]+") do
        tok = (tok:gsub("^%s+",""):gsub("%s+$",""))
        if tok ~= "" then table.insert(pool, tok) end
    end
    if #pool == 0 then pool = {".","_","hm"} end
    return pool[math.random(1,#pool)]
end

-- Click once (center of screen)
local function fakeClickCenter()
    local cam = workspace.CurrentCamera
    if not cam then return false end
    local vps = cam.ViewportSize
    local x, y = math.floor(vps.X/2), math.floor(vps.Y/2)
    -- mouse left button down & up
    pcall(function()
        VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
        task.wait((click_down.Value or 40)/1000)
        VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
    end)
    dprint("Click at", x, y)
    return true
end

-- Micro-move (почти нулевой)
local function microMove()
    local ch = LP.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    hum:Move(Vector3.new(1e-4,0,0), true)
    RunService.Heartbeat:Wait()
    hum:Move(Vector3.new(), true)
    dprint("MicroMove")
    return true
end

-- главный цикл
task.spawn(function()
    math.randomseed(tick()%1*1e7)
    while true do
        if afk_enable.Value then
            local actions = 0
            -- 1) чат (случайно ~50% попытка, чтобы не спамить)
            if use_chat.Value and math.random() < 0.55 then
                local ok = sendChatOnce(pickMessage(), team_only.Value)
                if ok then actions += 1 end
            end
            -- 2) клик (всегда, если включено)
            if use_click.Value then
                if fakeClickCenter() then actions += 1 end
            end
            -- 3) запаска: микро-движение, если ничего не сработало
            if actions == 0 and use_move.Value then
                microMove()
            end
        end
        local waitSec = randRange(afk_min.Value, afk_max.Value)
        task.wait(waitSec)
    end
end)

-- малый анти-идл дефенз (иногда игры ловят стандартный Idle сигнал)
pcall(function()
    LP.Idled:Connect(function()
        dprint("Roblox Idled -> poke")
        if use_click.Value then fakeClickCenter() end
        if use_move.Value then microMove() end
    end)
end)
-- ========= [ /TAB: Anti-AFK ] =========




-- ========= [ Finish / Autoload ] =========
Window:SelectTab(1)
Library:Notify{ Title="Fuger Hub", Content="Loaded: Configs + Survival + Farming + Heal + Loot + Combat + ESP + Movement (leash ON)", Duration=6 }
pcall(function() SaveManager:LoadAutoloadConfig() end)
pcall(function()
    local ok = Route_LoadFromFile(ROUTE_AUTOSAVE, _G.__ROUTE, _G.__ROUTE._redraw)
    if ok then Library:Notify{ Title="Route", Content="Route autosave loaded", Duration=3 } end
end)
            print("script loaded succesfull")
          else
          Rayfield:Notify({
                  Title = "Error",
                  Content = "You are not whitelisted",
                  Image = "badge-alert",
                  Duration = 6.5,
                })
      end
    end    
  end,
})
