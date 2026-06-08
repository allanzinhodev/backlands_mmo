

function recoveryLifePerSecond(cid, amount, time, totalTime, hTime)
    if not isCreature(cid) then                             
       return true 
    end
    
    if getCreatureHealth(cid) == getCreatureMaxHealth(cid) then
       doPlayerSendCancel(cid,"Your life is full.")
       return true
    end
    
    if hTime == totalTime then
       stopEvent(recoveryLife)
       return true
    end
    
    hTime = hTime + 1
    doCreatureAddHealth(cid, amount)
    recoveryLife = addEvent(recoveryLifePerSecond, time*1000, cid, amount, time, totalTime, hTime)
end
--------------------------------------------------------------------------------
function recoveryManaPerSecond(cid, amount, time, totalTime, mTime)
    if not isCreature(cid) then 
       return true 
    end
    
    if getPlayerMana(cid) == getPlayerMaxMana(cid) then
       doPlayerSendCancel(cid,"Your chakra is full.")
       return true
    end
    
    if mTime == totalTime then
       stopEvent(recoveryMana)
       return true
    end    

    mTime = mTime + 1
    doPlayerAddMana(cid, amount)
    recoveryMana = addEvent(recoveryManaPerSecond, time*1000, cid, amount, time, totalTime, mTime)
end
--------------------------------------------------------------------------------
function recoveryStaminaPerSecond(cid, amount, time, totalTime, sTime)   
    if not isCreature(cid) then
       return true
    end
	
	local actStamina = getPlayerStorageValue(cid,STAMINA_STORAGE)
	local maxStamina = getPlayerStorageValue(cid,STAMINAMAX_STORAGE)   
    
    if actStamina == maxStamina then
       doPlayerSendCancel(cid,"Your stamina is full.")
       return true
    end
    
    if sTime == totalTime then
       stopEvent(recoveryStamina)
       return true
    end 
      
    sTime = sTime + 1
    if (actStamina < maxStamina) then
       addStamina(cid, amount)
       recoveryStamina = addEvent(recoveryStaminaPerSecond, time*1000, cid, amount, time, totalTime, sTime)
    else
        if setStaminaToMax(cid) then
           stopEvent(recoveryStamina)
        end
    end
end
--------------------------------------------------------------------------------
local Food = {
    type = "",
    amount = 0,
    time = 0,
    text = "",
    totalTime = 0,
    uid = 0,
}
--------------------------------------------------------------------------------
function Food:new(type, amount, time, text, totalTime, uid)
    local foods = {
        type = type,
        amount = tonumber(amount),
        time = tonumber(time),
        text = text,
        totalTime = tonumber(totalTime),
        uid = tonumber(uid),
    }

    return setmetatable(foods, {__index = self})
end
--------------------------------------------------------------------------------
function Food:heal(cid)
    if self.type == "health" then
        recoveryLifePerSecond(cid, self.amount, self.time, self.totalTime, 0)
    elseif self.type == "mana" then
        recoveryManaPerSecond(cid, self.amount, self.time, self.totalTime, 0)
    elseif self.type == "stamina" then
        recoveryStaminaPerSecond(cid, self.amount, self.time, self.totalTime, 0)
    end
    doCreatureSay(cid, self.text, TALKTYPE_MONSTER)
return true
end
--------------------------------------------------------------------------------
fds = {
--[food_id] = Food:new("tipo de cura", quantidade, tempo, texto, tempo total),
	[13250] = Food:new("mana", 15, 1, "Yum.", 10), --Cherry
	[13247] = Food:new("health", 15, 1, "Crunch.", 10), --Apple
	[13261] = Food:new("health", 10, 1, "Crunch.", 10), --cheese
    [13264] = Food:new("health", 20, 1, "Crunch.", 10), --Ham
    [13259] = Food:new("mana", 14, 1, "Chomp.", 10), --Bread
    [13262] = Food:new("health", 20, 1, "Yum.", 12), --Orange
    [13263] = Food:new("health", 40, 1, "Delicious.", 10), --Meat
}
--------------------------------------------------------------------------------
local temp = {
exhausted = 70,
storage = 56453434
}
function onUse(cid, item, position, itemEx)
    if not isCreature(cid) then                             
       return true 
    end
    local Foods = fds[item.itemid]
	 if(getPlayerStorageValue(cid, temp.storage) > os.time()) then
		doPlayerSendTextMessage(cid, 24, "You are exhausted, wait " .. getPlayerStorageValue(cid, temp.storage) - os.time() .. ' second' .. ((getPlayerStorageValue(cid, temp.storage) - os.time()) == 1 and "" or "s"))
	    return true
	end
    Foods.uid = item.uid
    Foods:heal(cid)
    doRemoveItem(item.uid, 1)
	setPlayerStorageValue(cid, temp.storage, os.time() + temp.exhausted)
return true
end