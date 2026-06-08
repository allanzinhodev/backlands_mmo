-- Exame Chunin completo feito por Vitor Bertolucci.
-- Favor nao postar nem compartilhar este codigo.
-- Favor manter esses comentarios quando for utilizar o codigo.
-- 17/05/2014

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)				npcHandler:onCreatureAppear(cid) 			end
function onCreatureDisappear(cid) 			npcHandler:onCreatureDisappear(cid) 		end
function onCreatureSay(cid, type, msg) 		npcHandler:onCreatureSay(cid, type, msg) 	end
function onThink() 							npcHandler:onThink() 						end
function onPlayerEndTrade(cid)				npcHandler:onPlayerEndTrade(cid)			end
function onPlayerCloseChannel(cid)			npcHandler:onPlayerCloseChannel(cid)		end

    function creatureSayCallback(cid, type, msg)
        	if(not npcHandler:isFocused(cid)) then
            		return false
        	end                                               
                 
         local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

         if msgcontains(msg, "inscrever") then
            if getPlayerLevel(cid) < 20 then
               selfSay("So ninjas level 20+ podem se inscrever no exame", cid)
            else
             if getGlobalStorageValue(1821291) == 1 then
                 if getPlayerStorageValue(cid, initStorages.graduation) ~= "Chunnin" then
                    if getPlayerStorageValue(cid, 192191) == -1 then
                        selfSay("Obrigado por se inscrever! Aguarde o sorteio de equipes.", cid)
                        doPlayerSetStorageValue(cid, 192191, 1)
                    else
                        selfSay("Voce ja esta inscrito!", cid)
                    end
                    else
                        selfSay("Voce ja eh um Chunnin!", cid)
                    end
             else
                    selfSay("Ainda nao esta na hora de se inscrever!", cid)
             end
         end
        end
         return true
     end  
                     
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())