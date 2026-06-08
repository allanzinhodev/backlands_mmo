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
	if((msg == "hi") and not (isFocused(cid))) then
		selfSay("Ei, ".. getCreatureName(cid) .." voce ja conhece os Genjutsus ? ({Essas técnicas são usadas freqüentemente para criar imagens falsas ou causar dor de um trauma}.\n Outro jutsu que posso te ensinar é o {Shunshin no Jutsu} ({A Técnica de Cintilação Corporal é uma técnica de movimento em alta velocidade, permitindo que um ninja mova-se de uma curta para uma longa distância a uma velocidade quase indetectável}). Diga {KAI} ou {Shunshin No Jutsu}, que te ensinarei.", cid)
		addFocus(cid)
	elseif((isFocused(cid)) and (msg == "kai" or msg == "Kai")) then
		selfSay("Muito bem ai esta", cid)
		if(getPlayerItemCount(cid, 13378) >= 1) then
		local item = getPlayerItemById(cid, true, 13378)
				doTransformItem(item.uid, 11466)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Kai) Menu->Jutsus->Ninjutsu->Ninpou")
				selfSay('Voce aprendeu um novo jutsu! (Kai) Menu->Jutsus->Ninjutsu->Ninpou', cid)
			else
							selfSay('desculpe, eu não tenho nada pra você.', cid)
	end
	elseif((isFocused(cid)) and (msg == "Shunshin No Jutsu" or msg == "shunshin no jutsu")) then
		if not isPremium(cid) then
		 	return	doPlayerSendCancel(cid, "Você não tem premmium account. (VIP)")
		end
				selfSay("Muito bem ai esta", cid)
		if(getPlayerItemCount(cid, 13394) >= 1) then
		local item = getPlayerItemById(cid, true, 13394)
				doTransformItem(item.uid, 13440)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Shunshin no Jutsu) Menu->Jutsus->Ninjutsu->Ninpou")
				selfSay('Voce aprendeu um novo jutsu! (Shunshin no Jutsu) Menu->Jutsus->Ninjutsu->Ninpou', cid)
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