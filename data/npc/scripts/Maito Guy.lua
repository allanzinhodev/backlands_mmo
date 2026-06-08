local focuses = {}
local function isFocused(cid)
	for i, v in pairs(focuses) do
		if(v == cid) then
			return true
		end
	end
	return false
end

local function addFocus(cid)
	if(not isFocused(cid)) then
		table.insert(focuses, cid)
	end
end
local function removeFocus(cid)
	for i, v in pairs(focuses) do
		if(v == cid) then
			table.remove(focuses, i)
			break
		end
	end
end
local function lookAtFocus()
	for i, v in pairs(focuses) do
		if(isPlayer(v)) then
			doNpcSetCreatureFocus(v)
			return
		end
	end
	doNpcSetCreatureFocus(0)
end


function onCreatureAppear(cid)
end

function onCreatureDisappear(cid)
	if(isFocused(cid)) then
		selfSay("Hmph!")
		removeFocus(cid)
		if(isPlayer(cid)) then --Be sure he's online
			closeShopWindow(cid)
		end
	end
end

function onCreatureSay(cid, type, msg)
	if getPlayerStorageValue(cid, initStorages.graduation) == "Academy Student" then
	return selfSay("Va estudar para se tornar um ninja e volte aqui depois.", cid)
	end
	if((msg == "hi") and not (isFocused(cid))) then
		addFocus(cid)
		selfSay("Olá "..getPlayerName(cid).." oque te traz aqui ? [{taijutsu} , {missao}]", cid)
	elseif((msg == "missao" or msg == "Missao") and (isFocused(cid))) then
	if getPlayerStorageValue(cid, sto_missao[8]) == 1 then
		selfSay("Você veio me entregar um aviso importante ?")
	else
		selfSay("Acho que você não tem nada para mim agora.")
	end
	elseif((msg == "yes" or msg =="sim") and (isFocused(cid))) then
	if getPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA1) <= 0 then
		setPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA, getPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA) + 1)
		selfSay("Muito obrigado.")
		setPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA1, 1)
	else
		selfSay("Já recebi seu recado, tchau.")
		removeFocus(cid)
	end 
	elseif((isFocused(cid)) and (msg == "taijutsu" or msg == "Taijutsu")) then
		 if not isInArray({1}, getPlayerVocation(cid)) then
        	return selfSay("Nao posso te ensinar nada.", cid)
    	end
		selfSay("I can teach you some Taijutsu", cid)
		selfSay("{Konoha Senpuu} level 5 , {Dynamic Entry} level 10, {Hachimon Tonkou} level 15, {Omote Renge} level 35, {Konoha Dai Senpuu} level 45 , {Konoha Gouriki Senpuu} level 50", cid)
	elseif(msgcontains(msg, "Konoha Senpuu" or msg == "konoha senpuu")) then
		if getPlayerLevel(cid) < 5 then
        selfSay("You need to be atleast level 5", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13350) == 1) then
		local item = getPlayerItemById(cid, true, 13350)
				doTransformItem(item.uid, 11482)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You have learned a new taijutsu! (Konoha Senpuu) Menu->Jutsus->Maito Jutsu")
				selfSay('you learned Konoha Senpuu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	elseif(msgcontains(msg, 'Dynamic Entry' or msg == "dynamic Entry")) then
		if getPlayerLevel(cid) < 10 then
        selfSay("You need to be atleast level 10", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13351) == 1) then
		local item = getPlayerItemById(cid, true, 13351)
				doTransformItem(item.uid, 11483)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You have learned a new taijutsu! (Dynamic Entry) Menu->Jutsus->Maito Jutsu")
				selfSay('you learned Dynamic Entry', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end

	elseif(msgcontains(msg, "Hachimon Tonkou" or msg == "hachimon tonkou")) then
		if getPlayerLevel(cid) < 15 then
        selfSay("You need to be atleast level 15", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13356) == 1) then
		local item = getPlayerItemById(cid, true, 13356)
				doTransformItem(item.uid, 11485)
								doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You have learned a new taijutsu! (Kaimon) Menu->Jutsus->Maito Jutsu->Hachimon Tonkou")
				selfSay('you learned Hachimon Tonkou', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	elseif(msgcontains(msg, "Omote Renge" or msg == "omote renge")) then
		if getPlayerLevel(cid) < 35 then
        selfSay("You need to be atleast level 35", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13354) == 1) then
		local item = getPlayerItemById(cid, true, 13354)
				doTransformItem(item.uid, 11493)
								doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You have learned a new taijutsu! (Omote Renge) Menu->Jutsus->Maito Jutsu")
				selfSay('you learned Omote Renge', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
     	elseif(msgcontains(msg, "Konoha Dai Senpuu" or msg == "konoha dai senpuu")) then
		if getPlayerLevel(cid) < 45 then
        selfSay("You need to be atleast level 45", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13352) == 1) then
		local item = getPlayerItemById(cid, true, 13352)
				doTransformItem(item.uid, 12370)
								doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You have learned a new taijutsu! (Konoha Dai Senpuu) Menu->Jutsus->Maito Jutsu")
				selfSay('you learned Konoha Dai Senpuu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
			
			 	elseif(msgcontains(msg, "Konoha Gouriki Senpuu" or msg == "konoha gouriki senpuu")) then
		if getPlayerLevel(cid) < 50 then
        selfSay("You need to be atleast level 50", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13353) == 1) then
		local item = getPlayerItemById(cid, true, 13353)
				doTransformItem(item.uid, 13439)
								doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You have learned a new taijutsu! (Konoha Gouriki) Menu->Jutsus->Maito Jutsu")
				selfSay('you learned Konoha Gouriki Senpuu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	elseif((isFocused(cid)) and (msg == "bye" or msg == "goodbye" or msg == "cya")) then
		selfSay("Goodbye!", cid, true)
		removeFocus(cid)
	end
end


function onPlayerCloseChannel(cid)
	if(isFocused(cid)) then
		selfSay("Hmph!")
		closeShopWindow(cid)
		removeFocus(cid)
	end
end


function onThink()
	for i, focus in pairs(focuses) do
		if(not isCreature(focus)) then
			removeFocus(focus)
		else
			local distance = getDistanceTo(focus) or -1
			if((distance > 4) or (distance == -1)) then
				selfSay("Hmph!")
				closeShopWindow(focus)
				removeFocus(focus)
			end
		end
	end
	lookAtFocus()
end