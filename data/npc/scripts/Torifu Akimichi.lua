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
	if getPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA7) <= 0 then
		setPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA, getPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA) + 1)
		selfSay("Muito obrigado.")
		setPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA7, 1)
	else
		selfSay("Já recebi seu recado, tchau.")
		removeFocus(cid)
	end 
	elseif((isFocused(cid)) and (msg == "jutsu" or msg == "Jutsu")) then
		 if not isInArray({7}, getPlayerVocation(cid)) then
        	return selfSay("Nao posso te ensinar nada.", cid)
    	end
		selfSay("I can teach you some jutsus", cid)
		selfSay("{Nikudan Sensha} level 5 , {Horengan} level 10, {Nikudan Hari Sensha} level 15, {Karegan} level 20,  {Chou Baika} level 25, {Omoni} level 30, {Harite Chou} level 35, , {Mizudan Suisha} level 40, {Bubun Baika} level 45, {Tongarashigan} level 50, {Choudan Bakugeki} level 55", cid)
	elseif(msgcontains(msg, "Nikudan Sensha" or msg == "nikudan senha")) then
		if getPlayerLevel(cid) < 5 then
        selfSay("You need to be atleast level 5", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13357) == 1) then
		local item = getPlayerItemById(cid, true, 13357)
				doTransformItem(item.uid, 12357)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Nikudan Sensha) Menu->Jutsus->Akimichi Jutsu")
				selfSay('you learned Nikudan Sensha', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	elseif(msgcontains(msg, 'Horengan' or msg == "horengan")) then
		if getPlayerLevel(cid) < 10 then
        selfSay("You need to be atleast level 10", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13365) == 1) then
		local item = getPlayerItemById(cid, true, 13365)
				doTransformItem(item.uid, 12366)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Horengan) Menu->Jutsus->Akimichi Jutsu")
				selfSay('you learned Horengan', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end

	elseif(msgcontains(msg, "Nikudan Hari Sensha" or msg == "nikudan hari sensha")) then
		if getPlayerLevel(cid) < 15 then
        selfSay("You need to be atleast level 15", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13358) == 1) then
		local item = getPlayerItemById(cid, true, 13358)
				doTransformItem(item.uid, 12356)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Nikudan Hari Sensha) Menu->Jutsus->Akimichi Jutsu")
				selfSay('you learned Hari Sensha', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	elseif(msgcontains(msg, "Karegan" or msg == "karegan")) then
		if getPlayerLevel(cid) < 20 then
        selfSay("You need to be atleast level 20", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13366) == 1) then
		local item = getPlayerItemById(cid, true, 13366)
				doTransformItem(item.uid, 12367)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Karegan) Menu->Jutsus->Akimichi Jutsu")
				selfSay('you learned Karegan', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	elseif(msgcontains(msg, "Chou Baika" or msg == "chou baika")) then
		if getPlayerLevel(cid) < 25 then
        selfSay("You need to be atleast level 25", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13359) == 1) then
		local item = getPlayerItemById(cid, true, 13359)
				doTransformItem(item.uid, 12728)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Chou Baika) Menu->Jutsus->Akimichi Jutsu")
				selfSay('you learned Chou Baika', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	elseif(msgcontains(msg, "Omoni" or msg == "omoni")) then
		if getPlayerLevel(cid) < 30 then
        selfSay("You need to be atleast level 30", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13360) == 1) then
		local item = getPlayerItemById(cid, true, 13360)
				doTransformItem(item.uid, 12365)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Omoni) Menu->Jutsus->Akimichi Jutsu")
				selfSay('you learned Omoni', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	elseif(msgcontains(msg, "Harite Chou" or msg == "harite chou")) then
		if getPlayerLevel(cid) < 35 then
        selfSay("You need to be atleast level 35", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13361) == 1) then
		local item = getPlayerItemById(cid, true, 13361)
				doTransformItem(item.uid, 12726)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Harite Chou) Menu->Jutsus->Akimichi Jutsu")
				selfSay('you learned Harite Chou', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	elseif(msgcontains(msg, "Mizudan Suisha" or msg == "mizudan suisha")) then
		if getPlayerLevel(cid) < 40 then
        selfSay("You need to be atleast level 40", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13362) == 1) then
		local item = getPlayerItemById(cid, true, 13362)
				doTransformItem(item.uid, 12723)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Mizudan Suisha) Menu->Jutsus->Akimichi Jutsu")
				selfSay('you learned Mizudan Suisha', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	elseif(msgcontains(msg, "Bubun Baika" or msg == "bubun baika")) then
		if getPlayerLevel(cid) < 45 then
        selfSay("You need to be atleast level 45", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13363) == 1) then
		local item = getPlayerItemById(cid, true, 13363)
				doTransformItem(item.uid, 12724)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Bubun Baika) Menu->Jutsus->Akimichi Jutsu")
				selfSay('you learned Bubun Baika', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	elseif(msgcontains(msg, "Tongarashigan" or msg == "tongarashigan")) then
		if getPlayerLevel(cid) < 50 then
        selfSay("You need to be atleast level 50", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13367) == 1) then
		local item = getPlayerItemById(cid, true, 13367)
				doTransformItem(item.uid, 12368)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Tongarashigan) Menu->Jutsus->Akimichi Jutsu")
				selfSay('you learned Tongarashigan', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
		elseif(msgcontains(msg, "Choudan Bakugeki" or msg == "choudan bakugeki")) then
		if getPlayerLevel(cid) < 55 then
        selfSay("You need to be atleast level 55", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13364) == 1) then
		local item = getPlayerItemById(cid, true, 13364)
				doTransformItem(item.uid, 12730)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Choudan Bakugeki) Menu->Jutsus->Akimichi Jutsu")
				selfSay('you learned Choudan Bakugeki', cid)
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