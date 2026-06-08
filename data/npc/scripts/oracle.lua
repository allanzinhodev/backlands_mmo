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

local talkUser = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid

if(msgcontains(msg, 'yes') or msgcontains(msg, 'fire')) then
selfSay('We get good training, but first you must bring me a {eternal flames}', cid)
talkState[talkUser] = 1
if(msgcontains(msg, 'yes') and talkState[talkUser] == 1) then
if(getPlayerItemCount(cid, 8304) >= 1) then
doPlayerRemoveItem(cid, 8304, 1)
doPlayerSetVocation(cid, 1)
selfSay('Congratulations you are now a mage fire element', cid)
else
selfSay('You have not brought me the item needed', cid)
end
talkState[talkUser] = 0
end
end
return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())