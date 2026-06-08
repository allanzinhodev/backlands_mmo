local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)                  npcHandler:onCreatureAppear(cid)                        end
function onCreatureDisappear(cid)               npcHandler:onCreatureDisappear(cid)                     end
function onCreatureSay(cid, type, msg)          npcHandler:onCreatureSay(cid, type, msg)                end
function onThink()                              npcHandler:onThink()                                    end

function creatureSayCallback(cid, type, msg)

 local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

        if(not npcHandler:isFocused(cid)) then
                return false
        end

	if isPremium(cid) == FALSE then
		return doPlayerSendCancel(cid, "Desculpe, eu posso levar apenas Ninjas VIP. Você não é premium account.")
	end
	
	if msgcontains (msg, 'yes') or msgcontains (msg, 'sim') then
		local pos = {x = 2583, y = 1906, z = 7}
		selfSay("Boa Aventura!", cid)
		doTeleportThing(cid, pos)
		return true
	end

	if msgcontains (msg, 'no') or msgcontains (msg, 'nao') then
		selfSay("Tudo bem, ate logo.", cid)
		return false
	end

return false
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())