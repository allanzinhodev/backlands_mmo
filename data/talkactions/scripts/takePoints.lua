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
	

	doPlayerAddSoul(pid, t[2])
	doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, "Adicionado pontos")
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Adicionado pontos para "..t[1].."")
	return true
end

