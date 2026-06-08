function checkJutsu(cid, jutsu)
----------------------------------------------------------	
   if jutsu == "Henge" then
			if getCreatureStorage(cid, sto_jutsu[2]) >= 1 then
				setPlayerStorageValue(cid, sto_jutsu[2], 0)
				doSendMagicEffect(getThingPos(cid), 107)
				return true
	end	
----------------------------------------------------------------------------------------
		elseif jutsu == "Kagemane" then
		if getCreatureStorage(cid, STORAGE_TRAPED_ON_KAGEMANE) == 1 then
			return true
		end
		elseif jutsu == "Nikudan" then
		if getCreatureStorage(cid, sto_sensha[1]) == 1 then
			return true
		end
		elseif jutsu == "Hari" then
		if getCreatureStorage(cid, sto_sensha[5]) == 1 then
			return true
		end
			elseif jutsu == "Chou Baika" then
		if getCreatureStorage(cid, sto_sensha[6]) == 0 then
			return true
		end
			elseif jutsu == "Mizudan" then
		if getCreatureStorage(cid, sto_sensha[7]) == 1 then
			return true
		end
			elseif jutsu == "Horengan" then
		if getCreatureStorage(cid, sto_sensha[2]) == 0 then
			return true
		end
			elseif jutsu == "Karegan" then
		if getCreatureStorage(cid, sto_sensha[3]) == 0 then
			return true
		end
			elseif jutsu == "Tongarashigan" then
		if getCreatureStorage(cid, sto_sensha[4]) == 0 then
			return true
		end

----------------------------------------------------------------------------
			elseif jutsu == "Shikyaku" then
		if getCreatureStorage(cid, sto_inuzuka[1]) == 0 then
			return true
		end
			elseif jutsu == "Juujin" then
		if getCreatureStorage(cid, sto_inuzuka[2]) == 0 then
			return true
		end
			elseif jutsu == "Soutorou" then
		if getCreatureStorage(cid, sto_inuzuka[3]) == 0 then
			return true
		end			
			end
		return false
	end
	