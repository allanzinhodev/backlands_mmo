local focus = 0
local pos = nil
local dir = nil


function onCreatureDisappear(cid, pos)
	if focus == cid then

		selfSay(substring(NPC_MESSAGES["Bye [Creature Disappear"], cid), cid)
		focus = 0
	end
end

function msgcontains(txt, str)

	return (string.find(txt, str) and not string.find(txt, '(%w+)' .. str) and not string.find(txt, str .. '(%w+)'))
end

function onCreatureSay(cid, type, msg)
	local msg = string.lower(msg)
	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
	local slot = getPlayerSlotItem(cid, 6) or getPlayerSlotItem(cid, 5) or 0

	if (msgcontains(msg, 'bye') and focus == cid) then

		selfSay(substring(NPC_MESSAGES["Bye"], cid), cid)
		focus = 0
	elseif (msgcontains(msg, 'hi') and (focus == 0) and (focus ~= cid) and (getDistanceToCreature(cid) <= 3)) then

		selfSay(substring(NPC_MESSAGES["Hi"], cid), cid)
		focus = cid
	elseif (msgcontains(msg, 'upgrade') and focus == cid) then

		selfSay(substring(NPC_MESSAGES["Upgrade"], cid), cid)
	elseif (msgcontains(msg, 'yes') and focus == cid) then

		if not isArmor(slot) and not isAxe(slot.uid) and not isFist(slot.uid) then

			selfSay(substring(NPC_MESSAGES["DontUpgradeItem"], cid), cid)
			focus = 0
			return false
		end

		if getPlayerItemCount(cid, UPGRADE_CONFIGS.upgrader_itemid) < 1 then

			selfSay(substring(NPC_MESSAGES["DontHaveItem"], cid) ,cid)
			focus = 0
			return false
		end

		if getItemLevel(slot) == UPGRADE_CONFIGS.max_level then

			selfSay(substring(NPC_MESSAGES["MaxLevel"], cid), cid)
			focus = 0
			return false
		end

		if math.random(100) < UPGRADE_CONFIGS.fail_chance then

			selfSay(substring(NPC_MESSAGES["UpgradeFail"], cid), cid)
			doPlayerRemoveItem(cid, UPGRADE_CONFIGS.upgrader_itemid, 1)
			doSendMagicEffect(getThingPos(cid), 2)
			focus = 0
			return true
		else

			setItemLevel(slot, (getItemLevel(slot) + 1))
			selfSay(substring(NPC_MESSAGES["UpgradeSucess"], cid), cid)
			doPlayerRemoveItem(cid, UPGRADE_CONFIGS.upgrader_itemid, 1)
			doSendMagicEffect(getThingPos(cid), 12)
			focus = 0
			return true
		end
	end
return true
end

function onPlayerCloseChannel(cid)
	if focus == cid then
		selfSay("Hmph!")
		closeShopWindow(cid)
		focus = 0
	end
end

function onThink()

       local direction = getCreatureLookDirection(getNpcId())
	   doCreatureSetLookDirection(getNpcId(), 1)
		if(not isCreature(focus)) then
			focus = 0
		else
			local distance = getDistanceTo(focus) or -1
			if((distance > 4) or (distance == -1)) then
				selfSay("Hmph!")
				closeShopWindow(focus)
				focus = 0
			end
		end
end