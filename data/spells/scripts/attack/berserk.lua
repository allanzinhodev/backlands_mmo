local area = {
{0,0,0},
{0,3,0},
{0,0,0},
}

function onDash(cid)
 local poslook = getCreatureLookPosition(cid)
 poslook.stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE
     if isWalkable(poslook, false, false, false) then
     if not isCreature(getThingfromPos(poslook).uid) then
          doMoveCreature(cid, getPlayerLookDirection(cid))
          doSendMagicEffect(getPlayerPosition(cid), 2)
     return TRUE
      else
          doMoveCreature(cid, getPlayerLookDirection(cid))
          doAreaCombatHealth(0, 1, poslook, area, -getCreatureSpeed(cid)*2/(getCreatureHealth(cid)/300), -getCreatureSpeed(cid)*3/(getCreatureHealth(cid)/30), 9)
          doCreatureSay(getThingfromPos(poslook).uid, 'Auch', TALKTYPE_MONSTER)
          doSetItemOutfit(getThingfromPos(poslook).uid, 2317, 1*1000)
          doSendMagicEffect(getCreaturePosition(getThingfromPos(poslook).uid), 31)
     return TRUE
      end
       end
       end


function onCastSpell(cid, var)
local distance = 8

      for i = 0, distance do
      addEvent(onDash,90*i,cid)
       end
        return TRUE
        end 

function isWalkable(pos, creature, proj, pz)-- by Nord
    if getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid == 0 then return false end
    if getTopCreature(pos).uid > 0 and creature then return false end
    if getTileInfo(pos).protection and pz then return false, true end
    local n = not proj and 3 or 2
    for i = 0, 255 do
        pos.stackpos = i
        local tile = getTileThingByPos(pos)
        if tile.itemid ~= 0 and not isCreature(tile.uid) then
            if hasProperty(tile.uid, n) or hasProperty(tile.uid, 7) then
                return false
            end
        end
    end
    return true
end  