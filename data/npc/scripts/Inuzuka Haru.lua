
local STORAGE = 100010 -- Não Mecha
local ITEM = 11879 -- Item a ser Removido , dado pelo primeiro NPC
local QUANT = 1 -- Quantidade de item a ser removido dado pelo primeiro npc
local PREMIO = 2148 -- Premio do NPC
local PQUANT = 40 -- Quantidade de premio


local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)


function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function santaNPC(cid, message, keywords, parameters, node)
if(not npcHandler:isFocused(cid)) then
return false
end
if (parameters.present == true) then
if getPlayerStorageValue(cid,sto_missao[1]) == 1 and getPlayerItemCount(cid,ITEM) >= 1 then
doPlayerRemoveItem(cid,ITEM,QUANT)
doPlayerAddItem(cid,PREMIO,PQUANT)
doPlayerAddExp(cid,400)
setPlayerStorageValue(cid, sto_missao[2], getPlayerStorageValue(cid,sto_missao[2]) + 1)
setPlayerStorageValue(cid, sto_missao[1], 2)
setPlayerStorageValue(cid, sto_missao[7], os.time() + 1*60*60*24)
doSendPlayerExtendedOpcode(cid, 108, {x = 2576, y = 1819, z = 7,})
npcHandler:say('Obrigado', cid)
elseif getPlayerStorageValue(cid,sto_missao[1]) >= 2 then
npcHandler:say('Voce ja completou essa missao.', cid)
elseif getPlayerStorageValue(cid,sto_missao[1]) < 1 then
npcHandler:say('Acho que voce nao tem nada para mim', cid)
elseif getPlayerItemCount(cid,ITEM) <= 0 then
npcHandler:say('Voce nao tem nada para mim', cid)
end
end
npcHandler:resetNpc()
return true
end

local function reviveNPC(cid, message, keywords, parameters, node)
if(not npcHandler:isFocused(cid)) then
return false
end
if not isInArray({2}, getPlayerVocation(cid)) then
        return selfSay("Voce nao tem um pet.", cid)
end
if (parameters.present == true) then
if getPlayerItemCount(cid,2148) >= 10 then
doPlayerRemoveItem(cid,2148,10)
setPlayerStorageValue(cid,  petStorages.isDead, 0)
npcHandler:say('Obrigado o seu Pet esta vivo.', cid)
elseif getPlayerItemCount(cid,2148) < 10 then
npcHandler:say('Voce nao tem dinheiro suficiente.', cid)
end
end
npcHandler:resetNpc()
return true
end

npcHandler:setMessage(MESSAGE_GREET, "Ola |PLAYERNAME|. Tem algo para me entregar ou veio {reviver} seu Pet por 10 Yen ? ")

local noNode = KeywordNode:new({'no'}, santaNPC, {present = false})
local yesNode = KeywordNode:new({'yes'}, santaNPC, {present = true})
local noNodes = KeywordNode:new({'no'}, reviveNPC, {present = false})
local yesNodes = KeywordNode:new({'yes'}, reviveNPC, {present = true})

local node = keywordHandler:addKeyword({'missao'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Voce trouxe o pergaminho?'})
local nodes = keywordHandler:addKeyword({'reviver'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Voce quer reviver seu Pet?'})
node:addChildKeywordNode(yesNode)
node:addChildKeywordNode(noNode)
nodes:addChildKeywordNode(yesNodes)
nodes:addChildKeywordNode(noNodes)
npcHandler:addModule(FocusModule:new())