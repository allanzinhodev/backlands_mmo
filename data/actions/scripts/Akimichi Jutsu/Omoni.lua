local temp = {
exhausted = 3,
}

local confg = {
level = 30,
chakra = 80
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
	if checkJutsu(cid, "Tongarashigan") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
-----[Restrições]-----
	if(getPlayerStorageValue(cid, sto_jutsu[1]) > os.time() and getPlayerStorageValue(cid, sto_jutsu[1]) < 100+os.time()) then
		doPlayerSendTextMessage(cid, 24, "Voce ja esta fazendo um jutsu")
	return true
	elseif getPlayerLevel(cid) < confg.level then
		doPlayerSendCancel(cid, "You need to be atleast level ".. confg.level ..".") 
	return true
	end
-----------------------
if isPlayer(cid) and getPlayerStorageValue(cid, sto_sensha[6]) == 0 then
	removeChakraLife(cid, - confg.chakra)
	doPlayerCastSpell(cid, "#YZakimichi1")
	setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
else
	doPlayerSendCancel(cid, "you do not using chou baika.")
end
end