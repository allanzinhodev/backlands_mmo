function onAdvance(cid, skill, oldLevel, newLevel)
if(oldLevel < newLevel and skill == SKILL__LEVEL) then
      local qtdLvl = newLevel-oldLevel
      local stoAdv = getPlayerStorageValue(cid, levelUpStorages.advance)
      local stoPnt = getPlayerStorageValue(cid, sto_resetPoints)
      local mqtdLvl = qtdLvl*3
           
      if stoAdv >= newLevel then return true end
      if stoPnt == -1 then setPlayerStorageValue(cid, sto_resetPoints, 0) stoPnt = 0 end
       
      if oldLevel < stoAdv and newLevel > stoAdv then
         qtdLvl = newLevel-stoAdv
      end      
       
      setPlayerStorageValue(cid, levelUpStorages.advance, newLevel)
      doPlayerAddSoul(cid, qtdLvl*3)
      setPlayerStorageValue(cid, sto_resetPoints, stoPnt+(qtdLvl*3))
      --print(getPlayerStorageValue(cid, sto_resetPoints))  
      doPlayerSendTextMessage(cid, 20, "You have earned "..mqtdLvl.." skill and jutsu points. Please go to Ninja Info to distribute them.")
      doPlayerSave(cid)
   end
   return true
end