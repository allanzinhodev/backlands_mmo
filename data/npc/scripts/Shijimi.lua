---------------------------------
------- NPC Missão 1.0 ---------
--- by Fox - xtibia.com/forum ---
---------------------------------

--------------
--- Config ---
--------------
-- item necessário para fazer a busca
local i_required = 11525

-- contagem de item necessário para fazer a busca
local i_required_count = 1

-- recompensa padrão id item (crystal coins)
local i_reward = 2152

-- contagem de recompensa id padrão (10)
local i_reward_count = 3

-- --
local storage = 60374154

-- --
local questname = "gato"

-- NPC Messages --
local npc_message ={

"Eu preciso que voce ache o meu gato, voce vai procura-lo?",
"Voce não achou meu gato.", 
"YOOOOO OBRIGADO!!!, agora estou feliz por voce ser uma boa pessoa te darei uns trocados, {pegue isso.}",
"Voce ja me ajudou.",
"OH MEU JOVEM, estou muito triste o meu {GATO} fugiu de novo\nvoce poderia procurar ele por mim ?"
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

if getPlayerStorageValue(cid, 855451) == 1 then 
setPlayerStorageValue(cid,storage,1)
doPlayerAddItem(cid,i_reward,i_reward_count)
selfSay(npc_message[3], cid)
doSendMagicEffect(getCreaturePosition(cid), 10)
doCreatureSay(cid, "Missao Completada!", TALKTYPE_ORANGE_1)
doPlayerAddExp(cid, 3500)
else
selfSay(npc_message[2], cid)
end
end
return true
end
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())