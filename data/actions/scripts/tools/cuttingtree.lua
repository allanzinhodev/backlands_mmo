---------------------------
-- Configurations --
---------------------------

local STORAGE_SKILL_LEVEL = 10000
local STORAGE_SKILL_TRY = 10001  

    local config = {
     levels = {
         {level = {0,9}, quant = {1,2}, percent = 5},
         {level = {10,19}, quant = {2,4}, percent = 10},
         {level = {20,29}, quant = {3,6}, percent = 15},
         {level = {30,39}, quant = {4,8}, percent = 20},
         {level = {40,49}, quant = {5,10}, percent = 25},
         {level = {50,59}, quant = {6,12}, percent = 30},
         {level = {60,69}, quant = {7,14}, percent = 30},
         {level = {70,79}, quant = {8,16}, percent = 35},
         {level = {80,89}, quant = {9,18}, percent = 35},
         {level = {90,99}, quant = {10,20}, percent = 40},
         {level = {100}, quant = {11,22}, percent = 50}
     },
	 trees = {2708, 2768, 2767, 2702, 2785, 2700, 2707, 2711, 2706, 2707, 2705, 2719, 7024, 5156, 5157, 2697, 2698, 2701, 2702, 2703, 2704, 2707, 2712, 2718, 2719, 2720, 2709, 2710, 2722, 2725, 2726, 2770, 2786, 4006, 4007, 4008, 4009, 4010, 7020, 7021, 7022, 7023}, -- Id das arvores que podem ser cortadas
     woods = {},  -- Modelo = {wood_id, tree_id}
     default_wood = 13235, -- Madeira padrão
     tree_delay = 3, -- Tempo de crescimento da arvore cortada (Em segundos)
     bonus_chance = 5, -- Chance (em porcentagem) de se conseguir um bonus de exp
     bonus_exp = 2 -- Bonus extra
    }
    
    
------------------------------------
-- END Configurations ---
------------------------------------

function getLumberjackLevel(cid)
    return getPlayerStorageValue(cid, STORAGE_SKILL_LEVEL)
end

function setPlayerLumberjackLevel(cid, n)
    setPlayerStorageValue(cid, STORAGE_SKILL_LEVEL, n)
end

function addLumberjackLevel(cid, n)
    setPlayerLumberjackLevel(cid, getLumberjackLevel(cid) + (isNumber(n) and n or 1))
    setLumberjackTry(cid, 0)
end

function getLumberjackInfo(cid)
    for i = 1, #config.levels do
        min = config.levels[i].level[1]; max = config.levels[i].level[2]
        if (getLumberjackLevel(cid) >= min and getLumberjackLevel(cid) <= max) then
            return {quantity = {min = config.levels[i].quant[1], max = config.levels[i].quant[2]}, chance = config.levels[i].percent}
        end
    end
end

function getWoodByTree(treeid)
    for i = 1, #config.woods do
        if (config.woods[2] == treeid) then
            return config.woods[1]
        end
    end
    return config.default_wood
end

function getLumberjackTries(cid)
    return getPlayerStorageValue(cid, STORAGE_SKILL_TRY)
end

function setLumberjackTry(cid, n)
    setPlayerStorageValue(cid, STORAGE_SKILL_TRY, n)
end

function addLumberjackTry(cid, bonus)
    setLumberjackTry(cid, getLumberjackTries(cid) + 1 + (bonus and config.bonus_exp or 0))
    
    if (getLumberjackTries(cid) >= getLumberjackExpTo(getLumberjackLevel(cid))) then -- Up
        doPlayerSendTextMessage(cid, 22, "You advanced from level " .. getLumberjackLevel(cid) .. " to level ".. (getLumberjackLevel(cid) + 1) .." in Lumberjacking.")
        
        if ((getLumberjackLevel(cid)+1) == getLumberjackMaxLevel()) then
            doPlayerSendTextMessage(cid, 22, "Max level reached in lumberjacking.")
        end
        
        addLumberjackLevel(cid)
        doSendMagicEffect(getCreaturePosition(cid), math.random(3,3))
        setLumberjackTry(cid, 0)
    end
end

function getLumberjackExpTo(level)
    return ((level*1.5)+((level+1)*7))
end

function getLumberjackMaxLevel()
    return config.levels[#config.levels].level[#config.levels[#config.levels].level]
end

---------------------------


function onUse(cid, item, fromPosition, itemEx, toPosition)
    tree = { id = itemEx.itemid, uid = itemEx.uid, position = toPosition }
    player = { position = getCreaturePosition(cid) }
    
    if (getLumberjackLevel(cid) < 0) then 
        setPlayerLumberjackLevel(cid, 0)
    end
    
    if (isInArray(config.trees, tree.id)) then
        addLumberjackTry(cid)
    
        if (math.random(1,100) <= getLumberjackInfo(cid).chance) then
            local collected = math.random(getLumberjackInfo(cid).quantity.min, getLumberjackInfo(cid).quantity.max)
            doPlayerAddItem(cid, getWoodByTree(tree.id), collected)
            doPlayerSay(cid, "I got " .. collected .. " piece" .. (collected > 1 and "s" or "") .. " of wood.", 1)
            
            if (math.random(1,100) <= config.bonus_chance) then -- Bonus calc
                addLumberjackTry(cid, true)
                doSendAnimatedText(player.position, "Bonus!", COLOR_ORANGE)
            end
            
            event_treeCut(tree)
        else
            if (math.random(1,100) <= (10-getLumberjackInfo(cid).chance/10)) then
                doPlayerSendTextMessage(cid, 22, "You got nothing.") 
                event_treeCut(tree)
            else
                doSendMagicEffect(tree.position, 3)
                doSendAnimatedText(tree.position, "Pock!", COLOR_GREEN)
            end
        end
    else
        doPlayerSendCancel(cid, "This can't be cut.")
    end
end

function event_treeCut(tree)
    addEvent(event_treeGrow, config.tree_delay * 1000, tree.position, tree.id)
    
    doTransformItem(tree.uid, 8792)
    doSendMagicEffect(tree.position, 3)
    doSendAnimatedText(tree.position, "Pock!", COLOR_GREEN)
    doItemSetAttribute(tree.uid, "name", "A trunk of " .. getItemNameById(tree.id))
end

function event_treeGrow(treePos, old_id)
    local tree = getThingFromPos(treePos).uid
    doTransformItem(tree, old_id)
    doItemSetAttribute(tree, "name", getItemNameById(old_id))
    doSendMagicEffect(treePos, 3)
end