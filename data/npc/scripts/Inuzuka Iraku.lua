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
	local pet = getPlayerPet(cid)	
	if getPlayerStorageValue(cid, initStorages.graduation) == "Academy Student" then
	return selfSay("you're too young, go study and come back later", cid)
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
	if getPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA2) <= 0 then
		setPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA, getPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA) + 1)
		selfSay("Muito obrigado.")
		setPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA2, 1)
	else
		selfSay("Já recebi seu recado, tchau.")
		removeFocus(cid)
	end 
	elseif((isFocused(cid)) and (msg == "jutsu" or msg == "Jutsu")) then
		if not isInArray({2}, getPlayerVocation(cid)) then
        	return selfSay("Nao posso te ensinar nada.", cid)
    	end
		selfSay("I can teach you some jutsus", cid)
		selfSay("{Tsuuga no jutsu} level 5 , {Shikyaku no Jutsu} level 10, {Juujin Bunshin} level 20, {Gatsuuga} level 30, {Soutorou} level 40, {Garouga} level 45", cid)
	elseif(msgcontains(msg, "Tsuuga No Jutsu" or msg == "tsuuga no jutsu")) then
		if getPlayerLevel(cid) < 5 then
        selfSay("You need to be atleast level 5", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13369) == 1) then
		local item = getPlayerItemById(cid, true, 13369)
				doTransformItem(item.uid, 12787)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Tsuuga) Menu->Jutsus->Inuzuka Jutsu")
				selfSay('you learned Tsuuga', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	elseif(msgcontains(msg, 'Shikyaku No Jutsu' or msg == "shikyaku no jutsu")) then
		if getPlayerLevel(cid) < 10 then
        selfSay("You need to be atleast level 10", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13370) == 1) then
		local item = getPlayerItemById(cid, true, 13370)
				doTransformItem(item.uid, 12786)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Shikyaku no Jutsu) Menu->Jutsus->Inuzuka Jutsu")
				selfSay('you learned Shikyaku No Jutsu', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end

	elseif(msgcontains(msg, "Juujin Bunshin" or msg == "juujin bunshin")) then
		if getPlayerLevel(cid) < 20 then
        selfSay("You need to be atleast level 20", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13371) == 1) then
		local item = getPlayerItemById(cid, true, 13371)
				doTransformItem(item.uid, 12785)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Juujin Bunshin) Menu->Jutsus->Inuzuka Jutsu")
				selfSay('you learned Juujin Bunshin', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
			
				elseif(msgcontains(msg, "Gatsuuga" or msg == "gatsuuga")) then
		if getPlayerLevel(cid) < 30 then
			selfSay("You need to be atleast level 30", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13372) == 1) then
		local item = getPlayerItemById(cid, true, 13372)
				doTransformItem(item.uid, 12788)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Gatsuuga) Menu->Jutsus->Inuzuka Jutsu")
				selfSay('you learned Gatsuuga', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
					elseif(msgcontains(msg, "Soutorou" or msg == "soutorou")) then
		if getPlayerLevel(cid) < 40 then
			selfSay("You need to be atleast level 40", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13374) == 1) then
		local item = getPlayerItemById(cid, true, 13374)
				doTransformItem(item.uid, 12789)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Soutorou) Menu->Jutsus->Inuzuka Jutsu")
				selfSay('you learned Soutorou', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
				elseif(msgcontains(msg, "Garouga" or msg == "garouga")) then
		if getPlayerLevel(cid) < 45 then
			selfSay("You need to be atleast level 45", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13373) == 1) then
		local item = getPlayerItemById(cid, true, 13373)
				doTransformItem(item.uid, 12790)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Garouga) Menu->Jutsus->Inuzuka Jutsu")
				selfSay('you learned Garouga', cid)
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end
	elseif((isFocused(cid)) and (msg == "Comandos" or msg == "comandos")) then
			selfSay('use o comando {!nick} para dar um nome ao seu Dog.', cid)
	elseif((isFocused(cid)) and (msg == "Pet Jutsus" or msg == "pet jutsus")) then
		if not pet then
			return selfSay("Chame seu pet primeiro.", cid)
		end
		selfSay("Eu posso ensinar esses jutsus.", cid)
		selfSay("{Dynamic Marking} level 5 , {Bite} level 10, {Scratch} level 15, {Moko Taiko} level 20", cid)
	elseif(msgcontains(msg, "Dynamic Marking" or msg == "dynamic marking")) then
		if getPetLevel(pet) < 1 then
        selfSay("Your pet need to be atleast level 5", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13435) == 1) then
		local item = getPlayerItemById(cid, true, 13435)
				doTransformItem(item.uid, 12296)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Seu pet aprendeu um novo jutsu! (Dynamic Marking) CTRL+D -> Jutsus")
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
			end

		elseif(msgcontains(msg, 'Bite' or msg == "bite")) then
		if getPetLevel(pet) < 10 then
       		 selfSay("Your pet need to be atleast level 10", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13436) == 1) then
		local item = getPlayerItemById(cid, true, 13436)
				doTransformItem(item.uid, 12795)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Seu pet aprendeu um novo jutsu! (Bite) CTRL+D -> Jutsus")
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
		end
		elseif(msgcontains(msg, 'Scratch' or msg == "scratch")) then
		if getPetLevel(pet) < 15 then
       		 selfSay("Your pet need to be atleast level 15", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13437) == 1) then
		local item = getPlayerItemById(cid, true, 13437)
				doTransformItem(item.uid, 12796)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Seu pet aprendeu um novo jutsu! (Scratch) CTRL+D -> Jutsus")
			else
				selfSay('sorry, you already learned this Jutsu.', cid)
		end
		elseif(msgcontains(msg, 'Moko Taiko' or msg == "moko taiko")) then
		if getPetLevel(pet) < 20 then
       		 selfSay("Your pet need to be atleast level 20", cid)
		return true
		end
		if(getPlayerItemCount(cid, 13438) == 1) then
		local item = getPlayerItemById(cid, true, 13438)
				doTransformItem(item.uid, 12797)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Seu pet aprendeu um novo jutsu! (Moko Taiko) CTRL+D -> Jutsus")
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