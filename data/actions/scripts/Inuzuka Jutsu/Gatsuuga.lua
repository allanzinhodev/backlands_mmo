local temp = {
exhausted = 3,
}

local confg = {
level = 30,	
chakra = 55,
}
function onUse(cid, item, fromPosition, itemEx, toPosition)
local pet = getPlayerPet(cid)

	if getPlayerStorageValue(cid, sto_inuzuka[2]) == 1 then
		return doPlayerSendCancel(cid, "Use o Juujin primeiro.") 
	end 
	
-----[Restrições]-----

	if	impossibleUse(cid) then
		return true
	end

	if checkDoing(cid) then
		return true
	end	
	if checkJutsu(cid, "Soutorou") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end	
	
	if not pet then
		return doPlayerSendCancel(cid, "Call your dog.")
	end
-----[Restrições]-----
	if isPlayer(cid) then
		removeChakraLife(cid, - confg.chakra)
		doPlayerCastSpell(cid, "#YZinuzuka2")
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
	end
end