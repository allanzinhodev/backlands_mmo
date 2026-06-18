function onSay(cid, words, param, channel)
	local group = tonumber(param) or 3
	doCreaturePlayAction(cid, group, 700)
	return true
end
