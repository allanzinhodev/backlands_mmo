-- Exame Chunin completo feito por Vitor Bertolucci.
-- Favor nao postar nem compartilhar este codigo.
-- Favor manter esses comentarios quando for utilizar o codigo.
-- 17/05/2014

function onSay(cid, words, param, channel)
    local fighters = {}
    for _, pid in pairs(getPlayersOnline()) do
        if getPlayerStorageValue(pid, exame.storage_x1) == 1 then
            table.insert(fighters, pid)
        end
    end
    if #fighters > 1 then
        local first = math.random(1, #fighters)
        local second = math.random(1, #fighters)
        if first == second then
            repeat
                first = math.random(1, #fighters)
            until first ~= second
        end
        doBroadcastMessage("Agora na arena, x1 entre "..getCreatureName(fighters[first]).." X "..getCreatureName(fighters[second]).."!")
        doTeleportThing(fighters[first], exame.arena_pos_1)
        doTeleportThing(fighters[second], exame.arena_pos_2)
        doPlayerSendTextMessage(fighters[second], MESSAGE_STATUS_CONSOLE_ORANGE, "Voce foi convocado para um x1 contra "..getCreatureName(fighters[first]).."! Boa sorte!")
        doPlayerSendTextMessage(fighters[first], MESSAGE_STATUS_CONSOLE_ORANGE, "Voce foi convocado para um x1 contra "..getCreatureName(fighters[second]).."! Boa sorte!")
    elseif #fighters == 1 then
        doBroadcastMessage("O jogador "..getCreatureName(fighters[1]).." venceu o exame chunin! Parabens ao novo Chunin!")
        doPlayerSetStorageValue(fighters[1], exame.storage_x1, -1)
        doPlayerSetStorageValue(fighters[1], 192191, -1)
        doPlayerSetStorageValue(fighters[1], initStorages.graduation, "Chunnin")
        doPlayerSetStorageValue(fighters[1], 600, 3)
        doPlayerSendTextMessage(fighters[1], MESSAGE_STATUS_CONSOLE_BLUE, "Parabens, voce se tornou um Chunin!")
        setGlobalStorageValue(1821291, -1)
        setGlobalStorageValue(2381121, 0)
        doTeleportThing(fighters[1], getTownTemplePosition(getPlayerTown(deathList[1])))
    end
    return true
end