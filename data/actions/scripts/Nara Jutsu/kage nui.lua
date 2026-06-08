local temp = {
	exhausted = 7,
}


local config = {
     sqms = 20,
	 chakra = 50,
     effects = {
         [0] = 83,
         [1] = 85,
         [2] = 84,
         [3] = 86,
     },
     intervalo = 300
}

local function direcao(cid, pos, n)
local level = getPlayerLevel(cid) 
local jutsuDmg = 18
local skill_factor = math.ceil((jutsuSkill_factor(cid, 1) + level)/2)
local dmg = - math.max(1, math.ceil(((skill_factor*0.5) * jutsuDmg)*0.20))
        local n = n or 0

        if (n < config.sqms) then
            if (isCreature(cid)) then
                local pos = pos or getCreaturePosition(cid)

                local dir = getCreatureLookDirection(cid)

                local newPos = getPosByDir(pos, dir)

                --doAreaCombatHealth(cid, type, pos, area, min, max, effect)
                doAreaCombatHealth(cid, 1, newPos, 0, dmg, dmg, config.effects[dir])

                addEvent(direcao, config.intervalo, cid, newPos, n + 1)
            end
        end
    end

function onUse(cid, item, fromPosition, itemEx, toPosition)	
	if	impossibleUse(cid) then
		return true
	end

	if checkDoing(cid) then
		return true
	end	
	if getPlayerStorageValue(cid, sto_gen[1]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")		
	end
	
	if getPlayerStorageValue(cid, sto_nara[7]) == 0 then
		return doPlayerSendCancel(cid, "Sorry this is not possible.")
	end
	
	if isPlayer(cid) then
	    removeChakraLife(cid, - config.chakra)
		doCreatureSay(cid, "Kage Nui !!", TALKTYPE_MONSTER)
		direcao(cid)
		actionMove(cid, 401, 6000)
		setPlayerStorageValue(cid, sto_jutsu[1], os.time() + temp.exhausted)
		noMove(cid, 6000)
	end
    return true
end