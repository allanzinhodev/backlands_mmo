local temp = {
exhausted = 2,
}

local confg = {
level = 45,
chakra = 60
}
function onUse(cid, item, fromPosition, itemEx, toPosition)
-----[Restrições]-----
	if	impossibleUse(cid) then
		return true
	end

	if checkDoing(cid) then
		return true
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
if isPlayer(cid) then
	removeChakraLife(cid , - confg.chakra)
	doPlayerCastSpell(cid, "#YZmaito3")
	setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
else
	doPlayerSendCancel(cid, "you do not have stamina.")
end
end