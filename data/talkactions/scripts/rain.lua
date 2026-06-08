function onSay(cid, words, param, channel)
function startRain(cid)
	if not isCreature(cid) then return true end
doSendMagicEffect({x = getThingPos(cid).x,y = getThingPos(cid).y,z = getThingPos(cid).z}, 39)
doSendMagicEffect({x = getThingPos(cid).x+2,y = getThingPos(cid).y,z = getThingPos(cid).z}, 39)
	addEvent(startRain, 500, cid)
end
startRain(cid)
end
