function onUse(cid, item, fromPosition, itemEx, toPosition)

local a = 984162

	if getPlayerStorageValue(cid, a) < 1 then
		doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Voce completou a quest.")
		doPlayerAddItem(cid, 13036, 10)
		doPlayerAddItem(cid, 13037, 5)
		doPlayerAddItem(cid, 11473, 6)
		doPlayerAddItem(cid, 2148, 70)
		doPlayerAddExp(cid,7000)
		doPlayerSetStorageValue(cid, a, 1)
	else
		doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "It is empty.")
	end

	return true
end