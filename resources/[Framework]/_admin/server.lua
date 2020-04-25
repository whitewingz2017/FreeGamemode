local Proxy = module("_core", "libs/Proxy")
local Tunnel = module("_core", "libs/Tunnel")

API = Proxy.getInterface("API")
cAPI = Tunnel.getInterface("cAPI")

------------------------------------
------------ADMIN COMMANDS----------
------------------------------------

RegisterCommand(
    "nc",
    function(source, args, rawCommand)
        local User = API.getUserFromSource(source)
        local Character = User:getCharacter()
        if Character:hasGroupOrInheritance("admin") then
            cAPI.toggleNoclip(source)
        end
    end
)

RegisterCommand(
    "tptome",
    function(source, args, rawCommand)
        local User = API.getUserFromSource(source)
        local Character = User:getCharacter()
        if Character:hasGroupOrInheritance("admin") and args[1] then
            local tplayer = API.getUserFromUserId(parseInt(args[1])):getSource()
            local x, y, z = cAPI.getPosition(source)
            if tplayer then
                cAPI.teleport(tplayer, x, y, z)
            end
        end
    end
)

RegisterCommand(
    "tpto",
    function(source, args, rawCommand)
        local User = API.getUserFromSource(source)
        local Character = User:getCharacter()
        if Character:hasGroupOrInheritance("admin") and args[1] then
            local tplayer = API.getUserSource(parseInt(args[1]))
            if tplayer then
                cAPI.teleport(source, cAPI.getPosition(tplayer))
            end
        end
    end
)

RegisterCommand(
    "tpcds",
    function(source, args, rawCommand)
        local User = API.getUserFromSource(source)
        local Character = User:getCharacter()
        if Character:hasGroupOrInheritance("admin") then
            local fcoords = cAPI.prompt(source, "Cordenadas:", "")
            if fcoords == "" then
                print('fcoords == ""')
                return
            end
            local coords = {}
            for coord in string.gmatch(fcoords or "0,0,0", "[^,]+") do
                table.insert(coords, parseInt(coord))
            end
            print(coords[1], coords[2], coords[3])
            cAPI.teleport(source, coords[1] or 0, coords[2] or 0, coords[3] or 0)
        end
    end
)

RegisterCommand(
    "tpway",
    function(source, args, rawCommand)
        local User = API.getUserFromSource(source)
        local Character = User:getCharacter()
        if Character:hasGroupOrInheritance("admin") then
            cAPI.teleportToWaypoint(source)
        end
    end
)

RegisterCommand(
    "ban",
    function(source, args, rawCommand)
        local User = API.getUserFromSource(source)
        local Character = User:getCharacter()
        if Character:hasGroupOrInheritance("admin") and args[1] then
            local sourcePlayer = API.getUserFromUserId(parseInt(args[1])):getSource()
            API.setBanned(sourcePlayer, args[1], "Banido")
        end
    end
)

RegisterCommand(
    "kick",
    function(source, args, rawCommand)
        local User = API.getUserFromSource(source)
        local Character = User:getCharacter()
        if Character:hasGroupOrInheritance("admin") and args[1] then
            local sourcePlayer = API.getUserFromUserId(parseInt(args[1])):getSource()
            API.kick(sourcePlayer, "Você foi expulso da cidade.")
        end
    end
)

RegisterCommand(
    "addxp",
    function(source, args, raw)
        local User = API.getUserFromSource(source)
        local Character = User:getCharacter()
        if Character:hasGroupOrInheritance("admin") then
            local UserTarget = API.getUserFromUserId(tonumber(args[1]))
            if UserTarget ~= nil then
                UserTarget:getCharacter():addXp(tonumber(args[2]))
                TriggerClientEvent("chatMessage", source, args[2] .. " XP adicionado ao jogador " .. UserTarget:getCharacter():getName())
            end
        end
    end
)

RegisterCommand(
    "remXP",
    function(source, args, raw)
        local User = API.getUserFromSource(source)
        local Character = User:getCharacter()
        if Character:hasGroupOrInheritance("admin") then
            local UserTarget = API.getUserFromUserId(tonumber(args[1]))
            if UserTarget ~= nil then
                UserTarget:getCharacter():removeXp(tonumber(args[2]))
                TriggerClientEvent("chatMessage", source, args[2] .. " XP removido ao jogador " .. UserTarget:getCharacter():getName())
            end
        end
    end
)

RegisterCommand(
    "dv",
    function(source, args, rawCommand)
        local User = API.getUserFromSource(source)
        local Character = User:getCharacter()

        TriggerClientEvent("deletarveiculo", source)
    end
)

RegisterServerEvent("trydeleteveh")
AddEventHandler(
    "trydeleteveh",
    function(index)
        TriggerClientEvent("syncdeleteveh", -1, index)
    end
)

RegisterCommand(
    "car",
    function(source, args, rawCommand)
        local User = API.getUserFromSource(source)
        local Character = User:getCharacter()
        if Character:hasGroupOrInheritance("admin") then
            cAPI.createVehicle(source, args[1])
        end
    end
)

RegisterCommand(
    "unban",
    function(source, args, rawCommand)
        local User = API.getUserFromSource(source)
        local Character = User:getCharacter()
        if Character:hasGroupOrInheritance("admin") then
        end
    end
)

RegisterCommand(
    "setlevel",
    function(source, args, rawCommand)
        local User = API.getUserFromSource(source)
        local Character = User:getCharacter()
        if Character:hasGroupOrInheritance("admin") then
            local UserTarget = API.getUserFromUserId(tonumber(args[1]))
            if UserTarget ~= nil then
                UserTarget:getCharacter():setLevel(tonumber(args[2]))
            end
        end
    end
)

RegisterCommand(
    "item",
    function(source, args, rawCommand)
        local User = API.getUserFromSource(source)
        local Character = User:getCharacter()
        if ItemList[args[1]] then
            if #args < 2 and not tonumber(args[2]) then
                return
            end
            if Character:hasGroupOrInheritance("admin") then
                Character:getInventory():addItem(args[1], tonumber(args[2]))
            end
        else
            User:notify(" This item does not exists in ItemList. ")
        end
    end
)

RegisterCommand(
    "ped",
    function(source, args, rawCommand)
        if #args >= 1 then
            local User = API.getUserFromSource(source)
            local Character = User:getCharacter()
            if Character:hasGroupOrInheritance("admin") then
                TriggerClientEvent("fc_faroeste:ped", args[1], args[2])
            end
        end
    end
)

RegisterCommand(
    "cds",
    function(source, args, rawCommand)
        local User = API.getUserFromSource(source)
        local Character = User:getCharacter()
        if Character:hasGroupOrInheritance("admin") then
            local x, y, z = cAPI.getPosition(source)
            API.prompt(source, "Cordenadas:", x .. "," .. y .. "," .. z)
        end
    end
)

RegisterCommand(
    "getmoney",
    function(source, args, rawCommand)
        local User = API.getUserFromSource(source)
        local Character = User:getCharacter()
        if args[1] and args[2] then 
            if Character:hasGroupOrInheritance("admin") then
                if args[1] == "user" then
                    local tplayer = API.getUserFromUserId(parseInt(args[2]))
                    if tplayer then
                        local OtherCharacter = tplayer:getCharacter()
                        User:notify(OtherCharacter:getName().." has " .. OtherCharacter:getMoney() .. "$")
                    end
                elseif args[1] == "char" then
                    local tplayer = API.getUserFromCharId(parseInt(args[2]))
                    if tplayer then
                        local OtherCharacter = tplayer:getCharacter()
                        User:notify(OtherCharacter:getName().." has " .. OtherCharacter:getMoney() .. "$")
                    end
                end
            end
        end
    end
)

RegisterCommand(
    "addmoney",
    function(source, args, rawCommand)
        local User = API.getUserFromSource(source)
        local Character = User:getCharacter()
        if args[1] and args[2] and parseInt(args[3]) > 1 then 
            if Character:hasGroupOrInheritance("admin") then
                if args[1] == "user" then
                    local tplayer = API.getUserFromUserId(parseInt(args[2]))
                    if tplayer then
                        local OtherCharacter = tplayer:getCharacter()
                        OtherCharacter:addMoney(args[3])
                        User:notify("Added: " .. args[3] .. "$ to "..OtherCharacter:getName())
                    end
                elseif args[1] == "char" then
                    local tplayer = API.getUserFromCharId(parseInt(args[2]))
                    if tplayer then
                        local OtherCharacter = tplayer:getCharacter()
                        OtherCharacter:addMoney(args[3])
                        User:notify("Added: " .. args[3] .. "$ to "..OtherCharacter:getName())
                    end
                end
            end
        end
    end
)

RegisterCommand(
    "removemoney",
    function(source, args, rawCommand)
        local User = API.getUserFromSource(source)
        local Character = User:getCharacter()
        if args[1] and args[2] and parseInt(args[3]) > 1 then 
            if Character:hasGroupOrInheritance("admin") then
                if args[1] == "user" then
                    local tplayer = API.getUserFromUserId(parseInt(args[2]))
                    if tplayer then
                        local OtherCharacter = tplayer:getCharacter()
                        OtherCharacter:removeMoney(args[3])
                        User:notify("Removed: " .. args[3] .. "$ to "..OtherCharacter:getName())
                    end
                elseif args[1] == "char" then
                    local tplayer = API.getUserFromCharId(parseInt(args[2]))
                    if tplayer then
                        local OtherCharacter = tplayer:getCharacter()
                        OtherCharacter:removeMoney(args[3])
                        User:notify("Removed: " .. args[3] .. "$ to "..OtherCharacter:getName())
                    end
                end
            end
        end
    end
)

RegisterCommand(
    "group",
    function(source, args, rawCommand)
        local User = API.getUserFromSource(source)
        local Character = User:getCharacter()
        if Character:hasGroupOrInheritance("admin") then
            if args[1] == "add" then
                local UserTarget = API.getUserFromUserId(parseInt(args[2]))
                if not UserTarget:getCharacter():hasGroupOrInheritance(args[3]) then
                    UserTarget:getCharacter():addGroup(args[3])
                end
            elseif args[1] == "remove" then
                local UserTarget = API.getUserFromUserId(parseInt(args[2]))
                if UserTarget:getCharacter():hasGroupOrInheritance(args[3]) then
                    UserTarget:getCharacter():removeGroup(args[3])
                end
            end
        end
    end
)