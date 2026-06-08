local KAGEMANE_INTERVAL = 300
local KAGEMANE_TABLE = {}
local count = 0
local limit_sqms = 6 --ate onde vai a sombra...
local temp = {
	exhausted = 4,
}
 
 local config = {
	 chakra = 90,
}

local kunais = {
   {id = 12685, eff = 1},
   {id = 2399, eff = 7},
   {id = 333, eff = 25},
}
local posKunais = {  --tabela pra pegar as pos aos lados  x 1 x
   [0] = {e = {x = -1, y = 0}, d = {x = 1, y = 0}},
   [1] = {e = {x = 0, y = -1}, d = {x = 0, y = 1}},
   [2] = {e = {x = -1, y = 0}, d = {x = 1, y = 0}},    
   [3] = {e = {x = 0, y = 1}, d = {x = 0, y = -1}},
}
local posDistances = {
   [0] = {e = {x = -8, y = -6}, c = {x = 0, y = -6}, d = {x = 8, y = -6}},
   [1] = {e = {x = 8, y = -6}, c = {x = 8, y = 0}, d = {x = 8, y = 6}},
   [2] = {e = {x = -8, y = 6}, c = {x = 0, y = 6}, d = {x = 8, y = 6}},
   [3] = {e = {x = -8, y = 6}, c = {x = -8, y = 0}, d = {x = -8, y = -6}},
}
 
local function hasTile(pos)
   local p = {x = pos.x, y = pos.y, z = pos.z, stackpos = 0}
   if getTileThingByPos(p).itemid >= 1 then
      return true
   end
   return false
end
 
local function doDamage(pos, dir, kunaiIndex, cid)
   local posis = {}
      posis[1] = getPosByDir(pos, dir)
      posis[2] = {x = posis[1].x+posKunais[dir].e.x, y = posis[1].y+posKunais[dir].e.y, z = pos.z}
      posis[3] = {x = posis[1].x+posKunais[dir].d.x, y = posis[1].y+posKunais[dir].d.y, z = pos.z}
     
   local posis2 = {}
      posis2[1] = {x = pos.x+posDistances[dir].c.x, y = pos.y+posDistances[dir].c.y, z = pos.z}
      posis2[2] = {x = pos.x+posDistances[dir].e.x, y = pos.y+posDistances[dir].e.y, z = pos.z}
      posis2[3] = {x = pos.x+posDistances[dir].d.x, y = pos.y+posDistances[dir].d.y, z = pos.z}
   
	  doSendDistanceShoot(pos, posis2[1], kunais[kunaiIndex].eff)

   
local level = getPlayerLevel(cid) 
local jutsuDmg = 24
local skill_factor = math.ceil((jutsuSkill_factor(cid, 1) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.20))
	local find_area = getFirstCreaturePosOnDirection(cid, 8)	
		if dir == 0 then
			doAreaCombatHealth(cid, 1, find_area, AREA_NARA1, dmg, dmg, 255)
		elseif dir == 1 then
			doAreaCombatHealth(cid, 1, find_area, AREA_NARA1, dmg, dmg, 255)
		elseif dir == 2 then
			doAreaCombatHealth(cid, 1, find_area, AREA_NARA1, dmg, dmg, 255)
		elseif dir == 3 then
			doAreaCombatHealth(cid, 1, find_area, AREA_NARA1, dmg, dmg, 255)
		end
	
	doCreateItem(kunais[kunaiIndex].id, 1, posis[math.random(#posis)])
end
 
local function checkKunais(pos, dir, cid)
   for index, tab in ipairs(kunais) do
      local item = getTileItemById(pos, tab.id) 
      if item and item.uid > 0 then
         doDamage(pos, dir, index, cid)
         doRemoveItem(item.uid, 1)
      end
   end
end
 
local function removeCallback()
   local t = KAGEMANE_TABLE
   for i = 1, #t do
      local item = getTileItemById(t[i].pos, t[i].itemId)
      if item and item.uid > 0 then
         doRemoveItem(item.uid, 1)
      end
   end
   
   -- \\Destroy table and count
   KAGEMANE_TABLE = {}
   count = 0
   return true
end
 
local function createCallback(cid, position, lookDir)
   local id, newPos = 0, getPosByDir(position, lookDir)
   if not isKagemane(newPos) then
      removeCallback()
      doRemoveCondition(cid, CONDITION_OUTFIT)
      mayNotMove(cid,false)
      return true
   end
   
   if isInArray({0, 2}, lookDir) then
      id = 12336
   else
      id = 12333
   end
   
   count = count + 1
   KAGEMANE_TABLE[count] = {itemId = id, pos = {x = newPos.x, y = newPos.y, z = newPos.z}}
   
   if not hasTile(newPos) then
      if limit_sqms == count then
         removeCallback()
		 doRemoveCondition(cid, CONDITION_OUTFIT)
		 mayNotMove(cid, false)
         return
      else
         addEvent(createCallback, KAGEMANE_INTERVAL, cid, newPos, lookDir)
         return
      end
   end
   
   doCreateItem(id, 1, newPos)
   checkKunais(newPos, lookDir, cid)
                 
   if limit_sqms == count then removeCallback() 
      doRemoveCondition(cid, CONDITION_OUTFIT)
      mayNotMove(cid, false)
   return true 
   end
   
   addEvent(createCallback, KAGEMANE_INTERVAL, cid, newPos, lookDir)
   return true
end
 
function onUse(cid, item, fromPosition, itemEx, toPosition) 
	if not isCreature(cid) then
		return true
	end
	  if impossibleUse(cid) then
      return true
   end

   if checkDoing(cid) then
      return true
   end   
   
   	if getPlayerStorageValue(cid, sto_nara[7]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")
	end
       
   if isPlayer(cid) then
      actionMove(cid, 401, -1)
	  removeChakraLife(cid, - config.chakra)
      mayNotMove(cid, true)
      doCreatureSay(cid, "Kagemane Shuriken No Jutsu!!", TALKTYPE_MONSTER)
      createCallback(cid, getCreaturePosition(cid), getCreatureLookDir(cid))
	  setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
   end
   return true
end