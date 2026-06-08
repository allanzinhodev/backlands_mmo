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
	if getPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA4) <= 0 then
		setPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA, getPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA) + 1)
		selfSay("Muito obrigado.")
		setPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA4, 1)
	else
		selfSay("Já recebi seu recado, tchau.")
		removeFocus(cid)
	end 
	elseif((isFocused(cid)) and (msg == "jutsu" or msg == "Jutsu")) then
		if not isInArray({4}, getPlayerVocation(cid)) then
        	return selfSay("Nao posso te ensinar nada.", cid)
    	end
		selfSay("I can teach you some jutsus", cid)
		selfSay("{Hiasangi} level 5 , {Kuushou} level 10, {Kaiten} level 15, {Sanjuunishou} level 25, {Hasengeki} level 35, {Rokujuuyonshou} level 40, {Shiten} level 45, {Hyakunijuuhachishou} level 55", cid)
	elseif(msgcontains(msg, "Hiasangi" or msg == "hiasangi")) then
		if getPlayerLevel(cid) < 5 then
        selfSay("You need to be atleast level 5", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13336) == 1) then
		local item = getPlayerItemById(cid, true, 13336)
				doTransformItem(item.uid, 11464)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Hiasangi) Menu->Jutsus->Hyuuga Clan")
				selfSay('you learned Hiasangi', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	
	elseif(msgcontains(msg, "Kuushou" or msg == "kuushou")) then
		if getPlayerLevel(cid) < 10 then
        selfSay("You need to be atleast level 10", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13337) == 1) then
		local item = getPlayerItemById(cid, true, 13337)
				doTransformItem(item.uid, 11408)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Kuushou) Menu->Jutsus->Hyuuga Clan")
				selfSay('you learned Kuushou', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	
	elseif(msgcontains(msg, 'Kaiten' or msg == "kaiten")) then
		if getPlayerLevel(cid) < 15 then
        selfSay("You need to be atleast level 15", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13339) == 1) then
		local item = getPlayerItemById(cid, true, 13339)
				doTransformItem(item.uid, 11410)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Kaiten) Menu->Jutsus->Hyuuga Clan")
				selfSay('you learned Hakkeshou Kaiten', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
     	elseif(msgcontains(msg, "Sanjuunishou" or msg == "sanjuunishou")) then
		if getPlayerLevel(cid) < 25 then
        selfSay("You need to be atleast level 25", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13343) == 1) then
		local item = getPlayerItemById(cid, true, 13343)
				doTransformItem(item.uid, 11444)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Sanjuunishou) Menu->Jutsus->Hyuuga Clan->Byakugan->Hakkeshou Menu")
				selfSay('you learned Hakke Sanjuunishou', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
			
		elseif(msgcontains(msg, "Hasengeki" or msg == "hasengeki")) then
		if getPlayerLevel(cid) < 35 then
        selfSay("You need to be atleast level 35", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13338) == 1) then
		local item = getPlayerItemById(cid, true, 13338)
				doTransformItem(item.uid, 11409)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Hasengeki) Menu->Jutsus->Hyuuga Clan")
				selfSay('you learned Hasengeki', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
		end	
					
					 	elseif(msgcontains(msg, "Rokujuuyonshou" or msg == "rokujuuyonshou")) then
		if getPlayerLevel(cid) < 40 then
        selfSay("You need to be atleast level 40", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13344) == 1) then
		local item = getPlayerItemById(cid, true, 13344)
				doTransformItem(item.uid, 12781)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Rokujuuyonshou) Menu->Jutsus->Hyuuga Clan->Byakugan->Hakkeshou Menu")
				selfSay('you learned Hakke Rokujuuyonshou', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
			
		     	elseif(msgcontains(msg, "shiten" or msg == "shiten")) then
		if getPlayerLevel(cid) < 45 then
        selfSay("You need to be atleast level 45", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13335) == 1) then
		local item = getPlayerItemById(cid, true, 13335)
				doTransformItem(item.uid, 11465)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Shiten) Menu->Jutsus->Hyuuga Clan")
				selfSay('you learned Hakke Sanjuunishou', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
			
		elseif(msgcontains(msg, "Hyakunijuuhachishou" or msg == "hyakunijuuhachishou")) then
		if getPlayerLevel(cid) < 55 then
        selfSay("You need to be atleast level 55", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13345) == 1) then
		local item = getPlayerItemById(cid, true, 13345)
				doTransformItem(item.uid, 12782)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Hyakunijuuhachishou) Menu->Jutsus->Hyuuga Clan->Byakugan->Hakkeshou Menu")
				selfSay('you learned Hakke Hyakunijuuhachishou', cid)
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