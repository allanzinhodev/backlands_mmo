function onStatsChange(cid, attacker, type, combat, value)
dmg = value
-----[ KAGEMANE ]------
if isMonster(cid) or isPlayer(attacker) or isPlayer(cid) then
---------------------------
-----[ Damage Color ]------
   if combat == COMBAT_JUUKEN then
   doSendAnimatedText(getThingPos(cid), "".. dmg .."", COLOR_LIGHTBLUE)
   elseif combat == COMBAT_KIKAICHUU then
   doSendAnimatedText(getThingPos(cid), "".. dmg .."", COLOR_LIGHTGREEN)
   elseif combat == COMBAT_RESISTENCE then
   doSendAnimatedText(getThingPos(cid), "".. dmg .."", COLOR_RED)
   elseif combat == COMBAT_NEHAN then
   doSendAnimatedText(getThingPos(cid), "".. dmg .."", COLOR_WHITE)
   setPlayerStorageValue(cid, sto_gen[5], os.time() + 7)
   setPlayerStorageValue(cid, sto_gen[3], 0)
   Nehan(cid, 7, 131, sto_gen[3])
   end
end
-----[ Damage Color ]------

-----[ Juuken Ryuu ]------
if isPlayer(attacker) and getPlayerStorageValue(attacker, 9997) == 1 and getPlayerVocation(attacker) == 4 then
   if combat == COMBAT_PHYSICALDAMAGE then
 actionMove(attacker, 378, 200)
                        if isMonster(attacker) then
                       dmg = value*0.4
                       local maxdmg = math.ceil(dmg)
                       doTargetCombatHealth(attacker, cid, COMBAT_JUUKEN, -maxdmg, -maxdmg, 1)
					    elseif isPlayer(cid) then
                        dmg = value*0.2
                      local maxdmg = math.ceil(dmg)
                        doPlayerAddMana(cid, -maxdmg) 
                      end
  end
end

----MONSTER BLOCK SYSTEM----
if isPlayer(attacker) then
  if type == STATSCHANGE_HEALTHLOSS and isMonster(cid) then
    if math.random(1, 100) <= 4 then
         doSendAnimatedText(getCreaturePosition(cid), "Block..",COLOR_GREY)
         return false   
    end
  end
end

if isPlayer(cid) then
   ----[Invunerable System]----
   if getPlayerStorageValue(cid, STORAGE_DEFENSE) == 1 then
	doSendAnimatedText(getCreaturePosition(cid), "Def -".. value .."", 173)
   return false
   end
   ----[BLOCK]----
if type == STATSCHANGE_HEALTHLOSS and isPlayer(cid) and isPlayer(attacker) or isMonster(attacker) then
   local ChanceBlock = math.random(1, 700)
   local ChanceBKHit = getPlayerSkill(cid, 5)
   if ChanceBlock <= ChanceBKHit then
   doSendAnimatedText(getCreaturePosition(cid), "Block..",COLOR_GREY)    
      return false  
  end
----------[EVASION]----------
   local ChanceEva = math.random(1, 700)
   local ChanceEvHit = getPlayerSkill(cid, 6)
   if ChanceEva <= ChanceEvHit then
   doSendAnimatedText(getCreaturePosition(cid), "Evasion..", COLOR_GREEN)
      return false  
    end
end
end
------ Sharingan ------ 
if isPlayer(cid) and getPlayerVocation(cid) == 5 then
      ----[Sharingan level 1]----      
      if math.random(1,500) <= getPlayerLevel(cid) and getPlayerStorageValue(cid, 9999) <= 0 then
	  doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Congratulations! You released the Sharingan Level 1!")
	  setPlayerStorageValue(cid, 9999, 1)
	  if getPlayerItemCount(cid, 13340) == 1 then
	  local item = getPlayerItemById(cid, true, 13340)
	  doTransformItem(item.uid, 11446)
      ----[Sharingan level 1]---- 
      end
end	  
      ----[Sharingan level 2]----                                                                                                
if getPlayerStorageValue(cid, 9998) >= 1000 and getPlayerLevel(cid) >= 10 and getPlayerVocation(cid) == 5 and getCreatureHealth(cid) <= (0.4*getCreatureMaxHealth(cid))
      and getPlayerStorageValue(cid, 9999) == 1 and math.random(1,100) == 1 then 
      doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Congratulations! You released the Sharingan Level 2!")
      setPlayerStorageValue(cid, 9999, 2)
      setPlayerStorageValue(cid, 9998, 0)
	if(getPlayerItemCount(cid, 13341) == 1) then
	  local item = getPlayerItemById(cid, true, 13341)
	  doTransformItem(item.uid, 11447)
      ----[Sharingan level 2]----    
    end
end
      ----[Sharingan level 3]----    
if getPlayerStorageValue(cid, 9998) >= 2000 and getPlayerLevel(cid) >= 20 and getPlayerVocation(cid) == 5 and getPlayerStorageValue(cid, 9999) == 2 
      and getCreatureHealth(cid) <= (0.4*getCreatureMaxHealth(cid)) and getPlayerStorageValue(cid, 9999) == 2 and math.random(1,300) == 1 then 
      doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Congratulations! You released the Sharingan Level 3!")
	  setPlayerStorageValue(cid, 9999, 3)
      setPlayerStorageValue(cid, 9998, 0)
	if(getPlayerItemCount(cid, 13342) == 1) then
	  local item = getPlayerItemById(cid, true, 13342)
	  doTransformItem(item.uid, 11475)
      ----[Sharingan level 3]----    
	end
end
      ----[Mangekyou Sharingan]----    
if getPlayerStorageValue(cid, 9998) >= 3000 and getPlayerLevel(cid) >= 80 and getPlayerVocation(cid) == 5 and getCreatureHealth(cid) < 50 
      and getPlayerStorageValue(cid, 9999) == 3 and math.random(1,100) == 1 then 
      doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, "Congratulations! You released the Mangekyou Sharingan!")
      setPlayerStorageValue(cid, 9999, 4)
      setPlayerStorageValue(cid, 9998, 0)
	  if(getPlayerItemCount(cid, 13368) == 1) then
	  local item = getPlayerItemById(cid, true, 13368)
	  doTransformItem(item.uid, 11476)
      ----[Mangekyou Sharingan]----   
      end
end
------ Sharingan ------ 
------ Genjutsu ------
    if getPlayerStorageValue(cid, 9998) >= 1 and getPlayerStorageValue(cid, 9999) == 2 and getPlayerVocation(cid) == 5 and getPlayerStorageValue(cid, 9922) <= 0 then 
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Congratulations! You released the genjutsu Kanashibari")
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Kanashibari) Menu->Jutsus->Genjutsus")
		if(getPlayerItemCount(cid, 13444) == 1) then
		local item = getPlayerItemById(cid, true, 13444)
			doTransformItem(item.uid, 11460)
		end
		setPlayerStorageValue(cid, 9922, 1)
	end
   if getPlayerVocation(cid) == 5 and getPlayerStorageValue(cid, 9999) == 3 and math.random(1,100) == 70 and  getPlayerStorageValue(cid, 9919) <= 0 then 
      doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Congratulations! You released the genjutsu Kaen")
      doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Voce aprendeu um novo jutsu! (Kaen) Menu->Jutsus->Genjutsus")
	   if(getPlayerItemCount(cid, 13445) == 1) then
	       local item = getPlayerItemById(cid, true, 13445)
	       doTransformItem(item.uid, 11462)
      end
        setPlayerStorageValue(cid, 9919, 1)
    end
return true
end
return true
end