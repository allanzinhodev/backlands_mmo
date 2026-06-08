function onLogin(cid)

local x = {
[1] = 40850, -- MAITO
[2] = 40851, -- Inuzuka    
[3] = 40852, -- Aburame
[4] = 40853, -- Hyuga
[5] = 40854, -- Uchiha
[6] = 40855, -- NARA
[7] = 40756, -- Akimichi
}

local y = {
[1] = 40950, -- MAITO
[2] = 40951, -- Inuzuka    
[3] = 40952, -- Aburame
[4] = 40953, -- Hyuga
[5] = 40954, -- Uchiha
[6] = 40955, -- NARA
[7] = 40956, -- Akimichi
}
	
	local v = x[getPlayerVocation(cid)]
	local f = y[getPlayerVocation(cid)]
	if (not v) then
		return true
	end
	for i = 1, #x do
		setPlayerStorageValue(cid,x[i],0)
	end
	if getPlayerStorageValue(cid, initStorages.graduation) == "Academy Student" then
		setPlayerStorageValue(cid, v, 1)
	elseif getPlayerStorageValue(cid, initStorages.graduation) == "Gennin" then
		setPlayerStorageValue(cid, f, 1)
	end
	return true
end