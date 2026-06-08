function onSay(cid, words, param, channel)
	if param == "reset" then
		for _, player in ipairs(getPlayersOnline()) do
   			setPlayerStorageValue(player, levelUpStorages.advance, getPlayerLevel(player))
		end
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Servidor Desbugado.")
	else
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Use o parametro reset")
	end
	return true
end
