local function finishJutsu(cid)   
if not isCreature(cid) then return true end
   mayNotMove(cid, false)
end

local confg = {
chakra = 8,
}


function onUse(cid, item, fromPosition, itemEx, toPosition)

	if(isCreature(cid)) then
		if getPlayerStorageValue(cid, STORAGE_SHADOW_1) == 1 then
   			setPlayerStorageValue(cid, STORAGE_SHADOW_1, 0)
   			setPlayerStorageValue(cid, STORAGE_SHADOW_2, 0)
   			setPlayerStorageValue(cid, STORAGE_SHADOW_3, 0)
   			doPlayerSetNoMove(cid, false)
   			return doPlayerSendCancel(cid, "Kagemane stopped.")
	end

	if checkCmd(cid, "rest") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are resting.")
	end
	if checkCmd(cid, "mold") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are mold chakra")
	end
	if checkJutsu(cid, "Kagemane") then
		return doPlayerSendCancel(cid, "You are already doing kagemane no jutsu.")
	end

	if getPlayerStorageValue(cid, STORAGE_KAGEMANE_TRAPED_QTY) > 0 then
  		return doPlayerSendCancel(cid, "You are already doing kagemane no jutsu.")
	end


	if getTileInfo(getCreaturePosition(cid)).protection then return doPlayerSendCancel(cid, "You use that from here.") end  
	local maxShadowDist = 15
	setPlayerStorageValue(cid, STORAGE_SHADOW_DIST, maxShadowDist)

	setPlayerStorageValue(cid, STORAGE_MAX_SHADOW_DIST, maxShadowDist)
	setPlayerStorageValue(cid, 10176, 1)
	actionMove(cid, 401, -1)
	removeChakraLife(cid, - confg.chakra)
	mayNotMove(cid, true)
	setPlayerStorageValue(cid, 9000, 'doing jutsu')
	doCreatureSay(cid, 'Kagemane no Jutsu!', TALKTYPE_ORANGE_1) 
	createKagemane(cid, getCreaturePosition(cid), 1)

	end
	return TRUE
end