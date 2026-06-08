-- Exame Chunin completo feito por Vitor Bertolucci.
-- Favor nao postar nem compartilhar este codigo.
-- Favor manter esses comentarios quando for utilizar o codigo.
-- 17/05/2014

function onUse(cid, item, fromPosition, itemEx, toPosition)
    local element = 0
    if getPlayerStorageValue(cid, exame.team_storage) > 0 then
        if item.actionid == 7511 then
            element = 1
        elseif item.actionid == 7512 then
            element = 2
        elseif item.actionid == 7513 then
            element = 3
        elseif item.actionid == 7514 then
            element = 4
        end
        local player1 = getTopCreature(exame.player_positions[element][1])
        local player2 = getTopCreature(exame.player_positions[element][2])
        local player3 = getTopCreature(exame.player_positions[element][3])
        if isPlayer(player1.uid) and isPlayer(player2.uid) and isPlayer(player3.uid) then
            if getPlayerStorageValue(player1.uid, exame.team_storage) == getPlayerStorageValue(player2.uid, exame.team_storage) and getPlayerStorageValue(player1.uid, exame.team_storage) == getPlayerStorageValue(player3.uid, exame.team_storage) and getPlayerStorageValue(player1.uid, exame.team_storage) == getPlayerStorageValue(cid, exame.team_storage) then
                if getTileItemById(exame.scroll_positions[element][1], exame.scroll_id[1]).uid > 0 and getTileItemById(exame.scroll_positions[element][2], exame.scroll_id[2]).uid > 0 then
                    doRemoveItem(getTileItemById(exame.scroll_positions[element][1], exame.scroll_id[1]).uid, 1)
                    doRemoveItem(getTileItemById(exame.scroll_positions[element][2], exame.scroll_id[2]).uid, 1)
                    doSendMagicEffect(exame.scroll_positions[element][1], 6)
                    doSendMagicEffect(exame.scroll_positions[element][2], 6)                                      
                    doPlayerSendTextMessage(player1.uid, 25, "Parabens por ter conseguido passar da etapa da floresta! Sua equipe esta pronta para a proxima fase!")
                    doPlayerSendTextMessage(player2.uid, 25, "Parabens por ter conseguido passar da etapa da floresta! Sua equipe esta pronta para a proxima fase!")
                    doPlayerSendTextMessage(player3.uid, 25, "Parabens por ter conseguido passar da etapa da floresta! Sua equipe esta pronta para a proxima fase!")
                    doPlayerSetStorageValue(player1.uid, exame.team_storage, -1)
                    doPlayerSetStorageValue(player2.uid, exame.team_storage, -1)
                    doPlayerSetStorageValue(player3.uid, exame.team_storage, -1)
                    doPlayerSetStorageValue(player1.uid, exame.storage_x1, 1)
                    doPlayerSetStorageValue(player2.uid, exame.storage_x1, 1)
                    doPlayerSetStorageValue(player3.uid, exame.storage_x1, 1)
                    doTeleportThing(player1.uid, exame.arena_2_pos)
                    doTeleportThing(player2.uid, exame.arena_2_pos)
                    doTeleportThing(player3.uid, exame.arena_2_pos)
                    doTransformItem(item.uid, item.itemid == 1945 and 1946 or 1945, 1)
                    setGlobalStorageValue(2381121, getFighters() + 3)
                else
                    doPlayerSendCancel(cid, "Coloque os pergaminhos na ordem correta!")
                end
            else
                doPlayerSendCancel(cid, "As 3 pessoas devem ser da mesma equipe!")
            end
        else
            doPlayerSendCancel(cid, "Devem ter 3 pessoas para ir para a proxima fase!")
        end
    else
        doPlayerSendCancel(cid, "Voce nao faz parte de nenhuma equipe!")
    end
    return true
end
