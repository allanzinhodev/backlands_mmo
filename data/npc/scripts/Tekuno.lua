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
		return selfSay("Voce ja e um gennin", cid)
	end

	if((msg == "hi") and not (isFocused(cid))) then
		selfSay("Voce quer começar seu exame gennin?", cid)
		addFocus(cid)
	elseif((isFocused(cid)) and (msg == "yes" or msg == "sim")) then
		selfSay("Bem, para comecar eu vou ensinar-lhe o Henge jutsu, o jutsu básico de todos ninja {Jutsu de Transformacao, que e capaz de transformar em pessoas e animais.}", cid)
		selfSay("Agora use o Jutsu Henge e fale com Suzunne para continuar o seu exame.", cid)
		if(getPlayerItemCount(cid, 13375) >= 1) then
		local item = getPlayerItemById(cid, true, 13375)
				doTransformItem(item.uid, 12733)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Henge no Jutsu) Menu->Jutsus->Ninjutsu->Ninpou")
				doPlayerAddExp(cid, experience)
				doPlayerSave(cid)
				selfSay('Voce aprendeu um novo jutsu! (Henge no Jutsu) Menu->Jutsus->Ninjutsu->Ninpou', cid)
			else
							selfSay('Desculpe, mas eu nao tenho nada para voce.', cid)
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