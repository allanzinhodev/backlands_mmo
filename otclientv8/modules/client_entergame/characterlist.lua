CharacterList = { }

-- private variables
local charactersWindow
local loadBox
local characterList
local errorBox
local waitingWindow
local autoReconnectButton
local updateWaitEvent
local resendWaitEvent
local loginEvent
local autoReconnectEvent
local lastLogout = 0
local selectedIndex = 1

-- private functions
local function tryLogin(charInfo, tries)
  tries = tries or 1

  if tries > 50 then
    return
  end

  if g_game.isOnline() then
    if tries == 1 then
      g_game.safeLogout()
    end
    loginEvent = scheduleEvent(function() tryLogin(charInfo, tries+1) end, 100)
    return
  end

  CharacterList.hide()
  g_game.loginWorld(G.account, G.password, charInfo.worldName, charInfo.worldHost, charInfo.worldPort, charInfo.characterName, G.authenticatorToken, G.sessionKey)
  g_logger.info("Login to " .. charInfo.worldHost .. ":" .. charInfo.worldPort)
  loadBox = displayCancelBox(tr('Please wait'), tr('Connecting to game server...'))
  connect(loadBox, { onCancel = function()
                                  loadBox = nil
                                  g_game.cancelLogin()
                                  CharacterList.show()
                                end })

  -- save last used character
  g_settings.set('last-used-character', charInfo.characterName)
  g_settings.set('last-used-world', charInfo.worldName)
end

local function updateWait(timeStart, timeEnd)
  if waitingWindow then
    local time = g_clock.seconds()
    if time <= timeEnd then
      local percent = ((time - timeStart) / (timeEnd - timeStart)) * 100
      local timeStr = string.format("%.0f", timeEnd - time)

      local progressBar = waitingWindow:getChildById('progressBar')
      progressBar:setPercent(percent)

      local label = waitingWindow:getChildById('timeLabel')
      label:setText(tr('Trying to reconnect in %s seconds.', timeStr))

      updateWaitEvent = scheduleEvent(function() updateWait(timeStart, timeEnd) end, 1000 * progressBar:getPercentPixels() / 100 * (timeEnd - timeStart))
      return true
    end
  end

  if updateWaitEvent then
    updateWaitEvent:cancel()
    updateWaitEvent = nil
  end
end

local function resendWait()
  if waitingWindow then
    waitingWindow:destroy()
    waitingWindow = nil

    if updateWaitEvent then
      updateWaitEvent:cancel()
      updateWaitEvent = nil
    end

    if charactersWindow then
      local selected = G.characters[selectedIndex]
      if selected then
        local charInfo = { worldHost = selected.worldIp,
                           worldPort = selected.worldPort,
                           worldName = selected.worldName,
                           characterName = selected.name }
        tryLogin(charInfo)
      end
    end
  end
end

local function onLoginWait(message, time)
  CharacterList.destroyLoadBox()

  waitingWindow = g_ui.displayUI('waitinglist')

  local label = waitingWindow:getChildById('infoLabel')
  label:setText(message)

  updateWaitEvent = scheduleEvent(function() updateWait(g_clock.seconds(), g_clock.seconds() + time) end, 0)
  resendWaitEvent = scheduleEvent(resendWait, time * 1000)
end

function onGameLoginError(message)
  CharacterList.destroyLoadBox()
  errorBox = displayErrorBox(tr("Login Error"), message)
  errorBox.onOk = function()
    errorBox = nil
    CharacterList.showAgain()
  end
  scheduleAutoReconnect()
end

function onGameLoginToken(unknown)
  CharacterList.destroyLoadBox()
  -- TODO: make it possible to enter a new token here / prompt token
  errorBox = displayErrorBox(tr("Two-Factor Authentification"), 'A new authentification token is required.\nPlease login again.')
  errorBox.onOk = function()
    errorBox = nil
    EnterGame.show()
  end
end

function onGameConnectionError(message, code)
  CharacterList.destroyLoadBox()
  if (not g_game.isOnline() or code ~= 2) and not errorBox then -- code 2 is normal disconnect, end of file
    local text = translateNetworkError(code, g_game.getProtocolGame() and g_game.getProtocolGame():isConnecting(), message)
    errorBox = displayErrorBox(tr("Connection Error"), text)
    errorBox.onOk = function()
      errorBox = nil
      CharacterList.showAgain()
    end
  end
  scheduleAutoReconnect()
end

function onGameUpdateNeeded(signature)
  CharacterList.destroyLoadBox()
  errorBox = displayErrorBox(tr("Update needed"), tr('Enter with your account again to update your client.'))
  errorBox.onOk = function()
    errorBox = nil
    CharacterList.showAgain()
  end  
end

function onGameEnd()
  scheduleAutoReconnect()
  CharacterList.showAgain()
end

function onLogout()
  lastLogout = g_clock.millis()
end

function scheduleAutoReconnect()
  if lastLogout + 2000 > g_clock.millis() then
    return
  end
  if autoReconnectEvent then
    removeEvent(autoReconnectEvent)    
  end
  autoReconnectEvent = scheduleEvent(executeAutoReconnect, 2500)
end

function executeAutoReconnect()  
  if g_game.isOnline() then
    return
  end
  if errorBox then
    errorBox:destroy()
    errorBox = nil
  end
  CharacterList.doLogin()
end

-- public functions
function CharacterList.init()
  if USE_NEW_ENERGAME then return end
  connect(g_game, { onLoginError = onGameLoginError })
  connect(g_game, { onLoginToken = onGameLoginToken })
  connect(g_game, { onUpdateNeeded = onGameUpdateNeeded })
  connect(g_game, { onConnectionError = onGameConnectionError })
  connect(g_game, { onGameStart = CharacterList.destroyLoadBox })
  connect(g_game, { onLoginWait = onLoginWait })
  connect(g_game, { onGameEnd = onGameEnd })
  connect(g_game, { onLogout = onLogout })

  if G.characters then
    CharacterList.create(G.characters, G.characterAccount)
  end
end

function CharacterList.terminate()
 if USE_NEW_ENERGAME then return end
  disconnect(g_game, { onLoginError = onGameLoginError })
  disconnect(g_game, { onLoginToken = onGameLoginToken })
  disconnect(g_game, { onUpdateNeeded = onGameUpdateNeeded })
  disconnect(g_game, { onConnectionError = onGameConnectionError })
  disconnect(g_game, { onGameStart = CharacterList.destroyLoadBox })
  disconnect(g_game, { onLoginWait = onLoginWait })
  disconnect(g_game, { onGameEnd = onGameEnd })
  disconnect(g_game, { onLogout = onLogout })

  if charactersWindow then
    characterList = nil
    charactersWindow:destroy()
    charactersWindow = nil
  end

  if loadBox then
    g_game.cancelLogin()
    loadBox:destroy()
    loadBox = nil
  end

  if waitingWindow then
    waitingWindow:destroy()
    waitingWindow = nil
  end

  if updateWaitEvent then
    removeEvent(updateWaitEvent)
    updateWaitEvent = nil
  end

  if resendWaitEvent then
    removeEvent(resendWaitEvent)
    resendWaitEvent = nil
  end

  if loginEvent then
    removeEvent(loginEvent)
    loginEvent = nil
  end

  CharacterList = nil
end

local CardStates = {
  LEFT = {
    width = 100, height = 140, marginLeft = 10, opacity = 0.6,
    outfitSize = 48, outfitMarginTop = 10, outfitMarginLeft = -8,
    borderWidth = 0, nameFont = "verdana-11px-monochrome", nameColor = "#bbbbbb",
    flagOpacity = 0, groundOpacity = 0, flagMarginTop = 23, groundMarginTop = 98, groundMarginLeft = 8
  },
  CENTER = {
    width = 160, height = 224, marginLeft = 150, opacity = 1.0,
    outfitSize = 96, outfitMarginTop = 15, outfitMarginLeft = -24,
    borderWidth = 0, nameFont = "verdana-11px-rounded", nameColor = "#ffffff",
    flagOpacity = 1, groundOpacity = 1, flagMarginTop = 30, groundMarginTop = 74, groundMarginLeft = 8
  },
  RIGHT = {
    width = 100, height = 140, marginLeft = 350, opacity = 0.6,
    outfitSize = 48, outfitMarginTop = 10, outfitMarginLeft = -8,
    borderWidth = 0, nameFont = "verdana-11px-monochrome", nameColor = "#bbbbbb",
    flagOpacity = 0, groundOpacity = 0, flagMarginTop = 23, groundMarginTop = 98, groundMarginLeft = 8
  },
  HIDDEN_LEFT = {
    width = 100, height = 140, marginLeft = -120, opacity = 0,
    outfitSize = 48, outfitMarginTop = 10, outfitMarginLeft = -8,
    borderWidth = 0, nameFont = "verdana-11px-monochrome", nameColor = "#bbbbbb",
    flagOpacity = 0, groundOpacity = 0, flagMarginTop = 23, groundMarginTop = 98, groundMarginLeft = 8
  },
  HIDDEN_RIGHT = {
    width = 100, height = 140, marginLeft = 480, opacity = 0,
    outfitSize = 48, outfitMarginTop = 10, outfitMarginLeft = -8,
    borderWidth = 0, nameFont = "verdana-11px-monochrome", nameColor = "#bbbbbb",
    flagOpacity = 0, groundOpacity = 0, flagMarginTop = 23, groundMarginTop = 98, groundMarginLeft = 8
  }
}

local function applyCardState(card, state)
  card:setWidth(state.width)
  card:setHeight(state.height)
  card:setMarginLeft(state.marginLeft)
  card:setOpacity(state.opacity)
  card:setBorderWidth(state.borderWidth)
  
  local outfit = card:getChildById('outfit')
  outfit:setSize({width = state.outfitSize, height = state.outfitSize})
  outfit:setMarginTop(state.outfitMarginTop)
  outfit:setMarginLeft(state.outfitMarginLeft)
  
  local name = card:getChildById('name')
  name:setFont(state.nameFont)
  name:setColor(state.nameColor)
  
  card:getChildById('level'):setFont(state.nameFont)
  card:getChildById('level'):setColor(state.nameColor)
  
  local flag = card:getChildById('flag')
  flag:setOpacity(state.flagOpacity)
  flag:setMarginTop(state.flagMarginTop)

  local ground = card:getChildById('ground')
  ground:setOpacity(state.groundOpacity)
  ground:setMarginTop(state.groundMarginTop)
  ground:setMarginLeft(state.groundMarginLeft)
end

local function interpolateState(stateA, stateB, progress)
  local state = {}
  for k, v in pairs(stateA) do
    if type(v) == "number" then
      state[k] = v + (stateB[k] - v) * progress
    else
      state[k] = progress < 0.5 and v or stateB[k]
    end
  end
  return state
end

local isAnimating = false

function CharacterList.updateCards()
  if not G.characters or #G.characters == 0 then return end

  local prevCard = charactersWindow:getChildById('charactersPanel'):getChildById('prevCharacter')
  local selectedCard = charactersWindow:getChildById('charactersPanel'):getChildById('selectedCharacter')
  local nextCard = charactersWindow:getChildById('charactersPanel'):getChildById('nextCharacter')

  local char = G.characters[selectedIndex]
  selectedCard:getChildById('name'):setText(char.name)
  selectedCard:getChildById('level'):setText("Level " .. (char.level or 1))
  if char.vocation then
    selectedCard:getChildById('flag'):setImageSource("/images/flags/" .. char.vocation .. ".png")
  end
  if char.outfit then selectedCard:getChildById('outfit'):setOutfit(char.outfit) end
  applyCardState(selectedCard, CardStates.CENTER)

  if #G.characters > 1 then
    local prevIndex = selectedIndex - 1
    if prevIndex < 1 then prevIndex = #G.characters end
    local prevChar = G.characters[prevIndex]
    prevCard:getChildById('name'):setText(prevChar.name)
    prevCard:getChildById('level'):setText("Level " .. (prevChar.level or 1))
    if prevChar.vocation then prevCard:getChildById('flag'):setImageSource("/images/flags/" .. prevChar.vocation .. ".png") end
    if prevChar.outfit then prevCard:getChildById('outfit'):setOutfit(prevChar.outfit) end
    applyCardState(prevCard, CardStates.LEFT)

    local nextIndex = selectedIndex + 1
    if nextIndex > #G.characters then nextIndex = 1 end
    local nextChar = G.characters[nextIndex]
    nextCard:getChildById('name'):setText(nextChar.name)
    nextCard:getChildById('level'):setText("Level " .. (nextChar.level or 1))
    if nextChar.vocation then nextCard:getChildById('flag'):setImageSource("/images/flags/" .. nextChar.vocation .. ".png") end
    if nextChar.outfit then nextCard:getChildById('outfit'):setOutfit(nextChar.outfit) end
    applyCardState(nextCard, CardStates.RIGHT)
  else
    applyCardState(prevCard, CardStates.HIDDEN_LEFT)
    applyCardState(nextCard, CardStates.HIDDEN_RIGHT)
  end
end

function CharacterList.animateCarousel(direction)
  if not G.characters or #G.characters <= 1 then return end
  if isAnimating then return end
  isAnimating = true

  local prevCard = charactersWindow:getChildById('charactersPanel'):getChildById('prevCharacter')
  local selectedCard = charactersWindow:getChildById('charactersPanel'):getChildById('selectedCharacter')
  local nextCard = charactersWindow:getChildById('charactersPanel'):getChildById('nextCharacter')

  local step = 0
  local totalSteps = 20

  local transitions = {}
  if direction == "next" then
    transitions = {
      {card = selectedCard, from = CardStates.CENTER, to = CardStates.LEFT},
      {card = nextCard, from = CardStates.RIGHT, to = CardStates.CENTER},
      {card = prevCard, from = CardStates.LEFT, to = CardStates.HIDDEN_LEFT}
    }
  else
    transitions = {
      {card = selectedCard, from = CardStates.CENTER, to = CardStates.RIGHT},
      {card = prevCard, from = CardStates.LEFT, to = CardStates.CENTER},
      {card = nextCard, from = CardStates.RIGHT, to = CardStates.HIDDEN_RIGHT}
    }
  end

  local function doStep()
    step = step + 1
    local progress = step / totalSteps

    for _, trans in ipairs(transitions) do
      applyCardState(trans.card, interpolateState(trans.from, trans.to, progress))
    end

    if step < totalSteps then
      scheduleEvent(doStep, 15)
    else
      if direction == "next" then
        selectedIndex = selectedIndex + 1
        if selectedIndex > #G.characters then selectedIndex = 1 end
      else
        selectedIndex = selectedIndex - 1
        if selectedIndex < 1 then selectedIndex = #G.characters end
      end
      
      CharacterList.updateCards()
      isAnimating = false
    end
  end

  doStep()
end

function CharacterList.selectNext()
  CharacterList.animateCarousel("next")
end

function CharacterList.selectPrevious()
  CharacterList.animateCarousel("prev")
end

function CharacterList.create(characters, account, otui)
  if not otui then otui = 'characterlist' end
  if charactersWindow then
    charactersWindow:destroy()
  end

  charactersWindow = g_ui.displayUI(otui)

  -- characters
  G.characters = characters
  G.characterAccount = account

  selectedIndex = 1
  for i, char in ipairs(characters) do
    if g_settings.get('last-used-character') == char.name and g_settings.get('last-used-world') == char.worldName then
      selectedIndex = i
      break
    end
  end

  CharacterList.updateCards()
end

function CharacterList.destroy()
  CharacterList.hide(true)

  if charactersWindow then
    characterList = nil
    charactersWindow:destroy()
    charactersWindow = nil
  end
end

function CharacterList.show()
  if loadBox or errorBox or not charactersWindow then return end
  charactersWindow:show()
  charactersWindow:raise()
  charactersWindow:focus()
end

function CharacterList.hide(showLogin)
  removeEvent(autoReconnectEvent)
  autoReconnectEvent = nil

  showLogin = showLogin or false
  charactersWindow:hide()

  if showLogin and EnterGame and not g_game.isOnline() then
    EnterGame.show()
  end
end

function CharacterList.showAgain()
  if charactersWindow then
    CharacterList.show()
  end
end

function CharacterList.isVisible()
  if charactersWindow and charactersWindow:isVisible() then
    return true
  end
  return false
end

function CharacterList.doLogin()
  removeEvent(autoReconnectEvent)
  autoReconnectEvent = nil

  local selected = G.characters[selectedIndex]
  if selected then
    local charInfo = { worldHost = selected.worldIp,
                       worldPort = selected.worldPort,
                       worldName = selected.worldName,
                       characterName = selected.name }
    charactersWindow:hide()
    if loginEvent then
      removeEvent(loginEvent)
      loginEvent = nil
    end
    tryLogin(charInfo)
  else
    displayErrorBox(tr('Error'), tr('You must select a character to login!'))
  end
end

function CharacterList.destroyLoadBox()
  if loadBox then
    loadBox:destroy()
    loadBox = nil
  end
end

function CharacterList.cancelWait()
  if waitingWindow then
    waitingWindow:destroy()
    waitingWindow = nil
  end

  if updateWaitEvent then
    removeEvent(updateWaitEvent)
    updateWaitEvent = nil
  end

  if resendWaitEvent then
    removeEvent(resendWaitEvent)
    resendWaitEvent = nil
  end

  CharacterList.destroyLoadBox()
  CharacterList.showAgain()
end
