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
	if getPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA3) <= 0 then
		setPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA, getPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA) + 1)
		selfSay("Muito obrigado.")
		setPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA3, 1)
	else
		selfSay("Já recebi seu recado, tchau.")
		removeFocus(cid)
	end 
	elseif((isFocused(cid)) and (msg == "jutsu" or msg == "Jutsu")) then
	 	if not isInArray({3}, getPlayerVocation(cid)) then
        	return selfSay("Nao posso te ensinar nada.", cid)
    	end
		selfSay("I can teach you some jutsus", cid)
		selfSay("{Kikkaichu Bashira} level 5, {Kikkaichu no Jutsu} level 10, {Mushi Bunshin} level 15, {Kikkaichu Yajiri} level 20, {Kikkaichu Mushikame} level 25, {Kikkaichu Tsumoji} level 35, {Kikkaichu Arare} level 45, {Kikkaichu Mushidama} level 50" , cid)
	elseif(msgcontains(msg, 'Kikkaichu Bashira' or msg == "kikkaichu bashira")) then
		if getPlayerLevel(cid) < 5 then
        selfSay("You need to be atleast level 5", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13383) == 1) then
		local item = getPlayerItemById(cid, true, 13383)
				doTransformItem(item.uid, 11454)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Kikkaichu Bashira) Menu->Jutsus->Aburame Jutsus")
				selfSay('you learned Kikkaichu Bashira', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	elseif(msgcontains(msg, "Kikkaichu no Jutsu" or msg == "kikkaichu no jutsu")) then
		if getPlayerLevel(cid) < 10 then
        selfSay("You need to be atleast level 10", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13390) == 1) then
		local item = getPlayerItemById(cid, true, 13390)
		local item1 = getPlayerItemById(cid, true, 13391)
		local item2 = getPlayerItemById(cid, true, 13392)
				doTransformItem(item.uid, 11452)
				doTransformItem(item1.uid, 11453)
				doTransformItem(item2.uid, 11451)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Kikkaichu no Jutsu) Menu->Jutsus->Aburame Jutsus -> Kikkaichu Jutsu")
				selfSay('you learned Kikkaichu no Jutsu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	elseif(msgcontains(msg, "Mushi Bunshin" or msg == "mushi bunshin")) then
		if getPlayerLevel(cid) < 15 then
        selfSay("You need to be atleast level 15", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13384) == 1) then
		local item = getPlayerItemById(cid, true, 13384)
				doTransformItem(item.uid, 12722)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Kikkaichu Mushi Bunshin) Menu->Jutsus->Aburame Jutsus")
				selfSay('you learned Mushi Bunshin No Jutsu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
			
				elseif(msgcontains(msg, "Kikkaichu Yajiri" or msg == "kikkaichu yajiri")) then
		if getPlayerLevel(cid) < 20 then
        selfSay("You need to be atleast level 20", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13385) == 1) then
		local item = getPlayerItemById(cid, true, 13385)
				doTransformItem(item.uid, 11455)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Kikkaichu Yajiri) Menu->Jutsus->Aburame Jutsus")
				selfSay('you learned Katon Kikkaichu Yajiri no Jutsu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	
     	elseif(msgcontains(msg, "Kikkaichu Mushikame" or msg == "kikkaichu mushikame")) then
		if getPlayerLevel(cid) < 25 then
        selfSay("You need to be atleast level 25", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13386) == 1) then
		local item = getPlayerItemById(cid, true, 13386)
				doTransformItem(item.uid, 11398)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Kikkaichu Mushikame) Menu->Jutsus->Aburame Jutsus")
				selfSay('you learned Katon Kikkaichu Mushikame no Jutsu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
			
			 	elseif(msgcontains(msg, "Kikkaichu Tsumoji" or msg == "kikkaichu Tsumoji")) then
		if getPlayerLevel(cid) < 35 then
        selfSay("You need to be atleast level 35", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13387) == 1) then
		local item = getPlayerItemById(cid, true, 13387)
				doTransformItem(item.uid, 11396)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Kikkaichu Tsumoji) Menu->Jutsus->Aburame Jutsus")
				selfSay('you learned Katon Kikkaichu Tsumoji no Jutsu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
			
					 	elseif(msgcontains(msg, "Kikkaichu Arare" or msg == "kikkaichu Arare")) then
		if getPlayerLevel(cid) < 45 then
        selfSay("You need to be atleast level 45", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13388) == 1) then
		local item = getPlayerItemById(cid, true, 13388)
				doTransformItem(item.uid, 11471)
							doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Kikkaichu Arare) Menu->Jutsus->Aburame Jutsus")
				selfSay('you learned Kikkaichu Arare no Jutsu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
				elseif(msgcontains(msg, "Kikkaichu Mushidama" or msg == "kikkaichu mushidama")) then
		if getPlayerLevel(cid) < 45 then
        selfSay("You need to be atleast level 45", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13389) == 1) then
		local item = getPlayerItemById(cid, true, 13389)
				doTransformItem(item.uid, 11432)
							doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Kikkaichu Mushidama) Menu->Jutsus->Aburame Jutsus")
				selfSay('you learned Kikkaichu Mushidama no Jutsu', cid)
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