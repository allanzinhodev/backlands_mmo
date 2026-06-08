local function finishJutsu(cid)
doPlayerSetNoMove(cid, false)
end

local confg = {
chakra = 40,
}

function onUse(cid, item, fromPosition, itemEx, toPosition)

if getPlayerStorageValue(cid, STORAGE_SHADOW_3) == 1 or getPlayerStorageValue(cid, STORAGE_SHADOW_2) == 1 then
   return doPlayerSendCancel(cid, "You already have a duplicated/triplicate shadow.")
end

if getPlayerStorageValue(cid, STORAGE_SHADOW_1) ==  0 and getPlayerStorageValue(cid, STORAGE_SHADOW_2) ==  0 then
   return doPlayerSendCancel(cid, "You do not have a shadow do triplicate.")
end

setPlayerStorageValue(cid, STORAGE_SHADOW_3, 2)
local maxShadowDist = 15 
removeChakraLife(cid, - confg.chakra)
setPlayerStorageValue(cid, STORAGE_MAX_SHADOW_DIST, getStorage(cid, STORAGE_MAX_SHADOW_DIST) + maxShadowDist)
doCreatureSay(cid, 'Kagemane no Jutsu: Triplicate!', TALKTYPE_ORANGE_1)

return TRUE
end