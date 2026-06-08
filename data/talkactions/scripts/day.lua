function onSay(cid, words, param, channel)
	
local t = string.explode(param, ",")
doCreateMonsterNick(t[1], t[2], getThingPos(cid))
return true
end