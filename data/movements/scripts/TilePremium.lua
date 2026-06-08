local increasingItems = {[416] = 417, [426] = 425, [446] = 447, [3216] = 3217, [3202] = 3215}
local decreasingItems = {[417] = 416, [425] = 426, [447] = 446, [3217] = 3217, [3215] = 3202}
 
function onStepIn(cid, item, position, fromPosition)
if(increasingItems[item.itemid] ~= nil) then
   if(isPlayer(cid) ~= TRUE or isPlayerGhost(cid) ~= TRUE) then
	 doTransformItem(item.uid, increasingItems[item.itemid])
   end
end
if item.actionid == 7890 then
   if isPremium(cid) == FALSE and getPlayerAccess(cid) < 4 then
	 doTeleportThing(cid, fromPosition, FALSE)
				 doPlayerSendCancel(cid,"Apenas premium accounts passam aqui.")
   return FALSE
   end
end
return TRUE
end