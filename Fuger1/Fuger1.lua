print("Loading Herkle Hub -- Booga Booga Reborn")
print("-----------------------------------------")
local Library = loadstring(game:HttpGetAsync("https://github.com/1dontgiveaf/Fluent-Renewed/releases/download/v1.0/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/1dontgiveaf/Fluent-Renewed/refs/heads/main/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/1dontgiveaf/Fluent-Renewed/refs/heads/main/Addons/InterfaceManager.luau"))()
 
local Window = Library:CreateWindow{
    Title = "Herkle Hub -- Booga Booga Reborn",
    SubTitle = "by herkle berlington",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
}

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "menu" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "axe" }),
    Map = Window:AddTab({ Title = "Map", Icon = "trees" }),
    Pickup = Window:AddTab({ Title = "Pickup", Icon = "backpack" }),
    Farming = Window:AddTab({ Title = "Farming", Icon = "sprout" }),
    Extra = Window:AddTab({ Title = "Extra", Icon = "plus" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local rs = game:GetService("ReplicatedStorage")
local packets = require(rs.Modules.Packets)
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local runs = game:GetService("RunService")
local httpservice = game:GetService("HttpService")
local Players = game:GetService("Players")
local localiservice = game:GetService("LocalizationService")
local marketservice = game:GetService("MarketplaceService")
local rbxservice = game:GetService("RbxAnalyticsService")
local placestructure
local tspmo = game:GetService("TweenService")
local itemslist = {
"Adurite", "Berry", "Bloodfruit", "Bluefruit", "Coin", "Essence", "Hide", "Ice Cube", "Iron", "Jelly", "Leaves", "Log", "Steel", "Stone", "Wood", "Gold", "Raw Gold", "Crystal Chunk", "Raw Emerald", "Pink Diamond", "Raw Adurite", "Raw Iron", "Coal"}
local Options = Library.Options
--{MAIN TAB}
local wstoggle = Tabs.Main:CreateToggle("wstoggle", { Title = "Walkspeed", Default = false })
local wsslider = Tabs.Main:CreateSlider("wsslider", { Title = "Value", Min = 1, Max = 35, Rounding = 1, Default = 16 })
local jptoggle = Tabs.Main:CreateToggle("jptoggle", { Title = "JumpPower", Default = false })
local jpslider = Tabs.Main:CreateSlider("jpslider", { Title = "Value", Min = 1, Max = 65, Rounding = 1, Default = 50 })
local hheighttoggle = Tabs.Main:CreateToggle("hheighttoggle", { Title = "HipHeight", Default = false })
local hheightslider = Tabs.Main:CreateSlider("hheightslider", { Title = "Value", Min = 0.1, Max = 6.5, Rounding = 1, Default = 2 })
local msatoggle = Tabs.Main:CreateToggle("msatoggle", { Title = "No Mountain Slip", Default = false })
Tabs.Main:CreateButton({Title = "Copy Job ID", Callback = function() setclipboard(game.JobId) end})
Tabs.Main:CreateButton({Title = "Copy HWID", Callback = function() setclipboard(rbxservice:GetClientId()) end})
Tabs.Main:CreateButton({Title = "Copy SID", Callback = function() setclipboard(rbxservice:GetSessionId()) end})
--{COMBAT TAB}
local killauratoggle = Tabs.Combat:CreateToggle("killauratoggle", { Title = "Kill Aura", Default = false })
local killaurarangeslider = Tabs.Combat:CreateSlider("killaurarange", { Title = "Range", Min = 1, Max = 9, Rounding = 1, Default = 5 })
local katargetcountdropdown = Tabs.Combat:CreateDropdown("katargetcountdropdown", { Title = "Max Targets", Values = { "1", "2", "3", "4", "5", "6" }, Default = "1" })
local kaswingcooldownslider = Tabs.Combat:CreateSlider("kaswingcooldownslider", { Title = "Attack Cooldown (s)", Min = 0.01, Max = 1.01, Rounding = 2, Default = 0.1 })
--{MAP TAB}
local resourceauratoggle = Tabs.Map:CreateToggle("resourceauratoggle", { Title = "Resource Aura", Default = false })
local resourceaurarange = Tabs.Map:CreateSlider("resourceaurarange", { Title = "Range", Min = 1, Max = 20, Rounding = 1, Default = 20 })
local resourcetargetdropdown = Tabs.Map:CreateDropdown("resourcetargetdropdown", { Title = "Max Targets", Values = { "1", "2", "3", "4", "5", "6" }, Default = "1" })
local resourcecooldownslider = Tabs.Map:CreateSlider("resourcecooldownslider", { Title = "Swing Cooldown (s)", Min = 0.01, Max = 1.01, Rounding = 2, Default = 0.1 })
local critterauratoggle = Tabs.Map:CreateToggle("critterauratoggle", { Title = "Critter Aura", Default = false })
local critterrangeslider = Tabs.Map:CreateSlider("critterrangeslider", { Title = "Range", Min = 1, Max = 20, Rounding = 1, Default = 20 })
local crittertargetdropdown = Tabs.Map:CreateDropdown("crittertargetdropdown", { Title = "Max Targets", Values = { "1", "2", "3", "4", "5", "6" }, Default = "1" })
local crittercooldownslider = Tabs.Map:CreateSlider("crittercooldownslider", { Title = "Swing Cooldown (s)", Min = 0.01, Max = 1.01, Rounding = 2, Default = 0.1 })
--{PICKUP TAB}
local autopickuptoggle = Tabs.Pickup:CreateToggle("autopickuptoggle", { Title = "Auto Pickup", Default = false })
local chestpickuptoggle = Tabs.Pickup:CreateToggle("chestpickuptoggle", { Title = "Auto Pickup From Chests", Default = false })
local pickuprangeslider = Tabs.Pickup:CreateSlider("pickuprange", { Title = "Pickup Range", Min = 1, Max = 35, Rounding = 1, Default = 20 })
local itemdropdown = Tabs.Pickup:CreateDropdown("itemdropdown", {Title = "Items", Values = {"Berry", "Bloodfruit", "Bluefruit", "Lemon", "Strawberry", "Gold", "Raw Gold", "Crystal Chunk", "Coin", "Coins", "Coin2", "Coin Stack", "Essence", "Emerald", "Raw Emerald", "Pink Diamond", "Raw Pink Diamond", "Void Shard","Jelly", "Magnetite", "Raw Magnetite", "Adurite", "Raw Adurite", "Ice Cube", "Stone", "Iron", "Raw Iron", "Steel", "Hide", "Leaves", "Log", "Wood", "Pie"}, Multi = true, Default = { Leaves = true, Log = true }})
local droptoggle = Tabs.Pickup:AddToggle("droptoggle", { Title = "Auto Drop", Default = false })
local dropdropdown = Tabs.Pickup:AddDropdown("dropdropdown", {Title = "Select Item to Drop", Values = { "Bloodfruit", "Jelly", "Bluefruit", "Log", "Leaves", "Wood" }, Default = "Bloodfruit"})
local droptogglemanual = Tabs.Pickup:AddToggle("droptogglemanual", { Title = "Auto Drop Custom", Default = false })
local droptextbox = Tabs.Pickup:AddInput("droptextbox", { Title = "Custom Item", Default = "Bloodfruit", Numeric = false, Finished = false })
-- Добавляем вкладку Tp-pos
Tabs.TpPos = Window:AddTab({ Title = "Tp-pos", Icon = "location" })

--{FARMING TAB}
local fruitdropdown = Tabs.Farming:CreateDropdown("fruitdropdown", {Title = "Select Fruit",Values = {"Bloodfruit", "Bluefruit", "Lemon", "Coconut", "Jelly", "Banana", "Orange", "Oddberry", "Berry", "Strangefruit", "Strawberry", "Sunjfruit", "Pumpkin", "Prickly Pear", "Apple",  "Barley", "Cloudberry", "Carrot"}, Default = "Bloodfruit"})
local planttoggle = Tabs.Farming:CreateToggle("planttoggle", { Title = "Auto Plant", Default = false })
local plantrangeslider = Tabs.Farming:CreateSlider("plantrange", { Title = "Plant Range", Min = 1, Max = 30, Rounding = 1, Default = 30 })
local plantdelayslider = Tabs.Farming:CreateSlider("plantdelay", { Title = "Plant Delay (s)", Min = 0.01, Max = 1, Rounding = 2, Default = 0.1 })
local harvesttoggle = Tabs.Farming:CreateToggle("harvesttoggle", { Title = "Auto Harvest", Default = false })
local harvestrangeslider = Tabs.Farming:CreateSlider("harvestrange", { Title = "Harvest Range", Min = 1, Max = 30, Rounding = 1, Default = 30 })
Tabs.Farming:CreateParagraph("Aligned Paragraph", {Title = "Tween Stuff", Content = "wish this ui was more like linoria :(", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})
local tweenplantboxtoggle = Tabs.Farming:AddToggle("tweentoplantbox", { Title = "Tween to Plant Box", Default = false })
local tweenbushtoggle = Tabs.Farming:AddToggle("tweentobush", { Title = "Tween to Bush + Plant Box", Default = false })
local tweenrangeslider = Tabs.Farming:AddSlider("tweenrange", { Title = "Range", Min = 1, Max = 250, Rounding = 1, Default = 250 })
Tabs.Farming:CreateParagraph("Aligned Paragraph", {Title = "Plantbox Stuff", Content = "wish this ui was more like linoria :(", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})
Tabs.Farming:CreateButton({Title = "Place 16x16 Plantboxes (256)", Callback = function() placestructure(16) end })
Tabs.Farming:CreateButton({Title = "Place 15x15 Plantboxes (225)", Callback = function() placestructure(15) end })
Tabs.Farming:CreateButton({Title = "Place 10x10 Plantboxes (100)", Callback = function() placestructure(10) end })
Tabs.Farming:CreateButton({Title = "Place 5x5 Plantboxes (25)", Callback = function() placestructure(5) end })
--{EXTRA TAB}
Tabs.Extra:CreateButton({Title = "Infinite Yield", Description = "inf yield chat", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/decryp1/herklesiy/refs/heads/main/hiy"))()end})
Tabs.Extra:CreateParagraph("Aligned Paragraph", {Title = "orbit breaks sometimes", Content = "i dont give a shit", TitleAlignment = "Middle", ContentAlignment = Enum.TextXAlignment.Center})
local orbittoggle = Tabs.Extra:CreateToggle("orbittoggle", { Title = "Item Orbit", Default = false })
local orbitrangeslider = Tabs.Extra:CreateSlider("orbitrange", { Title = "Grab Range", Min = 1, Max = 50, Rounding = 1, Default = 20 })
local orbitradiusslider = Tabs.Extra:CreateSlider("orbitradius", { Title = "Orbit Radius", Min = 0, Max = 30, Rounding = 1, Default = 10 })
local orbitspeedslider = Tabs.Extra:CreateSlider("orbitspeed", { Title = "Orbit Speed", Min = 0, Max = 10, Rounding = 1, Default = 5 })
local itemheightslider = Tabs.Extra:CreateSlider("itemheight", { Title = "Item Height", Min = -3, Max = 10, Rounding = 1, Default = 3 })
--{END OF TAB ELEMENTS}


-- =========================
-- TAB: Break (Gold + Ice)
-- =========================

-- берём/создаём вкладку Break (GUI не ломаем)
local BreakTab = Tabs and Tabs.Break
if not BreakTab then
    local ok, res = pcall(function()
        return Window:AddTab({ Title = "Break", Icon = "hammer" })
    end)
    BreakTab = ok and res or Window
    Tabs.Break = BreakTab
end

-- UI
local brk_gold_toggle   = BreakTab:CreateToggle("break_gold_toggle", { Title = "Auto Break: Gold Node (through Ice)", Default = false })
local brk_gold_range    = BreakTab:CreateSlider("break_gold_range",  { Title = "Range (studs)", Min = 1, Max = 50, Rounding = 1, Default = 20 })
local brk_gold_cooldown = BreakTab:CreateSlider("break_gold_cd",     { Title = "Swing cooldown (s)", Min = 0.01, Max = 1.0, Rounding = 2, Default = 0.15 })

BreakTab:CreateParagraph("brk_sep", { Title = "— Optional —", Content = "Отдельное авто-ломание Ice Chunk (если нужно фармить лёд)." })

local brk_ice_toggle   = BreakTab:CreateToggle("break_ice_toggle", { Title = "Auto Break: Ice Chunk", Default = false })
local brk_ice_range    = BreakTab:CreateSlider("break_ice_range",  { Title = "Range (studs)", Min = 1, Max = 50, Rounding = 1, Default = 20 })
local brk_ice_cooldown = BreakTab:CreateSlider("break_ice_cd",     { Title = "Swing cooldown (s)", Min = 0.01, Max = 1.0, Rounding = 2, Default = 0.15 })

-- ===== helpers =====
local Players = game:GetService("Players")
local LP      = Players.LocalPlayer

local function getRoot()
    local ch = LP.Character
    return ch and ch:FindFirstChild("HumanoidRootPart") or nil
end

local function sendSwing(listOfEids)
    -- пробуем твою swingtool, иначе напрямую пакетом
    local ok = false
    if typeof(swingtool) == "function" then
        ok = pcall(function() swingtool(listOfEids) end)
        if ok then return end
    end
    if packets and packets.SwingTool and packets.SwingTool.send then
        pcall(function() packets.SwingTool.send(listOfEids) end)
    end
end

local function findNearestModelAroundPos(name, pos, range)
    local best, bestPos, bestDist

    local function scanFolder(folder)
        if not folder then return end
        for _, inst in ipairs(folder:GetChildren()) do
            if inst:IsA("Model") and inst.Name == name then
                local eid = inst:GetAttribute("EntityID")
                local pp  = inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart")
                if eid and pp then
                    local d = (pp.Position - pos).Magnitude
                    if d <= range and (not bestDist or d < bestDist) then
                        best, bestPos, bestDist = eid, pp.Position, d
                    end
                end
            end
        end
    end

    scanFolder(workspace)
    scanFolder(workspace:FindFirstChild("Resources"))
    return best, bestPos, bestDist
end

local function findNearestModelFromRoot(name, root, range)
    return findNearestModelAroundPos(name, root.Position, range)
end

-- ===== Auto Break: Gold Node (через Ice, если покрыт)
task.spawn(function()
    while true do
        local root = getRoot()
        if root and Options.break_gold_toggle and Options.break_gold_toggle.Value then
            local range    = tonumber(Options.break_gold_range.Value) or 20
            local cooldown = tonumber(Options.break_gold_cd.Value)    or 0.15

            -- ближайшее золото
            local goldEid, goldPos = findNearestModelFromRoot("Gold Node", root, range)
            if goldEid and goldPos then
                -- ищем лёд, который может «накрывать» это золото
                -- радиус покрытия подбери под карту; 6–10 обычно ок
                local iceEid = select(1, findNearestModelAroundPos("Ice Chunk", goldPos, 9))
                if iceEid then
                    -- бьём лёд и золото одним свингом (лёд треснет, золото получит урон)
                    sendSwing({ iceEid, goldEid })
                else
                    sendSwing({ goldEid })
                end
            end

            task.wait(cooldown)
        else
            task.wait(0.12)
        end
    end
end)

-- ===== Auto Break: Ice Chunk (отдельно, на всякий случай)
task.spawn(function()
    while true do
        local root = getRoot()
        if root and Options.break_ice_toggle and Options.break_ice_toggle.Value then
            local range    = tonumber(Options.break_ice_range.Value) or 20
            local cooldown = tonumber(Options.break_ice_cd.Value)    or 0.15

            local iceEid = select(1, findNearestModelFromRoot("Ice Chunk", root, range))
            if iceEid then
                sendSwing({ iceEid })
            end

            task.wait(cooldown)
        else
            task.wait(0.12)
        end
    end
end)

-- =========================
-- TAB: Follow (следовать за игроком)
-- =========================

-- Создаём вкладку
Tabs.Follow = Window:AddTab({ Title = "Follow", Icon = "user" })

-- UI
local flw_toggle = Tabs.Follow:CreateToggle("flw_on", {
    Title = "Follow selected player",
    Default = false
})

local flw_dist = Tabs.Follow:CreateSlider("flw_dist", {
    Title = "Keep distance (studs)",
    Min = 2, Max = 50, Rounding = 1, Default = 8
})

local flw_speed = Tabs.Follow:CreateSlider("flw_speed", {
    Title = "Speed (BV)",
    Min = 5, Max = 60, Rounding = 1, Default = 21
})

local function getAllPlayerNames()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= plr then table.insert(list, p.Name) end
    end
    table.sort(list)
    return list
end

local flw_dd = Tabs.Follow:CreateDropdown("flw_target", {
    Title = "Target player",
    Values = getAllPlayerNames(),
    Default = ""
})

Tabs.Follow:CreateButton({
    Title = "Refresh list",
    Callback = function()
        local names = getAllPlayerNames()
        -- пробуем обновить значения безопасно
        pcall(function()
            if flw_dd.SetValues then
                flw_dd:SetValues(names)
            end
        end)
        -- автоселект первого, если пусто
        if #names > 0 and (Options.flw_target.Value or "") == "" then
            pcall(function() flw_dd:SetValue(names[1]) end)
        end
    end
})

-- авто-обновление списка при заходе/выходе игроков
Players.PlayerAdded:Connect(function()
    pcall(function()
        if flw_dd.SetValues then flw_dd:SetValues(getAllPlayerNames()) end
    end)
end)
Players.PlayerRemoving:Connect(function(leaver)
    pcall(function()
        if flw_dd.SetValues then flw_dd:SetValues(getAllPlayerNames()) end
    end)
    -- если цель вышла — выключим фоллоу
    if Options.flw_target.Value == leaver.Name then
        flw_toggle:SetValue(false)
    end
end)

-- ===== логика follow через BodyVelocity =====
local function FLW_getBV()
    if not root then return nil end
    return root:FindFirstChild("_FLW_BV")
end

local function FLW_ensureBV()
    if not root then return nil end
    local bv = FLW_getBV()
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "_FLW_BV"
        bv.MaxForce = Vector3.new(1e9, 0, 1e9) -- только по XZ
        bv.Velocity = Vector3.new()
        bv.Parent = root
    end
    return bv
end

local function FLW_killBV()
    local bv = FLW_getBV()
    if bv then bv:Destroy() end
end

-- найти HumanoidRootPart цели (папка может быть и в workspace.Players)
local function getTargetRootByName(name)
    if not name or name == "" then return nil end
    local p = Players:FindFirstChild(name)
    if not p then return nil end

    -- приоритет: объект в workspace.Players (у вас так сущности устроены)
    local wf = workspace:FindFirstChild("Players")
    if wf then
        local wfplr = wf:FindFirstChild(name)
        if wfplr then
            local hrp = wfplr:FindFirstChild("HumanoidRootPart")
            if hrp then return hrp end
        end
    end

    -- запасной вариант — через Character
    local ch = p.Character
    return ch and ch:FindFirstChild("HumanoidRootPart") or nil
end

-- на всякий случай подчистим BV при респавне
plr.CharacterAdded:Connect(function()
    task.defer(FLW_killBV)
end)

-- основной раннер
task.spawn(function()
    while true do
        if Options.flw_on.Value then
            -- параметры
            local targetName = Options.flw_target.Value
            local keepDist   = tonumber(Options.flw_dist.Value) or 8
            local speed      = tonumber(Options.flw_speed.Value) or 21

            local trg = getTargetRootByName(targetName)
            if root and trg then
                local bv = FLW_ensureBV()

                local myPos  = root.Position
                local trgPos = trg.Position
                -- вектор только в XZ плоскости
                local v = Vector3.new(trgPos.X - myPos.X, 0, trgPos.Z - myPos.Z)
                local d = v.Magnitude

                local band = 0.8 -- гистерезис, чтобы не дёргался
                if d > keepDist + band then
                    bv.Velocity = v.Unit * speed
                elseif d < math.max(keepDist - band, 1) then
                    -- слишком близко — стоп
                    bv.Velocity = Vector3.new()
                else
                    -- в «кольце» — лёгкое сопровождение
                    bv.Velocity = v.Unit * (speed * 0.4)
                end
            else
                -- цели нет — стоп и чистка
                local bv = FLW_getBV()
                if bv then bv.Velocity = Vector3.new() end
                -- если цель пропала надолго — выключим
                -- (не жёстко: оставим включённым, вдруг вернётся)
            end

            runs.Heartbeat:Wait()
        else
            -- выключено — чистим BV, чтобы ты мог свободно ходить
            FLW_killBV()
            task.wait(0.15)
        end
    end
end)





-- ===============================================================
-- 🍏 TAB: Survival — авто-еда по голоду (держит планку)
-- ===============================================================
Tabs.Survival = Window:AddTab({ Title = "Survival", Icon = "apple" })

-- UI
local ae_toggle = Tabs.Survival:CreateToggle("ae_toggle", {
    Title = "Auto Eat (Hunger)",
    Default = false
})

local ae_food = Tabs.Survival:CreateDropdown("ae_food", {
    Title = "Food to eat",
    Values = {"Bloodfruit","Berry","Bluefruit","Coconut","Strawberry","Pumpkin","Apple","Lemon","Orange","Banana"},
    Default = "Bloodfruit"
})

local ae_thresh = Tabs.Survival:CreateSlider("ae_thresh", {
    Title = "Setpoint / Threshold (%)",
    Min = 1, Max = 100, Rounding = 0, Default = 70
})

-- Режим шкалы:
-- Fullness 100→0 : 100 = сытый, 0 = пусто (есть, когда < порога, доедаем до порога)
-- Hunger   0→100 : 0 = сытый, 100 = голодный (есть, когда > порога, доедаем до порога)
local ae_mode = Tabs.Survival:CreateDropdown("ae_mode", {
    Title = "Scale mode",
    Values = {"Fullness 100→0","Hunger 0→100"},
    Default = "Fullness 100→0"
})

local ae_debug = Tabs.Survival:CreateToggle("ae_debug", {
    Title = "Debug logs (F9)",
    Default = false
})

Tabs.Survival:CreateButton({
    Title = "List packet names (debug)",
    Callback = function()
        for name, t in pairs(packets) do
            print("[packets]", name, typeof(t), (typeof(t)=="table" and t.send) and "(send)" or "")
        end
    end
})

----------------------------------------------------------------
-- ===== Считывание процента голода (универсально) =====
local function normPct(n)
    if type(n) ~= "number" then return nil end
    if n <= 1.5 then n = n * 100 end          -- 0..1 -> %
    if n < 0 or n > 100 then n = math.clamp(n, 0, 100) end
    return n
end

local function readHungerFromValues()
    for _,v in ipairs(plr:GetDescendants()) do
        if v.Name == "Hunger" and (v:IsA("NumberValue") or v:IsA("IntValue")) then
            return normPct(v.Value)
        end
    end
end

local function readHungerFromBar()
    local pg = plr:FindFirstChild("PlayerGui"); if not pg then return end
    local mg = pg:FindFirstChild("MainGui");    if not mg then return end
    local bars = mg:FindFirstChild("Bars");     if not bars then return end
    local hb = bars:FindFirstChild("Hunger")
    if hb and hb:IsA("Frame") and hb.Size and hb.Size.X and typeof(hb.Size.X.Scale)=="number" then
        return normPct(hb.Size.X.Scale)         -- 0..1 -> %
    end
end

local function readHungerFromText()
    local pg = plr:FindFirstChild("PlayerGui"); if not pg then return end
    for _,inst in ipairs(pg:GetDescendants()) do
        if inst:IsA("TextLabel") then
            local txt = tostring(inst.Text or ""):lower()
            if txt:find("голод") or inst.Name:lower():find("hunger") or (inst.Parent and inst.Parent.Name:lower():find("hunger")) then
                local num = tonumber(txt:match("([-+]?%d+%.?%d*)"))
                if num and num >= 0 and num <= 100 then return num end
            end
        end
    end
end

local function readHungerFromAttr()
    local a = plr:GetAttribute("Hunger")
    if typeof(a) == "number" then return normPct(a) end
end

local function readHungerPercent()
    return readHungerFromValues()
        or readHungerFromBar()
        or readHungerFromText()
        or readHungerFromAttr()
        or 100
end

----------------------------------------------------------------
-- ===== Поиск слота по имени в инвентаре =====
local function findInventoryList()
    local pg = plr:FindFirstChild("PlayerGui"); if not pg then return nil end
    local mg = pg:FindFirstChild("MainGui");    if not mg then return nil end
    local rp = mg:FindFirstChild("RightPanel"); if not rp then return nil end
    local inv = rp:FindFirstChild("Inventory"); if not inv then return nil end
    return inv:FindFirstChild("List")
end

local function getSlotByName(itemName)
    local list = findInventoryList()
    if not list then return nil end
    for _,child in ipairs(list:GetChildren()) do
        if child:IsA("ImageLabel") and child.Name == itemName then
            return child.LayoutOrder
        end
    end
    return nil
end

----------------------------------------------------------------
-- ===== Вызовы поедания (слот/ID — пробуем всё известное) =====
local function consumeBySlot(slot)
    if packets.UseBagItem      and packets.UseBagItem.send      then pcall(function() packets.UseBagItem.send(slot) end)      return true end
    if packets.ConsumeBagItem  and packets.ConsumeBagItem.send  then pcall(function() packets.ConsumeBagItem.send(slot) end)  return true end
    if packets.ConsumeItem     and packets.ConsumeItem.send     then pcall(function() packets.ConsumeItem.send(slot) end)     return true end
    if packets.UseItem         and packets.UseItem.send         then pcall(function() packets.UseItem.send(slot) end)         return true end
    return false
end

local function getItemIdByName(name)
    if type(fruittoitemid)=="table" then return fruittoitemid[name] end
    if rawget(_G,"fruittoitemid") then return _G.fruittoitemid[name] end
    return nil
end

local function consumeById(id)
    if not id then return false end
    if packets.ConsumeItem and packets.ConsumeItem.send then pcall(function() packets.ConsumeItem.send(id) end) return true end
    if packets.UseItem     and packets.UseItem.send     then pcall(function() packets.UseItem.send({itemID=id}) end) return true end
    if packets.Eat         and packets.Eat.send         then pcall(function() packets.Eat.send(id) end) return true end
    if packets.EatFood     and packets.EatFood.send     then pcall(function() packets.EatFood.send(id) end) return true end
    return false
end

----------------------------------------------------------------
-- ===== Основной цикл: держать планку =====
local eatingLock = false
task.spawn(function()
    while true do
        task.wait(0.2)
        if not ae_toggle.Value then continue end

        local target = ae_thresh.Value
        local mode   = ae_mode.Value
        local cur    = readHungerPercent()

        -- Когда запускаем серию «кушаем до порога»:
        local need = (mode == "Fullness 100→0") and (cur < target)
                  or (mode == "Hunger 0→100")   and (cur > target)

        if need and not eatingLock then
            eatingLock = true
            task.spawn(function()
                local tries, maxTries = 0, 25      -- максимум укусов за одну серию
                local minDelay, band = 0.15, 0.5   -- задержка и «мертвая зона» вокруг порога

                while ae_toggle.Value and tries < maxTries do
                    cur = readHungerPercent()

                    -- Проверяем, достигли ли планки (с маленьким гистерезисом)
                    local okNow = (mode == "Fullness 100→0") and (cur >= target - band)
                               or (mode == "Hunger 0→100")   and (cur <= target + band)
                    if okNow then
                        if ae_debug.Value then
                            print(("[AutoEat] setpoint reached: cur=%.1f ~ target=%d (%s)"):format(cur, target, mode))
                        end
                        break
                    end

                    -- Делаем «укус»
                    local food = ae_food.Value or "Bloodfruit"
                    local ate  = false
                    local slot = getSlotByName(food)
                    if slot then
                        ate = consumeBySlot(slot)
                    end
                    if not ate then
                        ate = consumeById(getItemIdByName(food))
                    end

                    if ae_debug.Value then
                        print(("[AutoEat] aim=%d, cur=%.1f, try=%d → %s")
                            :format(target, cur, tries + 1, ate and "EAT" or "MISS"))
                    end

                    tries += 1
                    task.wait(minDelay)
                end

                eatingLock = false
            end)
        end
    end
end)
-- ===============================================================
-- /TAB: Survival
-- ===============================================================



-- =========================
-- TAB: BV Macro (простая запись/проигрыш)
-- =========================
local RS  = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local plr = game.Players.LocalPlayer
local hum, root
local function ensureHum()
    local ch = plr.Character or plr.CharacterAdded:Wait()
    hum  = ch:FindFirstChildOfClass("Humanoid") or ch:WaitForChild("Humanoid")
    root = ch:FindFirstChild("HumanoidRootPart") or ch:WaitForChild("HumanoidRootPart")
end
ensureHum()
plr.CharacterAdded:Connect(function() task.defer(ensureHum) end)

-- Состояние/параметры макроса
local Macro = {
    points = {},              -- { {t=sec, pos=Vector3}, ... }
    recording = false,
    playing = false,
    guard = 0,

    speed = 21.0,             -- скорость BV (везде)
    sampleInterval = 0.06,    -- шаг записи
    stopTol = 0.55,           -- допуск до точки (2D)
    maxSegTime = 6,           -- failsafe на сегмент
    loop = false,             -- повтор циклом
}

local recConn

local function horiz(v) return Vector3.new(v.X,0,v.Z) end
local function dist2D(a, b)
    return (Vector3.new(a.X,0,a.Z) - Vector3.new(b.X,0,b.Z)).Magnitude
end

local function makeBV()
    if not root then return end
    local old = root:FindFirstChildOfClass("BodyVelocity")
    if old then old:Destroy() end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9, 0, 1e9)
    bv.Velocity = Vector3.new()
    bv.Parent = root
    return bv
end

local function destroyBV()
    if not root then return end
    local old = root:FindFirstChildOfClass("BodyVelocity")
    if old then old:Destroy() end
end

-- Плавный проход к точке на BV
local function moveBV_to(target, speed, myGuard)
    ensureHum(); if not (hum and root) then return false end
    local bv = makeBV(); if not bv then return false end
    local tStart = tick()
    while Macro.playing and myGuard == Macro.guard do
        local rp = root.Position
        local to = horiz(target - rp)
        local d  = to.Magnitude
        if d <= Macro.stopTol then
            bv.Velocity = Vector3.new()
            break
        end
        local dir = to.Unit
        bv.Velocity = dir * speed
        if (tick() - tStart) > Macro.maxSegTime then
            break
        end
        RS.Heartbeat:Wait()
    end
    return true
end

-- ===== Запись
local t0 = 0
local function recStart()
    if Macro.recording then return end
    ensureHum(); if not root then return end
    table.clear(Macro.points)
    t0 = tick()
    Macro.recording = true

    local last = 0
    recConn = RS.Heartbeat:Connect(function()
        if not Macro.recording then return end
        local now = tick() - t0
        if now - last >= Macro.sampleInterval then
            last = now
            if root then
                table.insert(Macro.points, { t = now, pos = root.Position })
            end
        end
    end)
    print("[BV Macro] RECORD started")
end

local function recStop()
    if not Macro.recording then return end
    Macro.recording = false
    if recConn then recConn:Disconnect(); recConn = nil end
    print(("[BV Macro] RECORD stopped. Points=%d"):format(#Macro.points))
end

-- ===== Проигрыш
local function playOnce(myGuard)
    ensureHum(); if not (hum and root) then return end
    if #Macro.points < 2 then return end

    local startPosOnPlay = root.Position

    -- 1) подбегаем к первой записанной точке
    local first = Macro.points[1].pos
    moveBV_to(first, Macro.speed, myGuard)
    if not Macro.playing or myGuard ~= Macro.guard then return end

    -- 2) идём по всем сегментам ТАК ЖЕ, как записано
    for i = 1, #Macro.points - 1 do
        if not Macro.playing or myGuard ~= Macro.guard then return end
        local a, b = Macro.points[i], Macro.points[i+1]
        local d = dist2D(a.pos, b.pos)
        local dt = math.max(0, b.t - a.t)

        if d <= 0.05 then
            if dt > 0 then task.wait(dt) end  -- это «пауза» в записи
        else
            moveBV_to(b.pos, Macro.speed, myGuard)
            -- опционально небольшой выравнивающий sleep, чтобы не «толкаться» кадрами
            if dt > 0 then
                -- если хочешь максимально жёсткий тайминг — раскомментируй:
                -- task.wait(dt)
            end
        end
    end
    if not Macro.playing or myGuard ~= Macro.guard then return end

    -- 3) возврат туда, где нажали Play
    moveBV_to(startPosOnPlay, Macro.speed, myGuard)
end

local function playStart()
    if Macro.playing then return end
    if #Macro.points < 2 then
        warn("[BV Macro] Not enough points. Record first.")
        return
    end
    Macro.playing = true
    Macro.guard += 1
    local myGuard = Macro.guard
    print("[BV Macro] PLAY started")

    task.spawn(function()
        repeat
            playOnce(myGuard)
            -- защита на случай обрыва
            if not Macro.playing or myGuard ~= Macro.guard then break end
        until not Macro.loop
        Macro.playing = false
        destroyBV()
        print("[BV Macro] PLAY stopped")
    end)
end

local function playStop()
    Macro.recording = false
    if recConn then recConn:Disconnect(); recConn = nil end
    Macro.playing = false
    Macro.guard += 1
    destroyBV()
    print("[BV Macro] STOP")
end

-- ====== TAB UI (кнопки/настройки)
Tabs.BVMacro = Window:AddTab({ Title = "BV Macro", Icon = "play" })

Tabs.BVMacro:CreateButton({ Title = "Start Recording", Callback = recStart })
Tabs.BVMacro:CreateButton({ Title = "Stop Recording",  Callback = recStop  })
Tabs.BVMacro:CreateButton({ Title = "Play",            Callback = playStart })
Tabs.BVMacro:CreateButton({ Title = "Stop",            Callback = playStop  })

local spd = Tabs.BVMacro:CreateSlider("bvm_speed", {
    Title="Speed (BV)", Min=5, Max=60, Rounding=1, Default=21
})
spd:OnChanged(function(v) Macro.speed = v end)

local si = Tabs.BVMacro:CreateSlider("bvm_sample", {
    Title="Sample interval (s)", Min=0.02, Max=0.2, Rounding=2, Default=0.06
})
si:OnChanged(function(v) Macro.sampleInterval = v end)

local tol = Tabs.BVMacro:CreateSlider("bvm_tol", {
    Title="Stop tolerance (studs)", Min=0.1, Max=2.0, Rounding=2, Default=0.55
})
tol:OnChanged(function(v) Macro.stopTol = v end)

local loopT = Tabs.BVMacro:CreateToggle("bvm_loop", { Title="Loop playback", Default=false })
loopT:OnChanged(function(v) Macro.loop = v end)

-- хоткеи по желанию (убери если не надо)
UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.F5 then
        if Macro.recording then recStop() else recStart() end
    elseif inp.KeyCode == Enum.KeyCode.F6 then
        playStart()
    elseif inp.KeyCode == Enum.KeyCode.F7 then
        playStop()
    end
end)












local wscon, hhcon
local function updws()
    if wscon then wscon:Disconnect() end

    if Options.wstoggle.Value or Options.jptoggle.Value then
        wscon = runs.RenderStepped:Connect(function()
            if hum then
                hum.WalkSpeed = Options.wstoggle.Value and Options.wsslider.Value or 16
                hum.JumpPower = Options.jptoggle.Value and Options.jpslider.Value or 50
            end
        end)
    end
end

local function updhh()
    if hhcon then hhcon:Disconnect() end

    if Options.hheighttoggle.Value then
        hhcon = runs.RenderStepped:Connect(function()
            if hum then
                hum.HipHeight = Options.hheightslider.Value
            end
        end)
    end
end

local function onplradded(newChar)
    char = newChar
    root = char:WaitForChild("HumanoidRootPart")
    hum = char:WaitForChild("Humanoid")

    updws()
    updhh()
end

plr.CharacterAdded:Connect(onplradded)
Options.wstoggle:OnChanged(updws)
Options.jptoggle:OnChanged(updws)
Options.hheighttoggle:OnChanged(updhh)

local slopecon
local function updmsa()
    if slopecon then slopecon:Disconnect() end

    if Options.msatoggle.Value then
        slopecon = game:GetService("RunService").RenderStepped:Connect(function()
            if hum then
                hum.MaxSlopeAngle = 90
            end
        end)
    else
        if hum then
            hum.MaxSlopeAngle = 46
        end
    end
end

Options.msatoggle:OnChanged(updmsa)

local function getlayout(itemname)
    local inventory = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory:FindFirstChild("List")
    if not inventory then
        return nil
    end
    for _, child in ipairs(inventory:GetChildren()) do
        if child:IsA("ImageLabel") and child.Name == itemname then
            return child.LayoutOrder
        end
    end
    return nil
end

local function swingtool(tspmogngicl)
    if packets.SwingTool and packets.SwingTool.send then
        packets.SwingTool.send(tspmogngicl)
    end
end

local function pickup(entityid)
    if packets.Pickup and packets.Pickup.send then
        packets.Pickup.send(entityid)
    end
end

local function drop(itemname)
    local inventory = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory:FindFirstChild("List")
    if not inventory then return end

    for _, child in ipairs(inventory:GetChildren()) do
        if child:IsA("ImageLabel") and child.Name == itemname then
            if packets and packets.DropBagItem and packets.DropBagItem.send then
                packets.DropBagItem.send(child.LayoutOrder)
            end
        end
    end
end

local selecteditems = {}
itemdropdown:OnChanged(function(Value)
    selecteditems = {} 
    for item, State in pairs(Value) do
        if State then
            table.insert(selecteditems, item)
        end
    end
end)

task.spawn(function()
    while true do
        if not Options.killauratoggle.Value then
            task.wait(0.1)
            continue
        end

        local range = tonumber(Options.killaurarange.Value) or 20
        local targetCount = tonumber(Options.katargetcountdropdown.Value) or 1
        local cooldown = tonumber(Options.kaswingcooldownslider.Value) or 0.1
        local targets = {}

        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= plr then
                local playerfolder = workspace.Players:FindFirstChild(player.Name)
                if playerfolder then
                    local rootpart = playerfolder:FindFirstChild("HumanoidRootPart")
                    local entityid = playerfolder:GetAttribute("EntityID")

                    if rootpart and entityid then
                        local dist = (rootpart.Position - root.Position).Magnitude
                        if dist <= range then
                            table.insert(targets, { eid = entityid, dist = dist })
                        end
                    end
                end
            end
        end

        if #targets > 0 then
            table.sort(targets, function(a, b)
                return a.dist < b.dist
            end)

            local selectedTargets = {}
            for i = 1, math.min(targetCount, #targets) do
                table.insert(selectedTargets, targets[i].eid)
            end

            swingtool(selectedTargets)
        end

        task.wait(cooldown)
    end
end)

task.spawn(function()
    while true do
        if not Options.resourceauratoggle.Value then
            task.wait(0.1)
            continue
        end

        local range = tonumber(Options.resourceaurarange.Value) or 20
        local targetCount = tonumber(Options.resourcetargetdropdown.Value) or 1
        local cooldown = tonumber(Options.resourcecooldownslider.Value) or 0.1
        local targets = {}
        local allresources = {}

        for _, r in pairs(workspace.Resources:GetChildren()) do
            table.insert(allresources, r)
        end
        for _, r in pairs(workspace:GetChildren()) do
            if r:IsA("Model") and r.Name == "Gold Node" then
                table.insert(allresources, r)
            end
        end

        for _, res in pairs(allresources) do
            if res:IsA("Model") and res:GetAttribute("EntityID") then
                local eid = res:GetAttribute("EntityID")
                local ppart = res.PrimaryPart or res:FindFirstChildWhichIsA("BasePart")
                if ppart then
                    local dist = (ppart.Position - root.Position).Magnitude
                    if dist <= range then
                        table.insert(targets, { eid = eid, dist = dist })
                    end
                end
            end
        end

        if #targets > 0 then
            table.sort(targets, function(a, b)
                return a.dist < b.dist
            end)

            local selectedTargets = {}
            for i = 1, math.min(targetCount, #targets) do
                table.insert(selectedTargets, targets[i].eid)
            end

            swingtool(selectedTargets)
        end

        task.wait(cooldown)
    end
end)

task.spawn(function()
    while true do
        if not Options.critterauratoggle.Value then
            task.wait(0.1)
            continue
        end

        local range = tonumber(Options.critterrangeslider.Value) or 20
        local targetCount = tonumber(Options.crittertargetdropdown.Value) or 1
        local cooldown = tonumber(Options.crittercooldownslider.Value) or 0.1
        local targets = {}

        for _, critter in pairs(workspace.Critters:GetChildren()) do
            if critter:IsA("Model") and critter:GetAttribute("EntityID") then
                local eid = critter:GetAttribute("EntityID")
                local ppart = critter.PrimaryPart or critter:FindFirstChildWhichIsA("BasePart")

                if ppart then
                    local dist = (ppart.Position - root.Position).Magnitude
                    if dist <= range then
                        table.insert(targets, { eid = eid, dist = dist })
                    end
                end
            end
        end

        if #targets > 0 then
            table.sort(targets, function(a, b)
                return a.dist < b.dist
            end)

            local selectedTargets = {}
            for i = 1, math.min(targetCount, #targets) do
                table.insert(selectedTargets, targets[i].eid)
            end

            swingtool(selectedTargets)
        end

        task.wait(cooldown)
    end
end)



task.spawn(function()
    while true do
        local range = tonumber(Options.pickuprange.Value) or 35

        if Options.autopickuptoggle.Value then
            for _, item in ipairs(workspace.Items:GetChildren()) do
                if item:IsA("BasePart") or item:IsA("MeshPart") then
                    local selecteditem = item.Name
                    local entityid = item:GetAttribute("EntityID")

                    if entityid and table.find(selecteditems, selecteditem) then
                        local dist = (item.Position - root.Position).Magnitude
                        if dist <= range then
                            pickup(entityid)
                        end
                    end
                end
            end
        end

        if Options.chestpickuptoggle.Value then
            for _, chest in ipairs(workspace.Deployables:GetChildren()) do
                if chest:IsA("Model") and chest:FindFirstChild("Contents") then
                    for _, item in ipairs(chest.Contents:GetChildren()) do
                        if item:IsA("BasePart") or item:IsA("MeshPart") then
                            local selecteditem = item.Name
                            local entityid = item:GetAttribute("EntityID")

                            if entityid and table.find(selecteditems, selecteditem) then
                                local dist = (chest.PrimaryPart.Position - root.Position).Magnitude
                                if dist <= range then
                                    pickup(entityid)
                                end
                            end
                        end
                    end
                end
            end
        end

        task.wait(0.01)
    end
end)

local debounce = 0
local cd = 0 -- i genuinely dont know why it breaks now, but turn this up to 0.3 - 0.2 to stop it from dropping other items
runs.Heartbeat:Connect(function()
    if Options.droptoggle.Value then
        if tick() - debounce >= cd then
            local selectedItem = Options.dropdropdown.Value
            drop(selectedItem)
            debounce = tick()
        end
    end
end)

runs.Heartbeat:Connect(function()
    if Options.droptogglemanual.Value then
        if tick() - debounce >= cd then
            local itemname = Options.droptextbox.Value
            drop(itemname)
            debounce = tick()
        end
    end
end)

-- =========================
-- Farming: посадка/сбор + BV-передвижение (без правок GUI)
-- =========================

local plantedboxes = {}
local fruittoitemid = {
    Bloodfruit = 94, Bluefruit = 377, Lemon = 99, Coconut = 1, Jelly = 604,
    Banana = 606, Orange = 602, Oddberry = 32, Berry = 35, Strangefruit = 302,
    Strawberry = 282, Sunfruit = 128, Pumpkin = 80, ["Prickly Pear"] = 378,
    Apple = 243, Barley = 247, Cloudberry = 101, Carrot = 147
}

local function plant(entityid, itemID)
    if packets.InteractStructure and packets.InteractStructure.send then
        packets.InteractStructure.send({ entityID = entityid, itemID = itemID })
        plantedboxes[entityid] = true
    end
end

local function getpbs(range)
    if not root or not root.Parent then return {} end
    local plantboxes = {}
    local dep = workspace:FindFirstChild("Deployables")
    if not dep then return plantboxes end
    for _, deployable in ipairs(dep:GetChildren()) do
        if deployable:IsA("Model") and deployable.Name == "Plant Box" then
            local eid = deployable:GetAttribute("EntityID")
            local pp  = deployable.PrimaryPart or deployable:FindFirstChildWhichIsA("BasePart")
            if eid and pp then
                local d = (pp.Position - root.Position).Magnitude
                if d <= range then
                    table.insert(plantboxes, { entityid = eid, deployable = deployable, dist = d })
                end
            end
        end
    end
    return plantboxes
end

local function getbushes(range, fruitname)
    if not root or not root.Parent then return {} end
    local bushes = {}
    for _, model in ipairs(workspace:GetChildren()) do
        if model:IsA("Model") and model.Name:find(fruitname) then
            local pp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            if pp then
                local d = (pp.Position - root.Position).Magnitude
                if d <= range then
                    local eid = model:GetAttribute("EntityID")
                    if eid then
                        table.insert(bushes, { entityid = eid, model = model, dist = d })
                    end
                end
            end
        end
    end
    return bushes
end

-- безопасный пиккап
local function safePickup(eid)
    if typeof(pickup) == "function" then
        local ok = pcall(function() pickup(eid) end)
        if ok then return end
    end
    if packets and packets.Pickup and packets.Pickup.send then
        pcall(function() packets.Pickup.send(eid) end)
    end
end

-- === ДВИЖЕНИЕ ЧЕРЕЗ BV (вместо Tween) ===
local RS = game:GetService("RunService")

local BV_SPEED    = 21       -- скорость бега к цели
local BV_STOP_TOL = 0.8      -- допуск остановки (XZ)
local BV_MAXSEG   = 6        -- фейлсейф (сек) на один рывок

local function ensureRoot()
    local ch = plr.Character
    return ch and ch:FindFirstChild("HumanoidRootPart") or nil
end

local function makeBV(rootPart)
    local old = rootPart:FindFirstChildOfClass("BodyVelocity")
    if old then old:Destroy() end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9, 0, 1e9) -- только по XZ
    bv.Velocity = Vector3.new()
    bv.Parent = rootPart
    return bv
end

local function moveBV_toPos(targetPos)
    local rp = ensureRoot()
    if not rp then return false end
    local bv = makeBV(rp)
    local t0 = tick()

    while rp.Parent do
        local cur = rp.Position
        local vec = Vector3.new(targetPos.X - cur.X, 0, targetPos.Z - cur.Z)
        local d   = vec.Magnitude
        if d <= BV_STOP_TOL then
            bv.Velocity = Vector3.new()
            break
        end
        if tick() - t0 > BV_MAXSEG then
            break
        end
        bv.Velocity = (d > 0 and vec.Unit or Vector3.new()) * BV_SPEED
        RS.Heartbeat:Wait()
    end

    if bv then bv:Destroy() end
    return true
end

-- ⚠️ Сохраняем имена, чтобы остальной код не менять:

-- Раньше тут был Tween к целевому CFrame
local function tween(targetCFrame)
    moveBV_toPos(targetCFrame.Position)
end

-- Раньше: tweenplantbox(range)
local function tweenplantbox(range)
    while tweenplantboxtoggle.Value do
        local plantboxes = getpbs(range)
        table.sort(plantboxes, function(a, b) return a.dist < b.dist end)

        for _, box in ipairs(plantboxes) do
            if not box.deployable:FindFirstChild("Seed") then
                local pp = box.deployable.PrimaryPart or box.deployable:FindFirstChildWhichIsA("BasePart")
                if pp then moveBV_toPos(pp.Position) end
                break
            end
        end

        task.wait(0.05)
    end
end

-- Раньше: tweenpbs(range, fruitname)
local function tweenpbs(range, fruitname)
    while tweenbushtoggle.Value do
        local bushes = getbushes(range, fruitname)
        table.sort(bushes, function(a, b) return a.dist < b.dist end)

        if #bushes > 0 then
            local bp = bushes[1].model.PrimaryPart or bushes[1].model:FindFirstChildWhichIsA("BasePart")
            if bp then moveBV_toPos(bp.Position) end
        else
            local plantboxes = getpbs(range)
            table.sort(plantboxes, function(a, b) return a.dist < b.dist end)
            for _, box in ipairs(plantboxes) do
                if not box.deployable:FindFirstChild("Seed") then
                    local pp = box.deployable.PrimaryPart or box.deployable:FindFirstChildWhichIsA("BasePart")
                    if pp then moveBV_toPos(pp.Position) end
                    break
                end
            end
        end

        task.wait(0.05)
    end
end

-- ⚡ УСКОРЕННАЯ ПОСАДКА (батчами, гладко)
local PLANT_BATCH, PLANT_GAP = 25, 0.02

task.spawn(function()
    while true do
        if Options.planttoggle.Value then
            if not root or not root.Parent then task.wait(0.1); continue end

            local range   = tonumber(Options.plantrange.Value) or 30
            local delay   = tonumber(Options.plantdelay.Value) or 0.03
            local itemID  = fruittoitemid[Options.fruitdropdown.Value] or 94

            local plantboxes = getpbs(range)
            table.sort(plantboxes, function(a, b) return a.dist < b.dist end)

            local planted = 0
            for _, box in ipairs(plantboxes) do
                if not box.deployable:FindFirstChild("Seed") then
                    plant(box.entityid, itemID)
                    planted += 1
                    if planted % PLANT_BATCH == 0 then
                        task.wait(PLANT_GAP)
                    end
                else
                    plantedboxes[box.entityid] = true
                end
            end

            task.wait(delay)
        else
            task.wait(0.1)
        end
    end
end)

-- ✅ АВТО-СБОР ВКЛЮЧЕН (тоже батчами)
local HARVEST_BATCH, HARVEST_GAP = 20, 0.02

task.spawn(function()
    while true do
        if Options.harvesttoggle.Value then
            if not root or not root.Parent then task.wait(0.1); continue end

            local harvestrange  = tonumber(Options.harvestrange.Value) or 30
            local selectedfruit = Options.fruitdropdown.Value
            local bushes = getbushes(harvestrange, selectedfruit)
            table.sort(bushes, function(a, b) return a.dist < b.dist end)

            local picked = 0
            for _, bush in ipairs(bushes) do
                safePickup(bush.entityid)
                picked += 1
                if picked % HARVEST_BATCH == 0 then
                    task.wait(HARVEST_GAP)
                end
            end

            task.wait(0.05)
        else
            task.wait(0.1)
        end
    end
end)

-- Раннеры «твитов» (теперь двигаются BV, имена те же)
task.spawn(function()
    while true do
        if not tweenplantboxtoggle.Value then
            task.wait(0.1)
        else
            local range = tonumber(Options.tweenrange.Value) or 250
            tweenplantbox(range)
        end
    end
end)

task.spawn(function()
    while true do
        if not tweenbushtoggle.Value then
            task.wait(0.1)
        else
            local range = tonumber(Options.tweenrange.Value) or 20
            local selectedfruit = Options.fruitdropdown.Value
            tweenpbs(range, selectedfruit)
        end
    end
end)

-- =========================
-- Farming: Area Auto Build (BV) — with BV cleanup
-- =========================

-- таб не трогаем — используем уже существующий
local BuildTab = Tabs.Farming

-- состояние
local AB = {
    on = false,
    cornerA = nil,
    cornerB = nil,
    spacing = 6.04,
    hoverY  = 5,
    speed   = 21,
    stopTol = 0.6,
    segTimeout = 1.2,
    antiStuckTime = 0.8,
    placeDelay = 0.06,
    sideStep = 4.2,
    sideMaxTries = 4,
    wallProbeLen = 7.0,
    wallProbeHeight = 2.4,
}

-- UI (в уже существующем Tabs.Farming)
local ab_toggle  = BuildTab:CreateToggle("ab_area_on", { Title="Auto Build (BV) — Area", Default=false })
local ab_spacing = BuildTab:CreateSlider("ab_area_spacing", { Title="Spacing (studs)", Min=5.6, Max=7.2, Rounding=2, Default=6.04 })
local ab_speed   = BuildTab:CreateSlider("ab_area_speed", { Title="Speed (BV)", Min=10, Max=60, Rounding=1, Default=21 })
BuildTab:CreateButton({ Title="Set Corner A (here)", Callback=function() AB.cornerA = root.Position; print("[AB] A =", AB.cornerA) end })
BuildTab:CreateButton({ Title="Set Corner B (here)", Callback=function() AB.cornerB = root.Position; print("[AB] B =", AB.cornerB) end })
BuildTab:CreateButton({ Title="Clear Area (A & B)",  Callback=function() AB.cornerA, AB.cornerB = nil, nil end })

ab_toggle:OnChanged(function(v) AB.on = v; if not v then AB_killBV() end end)
ab_spacing:OnChanged(function(v) AB.spacing = v end)
ab_speed:OnChanged(function(v) AB.speed = v end)

-- ==== BV helpers (важно для очистки) ====
local function AB_getBV()
    if not root then return nil end
    return root:FindFirstChild("_AB_BV")
end

local function AB_ensureBV()
    local bv = AB_getBV()
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "_AB_BV"
        bv.MaxForce = Vector3.new(1e9, 0, 1e9)
        bv.Velocity = Vector3.new()
        bv.Parent = root
    end
    return bv
end

function AB_killBV()
    local bv = AB_getBV()
    if bv then bv:Destroy() end
end

-- raycast (не бьём по своему персонажу)
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.FilterDescendantsInstances = {plr.Character}

local function wallAhead(dir2d)
    if dir2d.Magnitude < 1e-4 then return false end
    local origin = root.Position + Vector3.new(0, AB.wallProbeHeight, 0)
    local dir3   = Vector3.new(dir2d.X, 0, dir2d.Z).Unit * AB.wallProbeLen
    local hit = workspace:Raycast(origin, dir3, rayParams)
    if not hit then return false end
    return (hit.Normal.Y or 0) < 0.55
end

-- движение BV с анти-застреванием
local function moveBV_to(target)
    if not AB.on or not root then return false end
    local bv = AB_ensureBV()
    local t0, lastMoveT = tick(), tick()
    local lastPos = root.Position
    local timeCap = AB.segTimeout + 6

    while AB.on do
        local rp = root.Position
        local to2 = Vector3.new(target.X - rp.X, 0, target.Z - rp.Z)
        local dist = to2.Magnitude
        if dist <= AB.stopTol then
            bv.Velocity = Vector3.new()
            return true
        end
        local dir = (dist > 0) and to2.Unit or Vector3.new()

        if wallAhead(dir) then
            local perp = Vector3.new(-dir.Z, 0, dir.X).Unit
            local ok = false
            for i=1, AB.sideMaxTries do
                local rightHit = workspace:Raycast(rp + Vector3.new(0,AB.wallProbeHeight,0), (dir + perp).Unit*AB.wallProbeLen, rayParams)
                local leftHit  = workspace:Raycast(rp + Vector3.new(0,AB.wallProbeHeight,0), (dir - perp).Unit*AB.wallProbeLen, rayParams)
                local sign = (not rightHit and leftHit) and 1 or ((rightHit and not leftHit) and -1 or (i%2==1 and 1 or -1))

                local t1 = tick()
                while AB.on and tick()-t1 < 0.22 do
                    bv.Velocity = perp * (AB.sideStep * 2.0 * sign)
                    RS.Heartbeat:Wait()
                end
                bv.Velocity = Vector3.new()
                if not wallAhead(dir) then ok = true break end
            end
            if not ok then bv.Velocity = Vector3.new(); return false end
        end

        bv.Velocity = dir * AB.speed

        local moved = (rp - lastPos).Magnitude
        if moved > 0.15 then lastMoveT = tick(); lastPos = rp end
        if (tick() - lastMoveT) > AB.antiStuckTime then
            local perp = Vector3.new(-dir.Z,0,dir.X).Unit
            local t1 = tick()
            while AB.on and tick()-t1 < 0.2 do bv.Velocity = perp * (AB.sideStep*2); RS.Heartbeat:Wait() end
            bv.Velocity = Vector3.new()
            t1 = tick()
            while AB.on and tick()-t1 < 0.2 do bv.Velocity = -perp * (AB.sideStep*2); RS.Heartbeat:Wait() end
            bv.Velocity = Vector3.new()
            lastMoveT = tick()
        end

        if (tick() - t0) > timeCap then
            bv.Velocity = Vector3.new(); return false
        end
        RS.Heartbeat:Wait()
    end
    return false
end

local function groundYAt(x, z)
    local origin = Vector3.new(x, (root.Position.Y + 50), z)
    local hit = workspace:Raycast(origin, Vector3.new(0, -500, 0), rayParams)
    if hit then return hit.Position.Y - 0.1 end
    return root.Position.Y - 3
end

local function spotOccupied(pos, r)
    r = r or (AB.spacing * 0.45)
    local dep = workspace:FindFirstChild("Deployables")
    if not dep then return false end
    for _,d in ipairs(dep:GetChildren()) do
        if d:IsA("Model") and d.Name == "Plant Box" then
            local p = d.PrimaryPart or d:FindFirstChildWhichIsA("BasePart")
            if p and (p.Position - pos).Magnitude <= r then
                return true
            end
        end
    end
    return false
end

local function placePlantBoxAt(pos)
    if (packets.PlaceStructure and packets.PlaceStructure.send) then
        packets.PlaceStructure.send{
            buildingName = "Plant Box",
            yrot = 45,
            vec = pos,
            isMobile = false
        }
        return true
    end
    return false
end

-- клетки внутри прямоугольника (серпантин)
local function buildCellsFromArea()
    if not (AB.cornerA and AB.cornerB) then return {} end
    local a, b = AB.cornerA, AB.cornerB
    local xmin, xmax = math.min(a.X,b.X), math.max(a.X,b.X)
    local zmin, zmax = math.min(a.Z,b.Z), math.max(a.Z,b.Z)
    local step = AB.spacing

    local function snap(v, s) return math.floor(v/s + 0.5)*s end
    xmin, xmax = snap(xmin, step), snap(xmax, step)
    zmin, zmax = snap(zmin, step), snap(zmax, step)

    local cells, row = {}, 0
    for z = zmin, zmax, step do
        local xs, xe, dx
        if (row % 2 == 0) then xs, xe, dx = xmin, xmax, step else xs, xe, dx = xmax, xmin, -step end
        for x = xs, xe, dx do
            table.insert(cells, Vector3.new(x, groundYAt(x,z), z))
        end
        row += 1
    end
    return cells
end

-- раннер
task.spawn(function()
    while true do
        if AB.on and AB.cornerA and AB.cornerB and root then
            local cells = buildCellsFromArea()
            for _, p in ipairs(cells) do
                if not AB.on then break end
                local fly = Vector3.new(p.X, root.Position.Y, p.Z)
                local ok1 = moveBV_to(fly)
                if not ok1 then continue end
                if not spotOccupied(p) then
                    placePlantBoxAt(p)
                    task.wait(AB.placeDelay)
                end
            end
            -- ВАЖНО: очистить BV после прохода
            AB_killBV()
        else
            -- если выключили/нет углов — на всякий случай тоже чистим BV
            AB_killBV()
            task.wait(0.15)
        end
    end
end)







orbitrangeslider:OnChanged(function(value) range = value end)
orbitradiusslider:OnChanged(function(value) orbitradius = value end)
orbitspeedslider:OnChanged(function(value) orbitspeed = value end)
itemheightslider:OnChanged(function(value) itemheight = value end)

runs.RenderStepped:Connect(function()
    if not orbiton then return end
    local time = tick() * orbitspeed
    for item, bp in pairs(attacheditems) do
        if item then
            local angle = itemangles[item] + time
            bp.Position = root.Position + Vector3.new(math.cos(angle) * orbitradius, itemheight, math.sin(angle) * orbitradius)
        end
    end
end)

task.spawn(function()
    while true do
        if orbiton then
            local children, index = itemsfolder:GetChildren(), 0
            local anglestep = (math.pi * 2) / math.max(#children, 1)

            for _, item in pairs(children) do
                local primary = item:IsA("BasePart") and item or item:IsA("Model") and item.PrimaryPart
                if primary and (primary.Position - root.Position).Magnitude <= range then
                    if not attacheditems[primary] then
                        local bp = Instance.new("BodyPosition")
                        bp.MaxForce, bp.D, bp.P, bp.Parent = Vector3.new(math.huge, math.huge, math.huge), 1500, 25000, primary
                        attacheditems[primary], itemangles[primary], lastpositions[primary] = bp, index * anglestep, primary.Position
                        index += 1
                    end
                end
            end
        end
        task.wait()
    end
end)

SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes{}
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
Library:Notify{
    Title = "Herkle Hub",
    Content = "Loaded, Enjoy!",
    Duration = 8
}
SaveManager:LoadAutoloadConfig()
print("Done! Enjoy Herkle Hub!")
