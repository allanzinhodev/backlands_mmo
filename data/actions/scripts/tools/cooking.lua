local configs = {
   fire = {1487},
                 --ham          --meat
   foods = { {13254, 13264}, {13257, 13263} },
         --{id cru, id assado}
   chance = 70
}

--END Configs--
function onUse(cid, item, frompos, item2, topos)
if isPremium(cid) then
   if isInArray(configs.fire, item2.itemid) then
      for _, tabs in ipairs(configs.foods) do
         if item.itemid == tabs[1] then
            if math.random(100) <= configs.chance then
               doRemoveItem(item.uid, 1)
               doSendMagicEffect(topos, 4) 
               doCreateItem(tabs[2], 1, topos)
               doPlayerSay(cid, "I got a food", 1)
            else
               doSendMagicEffect(topos, 4)
               doRemoveItem(item.uid, 1)
               doPlayerSay(cid,"Oh no burned!!", 1)
            end
         end
      end
   end
else
doPlayerSendCancel(cid, "Voce precisa ser um jogador premium account para cozinhar.")
end   
return true
end