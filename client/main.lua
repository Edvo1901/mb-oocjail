local QBCore = exports['qb-core']:GetCoreObject()

local inJail = false
local jailTime = 0
local isRunText = false

local function EscapePrevention(curPos)
	local distanceFromJail = GetDistanceBetweenCoords(Config.JailLocation.x, Config.JailLocation.y, Config.JailLocation.z, curPos.x, curPos.y, curPos.z, true)

	if Config.PreventEscapeMod.on then
		if distanceFromJail > Config.PreventEscapeMod.distance then
			return true
		else
			return false

		end
	end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	QBCore.Functions.GetPlayerData(function(cPlayerData)
		PlayerData = cPlayerData
		if cPlayerData.metadata["oocjail"] > 0 then
			TriggerEvent("mb-oocjail:client:SendToJail", cPlayerData.metadata["oocjail"])
		end
	end)
end)

RegisterNetEvent("mb-oocjail:client:AdminJail", function(time)
    inJail = true
    ClearPedTasks(PlayerPedId())
    DetachEntity(PlayerPedId(), true, false)
    TriggerEvent("mb-oocjail:client:SendToJail", time)
end)

RegisterNetEvent("mb-oocjail:client:SendToJail", function(time)
	DoScreenFadeOut(500)
	while not IsScreenFadedOut() do
		Wait(10)
	end
	local JailPosition = Config.JailLocation
	SetEntityCoords(PlayerPedId(), JailPosition.x, JailPosition.y, JailPosition.z - 0.9, 0, 0, 0, false)
    SetEntityInvincible(PlayerPedId(), true)
	Wait(500)

	inJail = true
	jailTime = time
	TriggerServerEvent("mb-oocjail:server:SetJailTime", jailTime)
	if not isRunText then
		TriggerEvent('mb-oocjail:client:showTime')
	end
	TriggerServerEvent("mb-oocjail:server:CheckJailTime", jailTime)
	TriggerServerEvent("mb-oocjail:server:ClearInv")
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "jail", 0.5)
	Wait(2000)
	DoScreenFadeIn(1000)
end)

RegisterNetEvent('mb-oocjail:client:UnJailOOC', function()
	if jailTime > 0 then
		inJail = false

		MBNotify(Lang:t("notify.title"), Lang:t("success.you_are_free"), 'success')
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Wait(10)
		end
		TriggerEvent('mb-oocjail:client:Leave')
		Wait(500)
		DoScreenFadeIn(1000)
	end
end)

RegisterNetEvent('mb-oocjail:client:Leave', function()
    jailTime = 0
    TriggerServerEvent("mb-oocjail:server:SetJailTime", 0)
    inJail = false
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(10)
    end

	SetEntityCoords(PlayerPedId(), Config.OutJailLocation.x, Config.OutJailLocation.y, Config.OutJailLocation.z, 0, 0, 0, 0)
	SetEntityInvincible(PlayerPedId(), false)

    Wait(500)

    DoScreenFadeIn(1000)
end)

RegisterNetEvent('mb-oocjail:client:showTime', function()
	isRunText = true
	TriggerEvent('mb-oocjail:client:checkTime')
	while not inJail and jailTime > 0 do
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('mb-oocjail:client:checkTime', function()
	while inJail and jailTime > 0 do
		Citizen.Wait(60 * 1000)
		jailTime = jailTime - 1
		TriggerServerEvent("mb-oocjail:server:SetJailTime", jailTime)
		TriggerServerEvent("mb-oocjail:server:CheckJailTime", jailTime)
	end
	TriggerEvent("mb-oocjail:client:Leave")
	isRunText = false
end)

Citizen.CreateThread(function()
	while true do
		if inJail and jailTime > 0 then
			local curPos = GetEntityCoords(PlayerPedId())
			if EscapePrevention(curPos) then
				QBCore.Functions.GetPlayerData(function(PlayerData)
					if PlayerData.metadata["oocjail"] > 0 then
						TriggerEvent("mb-oocjail:client:SendToJail", PlayerData.metadata["oocjail"])
					end
				end)
			end
		end
		Citizen.Wait(Config.PreventEscapeMod.checkTime)
	end
end)