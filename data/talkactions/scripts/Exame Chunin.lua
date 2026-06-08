-- Exame Chunin completo feito por Vitor Bertolucci.
-- Favor nao postar nem compartilhar este codigo.
-- Favor manter esses comentarios quando for utilizar o codigo.
-- 17/05/2014

function onSay(cid, words, param, channel)
    local players = {}
    if param == "" then
        doPlayerSendCancel(cid, "Utilize os parametros corretos.")
        return true
    end
    
    if param == "inscricoes" then
        setGlobalStorageValue(1821291, 1)
        doBroadcastMessage("As inscricoes para o exame Chunin estao abertas!")
        doCreateNpc("NPC Chunin", {x = 2571, y = 1674, z = 5})
    elseif param == "start" then
        for _, pid in pairs(getPlayersOnline()) do
            if getPlayerStorageValue(pid, 192191) == 1 then
                table.insert(players, pid)
            end
        end
        if #players >= 6 then
            if #players % 3 ~= 0 then
                while #players % 3 ~= 0 do
                    doPlayerSendTextMessage(players[1], MESSAGE_STATUS_CONSOLE_BLUE, "O numero de participantes nao foi compativel com numero de equipes. Voce ficou sem equipe, tente na proxima.")
                    doPlayerSetStorageValue(players[1], 192191, -1)
                    table.remove(players, 1)
                end
            end
            local a = 1
            local max = 12
            while max ~= 0 do
                if #players >= 3 then
                    doPlayerAddItem(players[1], exame.positions[a].id, 1)
                    doPlayerSendTextMessage(players[1], MESSAGE_STATUS_CONSOLE_BLUE, "Voce esta com o pergaminho de sua equipe! Cuidado para nao perde-lo!")
                    doPlayerSendTextMessage(players[2], MESSAGE_STATUS_CONSOLE_BLUE, getCreatureName(players[1]).." esta com o pergaminho de sua equipe! Proteja-o!")
                    doPlayerSendTextMessage(players[3], MESSAGE_STATUS_CONSOLE_BLUE, getCreatureName(players[1]).." esta com o pergaminho de sua equipe! Proteja-o!")
                    doPlayerSetStorageValue(players[1], exame.team_storage, a)
                    doPlayerSetStorageValue(players[2], exame.team_storage, a)
                    doPlayerSetStorageValue(players[3], exame.team_storage, a)
                    doPlayerSendTextMessage(players[1], MESSAGE_STATUS_CONSOLE_BLUE, "Voce entrou na equipe "..a..", boa sorte!")
                    doPlayerSendTextMessage(players[2], MESSAGE_STATUS_CONSOLE_BLUE, "Voce entrou na equipe "..a..", boa sorte!")
                    doPlayerSendTextMessage(players[3], MESSAGE_STATUS_CONSOLE_BLUE, "Voce entrou na equipe "..a..", boa sorte!")
                    doTeleportThing(players[1], exame.positions[a].pos)
                    doTeleportThing(players[2], exame.positions[a].pos)
                    doTeleportThing(players[3], exame.positions[a].pos)
                    table.remove(players, 1)
                    table.remove(players, 1)
                    table.remove(players, 1)
                end
                a = a + 1
                max = max - 1
            end
            doBroadcastMessage("As equipes do exame foram formadas e o exame comecou! Boa sorte a todos!")
        else
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "O numero de equipes eh menor que 2. O exame nao pode ser inciado.")
        end
        setGlobalStorageValue(1821291, -1)
    end
    return true
end