local function MaxCapKikais(cid)
local maxkikais = 50 + (10*getPlayerStorageValue(cid, sto_kikkais[2]))
return maxkikais
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if checkJutsu(cid, "Kagemane") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end

	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end
	
	if getPlayerVocation(cid) == 3 then
	if #getCreatureSummons(cid) == 0 then
	if getPlayerStorageValue(cid, sto_kikkais[1]) < MaxCapKikais(cid) then 
	if isPlayer(cid) then
		removeChakraLife(cid, - 1)
		doPlayerSendCancel(cid, "You lose ".. 1 .." chakra.")
		actionMove(cid, 372, 1000)
		noMove(cid, 1000)
		setPlayerStorageValue(cid, sto_kikkais[1], getPlayerStorageValue(cid, sto_kikkais[1])+10)                             
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You have ".. getPlayerStorageValue(cid, sto_kikkais[1]) .."/".. MaxCapKikais(cid) .." kikais.")
	else
		doPlayerSendCancel(cid, "You do not have chakra.")
	end
	else
		doPlayerSendCancel(cid, "You already have the maximum of kikais(".. MaxCapKikais(cid) ..").")
	end
	else
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You have ".. getPlayerStorageValue(cid, sto_kikkais[1]) .."/".. MaxCapKikais(cid) .." kikais.")
	end
	else
		doPlayerSendCancel(cid, "you do not is Aburame.")
	end 
end