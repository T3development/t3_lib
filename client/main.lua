ESX, QBCore = nil, nil

if Config.Framework == 'ESX' then
    Citizen.CreateThread(function()
        while ESX == nil do
            ESX = exports["es_extended"]:getSharedObject()
            Citizen.Wait(5)
        end
        function getFramework()
            return { Framework = ESX, Config = Config.Framework }
        end
        exports("getFramework", getFramework)
    end)
    RegisterNetEvent("t3_lib:triggerCallback", function(data, ...)
        ESX.TriggerServerCallback(data.cb, data.func, ...)
    end)
elseif Config.Framework == 'QB' then
    Citizen.CreateThread(function()
        while QBCore == nil do
            QBCore = exports['qb-core']:GetCoreObject()
            Citizen.Wait(5)
        end
        function getFramework()
            return { Framework = QBCore, Config = Config.Framework }
        end
        exports("getFramework", getFramework)
    end)
    RegisterNetEvent("t3_lib:triggerCallback", function(data, ...)
        QBCore.Functions.TriggerCallback(data.cb, data.func, ...)
    end)
end
exports("getInv", function() return Config.Inventory end)
RegisterNetEvent("t3_lib:showMetadata", function(data)
    if Config.Inventory == 'ox' then
        if data.metadata then
            for k,v in pairs(data.metadata) do
                exports.ox_inventory:displayMetadata(v.name,v.label)
            end
        end
    end
end)
--Notify Event (You can add your own notification event here or use one of the provided examples)
RegisterNetEvent("t3_lib:notify", function(data)
    local n = {
        msg = data.msg,
        title = data.title or "Notification",
        duration = data.duration or 5000,
        type = data.type or "info",
    }
    ESX.ShowNotification(n.msg, n.type, n.duration)
    --QBCore.Functions.Notify(n.msg, (n.type == "info" and "primary" or n.type), n.duration)
    --exports['okokNotify']:Alert(n.title, string.gsub(n.msg, '(~[rbgypcmuonshw]~)', ''), n.duration, n.type)
    --exports['mythic_notify']:DoCustomHudText(n.type, string.gsub(n.msg, '(~[rbgypcmuonshw]~)', ''), n.duration)
end)
RegisterNetEvent("t3_lib:setTarget", function(data)
    if Config.Target == 'ox_target' then
        if data.type == 'entity' then
            local ops = {}
            for k,v in pairs(data.options) do
                ops[k] = {
                    label = v.label,
                    name = v.name,
                    icon = v.icon,
                    iconColor = v.iconColor,
                    distance = data.distance,
                    bones = v.bones,
                    groups = v.groups,
                    items = (v.items or v.item),
                    anyItem = v.anyItem,
                    canInteract = v.canInteract,
                    onSelect = v.onSelect,
                    export = v.export,
                    event = v.event,
                    serverEvent = v.serverEvent,
                    command = v.command,
                }
            end
            exports['ox_target']:addLocalEntity(data.entity, ops)
        end
    elseif Config.Target == 'qb-target' then
        if data.type == 'entity' then
            local ops = {}
            for k,v in pairs(data.options) do
                ops[k] = {
                    number = v.number,
                    type = v.type,
                    event = v.QBevent,
                    icon = v.icon,
                    label = v.label,
                    targeticon = v.targeticon,
                    item = v.item,
                    action = v.action,
                    canInteract = v.canInteract,
                    job = v.job,
                    gang = v.gang,
                }
            end
            exports['qb-target']:AddTargetEntity(data.entity, {
                options = ops,
                distance = data.distance
            })
        end
    end
end)
RegisterNetEvent("t3_lib:closeInv", function()
    if Config.Inventory == 'mf' then
        exports["mf-inventory"]:closeInventory()
    end
end)