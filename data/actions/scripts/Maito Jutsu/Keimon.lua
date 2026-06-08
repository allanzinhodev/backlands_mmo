	local temp = {
	exhausted = 2,
	}
	
	
function onUse(cid, item, fromPosition, itemEx, toPosition)
local info = {
		mana = 6,
		speed = 260,
	}


	local manaPercent = getCreatureMaxMana(cid) * (info.mana / 100)
	
	if not isCreature(cid) then
		return true
	end
	
	if checkCmd(cid, "rest") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are resting.")
	end
	if checkCmd(cid, "mold") then
		return doPlayerSendCancel(cid, "you cannot use jutsu while you are mold chakra")
	end
	if checkJutsu(cid, "Kagemane") then
		return doPlayerSendCancel(cid, "you cannot use jutsu")
	end
	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end

	if(getPlayerStorageValue(cid, sto_jutsu[1]) > os.time() and getPlayerStorageValue(cid, sto_jutsu[1]) < 100+os.time()) then
		doPlayerSendTextMessage(cid, 24, "Voce ja esta fazendo um jutsu")
		return true
	end
	
	if getCreatureStorage(cid, sto_hachimon[1]) == 0 then
		doPlayerSendCancel(cid, "You can't use Keimon while you are using Kaimon.")
		return true
	end
	
	if getCreatureStorage(cid, sto_hachimon[2]) == 0 then
		doPlayerSendCancel(cid, "You can't use Keimon while you are using Kyumon.")
		return true
	end
	
	if getCreatureStorage(cid, sto_hachimon[3]) == 0 then
		doPlayerSendCancel(cid, "You can't use Keimon while you are using Seimon.")
		return true
	end
	
	if getCreatureStorage(cid, sto_hachimon[4]) == 0 then
		doPlayerSendCancel(cid, "You can't use Keimon while you are using Shomon.")
		return true
	end

	if getCreatureStorage(cid, sto_hachimon[5]) == 0 then
		doPlayerSendCancel(cid, "You can't use Keimon while you are using TOMON.")
		return true
	end
	
	if getCreatureStorage(cid, sto_hachimon[7]) == 0 then
		doPlayerSendCancel(cid, "You can't use Keimon while you are using Kyomon.")
		return true
	end
	
	if getCreatureStorage(cid, sto_hachimon[8]) == 0 then
		doPlayerSendCancel(cid, "You can't use Keimon while you are using Shimon.")
		return true
	end
	if getPlayerStorageValue(cid, sto_hachimon[6]) > 0 then
		addEvent(doCreatureSay, 100, cid, "Hachimon Tonkou!", TALKTYPE_MONSTER)
		addEvent(doSendAnimatedText, 200, getCreaturePosition(cid), "KAIMON..", COLOR_GREY)
		addEvent(doSendAnimatedText, 400, getCreaturePosition(cid), "KYUMON..", COLOR_YELLOW)
		addEvent(doSendAnimatedText, 600, getCreaturePosition(cid), "SEIMON..", COLOR_LIGHTBLUE)
		addEvent(doSendAnimatedText, 800, getCreaturePosition(cid), "SHOUMON..", COLOR_RED)
		addEvent(doSendAnimatedText, 1000, getCreaturePosition(cid), "TOMON..", COLOR_GREEN)
		addEvent(doSendAnimatedText, 1200, getCreaturePosition(cid), "KEIMON..", COLOR_WHITE)
		addEvent(doCreatureSay, 1400, cid, "KAI!!!", TALKTYPE_SAY)
		hachimonTonkou2(cid)
		doPlayerAddSkill(cid, 0, getPlayerSkill(cid, 0)+12)
		doPlayerAddSkill(cid, 6, getPlayerSkill(cid, 6)+12)
		setPlayerStorageValue(cid, sto_hachimon[6], 0)
		doChangeSpeed(cid, -getCreatureSpeed(cid))
		doChangeSpeed(cid, getCreatureBaseSpeed(cid) + info.speed)
		removeStaminaSecondLife(cid, -manaPercent, 1, sto_hachimon[6])
	elseif getPlayerStorageValue(cid, sto_hachimon[6]) == 0 then
		endhachimonTonkou2(cid)
		doChangeSpeed(cid, -getCreatureSpeed(cid))
		doChangeSpeed(cid, getCreatureBaseSpeed(cid))
		doPlayerAddSkill(cid, 0, getPlayerSkill(cid, 0)-12)
		doPlayerAddSkill(cid, 6, getPlayerSkill(cid, 6)-12)
		setPlayerStorageValue(cid, sto_hachimon[6], 1)
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
		end
	end


