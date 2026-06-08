---------------------------------
------- NPC Missão 1.0 ---------
--- by Fox - xtibia.com/forum ---
---------------------------------

--------------
--- Config ---
--------------
-- item necessário para fazer a busca
local i_required = 13012

-- contagem de item necessário para fazer a busca
local i_required_count = 10

-- recompensa padrão id item (crystal coins)
local i_reward = 12691

-- contagem de recompensa id padrão (10)
local i_reward_count = 1

-- --
local storage = 665456777

-- --
local questname = "broken kunai"

-- NPC Messages --
local npc_message = {
"Entao vamos começar, preciso que voce va ate a floresta e procure por um grupo de  bandidos chamados Hizuko, eles vivem atacando pessoas inocente, eles possuem um grande  arsenal de Kunais, derrote alguns deles e traga 10 Kunais quebradas para mim.  ",
"Voce não achou meu gato.", 
"Obrigado por ajudar um velho como eu, forgei esta arma para voce, tome.",
"Voce ja me ajudou.",
"Ha hoje em dia algumas lendas passadas sao esquecidas, me chamo Itsumo o grande  mestre das armas, ja criei varios tipos de armas para diferentes tipos de guerreiros, ja lutei  contra varios oponente, mas chega uma hora que infelizmente precisamos nos Aposentar, hoje  em dia coleto {broken kunai}, para derreter seu metal, fazendo novas armas  muito mais fortes, voce pode me ajudar ?",
"Desculpa voce nao pode me ajudar agora."
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

if (getPlayerStorageValue(cid,sto_missao[1]) < 8) then
selfSay(npc_message[6], cid)
else

if(msgcontains(msg, 'missao')) then
selfSay(npc_message[5], cid)
end

if(msgcontains(msg, 'questname')) then
selfSay(npc_message[1], cid)
talkState[talkUser] = 1
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 1) then

if (getPlayerStorageValue(cid,storage) > 0) then
selfSay(npc_message[4], cid)
else

if getPlayerStorageValue(cid, sto_missao[1]) == 8 then 
setPlayerStorageValue(cid,storage, 1)
setPlayerStorageValue(cid, sto_missao[1], 9)
doPlayerAddItem(cid,i_reward,i_reward_count)
selfSay(npc_message[3], cid)
doPlayerAddExp(cid, 5500)
else
selfSay(npc_message[2], cid)
end
end
return true
end
end
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())