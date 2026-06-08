local focuses = {}
local experience = 400
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
local x = {
[1] = 40850, -- MAITO
[2] = 40851, -- Inuzuka    
[3] = 40852, -- Aburame
[4] = 40853, -- Hyuga
[5] = 40854, -- Uchiha
[6] = 40855, -- NARA
[7] = 40756, -- Akimichi
}
		
	if getPlayerStorageValue(cid, initStorages.graduation) == "Gennin" then
	selfSay("you are already a Gennin", cid)
	return true
	end
	if((msg == "hi") and not (isFocused(cid))) then
		selfSay("Bem Vindo jovem Ninja, ".. getCreatureName(cid) ..".", cid, true)
		selfSay("Voce ja concluiu todo o exame ?", cid)
		addFocus(cid)
	elseif((isFocused(cid)) and (msg == "sim" or msg == "yes")) then
		if getPlayerStorageValue(cid, 4001) < 1 then
			selfSay("Vejo que ainda nao terminou, fale com suzunne e volte a falar comigo!!", cid)
		return true
		end
		if getPlayerStorageValue(cid, 4001) >= 1 then
		selfSay("Entao irei te ensinar o Kawarimi ({Com esta tecnica, o usuario substitui o seu proprio corpo com algum outro objeto}).", cid)
		if(getPlayerItemCount(cid, 13377) >= 1) then
		local item = getPlayerItemById(cid, true, 13377)
				doTransformItem(item.uid, 11468)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Kawarimi) Menu->Jutsus->Ninjutsu->Ninpou")
				doPlayerAddExp(cid, experience)
			selfSay('Voce aprendeu um novo jutsu! (Kawarimi) Menu->Jutsus->Ninjutsu->Ninpou', cid)
			selfSay("Parabens jovem Ninja ".. getCreatureName(cid).." voce acaba de se tornar um gennin !!", cid, true)
			doPlayerAddExp(cid, experience)
			doPlayerAddItem(cid, 12619, 1)
			setPlayerStorageValue(cid, initStorages.graduation, "Gennin")
			setPlayerStorageValue(cid, 600, 2)
			doPlayerSave(cid)
			local v = x[getPlayerVocation(cid)]
			if (not v) then
				return true
			end
			for i = 1, #x do
				setPlayerStorageValue(cid,x[i],0)
			end
			local outfit = getCreatureOutfit(cid)
			outfit.lookType = infoClan[getPlayerVocation(cid)].outfit
			doCreatureChangeOutfit(cid, outfit)
			else
							selfSay('desculpe, eu não tenho nada pra você.', cid)
				end
	elseif((isFocused(cid)) and (msg == "bye" or msg == "goodbye" or msg == "cya")) then
		selfSay("Goodbye!", cid, true)
		removeFocus(cid)
	end
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
	   doCreatureSetLookDirection(getNpcId(), 2)
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