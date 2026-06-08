dogWindow = nil
dogButton = nil

MIN_HEIGHT = 10
MAX_HEIGHT = 405
DOG_SLOT = InventorySlotFinger

dogSkillPoints = 0

healthTooltip = 'Your character health is %d out of %d.'
manaTooltip = 'Your character chakra is %d out of %d.'  
staminaTooltip = 'Your character stamina is %d out of %d.'  
experienceTooltip = 'You have %d%% to advance to level %d.'



function init() 
   connect(g_game, {
    onGameStart = refresh,
    onGameEnd = offline
  })
  
  connect(LocalPlayer, { onInventoryChange = onInventoryChange })
  
  dogButton = modules.client_topmenu.addRightGameToggleButton('dogButton', tr('Dog Info') .. ' (Ctrl+D)', '/images/topbuttons/skills', toggle)
  dogWindow = g_ui.loadUI('dog', modules.game_interface.getMapPanel())
  
  healthBar = dogWindow:recursiveGetChildById('dogHealth')
  manaBar = dogWindow:recursiveGetChildById('dogMana')
  staminaBar = dogWindow:recursiveGetChildById('dogStamina')
  experienceBar = dogWindow:recursiveGetChildById('dogExperience')
  
  dogPanel = dogWindow:getChildById('contentsPanel')
  
  
  ProtocolGame.registerExtendedOpcode(102, onExtendedOpcode)
  ProtocolGame.registerExtendedOpcode(103, onExtendedOpcode2)
  ProtocolGame.registerExtendedOpcode(105, openDogWindow)
 
  refresh()
  dogWindow:setup() 
  dogButton:setOn(false)
         dogButton:setVisible(false)
         dogWindow:close()
end

function terminate()
   disconnect(g_game, {
    onGameStart = refresh,
    onGameEnd = offline
  })
  
  disconnect(LocalPlayer, { onInventoryChange = onInventoryChange })
  
  g_keyboard.unbindKeyDown('Ctrl+D')
  ProtocolGame.unregisterExtendedOpcode(102)
  ProtocolGame.unregisterExtendedOpcode(103)
  ProtocolGame.unregisterExtendedOpcode(105)
  dogWindow:destroy()
  dogButton:destroy()
end

function expForLevel(level)
  return math.floor((50*level*level*level)/3 - 100*level*level + (850*level)/3 - 200)
end

function expToAdvance(currentLevel, currentExp)
  return expForLevel(currentLevel+1) - currentExp
end

function refresh()
    local player = g_game.getLocalPlayer()   
    if g_game.isOnline() then
      onInventoryChange(player, DOG_SLOT, player:getInventoryItem(DOG_SLOT))
      local voc = player:getVocation()
      if(voc ~= 5 and voc > 0) then
         dogButton:setOn(false)
         dogButton:setVisible(false)
         dogWindow:close()
      end
    else
      onInventoryChange(player, DOG_SLOT, nil)
    end

  dogWindow:setContentMinimumHeight(MIN_HEIGHT)
  dogWindow:setContentMaximumHeight(MAX_HEIGHT)
  requestInfo()
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
refresh()
  if dogButton:isOn() then
    dogWindow:close()
    dogButton:setOn(false)
  else
    dogWindow:open()
    dogButton:setOn(true)
  end
end

function openDogWindow(protocol, opcode, buffer)
  local player = g_game.getLocalPlayer()
  if not player then return end
  local msg = InputMessage.create()
  msg:setBuffer(buffer)
  local action = msg:getData()
  if(action == 10) then
    dogWindow:open()
  else
    dogWindow:close()
  end
end

function onMiniWindowClose()
  dogButton:setOn(false)
end

function onExtendedOpcode2(protocol, opcode, buffer)
   local player = g_game.getLocalPlayer()
  if not player then return end
   onNameChange(localPlayer, buffer)
end

function onExtendedOpcode(protocol, opcode, buffer)
  local msg = InputMessage.create()
  msg:setBuffer(buffer)
  
  local player = g_game.getLocalPlayer()
  if not player then return end
  
  setSkillValue('level',msg:getData() - 2)
  onExperienceChange(localPlayer,  msg:getData() - 2,  msg:getData() - 2)
  onHealthChange(localPlayer,  msg:getData() - 2,  msg:getData() - 2)
  onManaChange(localPlayer,  msg:getData() - 2,  msg:getData() - 2)
  onStaminaChange(localPlayer,  msg:getData() - 2,  msg:getData() - 2)
   setSkillValue('attackValue',msg:getData() - 2)
   setSkillValue('resistanceValue',msg:getData() - 2)
   setSkillValue('agilityValue',msg:getData() - 2)
   local skillPoints = msg:getData() - 2
   dogSkillPoints = skillPoints
   setSkillValue('skillPointsLabel',dogSkillPoints)
   setSkillValue('chakraLevelValue',msg:getData() - 2)
   setSkillValue('atkSpeed',msg:getData() - 2)
   setSkillValue('movSpeed',msg:getData() - 2)
   updateLvUpIcons(skillPoints) 
end

function requestInfo()
    local player = g_game.getLocalPlayer()
    if not player then return end
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
    protocolGame:sendExtendedOpcode(OPCODE_REQDOGINFO, 1)
    end
end

function onHealthChange(localPlayer, health, maxHealth)
  healthBar:setText(health .. ' / ' .. maxHealth)
  healthBar:setTooltip(tr(healthTooltip, health, maxHealth))
  healthBar:setValue(health, 0, maxHealth)
end


function onStaminaChange(localPlayer, stamina, maxStamina)
  staminaBar:setText(stamina .. ' / ' .. maxStamina)
  staminaBar:setTooltip(tr(staminaTooltip, stamina, maxStamina))
  staminaBar:setValue(stamina, 0, maxStamina)
end

function onManaChange(localPlayer, mana, maxMana)
  manaBar:setText(mana .. ' / ' .. maxMana)
  manaBar:setTooltip(tr(manaTooltip, mana, maxMana))
  manaBar:setValue(mana, 0, maxMana) 
end


function onLevelChange(localPlayer, value, percent)
  experienceBar:setText(percent .. '%')
  experienceBar:setTooltip(tr(experienceTooltip, percent, value+1))
  experienceBar:setPercent(percent)
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
  setSkillValue(dog[id], level)
  onBaseSkillChange(localPlayer, id, localPlayer:getSkillBaseLevel(id))
end

function onBaseSkillChange(localPlayer, id, baseLevel)
  setSkillBase(dog[id], localPlayer:getSkillLevel(id), baseLevel)
end

function onSoulChange(localPlayer, soul)
  setSkillValue('skillPointsLabel', soul)
  updateLvUpIcons(soul)
end

function onExperienceChange(localPlayer, value, next)
  setSkillValue('experience', value)
  local percent = ((value/next)*100)
  local string = percent .. "%"
  experienceBar:setText(string)
  experienceBar:setValue(value, 0, next) 
end

function setSkillBase(id, value, baseValue)
  if baseValue <= 0 or value < 0 then
    return
  end
  local widget = dogWindow:recursiveGetChildById(id)
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
  local widget = dogWindow:recursiveGetChildById(id)
  widget:setText(value)
end

function setSkillColor(id, value)
  local widget = dogWindow:recursiveGetChildById(id)
  widget:setColor(value)
end

function setSkillTooltip(id, value)
  local widget = dogWindow:recursiveGetChildById(id)
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
local canLevelUp = {"resistanceButton", "attackButton", "agilityButton", "chakraLevelButton"}
local player = g_game.getLocalPlayer()
  for _,v in pairs(canLevelUp) do
    local skill = dogWindow:recursiveGetChildById(v)
       local cost = 1       
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
    protocolGame:sendExtendedOpcode(OPCODE_DOGSKILL, skill)
    end
end

function onButtonClick(id)
  local player = g_game.getLocalPlayer()
  if not player then return end
  tryAddSkill(player, id)
  updateLvUpIcons(dogSkillPoints)
end 

-- hooked events
function onInventoryChange(player, slot, item, oldItem)
  if slot ~= DOG_SLOT then return end
  local itemWidget = dogPanel:recursiveGetChildById('slot9')
  if item then         
    itemWidget:setStyle('Item')
    itemWidget:setItem(item)
  else
    itemWidget:setStyle("JutsuSlot")
    itemWidget:setItem(nil)
  end
end