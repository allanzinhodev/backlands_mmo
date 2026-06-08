local focuses = {}
local experience = 200
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
	if getPlayerStorageValue(cid, initStorages.graduation) == "gennin" then
	return selfSay("you are already a gennin", cid)
	end
	if((msg == "hi") and not (isFocused(cid))) then
		selfSay("Bem vindo jovem Ninja, ".. getCreatureName(cid) ..".", cid, true)
		selfSay("Vamos continuar seu exame gennin ?", cid)
		
		addFocus(cid)
	elseif((isFocused(cid)) and (msg == "yes" or msg == "sim")) then
		if getPlayerStorageValue(cid, 4000) < 1 then
			selfSay("Fale com Tekuno primeiro para aprender o Basico e depois volte a falar comigo.!!", cid)
		return true
		end
		selfSay("Vejo que falou com Tekuno, vamos continuar com nosso treinamento, irei te ensinar o Bunshin no Jutsu ({Jutsu que cria um Clone intangivel apenas para confundir o inimigo})", cid)
		selfSay("Use o Jutsu Bunshin e fale com Iruka ele ira te promover!!", cid)
		if(getPlayerItemCount(cid, 13376) >= 1) then
		local item = getPlayerItemById(cid, true, 13376)
		local item1 = getPlayerItemById(cid, true, 13381)
		local item2 = getPlayerItemById(cid, true, 13382)
				doTransformItem(item.uid, 12253)
				doTransformItem(item1.uid, 12250)
				doTransformItem(item2.uid, 12256)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Bunshin no Jutsu) Menu->Jutsus->Ninjutsu->Ninpou")
				doPlayerAddExp(cid, experience)
				doPlayerSave(cid)
				selfSay('Voce aprendeu um novo jutsu! (Bunshin no Jutsu) Menu->Jutsus->Ninjutsu->Ninpou', cid)
			else
				selfSay('desculpe, eu nao tenho nada pra voce.', cid)
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

       local direction = getCreatureLookDirection(getNpcId())
	   doCreatureSetLookDirection(getNpcId(), 0)
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