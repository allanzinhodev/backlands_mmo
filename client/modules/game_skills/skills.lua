skillsWindow = nil
skillsButton = nil

JUTSUS_SLOT = InventorySlotAmmo

local skills = 
{
 [0] = 'taijutsuValue',
 [1] = 'ninjutsuValue',
 [2] = 'genjutsuValue',
 [3] = 'meleeWeaponsValue',
 [4] = 'distanceWeaponsValue',
 [5] = 'resistanceValue',
 [6] = 'agilityValue',
 [7] = 'chakraLevelValue',
}

local clans = 
{
[0] = { path = '/images/game/portraits/uchiha'},
[1] = { path = '/images/game/portraits/maito'},
[2] = { path = '/images/game/portraits/inuzuka'},
[3] = { path = '/images/game/portraits/aburame'},
[4] = { path = '/images/game/portraits/hyuuga'},
[5] = { path = '/images/game/portraits/uchiha'},
[6] = { path = '/images/game/portraits/nara'},
[7] = { path = '/images/game/portraits/akimichi'},
[8] = { path = '/images/game/portraits/hyuuga'},
}

local clansName = 
{
[0] = { path = 'None'},
[1] = { path = 'Maito'},
[2] = { path = 'Inuzuka'},
[3] = { path = 'Aburame'},
[4] = { path = 'Hyuuga'},
[5] = { path = 'Uchiha'},
[6] = { path = 'Nara'},
[7] = { path = 'Akimichi'},
[8] = { path = '/images/game/portraits/hyuuga'},
}


local ranks = 
{
 [1] = { path = 'Academy Student'},
 [2] = { path = 'Gennin'},
 [3] = { path = 'Chunnin'},
 [4] = { path = 'Jounnin'},
 [5] = { path = 'Special Jounnin'},
 [6] = { path = 'ANBU'},
 [7] = { path = 'ANBU Captain'},
 [8] = { path = 'Sannin'},
 [9] = { path = 'Kage'},
}


local ranksMiniature = 
{
 [1] = { path = '/images/game/skills/student'},
 [2] = { path = '/images/game/skills/gennin'},
 [3] = { path = '/images/game/skills/chunnin'},
 [4] = { path = '/images/game/skills/jounnin'},
 [5] = { path = '/images/game/skills/jounnin'},
 [6] = { path = '/images/game/skills/anbu'},
 [7] = { path = '/images/game/skills/anbu'},
 [8] = { path = '/images/game/skills/konoha'},
 [9] = { path = '/images/game/skills/konoha'},
}



local miniature =
{
[0] = { path = '/images/game/skills/uchiha'},
[1] = { path = '/images/game/skills/maito'},
[2] = { path = '/images/game/skills/inuzuka'},
[3] = { path = '/images/game/skills/aburame'},
[4] = { path = '/images/game/skills/hyuuga'},
[5] = { path = '/images/game/skills/uchiha'},
[6] = { path = '/images/game/skills/nara'},
[7] = { path = '/images/game/skills/akimichi'},
[8] = { path = '/images/game/skills/hyuuga'},
}

local villages = 
{
[0] = { path = 'Konohagakure'},
[1] = { path = 'Konohagakure'},
[2] = { path = 'Konohagakure'},
[3] = { path = 'Konohagakure'},
[4] = { path = 'Konohagakure'},
[5] = { path = 'Konohagakure'},
[6] = { path = 'Konohagakure'},
[7] = { path = 'Konohagakure'},
[8] = { path = '/images/game/portraits/hyuuga'},
}


local canLevelUp =
{
[7] = 'chakraLevelButton', 
[0] = 'taijutsuButton', 
[1] = 'ninjutsuButton', 
[2] = 'genjutsuButton', 
[3] = 'meleeWeaponsButton', 
[4] = 'distanceWeaponsButton', 
[5] = 'resistanceButton', 
[6] = 'agilityButton', 
}

local skillCosts =
{
[7] = 'chakraLevelCost', 
[0] = 'taijutsuCost', 
[1] = 'ninjutsuCost', 
[2] = 'genjutsuCost', 
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
  
  ProtocolGame.registerExtendedOpcode(27, getNinjaInfo)
  ProtocolGame.registerExtendedOpcode(28, getReqInfo)
  ProtocolGame.registerExtendedOpcode(29, getAttackSpeed)
  ProtocolGame.registerExtendedOpcode(10, missionInfo)

  g_keyboard.bindKeyDown('Ctrl+S', toggle) 
  skillsWindow = g_ui.loadUI('skills', modules.game_interface.getMapPanel())
  skillsWindow:disableResize()
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
  ProtocolGame.unregisterExtendedOpcode(27)
  ProtocolGame.unregisterExtendedOpcode(28)
  ProtocolGame.unregisterExtendedOpcode(29)
  ProtocolGame.unregisterExtendedOpcode(10)
  
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
  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
  protocolGame:sendExtendedOpcode(27)
  end
    local protocolGame = g_game.getProtocolGame()
  if protocolGame then
  protocolGame:sendExtendedOpcode(28)
  end
      local protocolGame = g_game.getProtocolGame()
  if protocolGame then
  protocolGame:sendExtendedOpcode(29)
  end
  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
  protocolGame:sendExtendedOpcode(10)
  end
  local player = g_game.getLocalPlayer()
  if not player then return end

  if expSpeedEvent then expSpeedEvent:cancel() end
  expSpeedEvent = cycleEvent(checkExpSpeed, 30*1000)
  onLevelChange(player, player:getLevel(), player:getLevelPercent())
  onNameChange(player, g_game.getCharacterName())

  onExperienceChange(player, player:getExperience())
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
  if skillsButton:isOn() then
	refresh()
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
  genjutsuTooltip = skillsWindow:recursiveGetChildById('genjutsuButton')
  resistenceTooltip = skillsWindow:recursiveGetChildById('resistanceButton')
  ninjutsuTooltip = skillsWindow:recursiveGetChildById('ninjutsuButton')
  local msg = InputMessage.create()
  msg:setBuffer(buffer)
  
  local player = g_game.getLocalPlayer()
  if not player then return end
  
  
  local vocations = tonumber(buffer)
  if vocations and vocations ~= 0 then
  local clansNames = clansName[vocations].path
  setSkillValue('clan', clansNames)
  setSkillValue('village', villages[vocations].path) 
  skillsWindow:recursiveGetChildById('portraitPanel'):setImageSource(clans[vocations].path)
  skillsWindow:recursiveGetChildById('clanMiniature'):setImageSource(miniature[vocations].path)
  genjutsuTooltip:setTooltip(tr('Genjutsu: Aumenta a chance de realizar um Genjutsu\ne tambem de escapar de um efeito\nde genjutsu.'))
  resistenceTooltip:setTooltip(tr('Resistence: Aumenta sua defesa e tambem\na chance de dar block ao receber um dano.\nADICIONAL +5 HP'))
  ninjutsuTooltip:setTooltip(tr('Ninjutsu: Aumenta o dano de jutsus\nque realizam selos,jutsus que nao sao\nde dano fisico'))  
	end 

  setSkillValue('bounty', 0)
  local skillPoints = player:getSoul()
  setSkillValue('skillPointsLabel', skillPoints)
    
  player:setSoul(skillPoints)
  onSoulChange(player, skillPoints)
 updateLvUpIcons(skillPoints)
  
end

function getAttackSpeed(protocol, opcode, buffer)
  local attackspeed = buffer
  setSkillValue('atkSpeed', attackspeed)
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
  setSkillValue('level', tr(value))
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
       
    --  print("\ncost = ".. cost .. " / " .. "soul = ".. soul)
       
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



function getReqInfo(cid, opcode, buffer)
  local msg = InputMessage.create()
  msg:setBuffer(buffer)
  
  local player = g_game.getLocalPlayer()
  if not player then return end
  local rank = tonumber(buffer)
  print(buffer)
  if ranks and rank ~= 0 then
  setSkillValue('rank', ranks[rank].path)
  skillsWindow:recursiveGetChildById('rankMiniature'):setImageSource(ranksMiniature[rank].path)
end
end

function missionInfo(cid, opcode, buffer)
	local d = buffer:match('D = (.-) De-')
	local c = buffer:match('C = (.-) Ce-')
	local b = buffer:match('B = (.-) Be-')
	local a = buffer:match('A = (.-) Ae-')
    local s = buffer:match('S = (.-) Se-')
	local msg = InputMessage.create()
	local player = g_game.getLocalPlayer()
	if not player then return end
	setSkillValue('rankd',  d)
	setSkillValue('rankc',  c)
	setSkillValue('rankb',  b)
	setSkillValue('ranka',  a)
	setSkillValue('ranks',  s)
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