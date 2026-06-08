function onCastSpell(cid, var)
  if not isCreature(cid) then
    return true
  end

  noMove(cid, 700)
  local find_area = getFirstCreaturePosOnDirection(cid, 2)
  local pos = getCreaturePosition(cid)
  doAreaCombatHealth(cid, COMBAT_NEHAN, pos, NEHAN, -55, -55, 1)
end