local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local TopicState = {}

-- OTServ event handling functions start
function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg) end
function onPlayerEndTrade(cid)              npcHandler:onPlayerEndTrade(cid) end
function onPlayerCloseChannel(cid)          npcHandler:onPlayerCloseChannel(cid) end
function onThink()                          npcHandler:onThink() end
-- OTServ event handling functions end



function creatureSayCallback(cid, type, msg)

	if (msgcontains(msg, "hello") or msgcontains(msg, "hi")) and (not npcHandler:isFocused(cid)) then
		npcHandler:say("Ola jovem ninja, como posso ajuda-lo? {bounty}", cid)
		npcHandler:addFocus(cid)
		TopicState[cid] = 0

	elseif(not npcHandler:isFocused(cid)) then
		return false

	elseif msgcontains(msg, "bye") or msgcontains(msg, "farewell") then
		npcHandler:say("Good Bye!", cid, TRUE)
		npcHandler:releaseFocus(cid)

	elseif msgcontains(msg, "bounty") and TopicState[cid] == 0 then
        if(getPlayerStorageValue(cid, 8877) == 0) then
		    npcHandler:say("O Livro Bingo e cheio de criminosos! Voce gostaria de me trazer a cabeça de alguns ou cancelar alguma caçada {cancel}?", cid)
		    TopicState[cid] = 1
        elseif(getPlayerStorageValue(cid, 8877) == 1) then
            npcHandler:say("Voce ainda esta caçando um crimial, volte quando tiver acabado com ele!", cid)
		    npcHandler:releaseFocus(cid)
        elseif(getPlayerStorageValue(cid, 8877) == 2) then
            prize = getPlayerStorageValue(cid, 8876)
            npcHandler:say("Ooh, voce me trouxe a sua cabeça, Obrigado! Aqui esta sua recompensa!", cid)
            doPlayerAddMoney(cid,prize)
            setPlayerStorageValue(cid, 8877, 0)
		    npcHandler:releaseFocus(cid)
        end

	elseif msgcontains(msg, "cancel") and TopicState[cid] == 0 then
        if(getPlayerStorageValue(cid, 8877) == 1) then
            npcHandler:say("Ok, eu estou decepcionado com voce. Mas se voce mudar de ideia venha a mim!", cid)
            setPlayerStorageValue(cid, 8877, 0)
            setPlayerStorageValue(cid, 8876, 0)
            npcHandler:releaseFocus(cid)
        else
            npcHandler:say("Voce nao esta caçando nenhum jogador!", cid)
            npcHandler:releaseFocus(cid)
        end
		
    elseif msgcontains(msg, "yes") or msgcontains(msg, "YES") and TopicState[cid] == 1 then
		npcHandler:say("Ok, nos vemos depois ...", cid)
		local result_search = db.getResult("SELECT * FROM `bounty_hunters` WHERE id >= (SELECT FLOOR( MAX(id) * RAND()) FROM `bounty_hunters` ) ORDER BY id LIMIT 1;")
		while(result_search:getDataInt("sp_id") == getPlayerGUID(cid)) do
            result_search = db.getResult("SELECT * FROM `bounty_hunters` WHERE id >= (SELECT FLOOR( MAX(id) * RAND()) FROM `bounty_hunters` ) ORDER BY id LIMIT 1;")
        end
		tName = getPlayerNameByGUID(result_search:getDataInt("sp_id"))
		tPrize = tonumber(result_search:getDataInt("prize"))
		setPlayerStorageValue(cid, 8877, 1)
		setPlayerStorageValue(cid, 8875, result_search:getDataInt("sp_id"))
        doPlayerPopupFYI(cid, "Information about the criminal:\n\nName: "..tName.."\nReward: "..tPrize.." golds\n\nBring his head as soon as possible!")
        npcHandler:releaseFocus(cid)
        
	end

	return true

end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_WALKAWAY, "Do not leave me talking alone!")
npcHandler:setMessage(MESSAGE_IDLETIMEOUT, "Ah, ok then!")