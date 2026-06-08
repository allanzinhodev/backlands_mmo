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
	if getPlayerStorageValue(cid, initStorages.graduation) ~= "Chunnin" then
		return 	selfSay("Desculpe, so falo com chunnins", cid)
	end
	if((msg == "hi") and not (isFocused(cid))) then
		selfSay("Vejo que voce se tornou um chunnin , gostaria de receber seus premios ?", cid)
		addFocus(cid)
	elseif((isFocused(cid)) and (msg == "Yes" or msg == "yes")) then
		selfSay("Muito bem ai esta", cid)
		if(getPlayerItemCount(cid, 13447) >= 1) then
		local item = getPlayerItemById(cid, true, 13447)
		local item2 = getPlayerItemById(cid, true, 13397)
				doTransformItem(item.uid, 12777)
				doTransformItem(item2.uid, 12837)
				doPlayerAddItem(cid, 12569, 1)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo genjutsu! (Nehan Shoja) Menu->Jutsus->Genjutsu")
				addEvent(doPlayerSendTextMessage, 700, cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Saikan Chuushutsu no Jutsu) Menu->Jutsus->Ninpou->Medicinal")
			else
				selfSay('desculpe, eu não tenho nada pra você.', cid)
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
	   doCreatureSetLookDirection(getNpcId(), 1)
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