local config = {
	waters = {4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625, 4665, 4666, 4820, 4821, 4822, 4823, 4824, 4825},
}
function onUse(cid, item, fromPosition, itemEx, toPosition)
	if not isInArray(config.waters, itemEx.itemid) then
		doSendMagicEffect(toPosition, CONST_ME_LOSEENERGY)
		return doPlayerSendCancel(cid, "Use apenas em rios.")
	end
	
	local chance = math.random(1,100)
	
	if chance <= 70 then
	    doPlayerAddItem(cid, 12668, 1)
	    doSendMagicEffect(fromPosition, 3)
	    doPlayerSendTextMessage(cid,24,"Você está ajudando a limpar os rios, continue assim!")
    else
        doPlayerSendTextMessage(cid,24,"Você não encontrou nada, continue tentando.")
    end
end        