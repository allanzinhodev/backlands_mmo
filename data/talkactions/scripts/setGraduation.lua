function onSay(cid, words, param, channel)

	if(param == '') then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Digite o nome de um Usuario.")
	return true
	end

local t = string.explode(param, ",")
	local pid = getPlayerByNameWildcard(t[1])
	if(not pid or (isPlayerGhost(pid) and getPlayerGhostAccess(pid) > getPlayerGhostAccess(cid))) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Player " .. t[1] .. " not found.")
		return true
	end
	

	setPlayerStorageValue(pid, initStorages.graduation, ""..t[2].."")
	setPlayerStorageValue(pid, 600, 3)
	doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, "Você se tornou um "..t[2].."")
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Jogador "..t[1].." virou "..t[2].."")
	return true
end

