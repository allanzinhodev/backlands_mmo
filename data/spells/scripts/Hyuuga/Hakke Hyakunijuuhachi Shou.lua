local function remove(pos, id)
local item = getTileItemById(pos, id).uid
if item > 1 then
   doRemoveItem(item, 1)
end
end

local function playerSay(cid, text)
if isCreature(cid) then
doCreatureSay(cid, text, TALKTYPE_MONSTER)
end
end 

local function playerCombat(cid, min, max) 
if isCreature(cid) then
local find_area = getFirstCreaturePosOnDirection(cid,1)
doAreaCombatHealth(cid, COMBAT_JUUKEN, find_area, 0, -min, -max, 255)
doAreaCombatMana(cid, find_area, 0, -min, -max, 255)	
end
end

local function lastHit(cid, min, max) 
if isCreature(cid) then
local pos = getCreaturePosition(cid)
local find_area = getFirstCreaturePosOnDirection(cid,1)
quakePush(cid, find_area, 1, -min, -max, 255, true)
end
end
	
function onCastSpell(cid, var)
   local pos = getCreaturePosition(cid)
   local position = {
         [1] = {pos = {x = pos.x, y = pos.y, z = pos.z}, item = 11411},
         [2] = {pos = {x = pos.x, y = pos.y-1, z = pos.z}, item = 11417},
         [3] = {pos = {x = pos.x+1, y = pos.y-1, z = pos.z}, item = 11420},
         [4] = {pos = {x = pos.x+1, y = pos.y, z = pos.z}, item = 11415},
         [5] = {pos = {x = pos.x+1, y = pos.y+1, z = pos.z}, item = 11412},
         [6] = {pos = {x = pos.x, y = pos.y+1, z = pos.z}, item = 11413},
         [7] = {pos = {x = pos.x-1, y = pos.y+1, z = pos.z}, item = 11414},
         [8] = {pos = {x = pos.x-1, y = pos.y, z = pos.z}, item = 11416},
         [9] = {pos = {x = pos.x-1, y = pos.y-1, z = pos.z}, item = 11418},  
         [10] = {pos = {x = pos.x, y = pos.y-2, z = pos.z}, item = 11419},
         [11] = {pos = {x = pos.x-1, y = pos.y-2, z = pos.z}, item = 11433},
         [12] = {pos = {x = pos.x+1, y = pos.y-2, z = pos.z}, item = 11434},
         [13] = {pos = {x = pos.x+2, y = pos.y-1, z = pos.z}, item = 11435},
         [14] = {pos = {x = pos.x+2, y = pos.y, z = pos.z}, item = 11436},
         [15] = {pos = {x = pos.x+2, y = pos.y+1, z = pos.z}, item = 11437},
         [16] = {pos = {x = pos.x, y = pos.y+2, z = pos.z}, item = 11438},
         [17] = {pos = {x = pos.x-1, y = pos.y+2, z = pos.z}, item = 11439},
         [18] = {pos = {x = pos.x-2, y = pos.y, z = pos.z}, item = 11440},
         [19] = {pos = {x = pos.x+1, y = pos.y+2, z = pos.z}, item = 11441},
         [20] = {pos = {x = pos.x-2, y = pos.y+1, z = pos.z}, item = 11442},
         [21] = {pos = {x = pos.x-2, y = pos.y-1, z = pos.z}, item = 11443}
   }
   addEvent(playerSay, 0, cid, "Hakke..")
   addEvent(actionMove, 100, cid, 404, 2100)
   addEvent(playerSay, 1400, cid, "Ni Shou")
   addEvent(playerSay, 2100, cid, "Yon Shou")
   addEvent(actionMove, 2100, cid, 405, 3600)
   addEvent(playerSay, 2800, cid, "Hachi Shou")
   addEvent(playerSay, 3600, cid, "Juuroku Shou")
   addEvent(actionMove, 3500, cid, 406, 200)
   addEvent(playerSay, 4900, cid, "SANJUUNI SHOU!!!")
   addEvent(actionMove, 3500, cid, 406, 900)
   addEvent(playerSay, 6300, cid, "ROKUJUUYON SHOU!!!!")
   addEvent(actionMove, 4600, cid, 406, 2000)
   addEvent(playerSay, 7100, cid, "HYAKUNIJUUHACHI SHOU!!!!")
   addEvent(actionMove, 6000, cid, 406, 2000)
   addEvent(actionMove, 7600, cid, 382, 800)
   
   for i = 1,21 do
      if hasSqm(position[i].pos) then
         local item = doCreateItem(position[i].item, 1, position[i].pos)
         doDecayItem(item)
         addEvent(remove, 7600, position[i].pos, position[i].item)
      end
   end  

local level = getPlayerLevel(cid) 
local jutsuDmg = 1
local skill_factor = math.ceil((jutsuSkill_factor(cid, 0) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.10))
local min = -dmg
local max = -dmg
   local find_area = getFirstCreaturePosOnDirection(cid,1)
   for i = 1,12 do
   if isPlayer(getThingfromPos(find_area).uid) then
         addEvent(doPlayerAddMana, 700 + (400*i), getThingfromPos(find_area).uid, -(min*i))
   end
addEvent(playerCombat, 700, cid, (min), (min))	 
addEvent(playerCombat, 1100, cid, (min), (min))
addEvent(playerCombat, 1300, cid, (min), (min))
addEvent(playerCombat, 1500, cid, (min), (min))
addEvent(playerCombat, 1700, cid, (min), (min))
addEvent(playerCombat, 1900, cid, (min), (min))
addEvent(playerCombat, 2100, cid, (min), (min))
addEvent(playerCombat, 2300, cid, (min), (min))
addEvent(playerCombat, 2500, cid, (min), (min))
addEvent(playerCombat, 2700, cid, (min), (min))	
addEvent(playerCombat, 2900, cid, (min), (min))
addEvent(playerCombat, 3100, cid, (min), (min))
addEvent(playerCombat, 3300, cid, (min), (min))
addEvent(playerCombat, 3500, cid, (min), (min))
addEvent(playerCombat, 3700, cid, (min), (min))	
addEvent(playerCombat, 3900, cid, (min), (min))
addEvent(playerCombat, 4100, cid, (min), (min))
addEvent(playerCombat, 4300, cid, (min), (min))
addEvent(playerCombat, 4500, cid, (min), (min))
addEvent(playerCombat, 4700, cid, (min), (min))	
addEvent(playerCombat, 4900, cid, (min), (min))
addEvent(playerCombat, 5100, cid, (min), (min))
addEvent(playerCombat, 5300, cid, (min), (min))
addEvent(playerCombat, 5500, cid, (min), (min))	
addEvent(playerCombat, 5900, cid, (min), (min))
addEvent(playerCombat, 6300, cid, (min), (min))
addEvent(playerCombat, 6600, cid, (min), (min))	
addEvent(playerCombat, 6900, cid, (min), (min))
addEvent(playerCombat, 7200, cid, (min), (min))
addEvent(playerCombat, 7600, cid, (min), (min))
addEvent(playerCombat, 7800, cid, (min), (min))	
addEvent(lastHit, 8100, cid, (min), (min))
   end
return false
end