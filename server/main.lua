exports("getInv", function() return Config.Inventory end)
if Config.Framework == 'ESX' then
    ESX = exports["es_extended"]:getSharedObject()
    local function getFramework()
        return { Framework = ESX, Config = Config.Framework }
    end
    exports("getFramework", getFramework)
    RegisterNetEvent("t3_lib:createCallback", function(data)
        ESX.RegisterServerCallback(data.cb, data.func)
    end)
    RegisterNetEvent("t3_lib:registerUsableItem", function(data)
        if Config.Inventory == 'qs' then
            exports['qs-inventory']:CreateUsableItem(data.item, data.func)
        else
            ESX.RegisterUsableItem(data.item, data.func)
        end
    end)
    RegisterNetEvent("t3_lib:addMoney", function(data)
        local _source = data.target
        local xPlayer = ESX.GetPlayerFromId(_source)
        if data.account then
            xPlayer.addAccountMoney(data.account, data.money)
        else
            xPlayer.addMoney(data.money)
        end
    end)
    local function removeMoney(data)
        local _source = data.target
        local xPlayer = ESX.GetPlayerFromId(_source)
        if data.account then
            local acc = xPlayer.getAccount(data.account)
            if acc.money >= data.money then
                xPlayer.removeAccountMoney(data.account, data.money)
                return true
            else
                return false
            end
        else
            local acc = xPlayer.getMoney()
            if acc >= data.money then
                xPlayer.removeMoney(data.money)
                return true
            else
                return false
            end
        end
    end
    exports("removeMoney", removeMoney)
    RegisterNetEvent("t3_lib:removeMoney", function(data)
        return removeMoney(data)
    end)
    local function getMoney(data)
        local _source = data.target
        local xPlayer = ESX.GetPlayerFromId(_source)
        if data.account ~= 'cash' then
            local acc = xPlayer.getAccount(data.account)
            return acc.money
        else
            local acc = xPlayer.getMoney()
            return acc
        end
    end
    exports("getMoney", getMoney)
    RegisterNetEvent("t3_lib:getMoney", function(data)
        return getMoney(data)
    end)
    RegisterNetEvent("t3_lib:addItem", function(data)
        local _source = data.target
        if Config.Inventory == 'ox' then
            local ox_inventory = exports['ox_inventory']
            local canCarryItem = ox_inventory:CanCarryItem(_source, data.item, data.qty)
            if (canCarryItem) then
                ox_inventory:AddItem(_source, data.item, data.qty, data.metadata)
            end
        elseif Config.Inventory == 'esx' then
            local xPlayer = ESX.GetPlayerFromId(_source)
            xPlayer.addInventoryItem(data.item, data.qty)
        elseif Config.Inventory == 'qs' then
            local canCarryItem = exports['qs-inventory']:CanCarryItem(_source, data.item, data.qty)
            if (canCarryItem) then
                exports['qs-inventory']:AddItem(_source, data.item, data.qty, nil, data.metadata)
            end
        elseif Config.Inventory == 'mf' then
            local xPlayer = ESX.GetPlayerFromId(_source)
            xPlayer.addInventoryItem(data.item, data.qty, 100, data.metadata)
        else
            print("ERROR: No ESX compatible inventory selected")
        end
    end)
    RegisterNetEvent("t3_lib:removeItem", function(data)
        local _source = data.target
        if Config.Inventory == 'ox' then
            local ox_inventory = exports['ox_inventory']
            ox_inventory:RemoveItem(_source, data.item, data.qty, data.metadata, data.slot)
        elseif Config.Inventory == 'esx' then
            local xPlayer = ESX.GetPlayerFromId(_source)
            xPlayer.removeInventoryItem(data.item, data.qty)
        elseif Config.Inventory == 'qs' then
            exports['qs-inventory']:RemoveItem(_source, data.item, data.qty, data.slot)
        elseif Config.Inventory == 'mf' then
            local xPlayer = ESX.GetPlayerFromId(_source)
            if data.slot then
                exports['mf_inventory']:removeItemAtSlot(xPlayer.identifier, data.slot, data.item, _source)
            else
                xPlayer.removeInventoryItem(data.item, data.qty)
            end
        else
            print("ERROR: No ESX compatible inventory selected")
        end
    end)
    local function getItemBySlot(data)
        local _source = data.target
        if Config.Inventory == 'ox' then
            local ox_inventory = exports["ox_inventory"]
            return ox_inventory:GetSlot(_source, data.slot)
        elseif Config.Inventory == 'esx' then
            print("ERROR: Default ESX inventory doesn't have slot support")
        elseif Config.Inventory == 'qs' then
            return exports['qs-inventory']:GetItemBySlot(_source, data.slot)
        elseif Config.Inventory == 'mf' then
            local xPlayer = ESX.GetPlayerFromId(_source)
            local Inventory = exports["mf-inventory"]
            local i = Inventory:getInventoryItems(xPlayer.identifier)
            for k,v in pairs(i) do
                if v.slot == data.slot then
                    return v
                end
            end
            print("ERROR: Cannot find item at slot: "..data.slot)
        else
            print("ERROR: No ESX compatible inventory selected")
        end
    end
    exports("getItemBySlot", getItemBySlot)
    RegisterNetEvent("t3_lib:getItemBySlot", function(data)
        return getItemBySlot(data)
    end)
    local function getItemsByName(data)
        local _source = data.target
        if Config.Inventory == 'ox' then
            local ox_inventory = exports["ox_inventory"]
            return ox_inventory:Search(_source, 'slots', data.item)
        elseif Config.Inventory == 'esx' then
            print("ERROR: Default ESX inventory doesn't have search support")
        elseif Config.Inventory == 'qs' then
            return exports['qs-inventory']:GetItemsByName(_source, data.item)
        elseif Config.Inventory == 'mf' then
            local xPlayer = ESX.GetPlayerFromId(_source)
            local Inventory = exports["mf-inventory"]
            local i = Inventory:getInventoryItems(xPlayer.identifier)
            local f = {}
            for k,v in pairs(i) do
                if v.name == data.item then
                    table.insert(f, v)
                end
            end
            return f
        else
            print("ERROR: No ESX compatible inventory selected")
        end
    end
    exports("getItemsByName", getItemsByName)
    RegisterNetEvent("t3_lib:getItemsByName", function(data)
        return getItemsByName(data)
    end)
    RegisterNetEvent("t3_lib:setMetadata", function(data)
        local _source = data.target
        if Config.Inventory == 'ox' then
            local ox_inventory = exports["ox_inventory"]
            ox_inventory:SetMetadata(_source, data.slot, data.metadata)
        elseif Config.Inventory == 'esx' then
            print("ERROR: Default ESX inventory doesn't have metadata support")
        elseif Config.Inventory == 'qs' then
            exports['qs-inventory']:SetItemMetadata(_source, data.slot, data.metadata)
        elseif Config.Inventory == 'mf' then
            local xPlayer = ESX.GetPlayerFromId(_source)
            local Inventory = exports["mf-inventory"]
            for k,v in pairs(data.metadata) do
                Inventory:setInventoryItemMetadata(xPlayer.identifier, data.slot, k, v)
            end
        else
            print("ERROR: No ESX compatible inventory selected")
        end
    end)
    local function getIdentifier(data)
        local xPlayer = ESX.GetPlayerFromId(data.target)
        return xPlayer.identifier
    end
    exports("getIdentifier", getIdentifier)
    RegisterNetEvent("t3_lib:getIdentifier", function(data)
        return getIdentifier(data)
    end)
elseif Config.Framework == 'QB' then
    QBCore = exports['qb-core']:GetCoreObject()
    local function getFramework()
        return { Framework = QBCore, Config = Config.Framework }
    end
    exports("getFramework", getFramework)
    RegisterNetEvent("t3_lib:createCallback", function(data)
        QBCore.Functions.CreateCallback(data.cb, data.func)
    end)
    RegisterNetEvent("t3_lib:registerUsableItem", function(data)
        if Config.Inventory == 'qs' then
            exports['qs-inventory']:CreateUsableItem(data.item, data.func)
        else
            QBCore.Functions.CreateUseableItem(data.item, data.func)
        end
    end)
    RegisterNetEvent("t3_lib:addMoney", function(data)
        local src = data.target
        local Player = QBCore.Functions.GetPlayer(src)
        if data.account then
            Player.Functions.AddMoney(data.account, data.money)
        else
            Player.Functions.AddMoney('cash', data.money)
        end
    end)
    local function removeMoney(data)
        local src = data.target
        local Player = QBCore.Functions.GetPlayer(src)
        if data.account then
            local acc = Player.Functions.GetMoney(data.account)
            if acc >= data.money then
                Player.Functions.RemoveMoney(data.account, data.money)
                return true
            else
                return false
            end
        else
            local acc = Player.Functions.GetMoney('cash')
            if acc >= data.money then
                Player.Functions.RemoveMoney('cash', data.money)
                return true
            else
                return false
            end
        end
    end
    exports("removeMoney", removeMoney)
    RegisterNetEvent("t3_lib:removeMoney", function(data)
        return removeMoney(data)
    end)
    local function getMoney(data)
        local src = data.target
        local Player = QBCore.Functions.GetPlayer(src)
        local acc = Player.Functions.GetMoney(data.account)
        return acc
    end
    exports("getMoney", getMoney)
    RegisterNetEvent("t3_lib:getMoney", function(data)
        return getMoney(data)
    end)
    RegisterNetEvent("t3_lib:addItem", function(data)
        local src = data.target
        if Config.Inventory == 'ox' then
            local ox_inventory = exports['ox_inventory']
            local canCarryItem = ox_inventory:CanCarryItem(src, data.item, data.qty)
            if (canCarryItem) then
                ox_inventory:AddItem(src, data.item, data.qty, data.metadata)
            end
        elseif Config.Inventory == 'qs' then
            local canCarryItem = exports['qs-inventory']:CanCarryItem(src, data.item, data.qty)
            if (canCarryItem) then
                exports['qs-inventory']:AddItem(src, data.item, data.qty, nil, data.metadata)
            end
        elseif Config.Inventory == 'qb' then
            if data.metadata and data.metadata.image then
                data.metadata.image = data.metadata.image..".png"
            end
            local Player = QBCore.Functions.GetPlayer(src)
            Player.Functions.AddItem(data.item, data.qty, data.slot, data.metadata)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[data.item], "add")
        else
            print("ERROR: No QB compatible inventory selected")
        end
    end)
    RegisterNetEvent("t3_lib:removeItem", function(data)
        local src = data.target
        if Config.Inventory == 'ox' then
            local ox_inventory = exports['ox_inventory']
            ox_inventory:RemoveItem(src, data.item, data.qty, data.metadata, data.slot)
        elseif Config.Inventory == 'qs' then
            exports['qs-inventory']:RemoveItem(src, data.item, data.qty, data.slot)
        elseif Config.Inventory == 'qb' then
            local Player = QBCore.Functions.GetPlayer(src)
            Player.Functions.RemoveItem(data.item, data.qty, data.slot)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[data.item], "remove")
        else
            print("ERROR: No QB compatible inventory selected")
        end
    end)
    local function getItemBySlot(data)
        local src = data.target
        if Config.Inventory == 'ox' then
            local ox_inventory = exports["ox_inventory"]
            return ox_inventory:GetSlot(src, data.slot)
        elseif Config.Inventory == 'qs' then
            return exports['qs-inventory']:GetItemBySlot(src, data.slot)
        elseif Config.Inventory == 'qb' then
            local Player = QBCore.Functions.GetPlayer(src)
            return Player.Functions.GetItemBySlot(data.slot)
        else
            print("ERROR: No QB compatible inventory selected")
        end
    end
    exports("getItemBySlot", getItemBySlot)
    RegisterNetEvent("t3_lib:getItemBySlot", function(data)
        return getItemBySlot(data)
    end)
    local function getItemsByName(data)
        local src = data.target
        if Config.Inventory == 'ox' then
            local ox_inventory = exports["ox_inventory"]
            return ox_inventory:Search(src, 'slots', data.item)
        elseif Config.Inventory == 'qs' then
            return exports['qs-inventory']:GetItemsByName(src, data.item)
        elseif Config.Inventory == 'qb' then
            local Player = QBCore.Functions.GetPlayer(src)
            return Player.Functions.GetItemsByName(data.item)
        else
            print("ERROR: No QB compatible inventory selected")
        end
    end
    exports("getItemsByName", getItemsByName)
    RegisterNetEvent("t3_lib:getItemsByName", function(data)
        return getItemsByName(data)
    end)
    RegisterNetEvent("t3_lib:setMetadata", function(data)
        local src = data.target
        if Config.Inventory == 'ox' then
            local ox_inventory = exports["ox_inventory"]
            ox_inventory:SetMetadata(src, data.slot, data.metadata)
        elseif Config.Inventory == 'qs' then
            exports['qs-inventory']:SetItemMetadata(src, data.slot, data.metadata)
        elseif Config.Inventory == 'qb' then
            local Player = QBCore.Functions.GetPlayer(src)
            Player.PlayerData.items[data.slot].info = data.metadata
            Player.Functions.SetInventory(Player.PlayerData.items)
        else
            print("ERROR: No QB compatible inventory selected")
        end
    end)
    local function getIdentifier(data)
        local license = QBCore.Functions.GetIdentifier(data.target, 'license')
        return license
    end
    exports("getIdentifier", getIdentifier)
    RegisterNetEvent("t3_lib:getIdentifier", function(data)
        return getIdentifier(data)
    end)
end