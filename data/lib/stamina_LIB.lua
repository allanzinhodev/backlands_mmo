STAMINA_STORAGE = 200
STAMINAMAX_STORAGE = 201

function setStaminaToMax(cid)
setPlayerStorageValue(cid, STAMINA_STORAGE, getPlayerStorageValue(cid, STAMINAMAX_STORAGE))
	local values = ""..getPlayerStorageValue(cid, STAMINA_STORAGE).."/"..getPlayerStorageValue(cid, STAMINAMAX_STORAGE)..""	
	doSendPlayerExtendedOpcode(cid, 53, values)	
end

function addStamina(cid, value)
if not isCreature(cid) then return true end
    actStamina = getPlayerStorageValue(cid,STAMINA_STORAGE)
	setPlayerStorageValue(cid, STAMINA_STORAGE, actStamina+value)
	local values = ""..getPlayerStorageValue(cid, STAMINA_STORAGE).."/"..getPlayerStorageValue(cid, STAMINAMAX_STORAGE)..""	
	doSendPlayerExtendedOpcode(cid, 53, values)	
end

function setStaminaStorage(cid)
	setPlayerStorageValue(cid, STAMINA_STORAGE, getPlayerStorageValue(cid,STAMINA_STORAGE))
	local values = ""..getPlayerStorageValue(cid, STAMINA_STORAGE).."/"..getPlayerStorageValue(cid, STAMINAMAX_STORAGE)..""	
	doSendPlayerExtendedOpcode(cid, 53, values)	
end

function addStaminaPerSecond(cid, percent, time, storage)
	if not isCreature(cid) then
		return true
	end
   if (getPlayerStorageValue(cid, storage) < 1) then
       actStamina = getPlayerStorageValue(cid,STAMINA_STORAGE)
    maxStamina = getPlayerStorageValue(cid,STAMINAMAX_STORAGE)
	if (actStamina < maxStamina) then
		addStamina(cid, percent)
		stamEvent = addEvent(addStaminaPerSecond, time*1000, cid, percent, time, storage)
	else
	if setStaminaToMax(cid) then
	    stopEvent(stamEvent)
    end
	end
end
end

function setMaxStamina(cid, value)
    if not isCreature(cid) then                             
       return true 
    end
    maxStamina = getPlayerStorageValue(cid,STAMINAMAX_STORAGE)
	setPlayerStorageValue(cid, STAMINAMAX_STORAGE, maxStamina+value)
	local values = ""..getPlayerStorageValue(cid, STAMINA_STORAGE).."/"..getPlayerStorageValue(cid, STAMINAMAX_STORAGE)..""	
	doSendPlayerExtendedOpcode(cid, 53, values)	
end


function removeStamina(cid, percent, time, storage, type)
    if not isCreature(cid) then
       return true
    end

    if (getPlayerStorageValue(cid, storage) < 1) then
       if type == "Run" then
          if getPlayerStorageValue(cid, STAMINA_STORAGE) >= 1 then
             addStamina(cid, -percent)
             remEvent = addEvent(removeStamina, time*1000, cid, percent, time, storage, type)
          else
             setPlayerStorageValue(cid, STAMINA_STORAGE, 0)
             doCreatureAddHealth(cid, -percent)
             doSendAnimatedText(getCreaturePosition(cid), percent, COLOR_RED)
             remEvent = addEvent(removeStamina, time*1000, cid, percent, time, storage, type)
          end
       elseif getPlayerStorageValue(cid, STAMINA_STORAGE) >= 1 then
             addStamina(cid, -percent)
             remEvent = addEvent(removeStamina, time*1000, cid, percent, time, storage, type)
       end
    else
       stopEvent(remEvent)
    end
end

function removeStaminaLife(cid, percent)
    if not isCreature(cid) then                             
       return true 
    end
    remove = percent
    if not isCreature(cid) then
       return true
    end

          if getPlayerStorageValue(cid, STAMINA_STORAGE) >= 1 then
             addStamina(cid, remove)
          else
             setPlayerStorageValue(cid, STAMINA_STORAGE, 0)
             doCreatureAddHealth(cid, remove)
			 doSendMagicEffect(getThingPos(cid), 0)
             doSendAnimatedText(getCreaturePosition(cid), remove, COLOR_RED)
			 return true
          end
       end

	   
	   
function removeStaminaSecondLife(cid, percent, time, storage)
    remove = percent
    if not isCreature(cid) then
       return true
    end
if (getCreatureStorage(cid, storage) < 1) then
	if getPlayerStorageValue(cid, STAMINA_STORAGE) >= 1 then
             addStamina(cid, remove)
          else
             setPlayerStorageValue(cid, STAMINA_STORAGE, 0)
             doCreatureAddHealth(cid, remove)
			 doSendMagicEffect(getThingPos(cid), 0)
             doSendAnimatedText(getCreaturePosition(cid), remove, COLOR_RED)
          end
			addEvent(removeStaminaSecondLife, time*1000, cid, percent, time, storage)
	end
    end	   	  

function removeStaminaSecondTwoLife(cid, percent, time, storage)
    remove = percent
    if not isCreature(cid) then
       return true
    end
if (getCreatureStorage(cid, storage) == 1) then
	if getPlayerStorageValue(cid, STAMINA_STORAGE) >= 1 then
             addStamina(cid, remove)
          else
             setPlayerStorageValue(cid, STAMINA_STORAGE, 0)
             doCreatureAddHealth(cid, remove)
			 doSendMagicEffect(getThingPos(cid), 0)
             doSendAnimatedText(getCreaturePosition(cid), remove, COLOR_RED)
          end
			addEvent(removeStaminaSecondTwoLife, time*1000, cid, percent, time, storage)
	end
    end	 	
	   
function removeChakraLife(cid, percent)
  remove = percent
  if not isCreature(cid) then return true end

  if getPlayerMana(cid) >= -percent then
    doPlayerAddMana(cid, remove)
  else
    doCreatureAddHealth(cid, remove)
    doSendMagicEffect(getThingPos(cid), 0)
    doSendAnimatedText(getCreaturePosition(cid), remove, COLOR_RED)
    doPlayerSendCancel(cid, "Care, you don't have chakra.")
    return true
  end
end
