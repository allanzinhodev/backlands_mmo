local ITEM = 2677 -- Item a ser Removido , dado pelo primeiro NPC
local QUANT = 150 -- Quantidade de item a ser removido dado pelo primeiro npc
local PREMIO = 2148 -- Premio do NPC
local PQUANT = 130 -- Quantidade de premio


local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)


function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function medicmissionNPC(cid, message, keywords, parameters, node)
if(not npcHandler:isFocused(cid)) then
return false
end
if (parameters.present == true) then
if getPlayerStorageValue(cid,sto_missao[1]) == 4 and getPlayerItemCount(cid,ITEM) >= 150 then
doPlayerRemoveItem(cid,ITEM,QUANT)
doPlayerAddItem(cid,PREMIO,PQUANT)
doPlayerAddExp(cid,1200)
setPlayerStorageValue(cid, sto_missao[2], getPlayerStorageValue(cid, sto_missao[2])+1)
setPlayerStorageValue(cid, sto_missao[1], 5)
setPlayerStorageValue(cid, sto_missao[7], os.time() + 1*60*60*24)
npcHandler:say('Obrigado', cid)
elseif getPlayerStorageValue(cid,sto_missao[1]) >= 5 then
npcHandler:say('Voce ja completou essa missao.', cid)
elseif getPlayerStorageValue(cid,sto_missao[1]) < 4 then
npcHandler:say('Acho que voce nao tem nada para mim', cid)
elseif getPlayerItemCount(cid,ITEM) <= 0 then
npcHandler:say('Voce nao tem nada para mim', cid)
end
end
npcHandler:resetNpc()
return true
end

npcHandler:setMessage(MESSAGE_GREET, "Ola |PLAYERNAME|. Tem algo para me entregar ?")

local noNode = KeywordNode:new({'no'}, medicmissionNPC, {present = false})
local yesNode = KeywordNode:new({'yes'}, medicmissionNPC, {present = true})

local node = keywordHandler:addKeyword({'missao'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Voce trouxe oque eu preciso?'})
node:addChildKeywordNode(yesNode)
node:addChildKeywordNode(noNode)
npcHandler:addModule(FocusModule:new())