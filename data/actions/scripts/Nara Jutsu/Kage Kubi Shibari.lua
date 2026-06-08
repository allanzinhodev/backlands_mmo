local function finishJutsu(cid)   
if not isCreature(cid) then return true end
   mayNotMove(cid, false)
   addEvent(setPlayerStorageValue, 1000, cid, STORAGE_KAGE_KUBI, 0)
end

local function kubi(cid, dmg, chakra, neck)
  if not isCreature(cid) then
     return finishJutsu(cid)
  end 
  
         local targets = getKagemaneTargetList(cid)
         if(#targets < 1) then
           return finishJutsu(cid)
         end
         for _,v in pairs(targets) do
             if(isCreature(v)) then
                local targetPosition = getCreaturePosition(v) 
                doSendMagicEffect(targetPosition, 78) -- muda o effect pro que vc quiser
                if math.random(1,100) <= neck then
                   addEvent(doAreaCombatHealth,  200, cid, COMBAT_PHYSICALDAMAGE, targetPosition, 0, - getCreatureHealth(v), - getCreatureHealth(v), 15)
                   doSendAnimatedText(targetPosition, "K.O", COLOR_BLACK)
                else
                    doCreatureAddMana(cid, -chakra)
                   addEvent(doAreaCombatHealth,  200, cid, COMBAT_PHYSICALDAMAGE, targetPosition, 0, dmg, dmg, 15)
                end
                finishJutsu(cid) 
             end
         end
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
if isPlayer(cid) then
if (getStorage(cid, 9063) == 1) then
   return doPlayerSendCancel(cid, "You are already using kage kubi.")
end

  if  impossibleUse(cid) then
    return true
  end

  if checkDoing(cid) then
    return true
  end 

if getPlayerStorageValue(cid, 9004) > 0 then
  setPlayerStorageValue(cid, STORAGE_KAGE_KUBI, 1)
local level = getPlayerLevel(cid) 
local jutsuDmg = 10
local skill_factor = math.ceil((jutsuSkill_factor(cid, 1) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.20))
      doCreatureSay(cid, "Kage Kubi Shibari!", TALKTYPE_ORANGE_1)
      actionMove(cid, 401, 600)
      mayNotMove(cid, true)
      return kubi(cid, dmg, 10, 2) -- esse 10 é a quantidade de chakra que gasta
      -- e esse 1 é a chance em % de quebrar o pescoço do alvo e matar ele 
      
end
else
return doPlayerSendCancel(cid, "You have catch somebody on your kagemane first.")
end 

return TRUE
end