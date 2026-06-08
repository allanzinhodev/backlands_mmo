function onUse(cid, item, fromPosition, itemEx, toPosition)

a = 9595

if getPlayerStorageValue(cid, a) < 1 then
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Voce completou a quest.")
doPlayerAddItem(cid, 13227, 7)
doPlayerAddItem(cid, 2148, 80)
doPlayerAddExp(cid,800)
doPlayerSetStorageValue(cid, a, 1)
else
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "It is empty.")
end

return TRUE
end