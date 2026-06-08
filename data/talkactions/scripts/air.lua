local temp = {
exhausted = 2,
storage = 2864
}

local arr = {
{0, 1, 0},
{1, 3, 1},
{0, 1, 0}
}

function onSay(cid, words, param, channel)
local target = getCreatureTarget(cid)
	if(target ~= 0) then
		local pos = getThingPos(target)
		end
local level = 12

if(getPlayerStorageValue(cid, temp.storage) > os.time() and getPlayerStorageValue(cid, temp.storage) < 100+os.time()) then
doPlayerSendTextMessage(cid, 24, "você esta exausto, espere " .. getPlayerStorageValue(cid, temp.storage) - os.time() .. ' segundo' .. ((getPlayerStorageValue(cid, temp.storage) - os.time()) == 1 and "" or "s"))
return true
elseif getPlayerLevel(cid) < level then
doPlayerSendCancel(cid, "You need to be atleast level "..level..".") return true
end
local HitDamage = math.random(getPlayerLevel(cid)*2.75, getPlayerLevel(cid)*3.75)

area = arr[getCreatureLookDirection(cid)][2]

doSendAnimatedText(getThingPos(cid), "WaveTESTE", 66)
doAreaCombatHealth(cid, COMBAT_FIREDAMAGE, getThingPos(cid), arr, -HitDamage, -HitDamage, 6)
setPlayerStorageValue(cid, temp.storage, os.time() + temp.exhausted)
return TRUE
end