local check_clock = os.clock()
local check_interval = 0.5
function onThink(cid, interval)
local Player = getPlayerStorageValue(cid, PLAYERSTORAGE)
if Player > 0 then
   if getPlayerNoMove(Player) == false then  
      doPlayerSetNoMove(Player, false)
      setPlayerStorageValue(Player, PEIXESTORAGE, 0)
      return true
   end
end   

if (os.clock() - check_clock) > check_interval then 

   local Px = getPlayerStorageValue(cid, PLAYERPOSX)
   local Py = getPlayerStorageValue(cid, PLAYERPOSY)
   local Pz = getPlayerStorageValue(cid, PLAYERPOSZ)
   local pos = {x=Px, y=Py, z=Pz} 

   local posPlayer = getCreaturePosition(cid)
   local ForcaAdd = getDistanceBetween(posPlayer, pos)

   local vidaAtual = getCreatureHealth(cid)
   local Forca = math.random(1, math.floor(vidaAtual/4)+1)

   doCreatureAddHealth(cid, (Forca+ForcaAdd))
--   doMoveCreature(cid, getDirectionTo(pos, posPlayer))

   if getDistanceBetween(pos, posPlayer) >= 7 then
      if getPlayerStorageValue(cid, PLAYERSTORAGE) > 0 then 
         doPlayerSetNoMove(getPlayerStorageValue(cid, PLAYERSTORAGE), false)
         setPlayerStorageValue(getPlayerStorageValue(cid, PLAYERSTORAGE), PEIXESTORAGE, 0)
         doRemoveCreature(cid)
      end   
      return true
   end   

   check_clock = os.clock()
end
return true
end