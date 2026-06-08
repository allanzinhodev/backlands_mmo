function onSay(cid, words, param, channel)
	local ret = {}

	local msg = "		                       FORGE\n"


	for _, recipe in ipairs(Recipes) do
		local skills = true
		for skillid, value in pairs(recipe.skills) do
			if getPlayerSkillLevel(cid, skillid) < value then
				skills = false
				break
			end
		end

		if skills == true then
			if getPlayerLevel(cid) >= recipe.level and getPlayerMagLevel(cid) >= recipe.maglevel then
				table.insert(ret, {recipe, true})
			else
				table.insert(ret, {recipe, false})
			end
		else
			table.insert(ret, {recipe, false})
		end
	end

	for _, recipe in ipairs(ret) do
		msg = msg .."\nRecipe for ".. getItemNameById(recipe[1].itemtype) ..":\n\n"
		if recipe[2] == true then
			for _, item in ipairs(recipe[1].items) do
				msg = msg .."* ".. getItemNameById(item[1]) .." [".. math.min(item[2], math.max(0, getPlayerItemCount(cid, item[1]))) .."/".. item[2] .."]\n"
			end
		else
			msg = msg .."[LOCKED]\n"
		end
	end
	doShowTextDialog(cid, 2555, msg)
	return true
end