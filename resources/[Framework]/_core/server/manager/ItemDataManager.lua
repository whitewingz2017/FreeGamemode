local itemDatas = {}
local names = {}

local defaultItemData = API.ItemData('????????', '????????', 0.1)

function API.getItemDataFromId(id)
    return itemDatas[id] or defaultItemData
end

function API.getItemDataFromName(name)
    if names[name] ~= nil then
        return itemDatas[names[name]] or defaultItemData
    end
    return defaultItemData
end

function API.useItem(source, id, amount)
    local User = API.getUserFromSource(source)
    local ItemData = API.getItemDataFromId(id)

    if ItemData:getType() == "weapon" then
        local uWeapons = cAPI.getWeapons(source)
        if uWeapons[ItemData:getId():upper()] then
            User:notify('Arma já está equipada')
            return false
        end
        Citizen.CreateThread(
            function()
                User:giveWeapon(id, 0)
            end
        )
        return true
    elseif ItemData:getType() == "ammo" then
        local uWeapons = cAPI.getWeapons(source)
        local formattedId = ItemData:getId():gsub('ammo_', 'WEAPON_'):upper()
        if uWeapons[formattedId] == nil then
            User:notify('Nenhuma arma equipada suporta este tipo de munição!')
            return false
        end
        local equipedAmmo = uWeapons[formattedId]

        Citizen.CreateThread(
            function()
                User:giveWeapon(formattedId, equipedAmmo + amount)
            end
        )
        return true
    elseif ItemData:getType() == "food" then
        local hungerVar = ItemData:getHungerVar()
        if API.varyHunger(source, -hungerVar) then
            return true
        end
        return false
    elseif ItemData:getType() == "beverage" then
        local thirstVar = ItemData:getThirstVar()
        if API.varyThirst(source, -thirstVar) then 
            return true
        end
        return false
    elseif ItemData:getType() == "normal" then
        if ItemData:getId() == "generic_money" then
            -- later make a payment system with using item Oo: this is new
        end
    end 
end

Citizen.CreateThread(
    function()
        for id, values in pairs(ItemList) do
            local ItemData = API.ItemData(id, values.name, values.weight or 0.1, values.subtitle, values.type, values.hungerVar, values.thirstVar)

            if id:find('weapon_') then
                ItemData:onUse(
                    function(this, User, amount)
                        local source = User:getSource()
                        local uWeapons = cAPI.getWeapons(source)

                        if uWeapons[id:toupper()] then
                            User:notify('Arma já está equipada')
                            return false
                        end

                        Citizen.CreateThread(
                            function()
                                User:giveWeapon(id, 0)
                            end
                        )
                        return true
                    end
                )
            end

            if id:find('ammo_') then
                ItemData:onUse(
                    function(this, User, amount)
                        local source = User:getSource()
                        local uWeapons = cAPI.getWeapons(source)
                        local formattedId = id:gsub('ammo_', ''):toupper()

                        if uWeapons[formattedId] == nil then
                            User:notify('Nenhuma arma equipada suporta este tipo de munição!')
                            return false
                        end

                        local equipedAmmo = uWeapons[formattedId]

                        Citizen.CreateThread(
                            function()
                                User:giveWeapon(formattedId, equipedAmmo + amount)
                            end
                        )
                        return true
                    end
                )
            end

            if values.type == 'food' then
                ItemData:onUse(
                    function(this, User, amount)
                        local hungerVar = values.hungerVar

                        API.varyHunger(User:getSource(), hungerVar)
                        -- TaskPlayScenario eating
                        -- Wait for Scenario to end
                        -- varyHunger

                        return true
                    end
                )
            end

            if values.type == 'beverage' then
                ItemData:onUse(
                    function(this, User, amount)
                        local thirstVar = values.thirstVar

                        API.varyThirst(User:getSource(), thirstVar)
                        -- TaskPlayScenario drinkin
                        -- Wait for Scenario to end
                        -- varyThirst

                        return true
                    end
                )
            end
            itemDatas[id] = ItemData
            names[values.name] = id
        end
    end
)