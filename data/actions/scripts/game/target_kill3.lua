--functions--
function setCreatureNoMoveTime(cid, time)
   doCreatureSetNoMove(cid, true)
   addEvent(function(cid, state)
      if isPlayer(cid) then
         doCreatureSetNoMove(cid, state)
      end
   end, time, cid, false)
end

function sendBlueMessage(cid, msg)
   return doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, msg)
end

function registerPosInStorage(cid, storage, pos)
   setPlayerStorageValue(cid, storage.."X", pos.x)
   setPlayerStorageValue(cid, storage.."Y", pos.y)
   setPlayerStorageValue(cid, storage.."Z", pos.z) 
end

function registerPlayerInQuest(params)   
   setPlayerStorageValue(params.player, "hasActiveInQuest3", 1)
   setPlayerStorageValue(params.player, "genericQuestString", params.globalStorage)
   registerPosInStorage(params.player, "genericQuestPos", params.posExit)
end

function registrePosesBetween(pos1, pos2, stackpos)
   local poses = {}
   for x = pos1.x, pos2.x do
      for y = pos1.y, pos2.y do
         table.insert(poses, {x=x,y=y,z=pos1.z, stackpos = stackpos})
      end
   end
   return poses
end

--fim--

--instruções: registrar esse script no actions.xml com uid ou actionid da porta de inicio

local config = {
   enter = {x=2576,y=1712,z=8},
   exit = {x=2578,y=1712,z=8},
   clock = {time=60},
   totalPoses = registrePosesBetween({x=2570,y=1708,z=8}, {x=2574,y=1715,z=8}), --top LEFT position, under RIGHT position
   nameQuest = "cidShootingThree",
   isActive = false,
   maxLevel = 100,
   expBonus = 5, --esse valor multiplicado pelo nr de acertos
   expBase = 100, --valor que o player ganhará se ficar até o final
   magicEffectBird = 10, --magicEffect qdo passaro nasce
   msgStart = "You need shot in the target as many times possible.",
   msgIfExit = "Sorry, you have lost this game.",
   msgIfWin = "Congratulations! You have killed %s target in 60 seconds",
   magicEffectIfWin = 29,
   magicEffectIfLost = 2,
   canStart = true
}

local function doBird()
   local sortedPos = config.totalPoses[math.random(1, #config.totalPoses)]
   doSendMagicEffect(sortedPos, config.magicEffectBird)
   config.currentBird = doCreateMonster("Challenge Target", sortedPos)
end

local function doGiantBow(position)
   if config.bowUids ~= nil then
      for x = 1, #config.bowUids do
         if isCreature(config.bowUids[x]) then
            doRemoveCreature(config.bowUids[x])
         end
      end
   end

   if position.x == 2576 then
      if position.y == 1712 then
         config.bowUids = {doCreateMonster("bow1", {x=position.x-2,y=position.y,z=position.z}), doCreateMonster("bow2", {x=position.x-3,y=position.y,z=position.z})}
      else
         config.bowUids = {doCreateMonster("bow1", {x=position.x-2,y=position.y,z=position.z}), doCreateMonster("bow2", {x=position.x-3,y=position.y,z=position.z}), doCreateMonster("bow3", {x=position.x-3,y=position.y-1,z=position.z})}
      end
   end      
end

local function doRemoveBird(monsterPos)
   if isCreature(config.currentBird) then
      config.birds = config.birds+1
      doSendAnimatedText(monsterPos, config.birds, COLOR_GREY)  
      doSendMagicEffect(monsterPos, 2) 
      doRemoveCreature(config.currentBird)
   end
end

local function reset()
   config.isActive = false
   config.canStart = true
   config.currentPlayer = nil
   config.timeLeft = 1
   config.birds = 0

   if config.currentBird then
      if isMonster(config.currentBird) then
         doRemoveCreature(config.currentBird)
      end
   end

   if config.bowUids ~= nil then
      for x = 1, #config.bowUids do
         if isCreature(config.bowUids[x]) then
            doRemoveCreature(config.bowUids[x])
         end
      end
   end

   config.currentBird = 0
   config.bowUids = {}
   doSetStorage(config.nameQuest, 0)
end

reset()

local function stop(isWin, exit)
   local cid = config.currentPlayer

   if isPlayer(cid) then
      if isWin and config.birds > 0 then
         local stringComplement = "."

         if getPlayerLevel(cid) < config.maxLevel then
            local expFormula = config.expBase+(config.birds*config.expBonus)
            doPlayerAddExperience(cid, expFormula)
            doSendAnimatedText(getPlayerPosition(cid), expFormula, TEXTCOLOR_WHITE)
            stringComplement = ", and you have gained "..expFormula.." points of experience."
         end

         sendBlueMessage(cid, string.format(config.msgIfWin, config.birds)..stringComplement)
         addEvent(doSendMagicEffect, 100, config.exit, config.magicEffectIfWin)
      else
         sendBlueMessage(cid, config.msgIfExit)
         if not exit then
            addEvent(doSendMagicEffect, 100, config.exit, config.magicEffectIfLost)
         end
      end

      setPlayerStorageValue(cid, "hasActiveInQuest3", -1)
      doTeleportThing(cid, config.exit, true)
   end

   reset()
end

local function loopFast()
   if config.isActive then
      local cid = config.currentPlayer

      if isPlayer(cid) then
         if not isCreature(config.currentBird) then
            doBird()
         end
         addEvent(loopFast, 200)
      else
         stop()
      end
   end
end

local function loopSlow()
   local currentTime = os.time()

   if config.isActive then
      if getStorage(config.nameQuest) ~= config.currentPlayer then
         return stop()
      end

      if currentTime < config.timeLeft then
         local cid = config.currentPlayer

         if isCreature(cid) then
            local monsterPos, playerPos = getThingPos(config.currentBird), getThingPos(cid)

            if isCreature(config.currentBird) then
               if playerPos.y == monsterPos.y then
                  addEvent(doRemoveBird, 300, monsterPos)
               end
            end

            doSendDistanceShoot({x=playerPos.x-2,y=playerPos.y,z=playerPos.z}, {x=playerPos.x-6,y=playerPos.y,z=playerPos.z}, CONST_ANI_BOLT)
         else
            stop()
         end

         addEvent(loopSlow, 1000)
      else
         stop(true)
      end
   end
end

local function start(cid)
   if isPlayer(cid) then
      doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, config.msgStart)
      config.isActive = true
      config.currentPlayer = cid
      config.timeLeft = os.time()+config.clock.time
      doTeleportThing(cid, config.enter, true)
      doSetStorage(config.nameQuest, cid)
      registerPlayerInQuest({player = cid, posExit = config.exit, globalStorage = config.nameQuest, cannotMoveItems = true})
      doBird()
      loopFast()
      loopSlow()
   end
end


function onUse(cid, item, fromPosition, itemEx, toPosition)
	if checkCmd(cid, "rest") then
		return doPlayerSendCancel(cid, "you cannot use game while you are resting.")
	end
	if checkCmd(cid, "mold") then
		return doPlayerSendCancel(cid, "you cannot use game while you are mold chakra")
	end
   if not config.isActive then
      if isPlayerPzLocked(cid) then
         doPlayerSendCancel(cid, "You cannot start the chellenge with battle active.")
         return true
      end
      if not config.canStart then
         doPlayerSendCancel(cid, "Sorry the room is in use, wait please.")
         return true
      end
      setCreatureNoMoveTime(cid, 500)
      doTransformItem(item.uid, 1224)
      doTeleportThing(cid, fromPosition, true)
      config.canStart = false
      addEvent(start, 300, cid)
   else
      if cid == config.currentPlayer then
         setCreatureNoMoveTime(cid, 500)
         doTransformItem(item.uid, 1224)
         doTeleportThing(cid, fromPosition, true)
         addEvent(stop, 300, false, true)   
      else
         doPlayerSendCancel(cid, "Sorry the room is in use, wait please.")
      end
   end

   return true
end