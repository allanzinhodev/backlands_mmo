local MSG_DEFAULT = 'I have many {tasks} for you!' 
local GRETZ_MSG   = 'Hello adventurer. '        .. MSG_DEFAULT
local WTF_MESSAGE = 'I can\'t understand you. Are you interested in any of my {tasks} ?'

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
npcHandler:setMessage(MESSAGE_GREET, GRETZ_MSG)
npcHandler.talkRadius = 2

NpcSystem.parseParameters(npcHandler)


function onCreatureAppear(cid)npcHandler:onCreatureAppear(cid)end
function onCreatureDisappear(cid)npcHandler:onCreatureDisappear(cid)end
function onThink()
local direction = getCreatureLookDirection(getNpcId())
doCreatureSetLookDirection(getNpcId(), 2)
npcHandler:onThink()
end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

local state = {}
local option = {} -- option[cid] = contem o nome da criatura da tabela TABLE_TASKS na lib_Tasks.lua  

function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
      return FALSE
	end
local user = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
msg = string.lower(msg)

  if msgcontains(msg, 'task') then
    selfSay('Do you want a {new} task or want to {report} ? Feel free to {cancel} a task if you wish.', cid)
    state[user] = 1.1
  
  --elseif state[user] == 1.1 then
  elseif msgcontains(msg, 'new') then
    local avaiableStr = getAvaiableTasks(cid)
    if avaiableStr ~= "" then
      selfSay('Avaiable tasks for your level: ' .. avaiableStr .. ".", cid)
      state[user] = 2                                        
    else
      selfSay('Sorry but there is no tasks for you.', cid)
    end
      
  elseif msgcontains(msg, 'report') then
    local myTasks = getDoingTasks(cid)
    if myTasks ~= "" then
      selfSay("What task do you want to report? In progress: " .. myTasks .. ".", cid)
      state[user] = 3
    else
      selfSay("Sorry but you do not have any active task to finish.", cid)
    end
    
  elseif msgcontains(msg, 'cancel') then
    local myTasks = getDoingTasks(cid)
    if myTasks ~= "" then
      selfSay("What task do you want to cancel? In progress: " .. myTasks .. ".", cid)
      state[user] = 4
    else
      selfSay("Sorry but you do not have any active task to cancel.", cid)
    end    
  
  elseif state[user] == 2 then -- escolher a task ( fazer ainda )
    if TABLE_TASKS[msg] then
      local t = TABLE_TASKS[msg]
      
      if task.avaiable(cid, msg) then
        selfSay('In this task for level ' .. t.level .. ' you will need to kill ' .. t.count .. ' ' .. msg .. 's. Do you {accept} ?', cid)
        option[user] = msg -- nome da criatura 
        state[user] = 2.1
      else
        selfSay('Sorry, but this task is not avaiable.', cid)
      end
    else
      selfSay('Sorry, but this task is invalid.', cid)
    end
  
  elseif state[user] == 2.1 then
    if msgcontains(msg, 'yes') or msgcontains(msg, 'accept') then
      if option[user] then
        if task.doSaveSlot(cid, option[user]) then
          local t = TABLE_TASKS[ option[user] ]
          selfSay('Go kill all the ' .. t.count .. ' ' .. option[user] .. 's and come back here to take the prize.', cid)
          task.doStart(cid, option[user])
        else
          selfSay('You are already doing 1 tasks in the same time. Please cancel any before starting a new one.' , cid)
        end
      else
        selfSay('Something went wrong bro. ((x)_(x))', cid)
      end
      state[user] = 1
    else
      selfSay('Why not ?', cid)
      state[user] = 2
    end
  
  elseif state[user] == 3 then -- reportar
    if task.doing(cid, msg) then
      if task.killedNeededCount(cid, msg) then
        selfSay('You finished the ' .. msg .. ' task and earned ' .. TABLE_TASKS[msg].exp .. ' experience points.', cid)
        task.doComplete(cid, msg)
        state[user] = 1
      else
        selfSay('You need to kill ' .. TABLE_TASKS[msg].count .. ' ' .. msg .. 's, but you just killed ' .. task.kills(cid, msg) .. '.', cid)
      end
    else
      selfSay('You are not doing this task.', cid)
    end
  
  elseif state[user] == 4 then -- cancelar 
    if task.doing(cid, msg) then
      if task.killedNeededCount(cid, msg) then
        selfSay('You cannot cancel a task wich you killed all monsters.', cid)
      else
        selfSay('Are you sure you want to cancel ' .. msg .. ' task ? {yes} or {no}? Keep in mind that if you start it again, you will need to start it from zero counter.', cid)
        option[user] = msg
        state[user] = 4.1
      end
    else
      selfSay('You are not doing this task.', cid)
    end  
  
  elseif state[user] == 4.1 then -- cancelar task
    if msgcontains(msg, 'yes') then
      local t = TABLE_TASKS[ option[user] ] 
      selfSay(option[user] .. ' task cancelled...', cid)
      task.doCancel(cid, option[user])
    else
      selfSay('Then, not.', cid)
    end
    
    state[user] = 1
  else
    selfSay(WTF_MESSAGE, cid)
  end

return TRUE
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())