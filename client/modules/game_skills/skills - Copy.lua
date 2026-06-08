skillsWindow = nil
skillsButton = nil

JUTSUS_SLOT = InventorySlotAmmo

local skills = 
{
 [0] = 'taijutsuValue',
 [1] = 'genjutsuValue',
 [2] = 'ninjutsuValue',
 [3] = 'meleeWeaponsValue',
 [4] = 'distanceWeaponsValue',
 [5] = 'resistanceValue',
 [6] = 'agilityValue',
 [7] = 'chakraLevelValue',
}

local clans = 
{
 [1] = {'Uchiha', '/images/game/skills/uchiha', '/images/game/portraits/uchiha'},
 [2] = {'Hyuuga', '/images/game/skills/hyuuga', '/images/game/portraits/hyuuga'},
 [3] = {'Aburame', '/images/game/skills/aburame', '/images/game/portraits/aburame'},
 [4] = {'Nara', '/images/game/skills/nara', '/images/game/portraits/nara'},
 [5] = {'Inuzuka', '/images/game/skills/inuzuka', '/images/game/portraits/inuzuka'},
 [6] = {'Akimichi', '/images/game/skills/akimichi', '/images/game/portraits/akimichi'},
 [7] = {'Maito', '/images/game/skills/maito', '/images/game/portraits/maito'},
 [8] = {'Yamanaka', '/images/game/skills/yamanaka', '/images/game/portraits/yamanaka'},
}

local ranks = 
{
 [1] = {'Academy Student', '/images/game/skills/student'},
 [2] = {'Gennin', '/images/game/skills/gennin'},
 [3] = {'Chunnin', '/images/game/skills/chunnin'},
 [4] = {'Jounnin', '/images/game/skills/jounnin'},
 [5] = {'Special Jounnin', '/images/game/skills/jounnin'},
 [6] = {'ANBU', '/images/game/skills/ANBU'},
 [7] = {'ANBU Captain', '/images/game/skills/ANBU'},
 [8] = {'Sannin', '/images/game/skills/konoha'},
 [9] = {'Kage', '/images/game/skills/konoha'},
}

local villages = 
{
 [1] = {'Konohagakure', '/images/game/skills/konoha'},
 [2] = {'Sunagakure', '/images/game/skills/konoha'},
 [3] = {'Kirigakure', '/images/game/skills/konoha'},
}

local canLevelUp =
{
[7] = 'chakraLevelButton', 
[0] = 'taijutsuButton', 
[1] = 'genjutsuButton', 
[2] = 'ninjutsuButton', 
[3] = 'meleeWeaponsButton', 
[4] = 'distanceWeaponsButton', 
[5] = 'resistanceButton', 
[6] = 'agilityButton', 
}

local skillCosts =
{
[7] = 'chakraLevelCost', 
[0] = 'taijutsuCost', 
[1] = 'genjutsuCost', 
[2] = 'ninjutsuCost', 
[3] = 'meleeWeaponsCost', 
[4] = 'distanceWeaponsCost', 
[5] = 'resistanceCost', 
[6] = 'agilityCost', 
}



function init()
  connect(LocalPlayer, {
    onExperienceChange = onExperienceChange,
    onLevelChange = onLevelChange,
    onSoulChange = onSoulChange,
    onSpeedChange = onSpeedChange,
    onBaseSpeedChange = onBaseSpeedChange,
    onMagicLevelChange = onMagicLevelChange,
    onBaseMagicLevelChange = onBaseMagicLevelChange,
    onSkillChange = onSkillChange,
    onInventoryChange = onInventoryChange,
    onBaseSkillChange = onBaseSkillChange
  })
  
   connect(g_game, {
    onGameStart = refresh,
    onGameEnd = offline
  })
  
  skillsButton = modules.client_topmenu.addRightGameToggleButton('skillsButton', tr('Ninja Info') .. ' (Ctrl+S)', '/images/topbuttons/skills', toggle)
  skillsButton:setOn(true)
  
  ProtocolGame.registerExtendedOpcode(101, getNinjaInfo)
  g_keyboard.bindKeyDown('Ctrl+S', toggle) 
  skillsWindow = g_ui.loadUI('skills', modules.game_interface.getMapPanel())
  refresh()
  skillsWindow:setup()
  
  skillsWindow:close()
  skillsButton:setOn(false)

end

function terminate()

  disconnect(LocalPlayer, {
    onExperienceChange = onExperienceChange,
    onLevelChange = onLevelChange,
    onSoulChange = onSoulChange,
    onSpeedChange = onSpeedChange,
    onBaseSpeedChange = onBaseSpeedChange,
    onMagicLevelChange = onMagicLevelChange,
    onBaseMagicLevelChange = onBaseMagicLevelChange,
    onSkillChange = onSkillChange,
    onInventoryChange = onInventoryChange,
    onBaseSkillChange = onBaseSkillChange
  })
  
   disconnect(g_game, {
    onGameStart = refresh,
    onGameEnd = offline
  })
  ProtocolGame.unregisterExtendedOpcode(101)
  g_keyboard.unbindKeyDown('Ctrl+S')
  skillsWindow:destroy()
  skillsButton:destroy()
end

function expForLevel(level)
  return math.floor((50*level*level*level)/3 - 100*level*level + (850*level)/3 - 200)
end

function expToAdvance(currentLevel, currentExp)
  return expForLevel(currentLevel+1) - currentExp
end

function refresh()
  local player = g_game.getLocalPlayer()
  if not player then return end

  if expSpeedEvent then expSpeedEvent:cancel() end
  expSpeedEvent = cycleEvent(checkExpSpeed, 30*1000)
  
  onNameChange(player, g_game.getCharacterName())

  onExperienceChange(player, player:getExperience())
  onLevelChange(player, player:getLevel(), player:getLevelPercent())
  onMagicLevelChange(player, player:getMagicLevel(), player:getMagicLevelPercent())
  
  onSpeedChange(player, player:getSpeed())

  for i=0,6 do
    onSkillChange(player, i, player:getSkillLevel(i), player:getSkillLevelPercent(i))
    onBaseSkillChange(player, i, player:getSkillBaseLevel(i))
  end
  onSoulChange(player, player:getSoul())
  
    if g_game.isOnline() then
      onInventoryChange(player, JUTSUS_SLOT, player:getInventoryItem(JUTSUS_SLOT))
    else
      onInventoryChange(player, JUTSUS_SLOT, nil)
    end
  requestInfo()  
  updateLvUpIcons(player:getSoul())
  
  skillsWindow:setContentMinimumHeight(10)
  skillsWindow:setContentMaximumHeight(430)
end

function offline()
  if expSpeedEvent then expSpeedEvent:cancel() expSpeedEvent = nil end
end

function getIndex(table, value)
   for _,v in pairs(table) do
      if(v == value)then
         return _
      end
   end
return false
end

function onNameChange(localPlayer, name)
   setSkillValue('name', tr(name))   
end

function toggle()
skillsWindow:setSize({width = 380, height = 450})
  if skillsButton:isOn() then
    skillsWindow:close()
    skillsButton:setOn(false)
  else
    skillsWindow:open()
    refresh()    
    skillsButton:setOn(true)
  end
end

function onMiniWindowClose()
  skillsButton:setOn(false)
end



function getNinjaInfo(protocol, opcode, buffer)
  local msg = InputMessage.create()
  msg:setBuffer(buffer)
  
  local player = g_game.getLocalPlayer()
  if not player then return end
  local clanName = msg:getData()
  player:setVocation(clanName)
  setSkillValue('clan', clans[clanName][1])
  skillsWindow:recursiveGetChildById('clanMiniature'):setImageSource(clans[clanName][2])
  skillsWindow:recursiveGetChildById('portraitPanel'):setImageSource(clans[clanName][3])
  local rank = msg:getData()
  setSkillValue('rank', ranks[rank][1])
  skillsWindow:recursiveGetChildById('rankMiniature'):setImageSource(ranks[rank][2]) 
 local village = msg:getData()
  setSkillValue('village', villages[village][1]) 
  skillsWindow:recursiveGetChildById('villageMiniature'):setImageSource(villages[village][2])  
  
  local attackspeed = msg:getData()
  setSkillValue('atkSpeed', attackspeed)
  
  local bounty = msg:getData() - 1
  setSkillValue('bounty', bounty)
  local reputation = msg:getData() - 1
  setSkillValue('reputation', reputation)
  local skillPoints = msg:getData() - 1
  setSkillValue('skillPointsLabel', skillPoints)
  setSkillValue('rankd',  msg:getData() - 1) 
  setSkillValue('rankc',  msg:getData() - 1) 
  setSkillValue('rankb',  msg:getData() - 1) 
  setSkillValue('ranka',  msg:getData() - 1) 
  setSkillValue('ranks',  msg:getData() - 1)
    
  player:setSoul(skillPoints)
  onSoulChange(player, skillPoints)
 updateLvUpIcons(skillPoints)
  
end

function onSpeedChange(localPlayer, speed)
  setSkillValue('movSpeed', speed)
  onBaseSpeedChange(localPlayer, localPlayer:getBaseSpeed())
end

function onBaseSpeedChange(localPlayer, baseSpeed)
  setSkillBase('movSpeed', localPlayer:getSpeed(), baseSpeed)
end

function onMagicLevelChange(localPlayer, magiclevel, percent)
  setSkillValue('chakraLevelValue', magiclevel)
  onBaseMagicLevelChange(localPlayer, localPlayer:getBaseMagicLevel())
end

function onBaseMagicLevelChange(localPlayer, baseMagicLevel)
  setSkillBase('chakraLevelValue', localPlayer:getMagicLevel(), baseMagicLevel)
end

function onSkillChange(localPlayer, id, level, percent)
  setSkillValue(skills[id], level)
  onBaseSkillChange(localPlayer, id, localPlayer:getSkillBaseLevel(id))
end

function onBaseSkillChange(localPlayer, id, baseLevel)
  setSkillBase(skills[id], localPlayer:getSkillLevel(id), baseLevel)
end

function onSoulChange(localPlayer, soul)
  setSkillValue('skillPointsLabel', soul)
  updateLvUpIcons(soul)
end

function onExperienceChange(localPlayer, value)
  setSkillValue('experience', value)
end

function onLevelChange(localPlayer, value, percent)
  setSkillValue('level', value)
  local text = tr('You have %s percent to go', 100 - percent) .. '\n' ..
               tr('%s of experience left', expToAdvance(localPlayer:getLevel(), localPlayer:getExperience()))

  if localPlayer.expSpeed ~= nil then
     local expPerHour = math.floor(localPlayer.expSpeed * 3600)
     if expPerHour > 0 then
        local nextLevelExp = expForLevel(localPlayer:getLevel()+1)
        local hoursLeft = (nextLevelExp - localPlayer:getExperience()) / expPerHour
        local minutesLeft = math.floor((hoursLeft - math.floor(hoursLeft))*60)
        hoursLeft = math.floor(hoursLeft)
        text = text .. '\n' .. tr('%d of experience per hour', expPerHour)
        text = text .. '\n' .. tr('Next level in %d hours and %d minutes', hoursLeft, minutesLeft)
     end
  end
end

function setSkillBase(id, value, baseValue)
  if baseValue <= 0 or value < 0 then
    return
  end
  local widget = skillsWindow:recursiveGetChildById(id)
  if value > baseValue then
    widget:setColor('#008b00') -- green
    widget:setTooltip(baseValue .. ' +' .. (value - baseValue))
  elseif value < baseValue then
    widget:setColor('#b22222') -- red
    widget:setTooltip(baseValue .. ' ' .. (value - baseValue))
  else
    widget:setColor('#bbbbbb') -- default
    widget:removeTooltip()
  end
end

function setSkillValue(id, value)   
  local widget = skillsWindow:recursiveGetChildById(id)
  widget:setText(value)
end

function setSkillColor(id, value)
  local widget = skillsWindow:recursiveGetChildById(id)
  widget:setColor(value)
end

function setSkillTooltip(id, value)
  local widget = skillsWindow:recursiveGetChildById(id)
  widget:setTooltip(value)
end

function checkExpSpeed()
  local player = g_game.getLocalPlayer()
  if not player then return end
  
  local currentExp = player:getExperience()
  local currentTime = g_clock.seconds()
  if player.lastExps ~= nil then
    player.expSpeed = (currentExp - player.lastExps[1][1])/(currentTime - player.lastExps[1][2])
    onLevelChange(player, player:getLevel(), player:getLevelPercent())
  else
    player.lastExps = {}
  end
  table.insert(player.lastExps, {currentExp, currentTime})
  if #player.lastExps > 30 then
    table.remove(player.lastExps, 1)
  end
end

function updateLvUpIcons(soul)
local player = g_game.getLocalPlayer()
  for _,v in pairs(canLevelUp) do
    local skill = skillsWindow:recursiveGetChildById(v)
       local cost = 1
       if(v ~= 'chakraLevelButton') then
       cost = math.floor(player:getSkillLevel(_)/10)+1
       else
       cost = math.floor(player:getMagicLevel()/10)+1
       end 
       
       setSkillValue(skillCosts[_], "(Cost: ".. cost .. ")")
       
      --print("\ncost = ".. cost .. " / " .. "soul = ".. soul)
       
       if(cost <= soul) then
          skill:setVisible(true)
          skill:setEnabled(true)
       else
          skill:setVisible(false)
          skill:setEnabled(false)
       end
  end
end

function tryAddSkill(player, skill)
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
    protocolGame:sendExtendedOpcode(OPCODE_ADDSKILL, skill)
    end
end

function requestInfo()
    local player = g_game.getLocalPlayer()
    if not player then return end
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
    protocolGame:sendExtendedOpcode(OPCODE_REQINFO, 1)
    end
end

function onButtonClick(id)
  local player = g_game.getLocalPlayer()
  if not player then return end
  tryAddSkill(player, getIndex(canLevelUp, id))
  updateLvUpIcons(player:getSoul())
end                               
                                 
-- hooked events
function onInventoryChange(player, slot, item, oldItem)
  if slot ~= JUTSUS_SLOT then return end
  local itemWidget = skillsWindow:recursiveGetChildById('slot10')
  if item then         
    itemWidget:setStyle('Item')
    itemWidget:setItem(item)
  else
    itemWidget:setStyle("JutsusSlot")
    itemWidget:setItem(nil)
  end
end