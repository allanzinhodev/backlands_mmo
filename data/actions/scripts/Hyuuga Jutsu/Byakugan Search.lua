local radiusx = 20
local radiusy = 20
local stack = 253

function getMonstersfromArea(cid, pos, radiusx, radiusy, stack)
local monsters = { } 
local starting = {x = (pos.x - radiusx), y = (pos.y - radiusy), z = pos.z, stackpos = stack} 
local ending = {x = (pos.x + radiusx), y = (pos.y + radiusy), z = pos.z, stackpos = stack} 
local checking = {x = starting.x, y = starting.y, z = starting.z, stackpos = starting.stackpos} 
repeat 

local posTile = {x = checking.x, y = checking.y, z = checking.z}
if getTileThingByPos(posTile).uid ~= 0 then
	creature = getThingfromPos(checking)
	if creature.itemid > 0 then 
    	if isCreature(creature.uid) == TRUE then
        	table.insert (monsters, creature.uid) 
    	end 
	end
end

if checking.x == pos.x-1 and checking.y == pos.y then 
    checking.x = checking.x+2 
else 
    checking.x = checking.x+1 
end 
if checking.x > ending.x then 
    checking.x = starting.x 
    checking.y = checking.y+1 
end 
until checking.y > ending.y 
return monsters 
end 

function ByakuganSearch(cid)
        if not isCreature(cid) then
                return true
		end
if getPlayerStorageValue(cid, sto_byakugan[3]) == 0 then
monster_table = getMonstersfromArea(cid, getPlayerPosition(cid), radiusx, radiusy, stack)

if #monster_table >= 0 then
	for i = 1, #monster_table do
		local monsterBya = monster_table[i]
		local PosBya = getCreaturePosition(monsterBya)
        if isCreature(monsterBya) and monsterBya ~= cid then
            local peo = {x = PosBya.x, y = PosBya.y, z = PosBya.z}
            doPlayerAddMapMark(cid, peo, 19, "name:" ..getCreatureName(monsterBya).. "|HP:"..getCreatureHealth(monsterBya).."/"..getCreatureMaxHealth(monsterBya).."|CP:"..getCreatureMana(monsterBya).."/"..getCreatureMaxMana(monsterBya).."")
        end
    end
end
addEvent(function()
doSendPlayerExtendedOpcode(cid, 108, peo)
if not isCreature(cid) then return true end 
end,1500)

addEvent(ByakuganSearch, 1000, cid)
end
end

function onUse(cid, toPostion)
        if not isCreature(cid) then
                return true
		end
-----[Restrições]-----
        if checkCmd(cid, "rest") then
                return doPlayerSendCancel(cid, "you cannot use jutsu while you are resting.")
        end
        if checkCmd(cid, "mold") then
                return doPlayerSendCancel(cid, "you cannot use jutsu while you are mold chakra")
        end
        if checkJutsu(cid, "Kagemane") then
                return doPlayerSendCancel(cid, "you cannot use jutsu")
        end
        if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
            return doPlayerSendCancel(cid, "Sorry this is not possible.")       
        end
-----[Restrições]----- 
if getPlayerStorageValue(cid, sto_byakugan[6]) == 0 then
if getPlayerStorageValue(cid, sto_byakugan[4]) == 1 and isPlayer(cid) then
                if getPlayerStorageValue(cid, initStorages.graduation) == "Academy Student" then
                actionMove(cid, 594, 300)
                elseif getPlayerStorageValue(cid, initStorages.graduation) == "Gennin" then
                actionMove(cid, 376, 300)
                end
                setPlayerStorageValue(cid, sto_byakugan[4], 0)
				setPlayerStorageValue(cid, sto_byakugan[3], 0)
				ByakuganSearch(cid)
                doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Byakugan Search Mode: Activated!")
                doSendPlayerExtendedOpcode(cid, 124, "Inverted")
                setPlayerStorageValue(cid, sto_byakugan[5], 0)
                removeChakra(cid, 1, 2, sto_byakugan[5], "sharingan")
				doCreatureSay(cid, "Byakugan Search!", TALKTYPE_MONSTER)
else
				doPlayerSendCancel(cid, "You cannot use.") 
end
else
	doPlayerSendCancel(cid, "Activate your byakugan.")
end
return true
  end