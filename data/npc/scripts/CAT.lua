--------------
--- Config ---
---------------- --
function randomMove(cid, n)
   if not isCreature(cid) or n == 0 then 
      return
   end
   local rand = math.random(NORTH, NORTHEAST)
   local pos = getThingPos(cid)
         pos = getPosByDir(pos, rand)
   
   if not isWalkable(pos, true, false, true, true) then
      randomMove(cid, n)
      return
   end
   doTeleportThing(cid, pos, true)
   addEvent(randomMove, 200, cid, n-1)
end



local storage = 855451

-- --
local questname = "catch"

-- NPC Messages --
local npc_message ={

"MEOWWWWWW!!!",
"MEOWWWW!!!", 
"MEOWWWW!!!",
"MEOWWWW!!!",
"MEOWWW!! {catch}"
}

-------------------
--- End Confing --- 
-------------------

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function creatureSayCallback(cid, type, msg)
if(not npcHandler:isFocused(cid)) then
return false
end
local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

if(msgcontains(msg, 'missao')) then
selfSay(npc_message[5], cid)
end

if(msgcontains(msg, questname)) then
selfSay(npc_message[1], cid)
talkState[talkUser] = 1
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 1) then

if (getPlayerStorageValue(cid,storage) > 0) then
selfSay(npc_message[4], cid)
else

if getPlayerStorageValue(cid, 855451) < 1 then 
setPlayerStorageValue(cid,storage, 1)
actionMove(cid, 568, 2000)
addEvent(doCreateNpc, 5000, 'Cat', getThingPos(getNpcId()))
doRemoveCreature(getNpcId(), true)
doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce pegou o gato da Madame Shijimi.")
randomMove(cid, 10)
doSendMagicEffect(getCreaturePosition(cid), 10)
else
selfSay(npc_message[2], cid)
end
end
return true
end
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())