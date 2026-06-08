local config = {
	loginMessage = getConfigValue('loginMessage'),
	useFragHandler = getBooleanFromString(getConfigValue('useFragHandler'))
}

function onLogin(cid)
	local loss = getConfigValue('deathLostPercent')
	if(loss ~= nil) then
		doPlayerSetLossPercent(cid, PLAYERLOSS_EXPERIENCE, loss * 10)
	end

	local accountManager = getPlayerAccountManager(cid)
	if(accountManager == MANAGER_NONE) then
		local lastLogin, str = getPlayerLastLoginSaved(cid), config.loginMessage
		if(lastLogin > 0) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, str)
			str = "Your last visit was on " .. os.date("%a %b %d %X %Y", lastLogin) .. "."
		else
			str = str .. " Please choose your outfit."
			doPlayerSendOutfitWindow(cid)
		end

		doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, str)
	elseif(accountManager == MANAGER_NAMELOCK) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Hello, it appears that your character has been namelocked, what would you like as your new name?")
	elseif(accountManager == MANAGER_ACCOUNT) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Hello, type 'account' to manage your account and if you want to start over then type 'cancel'.")
	else
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Hello, type 'account' to create an account or type 'recover' to recover an account.")
	end

	if(not isPlayerGhost(cid)) then
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
	end


	for i = 9000, 9063 do setPlayerStorageValue(cid, i, 0) end
	registerCreatureEvent(cid, "Bounty")
    setPlayerStorageValue(cid, 8877, 0)


	registerCreatureEvent(cid, "petKill")
	registerCreatureEvent(cid, "direction")
    registerCreatureEvent(cid, "petDeath")
	registerCreatureEvent(cid, "petStats")
	registerCreatureEvent(cid, "GraduationSystem")
	registerCreatureEvent(cid, "ExtendedOpcode")
	registerCreatureEvent(cid, "Stamina")
	registerCreatureEvent(cid, "Mail")
	registerCreatureEvent(cid, "GuildMotd")
	registerCreatureEvent(cid, "Idle")
	registerCreatureEvent(cid, "Hit")
	registerCreatureEvent(cid, "pointsup")
	registerCreatureEvent(cid, "noMove")
	registerCreatureEvent(cid, "skillAdvance")
	registerCreatureEvent(cid, "CapKikkais")
	registerCreatureEvent(cid, "hachimonAdvance")
	registerCreatureEvent(cid, "Death")
	registerCreatureEvent(cid, "task")
--	registerCreatureEvent(cid, "partyAndGuildProtection")
	registerCreatureEvent(cid, "Rest")
	registerCreatureEvent(cid, "creatureMove")
	registerCreatureEvent(cid, "PlayerLogout")
	registerCreatureEvent(cid, "kagemaneDeath")

	if(config.useFragHandler) then
		registerCreatureEvent(cid, "SkullCheck")
	end
	registerCreatureEvent(cid, "ReportBug")
	registerCreatureEvent(cid, "AdvanceSave")
	
	return true
end

function onLogout(cid)
	cleanKagemaneTargetList(cid)
		if(getPlayerStorageValue(cid, STORAGE_TRAPED_ON_KAGEMANE) == 1) then
			freeFromKagemane(cid)
		end

	for i = 9000, 9063 do 
   		 setPlayerStorageValue(cid, i, 0)
	end
	return true
end