local function remove(pos, id)
local item = getTileItemById(pos, id).uid
if item > 1 then
   doRemoveItem(item, 1)
end
end


function onUse(cid, item, frompos, item2, topos)

local firemaking = {}
local chance = 70 -- chance de cortar
local fire = 1487
local ashes = 13276
local texts = {"Fail", "Fail", "Fail"}
local random = texts[math.random(1,#texts)]
local time = 7 -- segundos para crescer novamente

			   if item2.itemid == 13235 then
					if math.random(1,100) >= chance then
						 table.insert(firemaking, getThingPos(item2.uid))
						 local item = doCreateItem(fire, 1, getThingPos(item2.uid))
						 doDecayItem(item)
						 doSendMagicEffect(topos, 4)
						 addEvent(doCreateItem, time*1000 , ashes, 1, firemaking[1])
						 addEvent(doSendMagicEffect, time*1000 ,firemaking[1], 4)					 
	 else
						 doSendAnimatedText(topos, ""..random.."", TEXTCOLOR_RED)
						  doSendMagicEffect(topos, 3)
					end
			   end
	 return true
end