function onUse(cid)
	if checkJutsu(cid, "Soutorou") then
		return doPlayerSendCancel(cid, "You can not call dog.")
	end	
doCreatureExecuteTalkAction(cid, "!pet #call1")
end