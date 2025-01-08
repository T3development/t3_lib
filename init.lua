if not _VERSION:find('5.4') then
    error('^1Lua 5.4 must be enabled in the resource manifest!^0', 2)
end

Framework, FW = nil, nil
Cops = 0
local t3_lib = 't3_lib'
local export = exports[t3_lib]

if not GetResourceState(t3_lib):find('start') then
    error('^1t3_lib should be started before this resource.^0', 2)
elseif GetResourceState(t3_lib) ~= 'started' then
    for i = 1, 10 do
        Wait(1000)
        if GetResourceState(t3_lib) == 'started' then
            return
        end
    end
    error('^1t3_lib failed to start.^0', 2)
end

Inventory = export:getInv()
Citizen.CreateThread(function()
    while FW == nil do
        Citizen.Wait(10)
        while GetResourceState(t3_lib) ~= 'started' do
            Citizen.Wait(10)
        end
        local cb = export:getFramework()
        if cb ~= nil and cb.Framework ~= nil then
            Framework = cb.Config
            FW = cb.Framework
        end
    end
end)
t3 = {}
local context = IsDuplicityVersion() and 'server' or 'client'
local events = {
    showMetadata = "t3_lib:showMetadata",
    notify = "t3_lib:notify",
    createCallback = "t3_lib:createCallback",
    triggerCallback = "t3_lib:triggerCallback",
    registerUsableItem = "t3_lib:registerUsableItem",
    addMoney = "t3_lib:addMoney",
    removeMoney = "t3_lib:removeMoney",
    getMoney = "t3_lib:getMoney",
    addItem = "t3_lib:addItem",
    removeItem = "t3_lib:removeItem",
    getItemBySlot = "t3_lib:getItemBySlot",
    getItemsByName = "t3_lib:getItemsByName",
    setMetadata = "t3_lib:setMetadata",
    setTarget = "t3_lib:setTarget",
    closeInv = "t3_lib:closeInv",
    getIdentifier = "t3_lib:getIdentifier",
    getPlayerName = "t3_lib:getPlayerName",
    progressBar = "t3_lib:progressBar",
    inputDialog = "t3_lib:inputDialog",
    getNearbyPlayers = "t3_lib:getNearbyPlayers",
}

local function createEventHandler(eventName, triggerFunction)
    return function(data, ...)
        triggerFunction(eventName, data, ...)
    end
end

if context == 'client' then
    t3.showMetadata = createEventHandler(events.showMetadata, TriggerEvent)
    t3.notify = createEventHandler(events.notify, TriggerEvent)
    t3.createCallback = createEventHandler(events.createCallback, TriggerServerEvent)
    t3.triggerCallback = createEventHandler(events.triggerCallback, TriggerEvent, ...)
    t3.registerUsableItem = createEventHandler(events.registerUsableItem, TriggerServerEvent)
    t3.addMoney = createEventHandler(events.addMoney, TriggerServerEvent)
    t3.removeMoney = createEventHandler(events.removeMoney, TriggerServerEvent)
    t3.addItem = createEventHandler(events.addItem, TriggerServerEvent)
    t3.removeItem = createEventHandler(events.removeItem, TriggerServerEvent)
    t3.setMetadata = createEventHandler(events.setMetadata, TriggerServerEvent)
    t3.setTarget = createEventHandler(events.setTarget, TriggerEvent)
    t3.closeInv = createEventHandler(events.closeInv, TriggerEvent)
    t3.progressBar = createEventHandler(events.progressBar, TriggerEvent)
    RegisterNetEvent("t3_lib:setCopCount", function(count)
        Cops = count
    end)
    t3.inputDialog = function(data) return export:inputDialog(data) end
    t3.getNearbyPlayers = createEventHandler(events.getNearbyPlayers, TriggerServerEvent)
else
    t3.showMetadata = function(playerId, data)
        TriggerClientEvent(events.showMetadata, playerId, data)
    end
    t3.notify = function(playerId, data)
        TriggerClientEvent(events.notify, playerId, data)
    end
    t3.createCallback = createEventHandler(events.createCallback, TriggerEvent)
    t3.triggerCallback = function(playerId, data)
        TriggerClientEvent(events.triggerCallback, playerId, data)
    end
    t3.registerUsableItem = createEventHandler(events.registerUsableItem, TriggerEvent)
    t3.addMoney = createEventHandler(events.addMoney, TriggerEvent)
    t3.removeMoney = function(data) return export:removeMoney(data) end
    t3.getMoney = function(data) return export:getMoney(data) end
    t3.addItem = createEventHandler(events.addItem, TriggerEvent)
    t3.removeItem = createEventHandler(events.removeItem, TriggerEvent)
    t3.getItemBySlot = function(data) return export:getItemBySlot(data) end
    t3.getItemsByName = function(data) return export:getItemsByName(data) end
    t3.setMetadata = createEventHandler(events.setMetadata, TriggerEvent)
    t3.setTarget = function(playerId, data)
        TriggerClientEvent(events.setTarget, playerId, data)
    end
    t3.closeInv = function(playerId)
        TriggerClientEvent(events.closeInv, playerId)
    end
    t3.getIdentifier = function(data) return export:getIdentifier(data) end
    t3.getPlayerName = function(data) return export:getPlayerName(data) end
    t3.progressBar = function(playerId, data)
        TriggerClientEvent(events.progressBar, playerId, data)
    end
    t3.inputDialog = function(playerId, data)
        TriggerClientEvent(events.inputDialog, playerId, data)
    end
    t3.getNearbyPlayers = function(data) return export:getNearbyPlayers(data) end
end