function onSay(cid, words, param, channel)
local ManaSTO = 7002
local QtdeMana = getPlayerStorageValue(cid, ManaSTO) 
local KnowledgeSTO = 7003
local QtdeKnowledge = getPlayerStorageValue(cid, KnowledgeSTO)
local IntSTO = 7004
local QtdeInt = getPlayerStorageValue(cid, IntSTO)  
if param == "" then
doPlayerSendTextMessage(cid, 27, "Voce precisa usar algum parametro como: #status magic")
return true
end

if isInArray({"magic"}, param) then
if getPlayerMagLevel(cid) ~= 150 then
doPlayerSendTextMessage(cid,22,"you have reached the maximum level in magic level.")
return true
end
if getPlayerSoul(cid) >= 3 then
doPlayerAddMagLevel(cid, 1)
doPlayerAddSoul(cid, -1)
doSendMagicEffect(getThingPos(cid), 30)
doSendAnimatedText(getThingPos(cid), "UPGRADE", 100) 
doPlayerSendTextMessage(cid,22,"You're now better at magic level ["..getPlayerMagLevel(cid).."].")
else
doPlayerSendTextMessage(cid, 27, "você precisa ter 3 pontos.")
return true
end
end
if isInArray({"magic energy"}, param) then
if getPlayerStorageValue(cid, ManaSTO) ~= 150 then
doPlayerSendTextMessage(cid,22,"you have reached the maximum level in magic energy.")
return true
end
if getPlayerSoul(cid) >= 2 then
setCreatureMaxMana(cid, getCreatureMaxMana(cid) + 5)
setPlayerStorageValue(cid, ManaSTO, QtdeMana+1)
doPlayerAddSoul(cid, -2)
doSendMagicEffect(getThingPos(cid), 30)
doSendAnimatedText(getThingPos(cid), "UPGRADE", 100)
doPlayerSendTextMessage(cid,22,"You're now better at magic energy ["..getPlayerStorageValue(cid, ManaSTO).."].") 
else
doPlayerSendTextMessage(cid, 27, "você ainda não tem pontos.")
return true
end
end
if isInArray({"knowledge"}, param) then
if getPlayerStorageValue(cid, KnowledgeSTO) ~= 150 then
doPlayerSendTextMessage(cid,22,"you have reached the maximum level in knowledge.")
return true
end
if getPlayerSoul(cid) >= 2 then
setPlayerStorageValue(cid, KnowledgeSTO, QtdeKnowledge+1)
doPlayerAddSoul(cid, -2)
doSendMagicEffect(getThingPos(cid), 30)
doSendAnimatedText(getThingPos(cid), "UPGRADE", 100)
doPlayerSendTextMessage(cid,22,"You're now better at knowledge ["..getPlayerStorageValue(cid, KnowledgeSTO).."].")  
else
doPlayerSendTextMessage(cid, 27, "você ainda não tem pontos.")
return true
end
end
if isInArray({"intelligence"}, param) then
if getPlayerStorageValue(cid, IntSTO) ~= 150 then
doPlayerSendTextMessage(cid,22,"you have reached the maximum level in Intelligence.")
return true
end
if getPlayerSoul(cid) >= 2 then
setPlayerStorageValue(cid, IntSTO, QtdeInt+1)
doPlayerAddSoul(cid, -1)
doSendMagicEffect(getThingPos(cid), 30)
doSendAnimatedText(getThingPos(cid), "UPGRADE", 100)
doPlayerSendTextMessage(cid,22,"You're now better at intelligence ["..getPlayerStorageValue(cid, IntSTO).."].")  
else
doPlayerSendTextMessage(cid, 27, "você ainda não tem pontos.")
return true
end
end
return true
end