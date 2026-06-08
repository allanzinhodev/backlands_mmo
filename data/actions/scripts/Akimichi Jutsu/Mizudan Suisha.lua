local temp = {
exhausted = 4,
}

local confg = {
level = 40,
}


function onUse(cid, item, frompos, item2, topos)
	local info = {
		chakra = 8,
	}

	local chakraPercent = getCreatureMaxMana(cid) * (info.chakra / 100)
-----[Restrições]-----
	if	impossibleUse(cid) then
		return true
	end

	if checkDoing(cid) then
		return true
	end	
	if checkJutsu(cid, "Hari") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	if checkJutsu(cid, "Chou Baika") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	if checkJutsu(cid, "Nikudan") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	if checkJutsu(cid, "Tongarashigan") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
----------------------	
	if(getPlayerStorageValue(cid, sto_jutsu[1]) > os.time() and getPlayerStorageValue(cid, sto_jutsu[1]) < 100+os.time()) then
		doPlayerSendTextMessage(cid, 24, "Voce ja esta fazendo um jutsu")
	return true
	end
	 if isPlayer(cid) then
	  if(getPlayerStorageValue(cid, sto_sensha[7]) == 0) then
             iniMizudan(cid)
			 setPlayerStorageValue(cid, sto_sensha[7], 1)
             addEvent(mizudanSuisha, 800, cid, 3)
			 removeChakra(cid, -chakraPercent, 3, sto_sensha[7], "sharingan")
			 setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
         else
             endMizudan(cid)
			 setPlayerStorageValue(cid, sto_sensha[7], 0)
             doRemoveCondition(cid, CONDITION_OUTFIT)
			 setPlayerStorageValue(cid, STORAGE_AKIMICHI, os.time() + temp.exhausted)
         end
	end
end
