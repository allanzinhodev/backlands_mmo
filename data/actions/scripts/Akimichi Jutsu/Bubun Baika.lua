local temp = {
exhausted = 3,
}
local confg = {
level = 40,
chakra = 60,
}
function onUse(cid, item, fromPosition, itemEx, toPosition)
-----[Restrições]-----
	if	impossibleUse(cid) then
		return true
	end

	if checkDoing(cid) then
		return true
	end	
	if checkJutsu(cid, "Nikudan") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	if checkJutsu(cid, "Hari") then
		return doPlayerSendCancel(cid, "you cannot use jutsu ")	
	end
	if checkJutsu(cid, "Chou Baika") then
		return doPlayerSendCancel(cid, "you cannot use jutsu ")	
	end
	if checkJutsu(cid, "Mizudan	") then
		return doPlayerSendCancel(cid, "you cannot use jutsu ")	
	end
	if checkJutsu(cid, "Tongarashigan") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
-----[Restrições]-----
if isPlayer(cid) then
	removeChakraLife(cid, - confg.chakra)
	doPlayerCastSpell(cid, "#YZakimichi3")
	setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
else
	doPlayerSendCancel(cid, "you do not have stamina or chakra.")
end
end