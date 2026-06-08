function onKill(cid, target) 
    if isPlayer(target) == TRUE then 
       pid = cid
       pid1 = getPlayerGUID(cid) 
       pid2 = getPlayerGUID(target)
       local result_target = db.getResult("SELECT * FROM `bounty_hunters` WHERE `sp_id` = "..pid2.." AND `bounty` > 0;")
       local result_killer = db.getResult("SELECT * FROM `bounty_hunters` WHERE `sp_id` = "..pid1.." AND `bounty` >= 0;")
       if(result_target:getID() ~= -1) and (getPlayerStorageValue(cid, 8877) == 1) and (getPlayerStorageValue(cid, 8875) == result_target:getDataInt("sp_id")) then
           prize = tonumber(result_target:getDataInt("prize"))
           bid = tonumber(result_target:getDataInt("id"))
           bounty = tonumber(result_target:getDataInt("bounty"))-1
	       result_target:free()
	       check = 0
       elseif(result_killer:getID() ~= -1) then
           bid = tonumber(result_killer:getDataInt("id"))
           bounty = tonumber(result_killer:getDataInt("bounty"))+1
           prize = bounty*3
           check = 1
           doCreatureSetSkullType(cid,SKULL_WHITE)
           db.query("UPDATE `bounty_hunters` SET  `prize` = "..prize..", `bounty` = "..bounty..", `k_id`="..getPlayerGUID(cid)..", `kill_time` = " .. os.time() .. " WHERE `id` = "..bid..";")                         
       else
          prize = 3
          bid = 0
          check = 2
          
          if not (getCreatureSkullType(target) >= SKULL_WHITE) then
            db.query("INSERT INTO `bounty_hunters` VALUES (NULL,"..getPlayerGUID(cid)..","..getPlayerGUID(target).."," .. os.time() .. ","..prize..",1,0);")
          end
       end 
       if (bid ~= 0 and check == 0 and not(getTileInfo(getCreaturePosition(cid)).pvp)) then
          setPlayerStorageValue(cid, 8876, prize)
          db.query("DELETE FROM `bounty_hunters` WHERE `id` = "..bid..";")
          setPlayerStorageValue(cid, 8877, 2)
	      doPlayerSendTextMessage(cid,MESSAGE_STATUS_CONSOLE_ORANGE,"[Bounty System]: You killed "..getPlayerName(target).."! Go to Hokuro to get your reward!")
	      doSendMagicEffect(getCreaturePosition(cid), 27) 
       end
    end 
    return TRUE
end