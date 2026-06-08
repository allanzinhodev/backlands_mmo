--- All Rights Reserveds for Orochielf [OTScripts - Voce pede, a gente cria!] ---

function onPrepareDeath(cid)
	local pos = getThingPos(cid)
	local dir = getCreatureLookDir(cid)

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

	local message = NPC_MESSAGES["Win Duel"]

	if message:find("pn") then
		message = string.gsub(message, "pn", getCreatureName(getGlobalStorageValue(12344)))
	end


	local npc = doCreateNpc("masterShitsu", pos)
	doCreatureSetLookDirection(npc, dir)
	doCreatureSay(npc, message)

	if NPC_CONFIGS.Npc_AutoWalk then

		addEvent(pathfinder, 1000, npc, NPC_CONFIGS.Final_Pos)
	else

		doTeleportThing(npc, NPC_CONFIGS.Final_Pos, true)
	end

	setPlayerStorageValue(getGlobalStorageValue(STORAGES_DUEL["Player"]), STORAGES_DUEL["Duel"], 1)
	setPlayerStorageValue(getGlobalStorageValue(STORAGES_DUEL["Player"]), STORAGES_DUEL["Duel_AntiDeath"], 0)

	for a = 1, #NPC_REWARD_ITEMS do

		doPlayerAddItem(getGlobalStorageValue(STORAGES_DUEL["Player"]), NPC_REWARD_ITEMS[a].id, NPC_REWARD_ITEMS[a].ammount)
	end

	if NPC_REWARD_EXP.reward_xp then

		doPlayerAddExperience(getGlobalStorageValue(STORAGES_DUEL["Player"]), NPC_REWARD_EXP.experience)
	end

	setGlobalStorageValue(STORAGES_DUEL["Player"], 0)
	return true
end

function onAttack(cid, target)
	local pos = getThingPos(cid)
	local dir = getCreatureLookDir(cid)

	if target ~= getGlobalStorageValue(STORAGES_DUEL["Player"]) then


		message = NPC_MESSAGES["Attack Other Player"]

		if message:find("pn") then
			message = string.gsub(message, "pn", getCreatureName(target))
		end

		local npc = doCreateNpc("masterShitsu", pos)
		doCreatureSetLookDirection(npc, dir)
		doCreatureSay(npc, message)

		if NPC_CONFIGS.Npc_AutoWalk then

			addEvent(pathfinder, 1000, npc, NPC_CONFIGS.Final_Pos)
		else

			doTeleportThing(npc, NPC_CONFIGS.Final_Pos, true)
		end

		setGlobalStorageValue(STORAGES_DUEL["Player"], 0)
		return false
	end
	return true
end

function onStatsChange(cid, attacker, type, combat, value)
	if (type == STATSCHANGE_HEALTHGAIN) then
        return true
	end

	if attacker == getGlobalStorageValue(STORAGES_DUEL["Player"]) then
		return true
	end

	if attacker ~= getGlobalStorageValue(STORAGES_DUEL["Player"]) then
		if NPC_CONFIGS.Npc_Other_Player_Can_Attack then

			return true
		end
	end
	return false
end
