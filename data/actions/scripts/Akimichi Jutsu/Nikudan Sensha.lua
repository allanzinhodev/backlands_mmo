local temp = {
exhausted = 2,
}

local confg = {
level = 5,
}


function onUse(cid, item, frompos, item2, topos)
	local info = {
		chakra = 5,
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
	if checkJutsu(cid, "Mizudan") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	if checkJutsu(cid, "Tongarashigan") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
----------------------	
	 if isPlayer(cid) then
	  if(getPlayerStorageValue(cid,sto_sensha[1]) == 0) then
             iniNikudan(cid)
			 setPlayerStorageValue(cid, sto_sensha[1], 1)
             addEvent(nikudanSensha, 800, cid, 3)
			 removeChakra(cid, -chakraPercent, 3, sto_sensha[1], "sharingan")
			 setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
         else
             endNikudan(cid)
			 setPlayerStorageValue(cid, sto_sensha[1], 0)
             normalizeOutfit(cid)
			 setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
         end
	end
end
