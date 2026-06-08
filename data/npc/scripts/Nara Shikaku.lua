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
	if getPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA6) <= 0 then
		setPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA, getPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA) + 1)
		selfSay("Muito obrigado.")
		setPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA6, 1)
	else
		selfSay("Já recebi seu recado, tchau.")
		removeFocus(cid) 
	end
	elseif((isFocused(cid)) and (msg == "Jutsu" or msg == "jutsu")) then
		if not isInArray({6}, getPlayerVocation(cid)) then
        	return selfSay("Nao posso te ensinar nada.", cid)
    	end
		selfSay("I can teach you some Jutsu", cid)
		selfSay("{Kagemane no Jutsu} level 5 , {Kage Kubi Shibari} level 10, {Duplicate Kagemane} level 20, {Kage Nui} level 25, {Kagemane Shuriken No Jutsu} level 35, {Triplicate Kagemane} level 45, {Kageyose} level 50", cid)
	elseif(msgcontains(msg, "Kagemane no Jutsu" or msg == "kagemane no jutsu")) then
		if getPlayerLevel(cid) < 5 then
        selfSay("You need to be atleast level 5", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13426) == 1) then
		local item = getPlayerItemById(cid, true, 13426)
		local item2 = getPlayerItemById(cid, true, 13449)
				doTransformItem(item.uid, 12868)
				doTransformItem(item2.uid, 12225)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Kagemane no Jutsu) Menu -> Jutsus -> Nara Jutsu -> Kagemane")
				selfSay('you learned Kagemane no Jutsu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	elseif(msgcontains(msg, 'Kage Kubi Shibari' or msg == "kage kubi shibari")) then
		if getPlayerLevel(cid) < 10 then
        selfSay("You need to be atleast level 10", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13428) == 1) then
		local item = getPlayerItemById(cid, true, 13428)
				doTransformItem(item.uid, 12875)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Kubi Shibari) Menu->Jutsus->Nara Jutsu")
				selfSay('you learned Kage Kubi Shibari no Jutsu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	elseif(msgcontains(msg, 'Duplicate Kagemane' or msg == "duplicate kagemane")) then
		if getPlayerLevel(cid) < 20 then
        selfSay("You need to be atleast level 20", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13429) == 1) then
		local item = getPlayerItemById(cid, true, 13429)
				doTransformItem(item.uid, 12871)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Duplicate Kagemane) Menu -> Jutsus -> Nara Jutsu -> Kagemane")
				selfSay('you learned Duplicate Kagemane no Jutsu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
		elseif(msgcontains(msg, 'Kage Nui' or msg == "kage nui")) then
		if getPlayerLevel(cid) < 25 then
        selfSay("You need to be atleast level 25", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13430) == 1) then
		local item = getPlayerItemById(cid, true, 13430)
				doTransformItem(item.uid, 12870)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Kage Nui) Menu -> Jutsus -> Nara Jutsu")
				selfSay('you learned Kage Nui', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
		elseif(msgcontains(msg, 'Kagemane Shuriken No Jutsu' or msg == "kagemane shuriken no jutsu")) then
		if getPlayerLevel(cid) < 35 then
        selfSay("You need to be atleast level 35", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13431) == 1) then
		local item = getPlayerItemById(cid, true, 13431)
				doTransformItem(item.uid, 12872)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Kagemane Shuriken No Jutsu) Menu -> Jutsus -> Nara Jutsu")
				selfSay('you learned Kagemane Shuriken No Jutsu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
		elseif(msgcontains(msg, 'Triplicate Kagemane' or msg == "triplicate kagemane")) then
		if getPlayerLevel(cid) < 45 then
        selfSay("You need to be atleast level 45", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13432) == 1) then
		local item = getPlayerItemById(cid, true, 13432)
				doTransformItem(item.uid, 12873)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Triplicate Kagemane) Menu -> Jutsus -> Nara Jutsu -> Kagemane")
				selfSay('you learned Triplicate Kagemane no Jutsu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
		elseif(msgcontains(msg, 'Kage Nui' or msg == "kage nui")) then
		if getPlayerLevel(cid) < 25 then
        selfSay("You need to be atleast level 25", cid)
		return true
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