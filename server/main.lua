local QBCore = exports['qb-core']:GetCoreObject()
local globalJailTime = 0

function ExtractIdentifiers(id)
	local identifiers = {
		steam = "",
		ip = "",
		discord = "",
		license = "",
		xbl = "",
		live = ""
	}

	for i = 0, GetNumPlayerIdentifiers(id) - 1 do
		local playerID = GetPlayerIdentifier(id, i)

		if string.find(playerID, "steam") then
			identifiers.steam = playerID
		elseif string.find(playerID, "ip") then
			identifiers.ip = playerID
		elseif string.find(playerID, "discord") then
			identifiers.discord = playerID
		elseif string.find(playerID, "license") then
			identifiers.license = playerID
		elseif string.find(playerID, "xbl") then
			identifiers.xbl = playerID
		elseif string.find(playerID, "live") then
			identifiers.live = playerID
		end
	end

	return identifiers
end

function sendToDiscord(title, message, color, id, adminID) --Functions to send the log to discord
    local time = os.date("*t")

    --Banned player info
    local identifierlist = ExtractIdentifiers(id)
	local discord = "<@"..identifierlist.discord:gsub("discord:", "")..">"
    local bannedPlayer = QBCore.Functions.GetPlayer(id)
    local bannedCitizenId = bannedPlayer.PlayerData.citizenid
    local bannedCharInfo = bannedPlayer.PlayerData.charinfo

    --Admin info
    local adminIdentifierlist = ExtractIdentifiers(adminID)
    local adminDiscord = "<@"..adminIdentifierlist.discord:gsub("discord:", "")..">"
    local adminPlayer = QBCore.Functions.GetPlayer(adminID)
    local adminCharInfo = adminPlayer.PlayerData.charinfo

    local embed = {
            {
                ["color"] = color, --Set color
                ["author"] = {
                    ["icon_url"] = Config.Log.avatar, -- et avatar
                    ["name"] = Config.Log.server_name, --Set name
                },
                ["title"] = "**".. title .."**", --Set title
                ["description"] = Lang:t("log.jail_additional", {discord = discord, ID = id, fName = bannedCharInfo.firstname, lName = bannedCharInfo.lastname, CID = bannedCitizenId, adDiscord = adminDiscord, adFName = adminCharInfo.firstname, adLName = adminCharInfo.lastname, message = message}), --Set message
                ["footer"] = {
                    ["text"] = '' ..time.year.. '/' ..time.month..'/'..time.day..' '.. time.hour.. ':'..time.min, --Get time
                },
            }
        }

    PerformHttpRequest(Config.Log.webhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

QBCore.Commands.Add(Config.JailCommandName.name, Config.JailCommandName.help, {{name = Lang:t("argument.id"), help = Lang:t("argument.id_help")}, {name = Lang:t("argument.time"), help = Lang:t("argument.time_help")}, {name = Lang:t("argument.reason"), help = Lang:t("argument.reason_help")}}, true, function(source, args)
    if not args[1] or not args[2] or not args[3] then
        MBNotify(Lang:t("notify.title"), Lang:t("error.fill_argument"), 'error', source)
    else
        local src = source
        local reason = {}
        for i = 3, #args, 1 do
            reason[#reason+1] = args[i]
        end

        if QBCore.Functions.HasPermission(src, Config.JailCommandName.permission) or IsPlayerAceAllowed(src, 'command') ~= 1 then
            TriggerEvent("mb-oocjail:server:JailPlayer", tonumber(args[1]), tonumber(args[2]))
            MBNotify(Lang:t("notify.title"), Lang:t("success.you_have_been_jailed"), 'error', src)
            sendToDiscord(Lang:t("log.jail_title"), Lang:t("log.jail_description", {time = tonumber(args[2]), reason = table.concat(reason, " ")}), Config.Log.jail_color, tonumber(args[1]), src)
        else
            MBNotify(Lang:t("notify.title"), Lang:t("error.no_permission"), 'error', src)
        end
    end
end)

QBCore.Commands.Add(Config.UnjailCommandName.name, Config.UnjailCommandName.help, {{name = Lang:t("argument.id"), help = Lang:t("argument.id_help")}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if QBCore.Functions.HasPermission(src, Config.UnjailCommandName.permission) or IsPlayerAceAllowed(src, 'command') ~= 1 then
        local playerId = tonumber(args[1])
        TriggerClientEvent("mb-oocjail:client:UnJailOOC", playerId)
    else
        MBNotify(Lang:t("notify.title"), Lang:t("error.no_permission"), 'error', src)
    end
end)

QBCore.Commands.Add(Config.CheckTimeLeftCommand.name, Config.CheckTimeLeftCommand.help, {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Config.CheckTimeLeftCommand.allow then
        if Player.PlayerData.metadata["oocjail"] > 0 then
            if Config.CheckJailTimeType == "notify" then
                MBNotify(Lang:t("notify.title"), Lang:t("notify.check_time", {time = globalJailTime}), 'info', src)
            elseif Config.CheckJailTimeType == "chat" then
                TriggerClientEvent('chat:addMessage', src, {
                    template = '<div class="chat-message"><div class="chat-message"><font color="#D994DB"><strong>'..Lang:t("notify.check_time", {time = globalJailTime})..'</div></div>',
                })
            else
                print("Your choice of output time check is invalid, we dont support that type of output yet! Check your config please.")
            end
        else
            MBNotify(Lang:t("notify.title"), Lang:t("error.no_permission"), 'error', src)
        end
    else
        MBNotify(Lang:t("notify.title"), Lang:t("error.no_permission"), 'error', src)
    end
end)

RegisterNetEvent("mb-oocjail:server:CheckJailTime", function(jailTime)
    globalJailTime = jailTime
end)

RegisterNetEvent("mb-oocjail:server:JailPlayer", function(playerId, time)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local OtherPlayer = QBCore.Functions.GetPlayer(playerId)

    OtherPlayer.Functions.SetMetaData("oocjail", time)

    TriggerClientEvent("mb-oocjail:client:AdminJail", OtherPlayer.PlayerData.source, time)
end)

RegisterNetEvent('mb-oocjail:server:SetJailTime', function(jailTime)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.SetMetaData("oocjail", jailTime)

    if jailTime ~= 0 then
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message"><div class="chat-message"><font color="#D994DB"><strong>'..Lang:t("notify.jailed_player", {time = jailTime})..'</div></div>',
        })
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message"><div class="chat-message"><font color="#D994DB"><strong>'..Lang:t("notify.released_player")..'</div></div>',
        })
    end

    if jailTime > 0 and Config.LostJob then
        if Player.PlayerData.job.name ~= "unemployed" then
            Player.Functions.SetJob("unemployed")
            MBNotify(Lang:t("notify.title"), Lang:t("success.you_lost_job"), 'info', src)
        end
    end
end)

RegisterNetEvent("mb-oocjail:server:ClearInv", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if Config.DeleteInventory then
        Wait(2000)
        Player.Functions.ClearInventory()
        MBNotify(Lang:t("notify.title"), Lang:t("success.clear_inv"), 'info', src)
    end
end)