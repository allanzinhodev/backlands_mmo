---[Config Inicial Storage]------
initBase = 2500
initStorages =

{
init = initBase + 1,
graduation = initBase + 2,
death = initBase + 3
}
---[Config Level Up] ----
levelUpBase = 85601
levelUpStorages = 

{
advance = levelUpBase + 1,
}

---[Config Passive Skill] ---
STORAGE_DEFENSE = 54321 --Configuração não terminada.
sto_pointsLogin = 656444444 -- Storage ao logar quando reseta pontos
---[Storage Missao]---
STORAGE_MISSAO_ALDEIA = 400
STORAGE_MISSAO_ALDEIA1 = 401
STORAGE_MISSAO_ALDEIA2 = 402
STORAGE_MISSAO_ALDEIA3 = 403
STORAGE_MISSAO_ALDEIA4 = 404
STORAGE_MISSAO_ALDEIA5 = 405
STORAGE_MISSAO_ALDEIA6 = 406
STORAGE_MISSAO_ALDEIA7 = 407

sto_missao = {810, 811, 812, 813, 814, 815, 816, 817}
--sto_missao = {missao, rank d, rank c, rank b, rank a, rank s, exhausted missao diaria} 


---[Sharingan Storage]--
sto_sharingan = {8701, 8702, 8703, 8704}
--sto_sharingan = {nivel 1, nevel 2, nivel 3, MS}

sto_sharingan_exhausted = {6751}
--sto_sharingan_exhausted = {global exhausted sharingan}

sto_sharingan_reflect = {690, 691, 692, 693}
--sto_sharingan_reflect = {1}

--[Byakugan Storage]--
sto_byakugan = {8700, 65400, 18640, 8699, 8799, 895622}
--sto_byakugan = {nivel 1 , delay, search, checksearch, searchchakra, checkbyak}

--[Kikkais Storage]--
sto_kikkais = {63459, 63458}
--sto_kikkais = {qnt kikkais, checar kikkais}

--[Haachimon Storage]--
sto_hachimon = {5071, 5072, 5073, 5074, 5075, 5079, 5080, 5081}
--sto_hachimon = {1, 2, 3, 4, 5, 6, 7 ,8}

---[Jutsu Storage]--
sto_jutsu = {3232322, 29869, 29871, 297855}
--sto_jutsu = {time, henge, kinobori, shunshin}

--[Akimichi Storage]
sto_sensha = {658741, 658742, 6587454, 6859745121, 658743, 65132121, 54156155}
--sto_sensha = {nikudan, horengan, karengan, tongarashigan, hari, choubaika, mizudan}

--[Inuzuka Storage]--
sto_inuzuka = {415100, 1252121, 123132155, 1516548}
--sto_inuzuka = {shikyaku, juujin, soutorou}

sto_gen = {56622, 56788, 45641, 1456111, 656565}

---- Nara Jutsu Storage
sto_nara = {510033, 510034, 45122, 45157, 465233, 8961662, 565422, 11115, 458416512, 132231}
--sto_nara = {chakra kagemane, não poder lançar kagemane 2x, check kagekubi, chakra kagekubi, stopEvent, kagemane usuario tomou, caminho kagemane, checagem curva duplicate, check duplicate, chakra duplicate}

--- Inuzuka
STORAGE_NICKPET = 4546544
STORAGE_PET_REST = 54584500
STORAGE_DIRECTION = 8451222

-- Task
TASK_STORAGE_POINTS  = 49998
TASK_APPEAR_QUESTLOG = 49999 -- desuso 
TASK_STORAGE_DOING   = 50000 -- tem 10 storages pra salvar o nome dos bixos que estao com task ativa
TASK_STORAGE_START   = 50010  -- Examples: 50021 = rat kills count; 50032 = finished snake task

--Reset Points
sto_resetPoints = 45122233
sto_getHeathPoint = 152155
sto_getChakraPoint = 1651233

function isInArray3(array, array2) -- Function by Ramza (Ricardo Ianelli)
local x = array2[1]
local y = array2[2]

  for _,v in pairs(array) do
     if (v[1] == x and v[2] == array2[2]) or (v[2] == x and v[1] == y)  then
       return true    
     end
  end
return false
end                 

function chainRoute(init, r) -- Function by Ramza (Ricardo Ianelli)
 local route, targets, tam = {{init, init}}, {}, 0
 for i = 1,#route do
    repeat
    tam = #route 
       targets = getSpectators(getCreaturePosition(init), r, r, false)      
    if #targets > 1 then
       for _,v in pairs(targets) do
          if not isInArray3(route, {init, v}) and (init ~= v) then
             table.insert(route, {init,v})
          end 
       end
    end
    init = route[#route][2]
   until tam == #route
 end
return route 
end

function actionMove(cid, outfit, time)
if not isCreature(cid) then
return true
end
local action = {lookType = outfit, lookHead = getCreatureOutfit(cid).lookHead, lookBody = getCreatureOutfit(cid).lookBody, lookLegs = getCreatureOutfit(cid).lookLegs, lookFeet = getCreatureOutfit(cid).lookFeet}
doSetCreatureOutfit(cid, action, time)
end

function changeMove(cid, outfit, time)
if not isCreature(cid) then
return true
end
local action = {lookType = outfit, lookHead = getCreatureOutfit(cid).lookHead, lookBody = getCreatureOutfit(cid).lookBody, lookLegs = getCreatureOutfit(cid).lookLegs, lookFeet = getCreatureOutfit(cid).lookFeet}
doCreatureChangeOutfit(cid, action)
end


function cmdMove(cid, outfit)
if not isCreature(cid) then
return true
end
doCreatureChangeOutfit(cid, outfit)
end

function randomPos(cid, pos)
if not isCreature(cid) then
return true
end
local position = {
[1] = {x = pos.x+1, y = pos.y, z = pos.z},
[2] = {x = pos.x, y = pos.y+1, z = pos.z},
[3] = {x = pos.x-1, y = pos.y, z = pos.z},
[4] = {x = pos.x, y = pos.y-1, z = pos.z},
[5] = {x = pos.x+1, y = pos.y-1, z = pos.z},
[6] = {x = pos.x+1, y = pos.y+1, z = pos.z},
[7] = {x = pos.x-1, y = pos.y-1, z = pos.z},
[8] = {x = pos.x-1, y = pos.y+1, z = pos.z},
[9] = {x = pos.x, y = pos.y, z = pos.z}
}
return position[math.random(1,9)]
end


function randomPos4(cid, pos)
if not isCreature(cid) then
return true
end
local position = {
[1] = {x = pos.x+1, y = pos.y, z = pos.z},
[2] = {x = pos.x, y = pos.y+1, z = pos.z},
[3] = {x = pos.x-1, y = pos.y, z = pos.z},
[4] = {x = pos.x, y = pos.y-1, z = pos.z},
[5] = {x = pos.x+1, y = pos.y-1, z = pos.z},
[6] = {x = pos.x+1, y = pos.y+1, z = pos.z},
[7] = {x = pos.x-1, y = pos.y-1, z = pos.z},
[8] = {x = pos.x-1, y = pos.y+1, z = pos.z},
[1] = {x = pos.x+2, y = pos.y, z = pos.z},
[9] = {x = pos.x, y = pos.y, z = pos.z},
[10] = {x = pos.x, y = pos.y+2, z = pos.z},
[11] = {x = pos.x-2, y = pos.y, z = pos.z},
[12] = {x = pos.x, y = pos.y-2, z = pos.z},
[13] = {x = pos.x+2, y = pos.y-2, z = pos.z},
[14] = {x = pos.x+2, y = pos.y+2, z = pos.z},
[15] = {x = pos.x-2, y = pos.y-2, z = pos.z},
[16] = {x = pos.x-2, y = pos.y+2, z = pos.z},
}
return position[math.random(1,16)]
end

function explosiveKunaiPos(cid, pos)
if not isCreature(cid) then
return true
end
local position = {
[1] = {x = pos.x+1, y = pos.y, z = pos.z},
[2] = {x = pos.x, y = pos.y+1, z = pos.z},
[3] = {x = pos.x-1, y = pos.y, z = pos.z},
[4] = {x = pos.x, y = pos.y-1, z = pos.z},
[5] = {x = pos.x+1, y = pos.y-1, z = pos.z},
}
return position[math.random(1,5)]
end

function noMove(cid, time)
if not isCreature(cid) or not tonumber(time) then return true end
mayNotMove(cid, TRUE)
addEvent(mayNotMove, time, cid, FALSE)
end

function effectdir(cid, effect1, effect2)
if not isCreature(cid) then
return true
end
if getPlayerLookDir(cid) == (0) then
effect1 = effect1
return effect1
end
if getPlayerLookDir(cid) == (1) then
effect2 = effect2
return effect2
end
if getPlayerLookDir(cid) == (2) then
effect1 = effect1
return effect1
end
if getPlayerLookDir(cid) == (3) then
effect2 = effect2
return effect2
end
end

function Defense(cid, time)
if not isCreature(cid) then
return true
end
setPlayerStorageValue(cid, STORAGE_DEFENSE, 1)
addEvent(setPlayerStorageValue, time, cid, STORAGE_DEFENSE, 0)
end	

function getPlayerMeleeSkill(cid)
  return {[0] = getPlayerSkillLevel(cid, SKILL_FIST), [1] = getPlayerSkillLevel(cid, SKILL_CLUB), [2] = getPlayerSkillLevel(cid, SKILL_SWORD), [3] = getPlayerSkillLevel(cid, SKILL_AXE)}
end

function noMoves(cid, time)  
   if not isCreature(cid) or not tonumber(time) then return true end
                                                     
   local function podeMover(cid, speed)                        
      if isPlayer(cid) then
         mayNotMove(cid, false)  
      elseif isCreature(cid) then
         doChangeSpeed(cid, speed)
      end
   end
 
   local speed = getCreatureSpeed(cid)
   if isPlayer(cid) then
      mayNotMove(cid, true)
   else
      doChangeSpeed(cid, (getCreatureSpeed(cid) - getCreatureSpeed(cid)) - 1)
   end
   addEvent(podeMover, time, cid, speed)
end

function isSummon(sid)
    for i, pid in ipairs(getPlayersOnline()) do
        for c, cid in pairs(getCreatureSummons(pid)) do
            if (cid == sid) then
                return true
            end
        end 
    end
    return false
end 

function noSpeed(cid, time)  
   if not isCreature(cid) or not tonumber(time) then return true end
                                                     
   local function podeMover(cid, speed)                        
      if isPlayer(cid) then
         doChangeSpeed(cid, speed) 
      elseif isCreature(cid) then
         doChangeSpeed(cid, speed)
      end
   end
 
   local speed = getCreatureSpeed(cid)
   if isPlayer(cid) then
      doChangeSpeed(cid, (getCreatureSpeed(cid) - getCreatureSpeed(cid)) - 1)
   else
      doChangeSpeed(cid, (getCreatureSpeed(cid) - getCreatureSpeed(cid)) - 1)
   end
   addEvent(podeMover, time, cid, speed)
end

function getFirstCreaturePosOnDirection(cid,distance) -- By: Lwkass
  local p1 = getThingPos(cid)
   local lib_pos = {} 
  for t = 1, distance do
   local direction = {{x=p1.x, y=p1.y - t, z=p1.z},{x=p1.x + t, y=p1.y, z=p1.z},{x=p1.x, y=p1.y + t, z=p1.z},{x=p1.x - t, y=p1.y, z=p1.z}}
   table.insert(lib_pos, t, direction[getCreatureLookDir(cid) + 1])
  end
  
   for a = 1, #lib_pos do
   lib_pos[a].stackpos = 0
     if hasProperty(getThingFromPos(lib_pos[a]).uid,3) or hasProperty(getThingFromPos(lib_pos[a]).uid,7) then
      return lib_pos[a]
	 end
   lib_pos[a].stackpos = 255
	 if isCreature(getThingFromPos(lib_pos[a]).uid) then
	  return lib_pos[a]
	 end
	 if a == #lib_pos then
	  return lib_pos[a]
	 end
   end
   return FALSE
  end
 
function removeLevelSoul(cid, skillLevel)
for i = 0,100 do
if skillLevel >= 10*i and skillLevel < 10*i+10  then
quantidade = (1*i)+1
end
end
doPlayerAddSoul(cid, - quantidade)
end

function getLevelSoul(cid, skill)
 local soul = getPlayerSoul(cid)
 local skillValue = getPlayerSkill(cid, skill)
 if( math.ceil( skillValue/10 ) > soul ) then
  return true
 else
  return false
 end
end

function getChakraSoul(cid, chakra)
 local soul = getPlayerSoul(cid)
 local chakraValue = getPlayerMagLevel(cid)
 if( math.ceil( chakraValue/11 ) > soul ) then
  return true
 else
  return false
 end
end

function quakePush(cid, pos, combat, min, max, effect, x)
    if not isCreature(cid) then
        return false
    end
    doAreaCombatHealth(cid, combat, pos, 0, -min, -max, effect)
    local thing = {x=pos.x,y=pos.y,z=pos.z,stackpos=255}
    if isCreature(getThingFromPos(thing).uid) == TRUE and x == true then
        doMoveCreature2(getThingFromPos(thing).uid, getQuakePos(cid, getThingFromPos(thing).uid))
    elseif isCreature(getThingFromPos(thing).uid) == TRUE and x == false then
        doMoveCreature2(getThingFromPos(thing).uid, getPlayerLookDir(cid))
    end
end

function quake(cid, pos, combat, min, max, effect, x)
    if not isCreature(cid) then
        return false
    end
    doAreaCombatHealth(cid, combat, pos, 0, -min, -max, effect)
    local thing = {x=pos.x,y=pos.y,z=pos.z,stackpos=255}
    if isCreature(getThingFromPos(thing).uid) == TRUE and x == true then
        return true
    elseif isCreature(getThingFromPos(thing).uid) == TRUE and x == false then
        return true
    end
end

function regen(cid, percent, time)
  if not isCreature(cid) then
    return true
  end
    doCreatureAddHealth(cid, percent)
    doCreatureAddMana(cid, percent)
    addEvent(regen, time*1000, cid, percent, time)
end

function getBounty(cid)
    pid1 = getPlayerGUID(cid)
    local result_target = db.getResult("SELECT * FROM `bounty_hunters` WHERE `sp_id` = "..pid1..";")
    if(result_target:getID() ~= -1) then
        bounty = tonumber(result_target:getDataInt("bounty"))
    else
        bounty = 0
    end
    return bounty
end