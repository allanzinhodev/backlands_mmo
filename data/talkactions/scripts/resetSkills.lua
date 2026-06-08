function onSay(cid, words, param, channel)

	if(param == '') then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Digite o nome de um Usuario.")
	return true
	end

	local pid = getPlayerByNameWildcard(param)
	if(not pid or (isPlayerGhost(pid) and getPlayerGhostAccess(pid) > getPlayerGhostAccess(cid))) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Player " .. param .. " not found.")
		return true
	end


	doPlayerSetSkillLevel(pid, 0, 0)
	doPlayerSetSkillLevel(pid, 1, 0)
	doPlayerSetSkillLevel(pid, 2, 0)
	doPlayerSetSkillLevel(pid, 3, 0)
	doPlayerSetSkillLevel(pid, 4, 0)
	doPlayerSetSkillLevel(pid, 5, 0)
	doPlayerSetSkillLevel(pid, 6, 0)
	doPlayerAddSoul(pid, -100)
	doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, "Skills Resetadas")
	return true
end

