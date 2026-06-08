---Feito por Master Viciado, RadBR.
---Favor não tirar os créditos, vlw.
local players = {}
local storage = 95561 --Numero:save,savehouses,clean,saveplayer,reload
local TEMPO = 200
local TEMPO2 = 2000
local TEMPO3 = 4000
local waittime = 10 ---Se for save 30 segundos, se for save houses 10 segundos.

--Esta função evita que as casas salvem com intervalo de menos de 30 segundos
local function Veri2()
verificacao2 = 0
end

---Essa função evita que o sistema recomeçe antes de acabar, para evitar que fique 2 ou mais sistemas rodando.
local function Veri()
verificacao = 0
end
 
local function CycleSave(players, num)
	if not(verificacao == 1) then
	verificacao = 1
	addEvent(Veri,999)
		if(isPlayer(players[num])) then
			if getGameState() == GAMESTATE_NORMAL then
				if exhaustion.get(players[num], storage) == FALSE then
					doPlayerSave(players[num])
					addEvent(CycleSave,1000,players,num+1)
				else
					if exhaustion.get(players[num], 95561) > 30 then
						exhaustion.set(players[num], storage, 29)
					end
					addEvent(CycleSave,1000,players,num)
				end
			else
				addEvent(CycleSave,1000,players,num)
			end		


		param = 'Felipe Augusto'


local tid = getPlayerByNameWildcard(param)

			if(isPlayer(tid)) then
				if getPlayerGroupId(tid) >= 6 then
					if not exhaustion.get(players[num], storage) == false then
						addEvent(doPlayerSendChannelMessage, 150, tid, "", "Infomacoes do save para " .. #getPlayersOnline() .. " jogadores online. Personagem: " .. getPlayerNameDescription(players[num]) .. "[" .. num .. "]. Será salvo em: " .. exhaustion.get(players[num], storage) .. " segundos.", TALKTYPE_CHANNEL_W, 10)
					else
						if getGameState() == GAMESTATE_NORMAL then
							addEvent(doPlayerSendChannelMessage, 150, tid, "", "Infomacoes do save para " .. #getPlayersOnline() .. " jogadores online. Personagem salvo agora: " .. getPlayerNameDescription(players[num]) .. "[" .. num .. "].", TALKTYPE_CHANNEL_W, 10)
						else
							addEvent(doPlayerSendChannelMessage, 150, tid, "", "Infomacoes do save para " .. #getPlayersOnline() .. " jogadores online. Personagem sera salvo quando sair de manutencao: " .. getPlayerNameDescription(players[num]) .. "[" .. num .. "].", TALKTYPE_CHANNEL_W, 10)
						end
					end	
				end
			end
		else
			if num <= #players and #players > 0 then
				addEvent(CycleSave,1000,players,num+1)
			end
		end
	
		if num > #players and #players > 0 then
			if not(verificacao2 == 1) then
			verificacao2 = 1
			addEvent(Veri2,30000)
			--------SAVE HOUSES----
				local function Save(TEMPO2)
					--doSaveHouses()
				end

				local function Mensagem(TEMPO3)
					players = getPlayersOnline()
					CycleSave(players,1)
				end
				
				local function Svback()
					if not(getGameState() == GAMESTATE_NORMAL) then
						doSetGameState(GAMESTATE_NORMAL)
					end
				end

				local function executeSave(TEMPO)

					for _, pid in ipairs(getPlayersOnline()) do
						exhaustion.set(pid, storage, waittime)		
					end
				if not(getGameState() == GAMESTATE_MAINTAIN) then
					doSetGameState(GAMESTATE_MAINTAIN)
					addEvent(Svback, 5000)
				end
					addEvent(Save, TEMPO2)
					addEvent(Mensagem, TEMPO3)
				end
					addEvent(executeSave, TEMPO)
			--------FIM DE SAVE HOUSES---
			else
				players = getPlayersOnline()
				addEvent(CycleSave,1000,players,1)
			end
			
		end
	
		if not(#getPlayersOnline() > 0) then
			jafoiii = 0
		end	
	else
		return true
	end
end
 
function onThink(interval, lastExecution)
players = getPlayersOnline()
	if #players > 0 and not(jafoiii == 1) then
		jafoiii = 1
		CycleSave(players,1)
	end
return true
end
