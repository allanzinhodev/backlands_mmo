local focus = 0
local pos = nil
local dir = nil

function replaceName(cid, place)
	local messagea = place

	if messagea:find("pn") then
		messagea = string.gsub(messagea, "pn", getCreatureName(cid))
	end

	return messagea
end

function onCreatureDisappear(cid, pos)
	if focus == cid then

		selfSay(replaceName(cid, NPC_MESSAGES["No Duel [Creature Disappear]"]))
		focus = 0
	end
end

function msgcontains(txt, str)

	return (string.find(txt, str) and not string.find(txt, '(%w+)' .. str) and not string.find(txt, str .. '(%w+)'))
end

function onCreatureSay(cid, type, msg)
	local msg = string.lower(msg)
	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if (msgcontains(msg, 'no') and focus == cid) then

		selfSay(replaceName(cid, NPC_MESSAGES["No Duel"]))
		focus = 0
	elseif (msgcontains(msg, 'hi') and (focus == 0) and (focus ~= cid) and (getDistanceToCreature(cid) <= 4)) then

		selfSay(replaceName(cid, NPC_MESSAGES["Hi Duel"]))
		local dire = getDirectionTo(getThingPos(getNpcId()), getThingPos(cid))

		doCreatureSetLookDirection(getNpcId(), dire)
		focus = cid
	elseif (msgcontains(msg, 'yes') and focus == cid) then
		if getPlayerStorageValue(cid, STORAGES_DUEL["Duel"]) <= 0 then
			pos = getThingPos(getNpcId())
			dir = getCreatureLookDir(getNpcId())

			selfSay(replaceName(cid, NPC_MESSAGES["Yes Duel"]))
			doRemoveCreature(getNpcId(), true)
			local monster = doCreateMonster("NPCBattle", pos)

			registerCreatureEvent(monster, "DeathDuel")
			registerCreatureEvent(monster, "DuelAttack")
			registerCreatureEvent(monster, "AntiAttack")
			doCreatureSetLookDirection(monster, dir)

			setGlobalStorageValue(STORAGES_DUEL["Player"], cid)
			setPlayerStorageValue(cid, STORAGES_DUEL["Duel_Attacker"], monster)
			setPlayerStorageValue(cid, STORAGES_DUEL["Duel_AntiDeath"], 1)
			registerCreatureEvent(cid, "DeathPlayer")
			focus = cid
		else

			selfSay(replaceName(cid, NPC_MESSAGES["Again Duel"]))
			setGlobalStorageValue(STORAGES_DUEL["Player"], 0)
			focus = 0
		end
	end
return true
end
