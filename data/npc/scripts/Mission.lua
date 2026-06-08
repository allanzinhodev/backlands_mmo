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

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)


function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function santaNPC(cid)
if (getPlayerStorageValue(cid, STORAGE) < 1) then
	doPlayerAddItem(cid, ITEM, QUANT)
	setPlayerStorageValue(cid, STORAGE, 1)
	selfSay('Obrigado e Boa Sorte na sua jornada', cid)
else
	selfSay('Desculpe, Mas voce ja realizou todas as missoes, nao tem mais missoes por enquanto.', cid)
end
end

function onCreatureSay(cid, type, msg)
msg = msg:lower()
if getPlayerStorageValue(cid, initStorages.graduation) == "Academy Student" then
	return selfSay("Voce ainda nao pode realizar missoes, va se tornar um ninja primeiro.", cid)
end

--	if getPlayerStorageValue(cid, sto_missao[7]) > os.time() then
--     	return selfSay("Desculpe "..getPlayerName(cid)..", voce ja realizou sua missao diaria.", cid, true)
--   end

if(msgcontains(msg, "hi")) and not (isFocused(cid)) then
		selfSay("Ola "..getPlayerName(cid).." . Posso te dar uma {missao} diaria dependendo do seu rank Ninja", cid)
elseif(msgcontains(msg, "missao" or msg == "Missao")) then
		selfSay("({Rank D}) , ({Rank C})", cid)
elseif(msgcontains(msg, "rank d")) then
if (getPlayerStorageValue(cid, sto_missao[1]) < 1) then
selfSay("\nMissoes RANK D \n1-{Entrega da Mensagem}", cid)
end
if (getPlayerStorageValue(cid, sto_missao[1]) == 2) then
selfSay("\nMissoes RANK D \n2-{As Patas de Lobo}", cid)
end
if (getPlayerStorageValue(cid, sto_missao[1]) == 3) then
selfSay("\nMissoes RANK D \n3-{As Asas do Morcego}", cid)
end
if (getPlayerStorageValue(cid, sto_missao[1]) == 4) then
selfSay("\nMissoes RANK D \n4-{Ajuda Medica}", cid)
end

if (getPlayerStorageValue(cid, sto_missao[1]) == 5) then
selfSay("\nMissoes RANK D \n5-{Chifres de viado.}", cid)
end

if (getPlayerStorageValue(cid, sto_missao[1]) == 6) then
selfSay("\nMissoes RANK D \n6-{Ervas.}", cid)
end

if (getPlayerStorageValue(cid, sto_missao[1]) == 7) then
selfSay("\nMissoes RANK D \n-{Em lembrança de um ninja}.", cid)
end

if (getPlayerStorageValue(cid, sto_missao[1]) == 8) then
selfSay("\nMissoes RANK D \n{Um velho ferreiro}.", cid)
end

------------------------------------------------------------------------------------
elseif(msgcontains(msg, "entrega da mensagem")) then
if (getPlayerStorageValue(cid, sto_missao[1]) < 1) then
selfSay("Procure Inuzuka Haru no Hospital e entregue essa mensagem.", cid)
end
	Missao1(cid)
------------------------------------------------------------------------------------
elseif(msgcontains(msg, "as patas de lobo")) then
if (getPlayerStorageValue(cid, sto_missao[1]) == 2) then
selfSay("Sei que e perigoso, mas estamos precisando de algumas patas de lobos {15 wolf paw}, va em busca delas..", cid)
end
	Missao2(cid)
elseif(msgcontains(msg, "wolf paw")) then
if(getPlayerItemCount(cid, 5897) >= 15) and getPlayerStorageValue(cid, sto_missao[1]) == 2 then
 doPlayerRemoveItem(cid, 5897, 15)
 setPlayerStorageValue(cid, sto_missao[1], 3)
 setPlayerStorageValue(cid, sto_missao[7], os.time() + 1*60*60*24)
 doPlayerAddExp(cid, 1500)
 doPlayerAddItem(cid,2148,80)
 setPlayerStorageValue(cid, sto_missao[2], getPlayerStorageValue(cid,sto_missao[2]) + 1)
  selfSay('Muito bem aqui esta sua recompensa..', cid)
 else
 selfSay('Voce ainda não tem a quantidade de patas de lobos que nos precisamos.', cid)
end
------------------------------------------------------------------------------------
elseif(msgcontains(msg, "as asas do morcego")) then
if (getPlayerStorageValue(cid, sto_missao[1]) == 3) then
selfSay("Estamos fazendo uma pesquisa com morcegos e precisamos de algumas Asas de Morcego {25 Bat Wing}, va em busca delas ..", cid)
end
Missao3(cid)
elseif(msgcontains(msg, "bat wing")) then
if(getPlayerItemCount(cid, 5894) >= 25) and getPlayerStorageValue(cid, sto_missao[1]) == 3 then
 doPlayerRemoveItem(cid, 5894, 25)
 setPlayerStorageValue(cid, sto_missao[1], 4)
 setPlayerStorageValue(cid, sto_missao[7], os.time() + 1*60*60*24)
 doPlayerAddExp(cid, 2000)
 doPlayerAddItem(cid,2148,85)
 setPlayerStorageValue(cid, sto_missao[2], getPlayerStorageValue(cid,sto_missao[2])+1)
  selfSay('Muito bem aqui esta sua recompensa..', cid)
 else
 selfSay('Voce ainda não tem a quantidade de asas de morcego que nos precisamos.', cid)
end
----------------------------------------------------------------------------------
elseif(msgcontains(msg, "ajuda medica")) then
if (getPlayerStorageValue(cid, sto_missao[1]) == 4) then
selfSay("Os medicos de konoha estao precisando de suprimentos medicinais, e precisam muito de blueberrys, dizem que ao Sul de Konoha existe uma montanha com muitas blueberrys, va colher {150 blueberrys} e leve para o Medico Iyashi no segundo andar do hospital!! ..", cid)
end
Missao4(cid)
----------------------------------------------------------------------------------------
elseif(msgcontains(msg, "chifres de viado")) then
if (getPlayerStorageValue(cid, sto_missao[1]) == 5) then
selfSay("Precisamos de alguns chifres de viado , va em busca deles. me traga {5} horns deer ..", cid)
end
elseif(msgcontains(msg, "horns deer")) then
if(getPlayerItemCount(cid, 13019) >= 5) and getPlayerStorageValue(cid, sto_missao[1]) == 5 then
 doPlayerRemoveItem(cid, 13019, 5)
 setPlayerStorageValue(cid, sto_missao[1], 6)
 setPlayerStorageValue(cid, sto_missao[7], os.time() + 1*60*60*24)
 doPlayerAddExp(cid, 3000)
 doPlayerAddItem(cid,2148,45)
 setPlayerStorageValue(cid, sto_missao[2], getPlayerStorageValue(cid,sto_missao[2])+1)
  selfSay('Muito bem aqui esta sua recompensa..', cid)
 else
 selfSay('Voce ainda nao tem a quantidade de chifres que nos precisamos.', cid)
end
Missao5(cid)
------------------------------------------------------------------------------
elseif(msgcontains(msg, "ervas")) then
if (getPlayerStorageValue(cid, sto_missao[1]) == 6) then
selfSay("Nara SHIKAZU esta precisando de umas ervas {20}, soube que e possivel conseguir com alguns rabbits, va pegar e entregue pra ele, ele se encontra perto do cla nara.", cid)
end
Missao6(cid)
--------------------------------------------------------------------
elseif(msgcontains(msg, "em lembrança de um ninja")) then
if (getPlayerStorageValue(cid, sto_missao[1]) == 7) then
selfSay("Sr Takeshi esta muito triste pela morte de seu filho, ajude-o no velorio levando umas flores para ele no cimiterio de Konoha, vá na Yamanaka Flowers e compre.", cid)	
end
Missao7(cid)
-----------------------------------------------------------------------
elseif(msgcontains(msg, "um velho ferreiro")) then
if (getPlayerStorageValue(cid, sto_missao[1]) == 8) then
selfSay("Itsumo esta perto da saida sul de Konoha, ele veio nos procurar porque esta precisando de ajuda, va la ver oque ele precisa", cid)
end
Missao8(cid)
-----------------------------------------------------------------------------

elseif(msgcontains(msg, "rank c")) then
if getPlayerLevel(cid) < 25 then
	return selfSay("Desculpe, mas voce ainda não tem level sufuciente para realizar essa missao. 25+")
end

if (getPlayerStorageValue(cid, sto_missao[8]) == 1) then
	return selfSay("Voce veio {Reportar} uma missao?")
end

if (getPlayerStorageValue(cid, sto_missao[8]) < 1) then
	selfSay("\nMissoes RANK C \n1-{Aviso Importante}", cid)
end

if (getPlayerStorageValue(cid, sto_missao[8]) == 2) then
	selfSay("\nDesculpe nao temos missoes para voce agora.", cid)
end

--------------------------------------------------------------------------
elseif(msgcontains(msg, "aviso importante")) then
if (getPlayerStorageValue(cid, sto_missao[8]) < 1) then
selfSay("O Grande Hokage esta querendo fazer uma reuniao, entregue este recado para todos os chefes de clans. Volte aqui para {reportar} sua missao.", cid)
end
Missao1C(cid)
elseif(msgcontains(msg, "reportar")) then
if getPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA) == 7 then
	return selfSay('Voce ja completou essa missao..', cid)
end
if getPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA) == 6 then
 doPlayerAddExp(cid, 7500)
 doPlayerAddItem(cid,2148,45)
 setPlayerStorageValue(cid, sto_missao[8], 2)
 setPlayerStorageValue(cid, STORAGE_MISSAO_ALDEIA, 7)
 setPlayerStorageValue(cid, sto_missao[3], getPlayerStorageValue(cid,sto_missao[3])+1)
  selfSay('Muito bem aqui esta sua recompensa..', cid)
 else
 selfSay('Voce ainda nao falou com todos os chefes.', cid)
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