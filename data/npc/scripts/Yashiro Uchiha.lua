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
		selfSay("Olá "..getPlayerName(cid).." oque te traz aqui ? [{jutsu} , {missao}]", cid)
	elseif((msg == "missao" or msg == "Missao") and (isFocused(cid))) then
	if getPlayerStorageValue(cid, sto_missao[8]) == 1 then
		selfSay("Você veio me entregar um aviso importante ?")
	else
		selfSay("Acho que você não tem nada para mim agora.")
	end
	elseif((msg == "yes" or msg =="sim") and (isFocused(cid))) then
	if getPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA5) <= 0 then
		setPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA, getPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA) + 1)
		selfSay("Muito obrigado.")
		setPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA5, 1)
	else
		selfSay("Já recebi seu recado, tchau.")
		removeFocus(cid)
	end 
	elseif((msg == "jutsu" or msg == "Jutsu") and (isFocused(cid))) then
	 	if not isInArray({5}, getPlayerVocation(cid)) then
        	return selfSay("Nao posso te ensinar nada.", cid)
    	end
		selfSay("I can teach you some jutsus", cid)
		selfSay("{Katon Endan} level 5 , {Katon Goukakyuu} level 10, {Katon Housenka} level 15, {Katon Shiruko} level 25, {Katon Karyuudan} level 35, {Katon Ryuuka} level 45, {Katon Gouryuuka} level 50, {Katon Karyuu Endan} level 55", cid)
	elseif(msgcontains(msg, "Katon Endan" or msg == "katon endan")) then
		if getPlayerLevel(cid) < 5 then
        selfSay("You need to be atleast level 5", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13327) == 1) then
		local item = getPlayerItemById(cid, true, 13327)
				doTransformItem(item.uid, 11422)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Endan no Jutsu) Menu->Jutsus->Ninjutsu->Katon")
				selfSay('you learned Katon Endan no Jutsu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	elseif(msgcontains(msg, 'Katon Goukakyuu' or msg == "katon goukakyuu")) then
		if getPlayerLevel(cid) < 10 then
        selfSay("You need to be atleast level 10", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13328) == 1) then
		local item = getPlayerItemById(cid, true, 13328)
				doTransformItem(item.uid, 11423)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Goukakyuu no Jutsu) Menu->Jutsus->Ninjutsu->Katon")
				selfSay('you learned Katon Goukakyuu No Jutsu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end

	elseif(msgcontains(msg, "Katon Housenka" or msg == "katon housenka")) then
		if getPlayerLevel(cid) < 15 then
        selfSay("You need to be atleast level 15", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13329) == 1) then
		local item = getPlayerItemById(cid, true, 13329)
				doTransformItem(item.uid, 11424)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Housenka no Jutsu) Menu->Jutsus->Ninjutsu->Katon")
				selfSay('you learned Katon Housenka No Jutsu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
			
				elseif(msgcontains(msg, "Katon Shiruko" or msg == "katon shiruko")) then
		if getPlayerLevel(cid) < 25 then
        selfSay("You need to be atleast level 25", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13330) == 1) then
		local item = getPlayerItemById(cid, true, 13330)
				doTransformItem(item.uid, 11425)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Shiruko no Jutsu) Menu->Jutsus->Ninjutsu->Katon")
				selfSay('you learned Katon Shiruko No Jutsu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	
     	elseif(msgcontains(msg, "Katon Karyuudan" or msg == "katon karyuudan")) then
		if getPlayerLevel(cid) < 35 then
        selfSay("You need to be atleast level 35", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13331) == 1) then
		local item = getPlayerItemById(cid, true, 13331)
				doTransformItem(item.uid, 11426)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Karyuudan no Jutsu) Menu->Jutsus->Ninjutsu->Katon")
				selfSay('you learned Katon Karyuudan No Jutsu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
			
			 	elseif(msgcontains(msg, "Katon Ryuuka" or msg == "katon ryuuka")) then
		if getPlayerLevel(cid) < 45 then
        selfSay("You need to be atleast level 45", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13332) == 1) then
		local item = getPlayerItemById(cid, true, 13332)
				doTransformItem(item.uid, 11456)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Ryuuka no Jutsu) Menu->Jutsus->Ninjutsu->Katon")
				selfSay('you learned Katon Ryuuka No Jutsu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
			
					 	elseif(msgcontains(msg, "Katon Gouryuuka" or msg == "katon gouryuuka")) then
		if getPlayerLevel(cid) < 50 then
        selfSay("You need to be atleast level 50", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13333) == 1) then
		local item = getPlayerItemById(cid, true, 13333)
				doTransformItem(item.uid, 11457)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Gouryuuka no Jutsu) Menu->Jutsus->Ninjutsu->Katon")
				selfSay('you learned Katon Gouryuuka No Jutsu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
					elseif(msgcontains(msg, "Katon Karyuu Endan" or msg == "katon karyuu endan")) then
		if getPlayerLevel(cid) < 55 then
        selfSay("You need to be atleast level 55", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13334) == 1) then
		local item = getPlayerItemById(cid, true, 13334)
				doTransformItem(item.uid, 11458)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Karyuu Endan no Jutsu) Menu->Jutsus->Ninjutsu->Katon")
				selfSay('you learned Katon Karyuu No Jutsu', cid)
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