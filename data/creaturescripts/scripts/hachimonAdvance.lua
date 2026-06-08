function onAdvance(cid, skill, oldLevel, newLevel) 
if getPlayerVocation(cid) == 1 and getPlayerLevel(cid) >= 20 then
	if(getPlayerItemCount(cid, 13403) == 1) then
		local item = getPlayerItemById(cid, true, 13403)
				doTransformItem(item.uid, 11486)
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprende um novo taijutsu! (Kyumon) Menu->Jutsus->Maito Jutsu->Hachimon Tonkou")
	elseif getPlayerLevel(cid) >= 25 then
	if(getPlayerItemCount(cid, 13404) == 1) then
		local item = getPlayerItemById(cid, true, 13404)
				doTransformItem(item.uid, 11487)
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprende um novo taijutsu! (Seimon) Menu->Jutsus->Maito Jutsu->Hachimon Tonkou")	
	elseif getPlayerLevel(cid) >= 30 then
	if(getPlayerItemCount(cid, 13405) == 1) then
		local item = getPlayerItemById(cid, true, 13405)
				doTransformItem(item.uid, 11488)
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprende um novo taijutsu! (Shomon) Menu->Jutsus->Maito Jutsu->Hachimon Tonkou")
	elseif getPlayerLevel(cid) >= 35 then
		if(getPlayerItemCount(cid, 13406) == 1) then
		local item = getPlayerItemById(cid, true, 13406)
				doTransformItem(item.uid, 11489)
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprende um novo taijutsu! (Tomon) Menu->Jutsus->Maito Jutsu->Hachimon Tonkou")
		elseif getPlayerLevel(cid) >= 45 then
		if(getPlayerItemCount(cid, 13407) == 1) then
		local item = getPlayerItemById(cid, true, 13407)
				doTransformItem(item.uid, 11490)
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprende um novo taijutsu! (Keimon) Menu->Jutsus->Maito Jutsu->Hachimon Tonkou")	
				elseif getPlayerLevel(cid) >= 45 then
		if(getPlayerItemCount(cid, 13408) == 1) then
		local item = getPlayerItemById(cid, true, 13408)
				doTransformItem(item.uid, 11491)
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprende um novo taijutsu! (Kyomon) Menu->Jutsus->Maito Jutsu->Hachimon Tonkou")	
			elseif getPlayerLevel(cid) >= 45 then
		if(getPlayerItemCount(cid, 13409) == 1) then
		local item = getPlayerItemById(cid, true, 13409)
				doTransformItem(item.uid, 11492)
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprende um novo taijutsu! (Shimon) Menu->Jutsus->Maito Jutsu->Hachimon Tonkou")	
		return true
		end
	end
		end
	end
		end
end
	end
end
end