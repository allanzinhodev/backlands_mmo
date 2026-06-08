---------------------------------
------- NPC Missão 1.0 ---------
--- by Fox - xtibia.com/forum ---
---------------------------------

--------------
--- Config ---
--------------
-- item necessário para fazer a busca
local i_required = 2677

-- contagem de item necessário para fazer a busca
local i_required_count = 300

-- recompensa padrão id item (crystal coins)
local i_reward = 2148

-- contagem de recompensa id padrão (10)
local i_reward_count = 200

-- --
local storage = 60307

-- --
local questname = "blueberry quest"

-- NPC Messages --
local npc_message ={

"Eu preciso que voce pegue 300 blueberry, voce ja tem as 300 blueberry's?",
"Voce nao tem os items necessarios.", 
"Obrigado por me ajudar, {pegue isso.}",
"Voce ja me ajudou.",
"A Missao {" .. questname .. "} e, realmente serio, eu preciso de sua ajuda para completa-la, se voce me ajudar eu posso dar alguns itens para voce?"
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

if(doPlayerRemoveItem(cid,i_required,i_required_count)) then
setPlayerStorageValue(cid,storage,1)
doPlayerAddItem(cid,i_reward,i_reward_count)
selfSay(npc_message[3], cid)
doSendMagicEffect(getCreaturePosition(cid), 10)
doCreatureSay(cid, "Missao Completada!", TALKTYPE_ORANGE_1)
doPlayerAddExp(cid, 15000)
else
selfSay(npc_message[2], cid)
end
end
return true
end
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())