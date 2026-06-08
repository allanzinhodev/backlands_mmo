function onUse(cid, item, fromPosition, itemEx, toPosition)
    if getTilePzInfo(getPlayerPosition(cid)) == FALSE then
        doCreateItem(11474, 1, toPosition)
        doRemoveItem(item.uid, 1)
    else
        doPlayerSendCancel(cid, 'You cannot use this in PZ.') 
        return true
    end
end