function onCastSpell(cid, var)
local pet = getPlayerPet(cid)	
		if getPlayerStorageValue(cid, sto_inuzuka[2]) > 0 then
			return doPlayerSendCancel(cid, "Use o Juujin Bunshin primeiro.")
		end
	if pet then
         iniciarGatsuuga(cid)
		 setPlayerStorageValue(cid, STORAGE_DIRECTION, 1)
		 addEvent(function()
		 if not isCreature(cid) then return true end
		 setPlayerStorageValue(cid, STORAGE_DIRECTION, 0)
		 end, 1000)
         addEvent(dashGatsuuga, 320, cid)
         addEvent(finalizarGatsuuga, 1000, cid)
		 addEvent(doCreatureSay, 0, cid, "GAAAA", TALKTYPE_MONSTER)
         addEvent(doCreatureSay, 300, cid, "TSUUGAA!!!", TALKTYPE_MONSTER)
		end
end 