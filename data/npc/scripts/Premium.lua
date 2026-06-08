days = 30
vipcoins = 13324
quant = 10


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
if isPlayer(cid) then
if getPlayerItemCount(cid,vipcoins) >= quant then
doPlayerAddPremiumDays(cid,days)
doPlayerRemoveItem(cid,vipcoins,quant)
npcHandler:say('Thank you received 30 days vip', cid)
else
npcHandler:say('You do not have 10 shinobi coin(s)', cid)
end
end
npcHandler:resetNpc()
return true
end
end
npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|. I Sell {Premium} Days.")


local noNode = KeywordNode:new({'no'}, santaNPC, {present = false})
local yesNode = KeywordNode:new({'yes'}, santaNPC, {present = true})


local node = keywordHandler:addKeyword({'premium'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to buy 30 days of Premium on 10 shinobi coins?'})
node:addChildKeywordNode(yesNode)
node:addChildKeywordNode(noNode)
npcHandler:addModule(FocusModule:new())