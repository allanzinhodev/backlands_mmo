function onStepIn(cid, item, position, fromPosition)
local protection = getConfigValue('protectionLevel')
    if(getPlayerLevel(cid) < protection) then
        doTeleportThing(cid, fromPosition, true)
        doPlayerSendCancel(cid, "Desculpe, mas só ninja level "..protection.."+ podem usar o depot.") 
        return false
    end
    return true
end