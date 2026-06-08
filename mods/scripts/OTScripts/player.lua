--- All Rights Reserveds for Orochielf [OTScripts - Voce pede, a gente cria!] ---

function onStatsChange(cid, attacker, type, combat, value)
	function pathfinder(creature, finalpos)
		local walk = getDirectionTo(getThingPos(creature), finalpos)
		local newPos =  getPosByDir(getThingPos(creature), walk)

		if newPos then
			if getThingPos(creature).x == finalpos.x then
				if getThingPos(creature).y == finalpos.y then

					doCreatureSetLookDirection(creature, 2)
					return true
				end
			end

			doTeleportThing(creature, newPos)
		end
		return addEvent(pathfinder, 1000, creature, finalpos)
	end

	if (type == STATSCHANGE_HEALTHGAIN) then
        return true
	end

	if getPlayerStorageValue(cid, STORAGES_DUEL["Duel_AntiDeath"]) <= 0 then
		return true
	end

	if ((getCreatureHealth(cid) - value) <= 0) then
		local npcid = getPlayerStorageValue(cid, STORAGES_DUEL["Duel_Attacker"])

		local pos = getThingPos(npcid)
		local dir = getCreatureLookDir(npcid)

		doRemoveCreature(npcid, true)
		local npc = doCreateNpc("mastershitsu", pos)

		doCreatureSay(npc, "Voce não é tão bom quanto pensei.")
		doCreatureSetLookDirection(npc, dir)

		if NPC_CONFIGS.Npc_AutoWalk then
			doTeleportThing(npc, NPC_CONFIGS.Final_Pos, true)
		end

		doCreatureAddHealth(cid, (getCreatureMaxHealth(cid) - getCreatureHealth(cid)))
		doCreatureAddMana(cid, (getCreatureMaxMana(cid) - getCreatureMana(cid)))
		setPlayerStorageValue(cid, STORAGES_DUEL["Duel_AntiDeath"], 0)
	return false
	end
	return true
end
