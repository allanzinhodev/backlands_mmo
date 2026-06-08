
function onUse(cid, item, fromPosition, itemEx, toPosition)

local target = getCreatureOnPosition(toPosition)
if(isCreature(target)) then
if getCreatureName(target) == getCreatureName(cid) then
   return true
end

   if(isKagemaneTarget(cid, target)) then
      removeKagemaneTarget(cid, target)
   else
      return doPlayerSendCancel(cid, "This target is not under your kagemane no jutsu influence.")
   end
end   
return TRUE
end