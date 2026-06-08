UPGRADE_CONFIGS = {
	addArmor = 1,
	addDefense = 1,
	addAttack = 1,
	fail_chance = 0,
	max_level = 50,
	upgrader_itemid = 13281
}

NPC_MESSAGES = {
	["Bye [Creature Disappear"] = "Então... Tchau pn.",
	["Bye"] = "Tchau pn, boa sorte!",
	["Hi"] = "Olá pn, voce gostaria de aprimorar o seu equipamento?",
	["Upgrade"] = "Voce tem certeza que deseja aprimorar seu equipamento? Voce precisara de um upid.",
	["DontHaveItem"] = "Voce não tem um upid, para aprimorar o seu equipamento.",
	["DontUpgradeItem"] = "Voce não pode aprimorar este equipamento.",
	["MaxLevel"] = "Seu equipamento já está em seu nivel máximo.",
	["UpgradeSucess"] = "Seu equipamento foi aprimorado com sucesso, agora ele está +nlv.",
	["UpgradeFail"] = "A tentativa de aprimorar o seu equipamento falhou.",
}

-- All functions are made by OrochiElf <-- -->

function substring(word, cid)
	local slot = getPlayerSlotItem(cid, 6) or getPlayerSlotItem(cid, 5) or 0
	local used_words = {
		["nlv"] = getItemLevel(slot),
		["pn"] = getCreatureName(cid),
		["upid"] = getItemNameById(UPGRADE_CONFIGS.upgrader_itemid),
	}

	local words = word

	for used, transform in pairs(used_words) do
		if words:find(used) then

			words = string.gsub(words, used, transform)
		end
	end

	return words
end

function isArmor(a)
	a = a or 0

	if a.uid == 0 then
		return false
	end

	local arm = getItemAttribute(a.uid, "armor") or getItemInfo(a.itemid).armor or 0

	if arm > 0 then
		return true
	end
	return false
end

function isAxe(uid)
	uid = uid or 0

	if uid == 0 then
		return false
	end

	local f = getItemWeaponType(uid)

	if f == 3 then

		return true
	end
return false
end

function isFist(uid)
	uid = uid or 0

	if uid == 0 then
		return false
	end

	local f = getItemWeaponType(uid)

	if f == 8 then

		return true
	end
return false
end

function getItemLevel(uid)
    uid = uid.uid or 0

	if uid == 0 then
		return false
	end

    lvl = getItemAttribute(uid, "itemLevel")
    return tonumber(lvl) or 0
end

function getNormalAttribute(uid, attribute)
    local var = nil
    uid = uid or 0

    if attribute == "armor" then
        var = getItemAttribute(uid.uid, "armor") or getItemInfo(uid.itemid).armor or 0
    elseif attribute == "attk" then
        var = getItemAttribute(uid.uid, "attack") or getItemInfo(uid.itemid).attack or 0
    elseif attribute == "def" then
        var = getItemAttribute(uid.uid, "defense") or getItemInfo(uid.itemid).defense or 0
    end
    return var
end

function setItemLevel(uid, newLevel)
    uid = uid or 0

    doItemSetAttribute(uid.uid, "itemLevel", newLevel)
	doItemSetAttribute(uid.uid, "name", getItemNameById(uid.itemid).." [+"..newLevel.."]")
    if isAxe(uid.uid) or isFist(uid.uid) then

		doItemSetAttribute(uid.uid, "attack", (getNormalAttribute(uid, "attk") + UPGRADE_CONFIGS.addAttack))
        doItemSetAttribute(uid.uid, "defense", (getNormalAttribute(uid, "def") + UPGRADE_CONFIGS.addDefense))
		return true
	else

		doItemSetAttribute(uid.uid, "armor", (getNormalAttribute(uid, "armor") + UPGRADE_CONFIGS.addArmor))
		return true
    end
    return true
end
