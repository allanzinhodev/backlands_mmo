local vocs = {
      [0] = "None",
      [1] = "Maito",
      [2] = "Inuzuka",
      [3] = "Aburame",
      [4] = "Hyuuga",
      [5] = "Uchiha",
      [6] = "Nara",
      [7] = "Akimichi",
}
 
function onLook(cid, thing, position, lookDistance)

	local desc = {}

	if isPlayer(thing.uid) then
		pName = getPlayerName(thing.uid)               
		pLevel = getPlayerLevel(thing.uid)             
		if (getPlayerSex(thing.uid) == 1) then         
			pGender = "He"                        
		elseif (getPlayerSex(thing.uid) == 0) then     
			pGender = "She"                       
		end                                      
		pVoc = vocs[getPlayerVocation(thing.uid)]
		pGrad = getPlayerStorageValue(thing.uid, initStorages.graduation) 
		if (thing.uid == cid) then
			if(pGrad ~= -1) then                                                            
				table.insert(desc, "You see yourself. You are "..pGrad.." from clan "..pVoc..".")
			else
				table.insert(desc, "You see yourself. You are a player with error.\n(Contact a GM)")    
				return true
			end
            if(getPlayerGuildId(cid) > 0) then
                table.insert(desc, " You are ".. getPlayerGuildRank(cid) .." of the " .. getPlayerGuildName(cid))
                if(getPlayerGuildNick(cid) ~= "") then
                    table.insert(desc, " (" .. getPlayerGuildNick(cid) .. ").")
                else
                    table.insert(desc, ".")
                end
            end            
		else
    		if isPlayer(thing.uid) then		
    			if(pGrad ~= -1) then                         
    				table.insert(desc, "You see "..pName.." (Level "..pLevel.."). "..pGender.." is "..pGrad.." from clan "..pVoc..".")
    			else
    				table.insert(desc, "You see "..pName.." (Level "..pLevel.."). "..pGender.." is a player with error.\n(Contact a GM)")    
    				return true
    			end
    			if(getPlayerGuildId(thing.uid) > 0) then
                    table.insert(desc," " ..pGender.. " is " .. getPlayerGuildRank(thing.uid) .. " of the " .. getPlayerGuildName(thing.uid))
                    if(getPlayerGuildNick(cid) ~= "") then
                        table.insert(desc, " (" .. getPlayerGuildNick(thing.uid) .. ").")
                    else
                        table.insert(desc, ".")
                    end
                end
    		end
		end
		doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, table.concat(desc))
		return false
	else
		return true
	end
	return true
end