-- Exame Chunin completo feito por Vitor Bertolucci.
-- Favor nao postar nem compartilhar este codigo.
-- Favor manter esses comentarios quando for utilizar o codigo.
-- 17/05/2014

function onPrepareDeath(cid, deathList)
    local target = cid
    if isPlayer(deathList[1]) and isPlayer(target) then
        if getPlayerStorageValue(deathList[1], exame.storage_x1) == 1 and getPlayerStorageValue(target, exame.storage_x1) == 1 then
            if getFighters() == 2 then
                doBroadcastMessage("O jogador "..getCreatureName(deathList[1]).." venceu o exame chunin! Parabens ao novo Chunin!")
                doPlayerSetStorageValue(deathList[1], exame.storage_x1, -1)
                doPlayerSetStorageValue(deathList[1], 192191, -1)
                doPlayerSetStorageValue(deathList[1], initStorages.graduation, "Chunnin")
                doPlayerSetStorageValue(deathList[1], 600, 3)
                doPlayerSendTextMessage(deathList[1], MESSAGE_STATUS_CONSOLE_BLUE, "Parabens, voce se tornou um Chunin!")
                setGlobalStorageValue(1821291, -1)
                setGlobalStorageValue(2381121, 0)
                doTeleportThing(deathList[1], getTownTemplePosition(getPlayerTown(deathList[1])))
            else
                doBroadcastMessage("O jogador "..getCreatureName(deathList[1]).." venceu o x1 contra "..getCreatureName(target).." e permanece no exame, parabens!")
                doTeleportThing(deathList[1], exame.arena_2_pos)
            end
            doPlayerSetStorageValue(target, exame.storage_x1, -1)
            doPlayerSetStorageValue(target, 192191, -1)
            setGlobalStorageValue(2381121, getFighters() - 1)
            doPlayerSendTextMessage(target, MESSAGE_STATUS_CONSOLE_ORANGE, "Voce morreu e perdeu o exame! Tente novamente no proximo!")
            doPlayerSendTextMessage(deathList[1], MESSAGE_STATUS_CONSOLE_BLUE, "Voce venceu o x1! Voce continua no exame, boa sorte!")
            doSendMagicEffect(exame.arena_2_pos, CONST_ME_TELEPORT)
        end
    end
    return true
end

function onLogin(cid)
    registerCreatureEvent(cid, "Exame Chunin Fase 2 Death")
    if getPlayerStorageValue(cid, exame.storage_x1) == 1 then
        doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
        doPlayerSetStorageValue(cid, exame.storage_x1, -1)
    end
    return true
end