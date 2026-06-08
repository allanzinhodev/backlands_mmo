function onSay(cid, words, param)	
doPlayerSendTextMessage(cid, 27, "you have "..getPlayerStorageValue(cid, 7000).." points")
return true 
	end
