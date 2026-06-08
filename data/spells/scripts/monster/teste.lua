function onCastSpell(cid, var)
	if not isCreature(cid) then
return true
end
local target = getCreatureTarget(cid)
mayNotMove(target, true)
addEvent(mayNotMove, 2000, target, false)
doPlayerSendCancel(cid, "teste")
end