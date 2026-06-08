function onSay(cid, words, param, channel)
	if #param > 20 then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Use apenas 12 letras.")
	return true
	end

	if(param == '') then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Escolha um Nick exemplo !nick Akamaru.")
	return true
	end

	if getPlayerStorageValue(cid, STORAGE_NICKPET) <= 0 then 
		setPlayerStorageValue(cid, petStorages.nick, param)
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "o Nick do seu Pet agora e "..param..", voce nao podera trocar de novo.")
		setPlayerStorageValue(cid, STORAGE_NICKPET, 1)
		else
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Voce ja deu um nick para o seu Pet")
	return true
	end
	return true
	end