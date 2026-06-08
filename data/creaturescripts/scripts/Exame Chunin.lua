-- Exame Chunin completo feito por Vitor Bertolucci.
-- Favor nao postar nem compartilhar este codigo.
-- Favor manter esses comentarios quando for utilizar o codigo.
-- 17/05/2014

function onLogout(cid)
    if getPlayerStorageValue(cid, 192191) > 0 then
        doPlayerSendCancel(cid, "Voce so pode logar quando o exame acabar!")
        return false
    end
    return true
end

function onPrepareDeath(cid, deathList)
    local target = cid
    local players = {}
    if isPlayer(deathList[1]) and isPlayer(target) then
        if getPlayerStorageValue(deathList[1], exame.team_storage) > 0 and getPlayerStorageValue(target, exame.team_storage) > 0 then
            for _, pid in pairs(getPlayersOnline()) do
                if getPlayerStorageValue(pid, exame.team_storage) == getPlayerStorageValue(target, exame.team_storage) then
                    table.insert(players, pid)
                end
            end
            for i = 1, #players do
                if getPlayerItemCount(players[i], exame.scroll_id[1]) > 0 or getPlayerItemCount(players[i], exame.scroll_id[2]) > 0 then
                    if getPlayerItemCount(players[i], exame.scroll_id[1]) > 0 and getPlayerItemCount(players[i], exame.scroll_id[2]) == 0 then
                        doPlayerRemoveItem(players[i], exame.scroll_id[1], getPlayerItemCount(players[i], exame.scroll_id[1]))
                        doPlayerAddItem(deathList[1], exame.scroll_id[1], 1)
                    elseif getPlayerItemCount(players[i], exame.scroll_id[2]) > 0 and getPlayerItemCount(players[i], exame.scroll_id[1]) == 0 then
                        doPlayerRemoveItem(players[i], exame.scroll_id[2], getPlayerItemCount(players[i], exame.scroll_id[2]))
                        doPlayerAddItem(deathList[1], exame.scroll_id[2], 1)
                    elseif getPlayerItemCount(players[i], exame.scroll_id[1]) > 0 and getPlayerItemCount(players[i], exame.scroll_id[2]) > 0 then
                        doPlayerRemoveItem(players[i], exame.scroll_id[2], getPlayerItemCount(players[i], exame.scroll_id[2]))
                        doPlayerRemoveItem(players[i], exame.scroll_id[1], getPlayerItemCount(players[i], exame.scroll_id[1]))
                        if getPlayerItemCount(deathList[1], exame.scroll_id[1]) > 0 and getPlayerItemCount(deathList[1], exame.scroll_id[2]) == 0 then
                            doPlayerAddItem(deathList[1], exame.scroll_id[2], 1)
                        elseif getPlayerItemCount(deathList[1], exame.scroll_id[2]) > 0 and getPlayerItemCount(deathList[1], exame.scroll_id[1]) == 0 then
                            doPlayerAddItem(deathList[1], exame.scroll_id[1], 1)
                        elseif getPlayerItemCount(deathList[1], exame.scroll_id[1]) > 0 and getPlayerItemCount(deathList[1], exame.scroll_id[2]) > 0 then
                            doPlayerAddItem(deathList[1], exame.scroll_id[math.random(1, 2)], 1)
                        end
                    end
                    doPlayerSendTextMessage(deathList[1], MESSAGE_STATUS_CONSOLE_ORANGE, "Voce matou uma pessoa da equipe "..getPlayerStorageValue(target, 192191).." e roubou seu pergaminho! O pergaminho agora esta com vc")
                end
                doPlayerSetStorageValue(players[i], 192191, -1)
                doPlayerSetStorageValue(players[i], exame.team_storage, -1)
                doPlayerSendTextMessage(players[i], MESSAGE_STATUS_CONSOLE_BLUE, "Alguem de sua equipe morto no exame! Tente uma proxima vez.")
                doTeleportThing(players[i], getTownTemplePosition(getPlayerTown(players[i])))
            end
        end
    end
    return true
end

function onCombat(cid, target)
    if isPlayer(cid) and isPlayer(target) then
        if getPlayerStorageValue(cid, exame.team_storage) > 0 and getPlayerStorageValue(target, exame.team_storage) > 0 then
            if getPlayerStorageValue(cid, exame.team_storage) == getPlayerStorageValue(target, exame.team_storage) then
                doPlayerSendCancel(cid, "Nao pode atacar alguem da sua equipe!")
                return false
            end
        end
    end
    return true
end

function onTarget(cid, target)
    if isPlayer(cid) and isPlayer(target) then
        if getPlayerStorageValue(cid, exame.team_storage) > 0 and getPlayerStorageValue(target, exame.team_storage) > 0 then
            if getPlayerStorageValue(cid, exame.team_storage) == getPlayerStorageValue(target, exame.team_storage) then
                doPlayerSendCancel(cid, "Nao pode atacar alguem da sua equipe!")
                return false
            end
        end
    end
    return true
end

function onLogin(cid)
    registerCreatureEvent(cid, "Exame Chunin Combat")
    registerCreatureEvent(cid, "Exame Chunin Target")
    registerCreatureEvent(cid, "Exame Chunin Death")
    if getPlayerStorageValue(cid, 192191) > 0 then
        setPlayerStorageValue(cid, 192191, -1)
        doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
    end
    if getPlayerStorageValue(cid, exame.team_storage) > 0 then
        setPlayerStorageValue(cid, exame.team_storage, -1)
        doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
    end
    return true
end