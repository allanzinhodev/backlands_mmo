--[[
      Tag: <movevent type="StepIn" actionid="4972-4973" event="script" value="games/genius1.lua"/>
      OBS: para startar a quest, basta o player pisar no tile inicial.

]]--

--functions--

function getSecsString(sec)
 local sec = tonumber(sec)
 local days = 0
 local hours = 0
 local minutes = 0
 local seconds = 0

 repeat
  if sec >= 60 then
   minutes = minutes+1
   sec = sec-60
  end
 until sec < 60

 repeat
  if minutes >= 60 then
   hours = hours+1
   minutes = minutes-60
  end
 until minutes < 60

 repeat
  if hours >= 24 then
   days = days+1
   hours = hours-24
  end
 until hours < 24

 if days > 0 then
  if tostring(days):len() < 2 then
   days = "0"..days
  end
 end

 if hours > 0 then
  if tostring(hours):len() < 2 then
   hours = "0"..hours
  end
 end

 if minutes > 0 then
  if tostring(minutes):len() < 2 then
   minutes = "0"..minutes
  end
 end

 if sec > 0 then
  if tostring(sec):len() < 2 then
   sec = "0"..sec
  end
 end

 if tonumber(days) > 0 then
  return days.." day(s), "..hours.." hour(s), "..minutes.." minute(s) and "..sec.." second(s)"
 elseif tonumber(hours) > 0 then
  return hours.." hour(s), "..minutes.." minute(s) and "..sec.." second(s)"
 else
  if tonumber(minutes) > 0 then
   return minutes.." minute(s) and "..sec.." second(s)"
  else
   return sec.." second(s)"
  end
 end
end

function sendBlueMessage(cid, msg, id)
  if id == nil then
         return doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, msg)
        else
         return doPlayerSendTextMessage(cid, MESSAGE_STATUS_SMALL, msg)
        end
end

function registerPosInStorage(cid, storage, pos)
      setPlayerStorageValue(cid, storage.."X", pos.x)
      setPlayerStorageValue(cid, storage.."Y", pos.y)
      setPlayerStorageValue(cid, storage.."Z", pos.z) 
end


local function registrePosesBetween(pos1, pos2, stackpos)
      local poses = {}
      for x = pos1.x, pos2.x do
            for y = pos1.y, pos2.y do
                  table.insert(poses, {x=x,y=y,z=pos1.z, stackpos = stackpos})
            end
      end
      return poses
end

local function registerPlayerInQuest(params)      
      setPlayerStorageValue(params.player, "hasActiveInQuest2", 1)
      setPlayerStorageValue(params.player, "genericQuestString2", params.globalStorage)
      registerPosInStorage(params.player, "genericQuestPos2", params.posExit)
end

local function getTimeInString(time)
      interval = time - os.time()
      timeTable = {}
      timeTable.hour = math.floor(interval/(60*60))
      timeTable.minute = math.floor((math.fmod(interval, 60*60))/60) 
      timeTable.second = math.fmod(math.fmod(interval, 60*60),60) 
      for i, v in pairs(timeTable) do
            if tostring(v):len() < 2 then
                  timeTable[i] = "0"..timeTable[i]
            end
      end

      return timeTable
end

local function sendTimesOnAnimatedText(pos, other, notIsTime)
      if notIsTime then
            doSendAnimatedText(pos, other, COLOR_GREY)      
      else
            local time = getTimeInString(other) 
            doSendAnimatedText(pos, time.minute..":"..time.second, COLOR_GREY)       
      end  
end

--end--

local const = {
     exitPos = {x=2544,y=1687,z=8},
     enterPos = {x=2544,y=1683,z=8},
     storageName = 8795,
     possiblesDir = {{dir = EAST, eff = 4}, {dir = WEST, eff = 13}, {dir = NORTH, eff = 10}, {dir = SOUTH, eff = 30}},
     isOpen = false,
     baseMoney = 50000
}

local function reset()
      const.clockPos = {x=const.enterPos.x-1,y=const.enterPos.y-2,z=8}
      const.totalArea = registrePosesBetween({x=const.enterPos.x-1,y=const.enterPos.y-1,z=const.enterPos.z}, {x=const.enterPos.x+1,y=const.enterPos.y+1,z=const.enterPos.z})
      const.currentPlayer = nil
      const.timeLeft = 0
      const.pos = {}
      const.totalTime = 0
      const.sequences = {}
      const.isOpen = false
      const.currentPlayerSequence = 0
      doSetStorage(const.storageName, 0)
end

reset()

local function stop()
      local player = getStorage(const.storageName)
      local number = 0

      if #const.sequences-1 > 0 then
            number = #const.sequences-1
      end

      if isCreature(player) then
            setPlayerStorageValue(player, "hasActiveInQuest2", -1)
            doPlayerAddMoney(player, number*const.baseMoney) 
            sendBlueMessage(player, "You lose! You have survived per "..getSecsString(os.time()-const.totalTime).." and you did "..number.." correct sequences.")
            doCreatureSetNoMove(const.currentPlayer, false)
            doTeleportThing(player, const.exitPos, 10)
      end

      for x = 1, #const.totalArea do
            doCleanTile(const.totalArea[x])
            doSendMagicEffect(const.totalArea[x], 1)
      end

      reset()
end

local function sendEffect(pos, eff, isFinal, initialTime)
      if const.isOpen == false or initialTime ~= const.totalTime then
            return
      end

      if pos and eff then
            doSendMagicEffect(pos, eff)
      end

      if isFinal then
            if isPlayer(const.currentPlayer) then
                  doCreatureSetNoMove(const.currentPlayer, false)
            end
            const.timeLeft = os.time()+(3*(#const.sequences+1))
      end
end

local function getPosDir(pos, dir)
      if dir == NORTH then
            return {x=pos.x,y=pos.y-1,z=pos.z}
      elseif dir == SOUTH then
            return {x=pos.x,y=pos.y+1,z=pos.z}
      elseif dir == EAST then
            return {x=pos.x+1,y=pos.y,z=pos.z}  
      elseif dir == WEST then
            return {x=pos.x-1,y=pos.y,z=pos.z}
      end 
end

local function randomizeNewSequence()
      const.timeLeft = false
      const.currentPlayerSequence = 1
      local forWorked = 0

      if isPlayer(const.currentPlayer) then
            doCreatureSetNoMove(const.currentPlayer, true)
      end

      for counter = 1, #const.sequences+1 do
            if const.sequences[counter] == nil then
                  local tableDir = const.possiblesDir[math.random(1, 4)]
                  local position, effect = getPosDir(const.enterPos, tableDir.dir), tableDir.eff
                  table.insert(const.sequences, {position = position, effect = effect})
                  addEvent(sendEffect, 1000*counter, position, effect, nil, const.totalTime)
            else
                  addEvent(sendEffect, 1000*counter, const.sequences[counter].position, const.sequences[counter].effect, nil, const.totalTime)
            end
         forWorked = forWorked+1
      end
      addEvent(sendEffect, 1000*forWorked, false, false, true, const.totalTime)
end

local function loop()
      if const.isOpen then
            if const.currentPlayer ~= getStorage(const.storageName) then
                  stop()
                  return true
            end

            if const.timeLeft == false then
                  sendTimesOnAnimatedText(const.clockPos, "Wait!", true)
            else
                  local currentTime = os.time()
                  if currentTime > const.timeLeft then
                        stop()
                        return true
                  else
                        sendTimesOnAnimatedText(const.clockPos, const.timeLeft)   
                  end
            end
            addEvent(loop, 1000, nil)
      end
end

local function start(cid)
      const.isOpen = true
      const.totalTime = os.time()
      const.currentPlayer = cid
      registerPlayerInQuest({player = cid, posExit = const.exitPos, globalStorage = const.storageName, cannotMoveItems = true})
      doSetStorage(const.storageName, cid)
      randomizeNewSequence()
      loop()
end

function onStepIn(cid, item, position, fromPosition)
      if item.actionid == 19193 then
            if not const.isOpen then
                  start(cid)
            else         
            end
      else
            if const.isOpen == false or const.currentPlayer ~= cid then
                  return true
            end
            local currentSequence = const.currentPlayerSequence
            
            if const.sequences[currentSequence] ~= nil then
                  if doComparePositions(const.sequences[currentSequence].position, position) then
                        doSendMagicEffect(const.sequences[currentSequence].position, const.sequences[currentSequence].effect)
                        const.currentPlayerSequence = currentSequence+1
                        if const.sequences[const.currentPlayerSequence] == nil then
                              randomizeNewSequence()      
                        end
                        doTeleportThing(cid, fromPosition)
                  else
                        stop()  
                  end
            end
      end
      return true
end


