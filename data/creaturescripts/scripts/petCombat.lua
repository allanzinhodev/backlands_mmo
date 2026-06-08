function onCombat(cid, target)
if getCreatureName(getCreatureSummons(target)[n]) == getCreatureName(target) then
doPlayerSendCancel(cid, "You can't attack your dragon or best.")
return false
end
return true
end