local ITEM = 12655 -- Item a ser Removido , dado pelo primeiro NPC
local QUANT = 1 -- Quantidade de item a ser removido dado pelo primeiro npc
local PREMIO = 2148 -- Premio do NPC
local PQUANT = 70 -- Quantidade de premio


local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)


function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function takeshimissionNPC(cid, message, keywords, parameters, node)
if(not npcHandler:isFocused(cid)) then
return false
end
if (parameters.present == true) then
if getPlayerStorageValue(cid,sto_missao[1]) == 7 and getPlayerItemCount(cid,ITEM) >= 1 then
doPlayerRemoveItem(cid,ITEM,QUANT)
doPlayerAddItem(cid,PREMIO,PQUANT)
doPlayerAddExp(cid,3000)
setPlayerStorageValue(cid, sto_missao[2], getPlayerStorageValue(cid, sto_missao[2])+1)
setPlayerStorageValue(cid, sto_missao[1], 8)
setPlayerStorageValue(cid, sto_missao[7], os.time() + 1*60*60*24)
npcHandler:say('Obrigado, me sinto melhor agora sei que da onde ele esta tambem ficara feliz', cid)
elseif getPlayerStorageValue(cid,sto_missao[1]) >= 8 then
npcHandler:say('Voce ja completou essa missao.', cid)
elseif getPlayerStorageValue(cid,sto_missao[1]) < 7 then
npcHandler:say('Acho que voce nao tem nada para mim', cid)
elseif getPlayerItemCount(cid,ITEM) <= 0 then
npcHandler:say('Voce nao tem nada para mim', cid)
end
end
npcHandler:resetNpc()
return true
end

npcHandler:setMessage(MESSAGE_GREET, "Ola |PLAYERNAME|. Estou muito triste com a morte de meu filho, ele foi um grande ninja lutou ate o fim para ajudar a vila.")

local noNode = KeywordNode:new({'no'}, takeshimissionNPC, {present = false})
local yesNode = KeywordNode:new({'yes'}, takeshimissionNPC, {present = true})

local node = keywordHandler:addKeyword({'missao'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Voce tem algo para me confortar?'})
node:addChildKeywordNode(yesNode)
node:addChildKeywordNode(noNode)
npcHandler:addModule(FocusModule:new())