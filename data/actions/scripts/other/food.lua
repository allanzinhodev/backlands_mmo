local potions = {
[13264] = {effect = 255, div = 70}, --ham
[13259] = {effect = 255, div = 50}, --bread
[13262] = {effect = 255, div = 60}, --orange
[13263] = {effect = 255, div = 80}, --meat
}


function onUse(cid, item, frompos, item2, topos)
if item2.uid == cid then
local pid = getThingFromPosWithProtect(topos)

if not isPlayer(item2.uid) then
return doPlayerSendCancel(cid, "Voce pode usar isto somente em si mesmo!")
end


if getCreatureHealth(pid) == getCreatureMaxHealth(pid) then
return doPlayerSendCancel(cid, "Voce ja esta com a vida cheia.")
end

if getPlayerStorageValue(pid, 435642) >= 1 then
return doPlayerSendCancel(cid, "Voce ja esta sob o efeito desta comida.")
end

if (getCreatureCondition(cid, CONDITION_INFIGHT) == TRUE) then
doPlayerSendCancel(cid,"Nao disponivel em battle.")
	return true
end


doCreatureSay(cid, "Crunch..", TALKTYPE_MONSTER)
doSendMagicEffect(getThingPos(pid), 3)
setPlayerStorageValue(pid, 435642, 1)
doRemoveItem(item.uid, 1)

local a = potions[item.itemid]
doHealOverTime(pid, a.div, 100, a.effect)

return true
else
doPlayerSendCancel(cid, "Você pode usar isto somente em sí mesmo!")
end

end
