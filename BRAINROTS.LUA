-- 🎯 BRAINROT INCOME SCANNER v2.1 (6 WEBHOOKS + SPECIAL LIST)
-- Scans all objects in Steal a Brainrot and sends Discord notifications
-- Auto-run on start + by F key, copy JobId by G

local Players = game:GetService('Players')
local UserInputService = game:GetService('UserInputService')
local HttpService = game:GetService('HttpService')
local StarterGui = game:GetService("StarterGui")

-- ⚙️ WEBHOOK SETTINGS BY INCOME RANGE
local WEBHOOKS = {
    { -- 1M/s - 25M/s
        url = 'https://discord.com/api/webhooks/1449098958084247584/2DC20PHyEmiurZxS8roGSEqnszGoTzNKRLgFHai_Cxfra0nTpx5xNYbBaRh4OVqtf68R',
        title = '🟢 Low Income (1-25M/s)',
        color = 0x00ff00,
        min = 1_000_000,
        max = 25_000_000,
        sendServerInfo = false,
        sendTeleport = true
    },
    { -- 26M/s - 100M/s (основной, без Server Info)
        url = 'https://discord.com/api/webhooks/1449099051378409622/OVhVVK3GTpIOhN5kO-61wdj-jGE9iMmjSNiJISq8wP9xKK5FquoXmRTYcQS9kx-2Vgan',
        title = '🟡 Medium Income (26-100M/s)',
        color = 0xffff00,
        min = 26_000_000,
        max = 100_000_000,
        sendServerInfo = false,
        sendTeleport = false,
        showJoinerAd = true
    },
    { -- 26M/s - 100M/s (новый, с Server Info)
        url = 'https://discord.com/api/webhooks/1450022661076942959/I7Jz2ge1pqhEyJelOsox_wZmwSHRWyxopLYt-OZHTYBjUc_XUtkfSpV7nVzvWx91xbLe',
        title = '🟡 Medium Income (26-100M/s) + Server',
        color = 0xffff00,
        min = 26_000_000,
        max = 100_000_000,
        sendServerInfo = true,
        sendTeleport = true
    },
    { -- 101M/s - 10000M/s (основной, без Server Info)
        url = 'https://discord.com/api/webhooks/1449099129543327920/GhfLDP-UsokffIqE_TmFs8kep7q9zXharQhYuj0lzDYJxvnvsCT9jKdUAW7rED7HkvBA',
        title = '🔴 High Income (101M+ /s)',
        color = 0xff0000,
        min = 101_000_000,
        max = 10_000_000_000,
        sendServerInfo = false,
        sendTeleport = false,
        showJoinerAd = true
    },
    { -- 101M/s - 10000M/s (новый, с Server Info)
        url = 'https://discord.com/api/webhooks/1450023167937478790/9xcbPrMrVJeU3fwd1_jTELEyM5jXqUALRr5P-N2TVBKBMvgKggk1r-0Xjlr_3Zyr0nqI',
        title = '🔴 High Income (101M+ /s) + Server',
        color = 0xff0000,
        min = 101_000_000,
        max = 10_000_000_000,
        sendServerInfo = true,
        sendTeleport = true
    },
    { -- Special brainrots + overpay
        url = 'https://discord.com/api/webhooks/1449111713428275282/1CByDVDPiQUqD0r59w9DxtJ1F9CUpjbXzPrnA_kvtRvz2KIKpXMMBdTM2kYkYswTP45I',
        title = '⭐️ SPECIAL BRAINROTS',
        color = 0xff00ff,
        special = true,
        sendServerInfo = false,
        sendTeleport = true
    }
}

-- 📋 SPECIAL BRAINROTS WITH MIN VALUES
local SPECIAL_BRAINROTS = {
    ['Garama and Madundung'] = 0,
    ['Dragon Cannelloni'] = 0,
    ['La Supreme Combinasion'] = 0,
    ['Ketupat Kepat'] = 0,
    ['Strawberry Elephant'] = 0,
    ['Ketchuru and Musturu'] = 0,
    ['Tralaledon'] = 0,
    ['Tictac Sahur'] = 0,
    ['Burguro And Fryuro'] = 0,
    ['La Secret Combinasion'] = 0,
    ['Spooky and Pumpky'] = 0,
    ['Meowl'] = 0,
    ['La Casa Boo'] = 0,
    ['Headless Horseman'] = 0,
    ['Los Tacoritas'] = 0,
    ['Capitano Moby'] = 0,
    ['Cooki and Milki'] = 0,
    ['Fragrama and Chocrama'] = 0,
    ['Guest 666'] = 0,
    ['Lavadorito Spinito'] = 100_000_000,
    ['Fishino Clownino'] = 0,
    ['Tacorita Bicicleta'] = 100_000_000,
    ['La Jolly Grande'] = 200_000_000,
    ['W or L'] = 200_000_000,
    ['Los Puggies'] = 300_000_000,
    ['La Taco Combinasion'] = 300_000_000,
    ['Chipso and Queso'] = 200_000_000,
    ['Chipso And Queso'] = 200_000_000,
    ['Mieteteira Bicicleteira'] = 400_000_000,
    ['Los Mobilis'] = 400_000_000,
    ['La Spooky Grande'] = 200_000_000,
    ['Eviledon'] = 189_000_000,
    ['Chillin Chili'] = 25_000_000,
    ['Money Money Puggy'] = 200_000_000,
    ['Tang Tang Keletang'] = 100_000_000,
    ['Los Primos'] = 300_000_000,
    ['Orcaledon'] = 200_000_000,
    ['Las Sis'] = 300_000_000,
    ['La Extinct Grande'] = 200_000_000,
    ['Los Bros'] = 200_000_000,
    ['Spaghetti Tualetti'] = 300_000_000,
    ['Esok Sekolah'] = 300_000_000,
    ['Nuclearo Dinossauro'] = 100_000_000,
    ['Lavadorito Spinito'] = 0,
    ['La Ginger Sekolah'] = 0,
    ['Gingerat Gerat'] = 0,
    ['Reinito Sleighito'] = 0,
}

-- 🎮 OBJECTS WITH EMOJIS AND IMPORTANCE
local OBJECTS = {
    ['La Vacca Saturno Saturnita'] = { emoji = '🐄', important = false },
    ['Chimpanzini Spiderini'] = { emoji = '🕷️', important = false },
    ['Los Tralaleritos'] = { emoji = '🎵', important = false },
    ['Las Tralaleritas'] = { emoji = '🎶', important = false },
    ['Graipuss Medussi'] = { emoji = '🐍', important = false },
    ['Torrtuginni Dragonfrutini'] = { emoji = '🐢', important = false },
    ['Pot Hotspot'] = { emoji = '🔥', important = false },
    ['La Grande Combinasion'] = { emoji = '🌟', important = true },
    ['Garama and Madundung'] = { emoji = '🍝', important = true },
    ['Secret Lucky Block'] = { emoji = '🎲', important = false },
    ['Dragon Cannelloni'] = { emoji = '🐲', important = true },
    ['Nuclearo Dinossauro'] = { emoji = '☢️', important = true },
    ['Las Vaquitas Saturnitas'] = { emoji = '🐮', important = false },
    ['Agarrini la Palini'] = { emoji = '🤹', important = false },
    ['Los Hotspotsitos'] = { emoji = '⚡', important = true },
    ['Esok Sekolah'] = { emoji = '🏫', important = true },
    ['Nooo My Hotspot'] = { emoji = '📶', important = false },
    ['La Supreme Combinasion'] = { emoji = '👑', important = true },
    ['Admin Lucky Block'] = { emoji = '🔒', important = false },
    ['Ketupat Kepat'] = { emoji = '🍙', important = true },
    ['Strawberry Elephant'] = { emoji = '🐘', important = true },
    ['Spaghetti Tualetti'] = { emoji = '🚽', important = true },
    ['Ketchuru and Musturu'] = { emoji = '🍾', important = true },
    ['La Secret Combinasion'] = { emoji = '🕵️', important = true },
    ['La Karkerkar Combinasion'] = { emoji = '🤖', important = false },
    ['Los Bros'] = { emoji = '👊', important = true },
    ['Tralaledon'] = { emoji = '🦕', important = true },
    ['La Extinct Grande'] = { emoji = '💀', important = true },
    ['Las Sis'] = { emoji = '👭', important = true },
    ['Tacorita Bicicleta'] = { emoji = '🌮', important = true },
    ['Tictac Sahur'] = { emoji = '⏰', important = true },
    ['Celularcini Viciosini'] = { emoji = '📱', important = true },
    ['Los Primos'] = { emoji = '👬', important = true },
    ['Tang Tang Keletang'] = { emoji = '🥁', important = true },
    ['Money Money Puggy'] = { emoji = '💰', important = true },
    ['Burguro And Fryuro'] = { emoji = '🍔', important = true },
    ['Chillin Chili'] = { emoji = '🌶️', important = true },
    ['Eviledon'] = { emoji = '😈', important = true },
    ['La Spooky Grande'] = { emoji = '👻', important = true },
    ['Los Mobilis'] = { emoji = '🚗', important = true },
    ['Spooky and Pumpky'] = { emoji = '🎃', important = true },
    ['Mieteteira Bicicleteira'] = { emoji = '🚴', important = true },
    ['Meowl'] = { emoji = '🐱', important = true },
    ['Chipso and Queso'] = { emoji = '🧀', important = true },
    ['La Casa Boo'] = { emoji = '👁‍🗨', important = true },
    ['Headless Horseman'] = { emoji = '👹', important = true },
    ['Mariachi Corazoni'] = { emoji = '🎺', important = true },
    ['La Taco Combinasion'] = { emoji = '🌮', important = true },
    ['Capitano Moby'] = { emoji = '⚓', important = true },
    ['Guest 666'] = { emoji = '🔥', important = true },
    ['Cooki and Milki'] = { emoji = '🍪', important = true },
    ['Los Puggies'] = { emoji = '🐶', important = true },
    ['Fragrama and Chocrama'] = { emoji = '🍫', important = true },
    ['Los Spaghettis'] = { emoji = '🍝', important = true },
    ['Los Tacoritas'] = { emoji = '🌮', important = true },
    ['Orcaledon'] = { emoji = '🐋', important = true },
    ['Lavadorito Spinito'] = { emoji = '🌀', important = true },
    ['Los Planitos'] = { emoji = '🛫', important = true },
    ['W or L'] = { emoji = '🏆', important = true },
    ['Fishino Clownino'] = { emoji = '🐠', important = true },
    ['La Ginger Sekolah'] = { emoji = '🍪', important = true },
    ['Chicleteira Noelteira'] = { emoji = '🍬', important = true },
    ['La Jolly Grande'] = { emoji = '🎁', important = true },
    ['Ginger'] = { emoji = '🍪', important = true },
    ['Los Chicleteiras'] = { emoji = '🍭', important = true },
    ['Gobblino Uniciclino'] = { emoji = '🦃', important = true },
    ['Los 67'] = { emoji = '🎰', important = true },
    ['Los Spooky Combinasionas'] = { emoji = '💀', important = true },
    ['Swag Soda'] = { emoji = '🥤', important = true },
    ['Los Combinasionas'] = { emoji = '🧩', important = true },
    ['Los Burritos'] = { emoji = '🌯', important = true },
    ['67'] = { emoji = '🎲', important = true },
    ['Rang Ring Bus'] = { emoji = '🚌', important = true },
    ['Los Nooo My Hotspotsitos'] = { emoji = '📡', important = true },
    ['Chicleteirina Bicicleteirina'] = { emoji = '🚲', important = true },
    ['Noo My Candy'] = { emoji = '🍬', important = true },
    ['Los Quesadillas'] = { emoji = '🫓', important = true },
    ['Quesadillo Vampiro'] = { emoji = '🧛', important = true },
    ['Quesadilla Crocodila'] = { emoji = '🐊', important = true },
    ['Ho Ho Ho Sahur'] = { emoji = '🎅', important = true },
    ['Horegini Boom'] = { emoji = '💥', important = true },
    ['Pot Pumpkin'] = { emoji = '🎃', important = true },
    ['Pirulitoita Bicicleteira'] = { emoji = '🍭', important = true },
    ['La Sahur Combinasion'] = { emoji = '🌙', important = true },
    ['List List List Sahur'] = { emoji = '📋', important = true },
    ['Noo My Examine'] = { emoji = '📘', important = true },
    ['Cuadramat and Pakrahmatmamat'] = { emoji = '🧮', important = true },
    ['Los Cucarachas'] = { emoji = '🪳', important = true },
    ['1x1x1x1'] = { emoji = '💾', important = true },
    ['La Ginger Sekolah'] = { emoji = '🎁', important = true },
    ['Gingerat Gerat'] = { emoji = '🥮', important = true },
    ['Reinito Sleighito'] = { emoji = '🦌', important = true },
    ['Gingerat Gerat'] = { emoji = '🍬', important = true },
}

-- IMPORTANT OBJECTS TABLE
local ALWAYS_IMPORTANT = {}
for name, cfg in pairs(OBJECTS) do
    if cfg.important then
        ALWAYS_IMPORTANT[name] = true
    end
end

-- 💰 INCOME PARSER
local function parseGenerationText(s)
    if type(s) ~= 'string' or s == '' then return nil end
    local norm = s:gsub('%$', ''):gsub(',', ''):gsub('%s+', '')
    local num, suffix = norm:match('^([%-%d%.]+)([KkMmBb]?)/s$')
    if not num then return nil end
    local val = tonumber(num)
    if not val then return nil end
    local mult = 1
    if suffix == 'K' or suffix == 'k' then mult = 1e3
    elseif suffix == 'M' or suffix == 'm' then mult = 1e6
    elseif suffix == 'B' or suffix == 'b' then mult = 1e9
    end
    return val * mult
end

local function formatIncomeNumber(n)
    if not n then return 'Unknown' end
    if n >= 1e9 then
        local v = n / 1e9
        return (v % 1 == 0 and string.format('%dB/s', v) or string.format('%.1fB/s', v)):gsub('%.0B/s', 'B/s')
    elseif n >= 1e6 then
        local v = n / 1e6
        return (v % 1 == 0 and string.format('%dM/s', v) or string.format('%.1fM/s', v)):gsub('%.0M/s', 'M/s')
    elseif n >= 1e3 then
        local v = n / 1e3
        return (v % 1 == 0 and string.format('%dK/s', v) or string.format('%.1fK/s', v)):gsub('%.0K/s', 'K/s')
    else
        return string.format('%d/s', n)
    end
end

-- 📝 UI TEXT GRABBER
local function grabText(inst)
    if not inst then return nil end
    if inst:IsA('TextLabel') or inst:IsA('TextButton') or inst:IsA('TextBox') then
        local ok, ct = pcall(function() return inst.ContentText end)
        if ok and type(ct) == 'string' and #ct > 0 then return ct end
        local t = inst.Text
        if type(t) == 'string' and #t > 0 then return t end
    end
    if inst:IsA('StringValue') then
        local v = inst.Value
        if type(v) == 'string' and #v > 0 then return v end
    end
    return nil
end

local function getOverheadInfo(animalOverhead)
    if not animalOverhead then return nil, nil end

    local name = nil
    local display = animalOverhead:FindFirstChild('DisplayName')
    if display then name = grabText(display) end

    if not name then
        local anyText = animalOverhead:FindFirstChildOfClass('TextLabel')
            or animalOverhead:FindFirstChildOfClass('TextButton')
            or animalOverhead:FindFirstChildOfClass('TextBox')
        name = anyText and grabText(anyText) or nil
    end

    local genText = nil
    local generation = animalOverhead:FindFirstChild('Generation')
    if generation then genText = grabText(generation) end

    if not genText then
        for _, child in ipairs(animalOverhead:GetDescendants()) do
            if child:IsA('TextLabel') or child:IsA('TextButton') or child:IsA('TextBox') then
                local text = grabText(child)
                if text and (text:match('%$') or text:match('/s')) then
                    genText = text
                    break
                end
            end
        end
    end

    return name, genText
end

local function isGuidName(s)
    return s:match('^[0-9a-fA-F]+%-%x+%-%x+%-%x+%-%x+$') ~= nil
end

-- 🔍 FULL SCANNERS
local function scanPlots()
    local results = {}
    local Plots = workspace:FindFirstChild('Plots')
    if not Plots then return results end

    for _, plot in ipairs(Plots:GetChildren()) do
        local Podiums = plot:FindFirstChild('AnimalPodiums')
        if Podiums then
            for _, podium in ipairs(Podiums:GetChildren()) do
                local Base = podium:FindFirstChild('Base')
                local Spawn = Base and Base:FindFirstChild('Spawn')
                local Attachment = Spawn and Spawn:FindFirstChild('Attachment')
                local Overhead = Attachment and Attachment:FindFirstChild('AnimalOverhead')
                if Overhead then
                    local name, genText = getOverheadInfo(Overhead)
                    local genNum = genText and parseGenerationText(genText) or nil
                    if name and genNum then
                        table.insert(results, { name = name, gen = genNum, location = 'Plot' })
                    end
                end
            end
        end
    end
    return results
end

local function scanRunway()
    local results = {}
    for _, obj in ipairs(workspace:GetChildren()) do
        if isGuidName(obj.Name) then
            local part = obj:FindFirstChild('Part')
            local info = part and part:FindFirstChild('Info')
            local overhead = info and info:FindFirstChild('AnimalOverhead')
            if overhead then
                local name, genText = getOverheadInfo(overhead)
                local genNum = genText and parseGenerationText(genText) or nil
                if name and genNum then
                    table.insert(results, { name = name, gen = genNum, location = 'Runway' })
                end
            end
        end
    end
    return results
end

local function scanAllOverheads()
    local results, processed = {}, {}
    local function recursiveSearch(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child.Name == 'AnimalOverhead' and not processed[child] then
                processed[child] = true
                local name, genText = getOverheadInfo(child)
                local genNum = genText and parseGenerationText(genText) or nil
                if name and genNum then
                    table.insert(results, { name = name, gen = genNum, location = 'World' })
                end
            end
            pcall(function() recursiveSearch(child) end)
        end
    end
    recursiveSearch(workspace)
    return results
end

local function scanPlayerGui()
    local results = {}
    local lp = Players.LocalPlayer
    if not lp then return results end

    local playerGui = lp:FindFirstChild('PlayerGui')
    if not playerGui then return results end

    local function searchInGui(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child.Name == 'AnimalOverhead' or child.Name:match('Animal') then
                local name, genText = getOverheadInfo(child)
                local genNum = genText and parseGenerationText(genText) or nil
                if name and genNum then
                    table.insert(results, { name = name, gen = genNum, location = 'GUI' })
                end
            end
            pcall(function() searchInGui(child) end)
        end
    end
    searchInGui(playerGui)
    return results
end

-- 📊 MAIN COLLECT FUNCTION
local function collectAll(timeoutSec)
    local t0 = os.clock()
    local collected = {}

    repeat
        collected = {}

        local allSources = {
            scanPlots(),
            scanRunway(),
            scanAllOverheads(),
            scanPlayerGui(),
        }

        for _, source in ipairs(allSources) do
            for _, item in ipairs(source) do
                table.insert(collected, item)
            end
        end

        local seen, unique = {}, {}
        for _, item in ipairs(collected) do
            local key = item.name .. ':' .. tostring(item.gen)
            if not seen[key] then
                seen[key] = true
                table.insert(unique, item)
            end
        end
        collected = unique

        if #collected > 0 then break end
        task.wait(0.5)
    until os.clock() - t0 > timeoutSec

    return collected
end

local function shouldShow(name, gen)
    if ALWAYS_IMPORTANT[name] then return true end
    return (type(gen) == 'number') and gen >= 1_000_000
end

-- 🎯 SPECIAL BRAINROT CHECK
local function isSpecialBrainrot(name, gen)
    local minValue = SPECIAL_BRAINROTS[name]
    if not minValue then return false end
    return gen >= minValue
end

-- 🔗 EXECUTOR REQUEST
local function getRequester()
    return http_request or request or (syn and syn.request) or (fluxus and fluxus.request) or (KRNL_HTTP and KRNL_HTTP.request)
end

-- 📋 COPY JOBID TO CLIPBOARD (G KEY)
local function copyJobIdToClipboard()
    local jobId = game.JobId
    local text = tostring(jobId)

    if setclipboard then
        setclipboard(text)
    else
        pcall(function()
            StarterGui:SetCore("SetClipboard", text)
        end)
    end
end

-- 📤 RANGE SENDER
local function sendDiscordNotificationByRange(filteredObjects, webhookConfig)
    local req = getRequester()
    if not req then return end
    if #filteredObjects == 0 then return end

    local jobId = game.JobId
    local placeId = game.PlaceId

    local important, regular = {}, {}
    for _, obj in ipairs(filteredObjects) do
        if ALWAYS_IMPORTANT[obj.name] then
            table.insert(important, obj)
        else
            table.insert(regular, obj)
        end
    end

    table.sort(important, function(a, b) return a.gen > b.gen end)
    table.sort(regular, function(a, b) return a.gen > b.gen end)

    local sorted = {}
    for _, obj in ipairs(important) do table.insert(sorted, obj) end
    for _, obj in ipairs(regular) do table.insert(sorted, obj) end

    local objectsList = {}
    for i = 1, math.min(15, #sorted) do
        local obj = sorted[i]
        local emoji = OBJECTS[obj.name] and OBJECTS[obj.name].emoji or '💰'
        local mark = ALWAYS_IMPORTANT[obj.name] and '⭐️ ' or ''

        local overpayMark = ''
        if webhookConfig.special and SPECIAL_BRAINROTS[obj.name] then
            local minVal = SPECIAL_BRAINROTS[obj.name]
            if obj.gen > minVal then
                overpayMark = string.format(' 🔥 **OVERPAY** (min: %s)', formatIncomeNumber(minVal))
            end
        end

        table.insert(objectsList, string.format('%s%s **%s** (%s)%s', mark, emoji, obj.name, formatIncomeNumber(obj.gen), overpayMark))
    end
    local objectsText = table.concat(objectsList, '\n')

    local descriptionText = webhookConfig.special
        and string.format('⭐️ Found %d special brainrots!', #filteredObjects)
        or string.format('💎 Found %d objects in range!', #filteredObjects)

    local rangeText = webhookConfig.special
        and '**All from special list**'
        or string.format('**%s - %s**', formatIncomeNumber(webhookConfig.min), formatIncomeNumber(webhookConfig.max))

    local fields = {
        {
            name = '📊 Income range',
            value = rangeText,
            inline = true,
        },
        {
            name = '💰 Objects:',
            value = objectsText,
            inline = false,
        },
    }

    -- Добавляем Server Info только если флаг sendServerInfo == true
    if webhookConfig.sendServerInfo then
        table.insert(fields, 1, {
            name = '🆔 Server (Job ID)',
            value = tostring(jobId),
            inline = true,
        })
    end

    -- Добавляем Teleport code или рекламу Joiner
    if webhookConfig.sendTeleport then
        local teleportLua = string.format(
            "local ts = game:GetService('TeleportService');\nts:TeleportToPlaceInstance(%d, '%s')",
            placeId,
            jobId
        )
        table.insert(fields, {
            name = '🚀 Teleport code:',
            value = teleportLua,
            inline = false,
        })
    elseif webhookConfig.showJoinerAd then
        table.insert(fields, {
            name = '💎 Want convenience and see the server?',
            value = 'Buy Joiner here: https://discord.com/channels/1448597315207299126/1449995006315204891',
            inline = false,
        })
    end

    local payload = {
        username = '🎯 AURORA FINDER',
        embeds = { {
            title = webhookConfig.title,
            description = descriptionText,
            color = webhookConfig.color,
            fields = fields,
            footer = {
                text = string.format('Found: %d • %s', #filteredObjects, os.date('%H:%M:%S')),
            },
            timestamp = DateTime.now():ToIsoDate(),
        } },
    }

    pcall(function()
        req({
            Url = webhookConfig.url,
            Method = 'POST',
            Headers = { ['Content-Type'] = 'application/json' },
            Body = HttpService:JSONEncode(payload),
        })
    end)
end

-- 🎮 MAIN FUNCTION (6 WEBHOOKS)
local function scanAndNotify()
    local allFound = collectAll(8.0)

    local groups = {{}, {}, {}, {}, {}, {}}
    local hasSpecial = false

    for _, obj in ipairs(allFound) do
        if OBJECTS[obj.name] and shouldShow(obj.name, obj.gen) and type(obj.gen) == 'number' then
            if isSpecialBrainrot(obj.name, obj.gen) then
                hasSpecial = true
                table.insert(groups[6], obj)
            end
        end
    end

    if hasSpecial then
        sendDiscordNotificationByRange(groups[6], WEBHOOKS[6])
    else
        for _, obj in ipairs(allFound) do
            if OBJECTS[obj.name] and shouldShow(obj.name, obj.gen) and type(obj.gen) == 'number' then
                -- Low Income
                if obj.gen >= WEBHOOKS[1].min and obj.gen <= WEBHOOKS[1].max then
                    table.insert(groups[1], obj)
                -- Medium Income (оба вебхука)
                elseif obj.gen >= WEBHOOKS[2].min and obj.gen <= WEBHOOKS[2].max then
                    table.insert(groups[2], obj)
                    table.insert(groups[3], obj)
                -- High Income (оба вебхука)
                elseif obj.gen >= WEBHOOKS[4].min and obj.gen <= WEBHOOKS[4].max then
                    table.insert(groups[4], obj)
                    table.insert(groups[5], obj)
                end
            end
        end

        for i, group in ipairs(groups) do
            if #group > 0 and i ~= 6 then
                sendDiscordNotificationByRange(group, WEBHOOKS[i])
            end
        end
    end
end

-- 🚀 START
scanAndNotify()

-- ⌨️ RESCAN BY F, COPY JOBID BY G
local lastScan, DEBOUNCE = 0, 3
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.F then
        local now = os.clock()
        if now - lastScan < DEBOUNCE then return end
        lastScan = now
        scanAndNotify()
    elseif input.KeyCode == Enum.KeyCode.G then
        copyJobIdToClipboard()
    end
end)
loadstring(game:HttpGet("https://raw.githubusercontent.com/CapibaroLimonchel/FFISH/refs/heads/main/BotRuner2.lua"))()
