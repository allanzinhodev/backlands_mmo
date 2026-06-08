MessageSettings = {
  none            = {},
  consoleRed      = { color = TextColors.red,    consoleTab='Default' },
  consoleOrange   = { color = TextColors.orange, consoleTab='Default' },
  consoleBlue     = { color = TextColors.blue,   consoleTab='Default' },
  centerRed       = { color = TextColors.red,    consoleTab='Server Log', screenTarget='lowCenterLabel' },
  centerGreen     = { color = TextColors.green,  consoleTab='Server Log', screenTarget='highCenterLabel',   consoleOption='showInfoMessagesInConsole' },
  centerWhite     = { color = TextColors.white,  consoleTab='Server Log', screenTarget='middleCenterLabel', consoleOption='showEventMessagesInConsole' },
  bottomWhite     = { color = TextColors.white,  consoleTab='Server Log', screenTarget='statusLabel',       consoleOption='showEventMessagesInConsole' },
  status          = { color = TextColors.white,  consoleTab='Server Log', screenTarget='statusLabel',       consoleOption='showStatusMessagesInConsole' },
  statusSmall     = { color = TextColors.white,                           screenTarget='statusLabel' },
  private         = { color = TextColors.lightblue,                       screenTarget='privateLabel' }
}

MessageTypes = {}
local defaultTypes = {
  [MessageModes.MonsterSay or "MonsterSay"] = MessageSettings.consoleOrange,
  [MessageModes.MonsterYell or "MonsterYell"] = MessageSettings.consoleOrange,
  [MessageModes.BarkLow or "BarkLow"] = MessageSettings.consoleOrange,
  [MessageModes.BarkLoud or "BarkLoud"] = MessageSettings.consoleOrange,
  [MessageModes.Failure or "Failure"] = MessageSettings.statusSmall,
  [MessageModes.Login or "Login"] = MessageSettings.bottomWhite,
  [MessageModes.Game or "Game"] = MessageSettings.centerWhite,
  [MessageModes.Status or "Status"] = MessageSettings.status,
  [MessageModes.Warning or "Warning"] = MessageSettings.centerRed,
  [MessageModes.Look or "Look"] = MessageSettings.centerGreen,
  [MessageModes.Loot or "Loot"] = MessageSettings.centerGreen,
  [MessageModes.Red or "Red"] = MessageSettings.consoleRed,
  [MessageModes.Blue or "Blue"] = MessageSettings.consoleBlue,
  [MessageModes.PrivateFrom or "PrivateFrom"] = MessageSettings.consoleBlue,

  [MessageModes.GamemasterBroadcast or "GamemasterBroadcast"] = MessageSettings.consoleRed,

  [MessageModes.DamageDealed or "DamageDealed"] = MessageSettings.status,
  [MessageModes.DamageReceived or "DamageReceived"] = MessageSettings.status,
  [MessageModes.Heal or "Heal"] = MessageSettings.status,
  [MessageModes.Exp or "Exp"] = MessageSettings.status,

  [MessageModes.DamageOthers or "DamageOthers"] = MessageSettings.none,
  [MessageModes.HealOthers or "HealOthers"] = MessageSettings.none,
  [MessageModes.ExpOthers or "ExpOthers"] = MessageSettings.none,

  [MessageModes.TradeNpc or "TradeNpc"] = MessageSettings.centerWhite,
  [MessageModes.Guild or "Guild"] = MessageSettings.centerWhite,
  [MessageModes.Party or "Party"] = MessageSettings.centerGreen,
  [MessageModes.PartyManagement or "PartyManagement"] = MessageSettings.centerWhite,
  [MessageModes.TutorialHint or "TutorialHint"] = MessageSettings.centerWhite,
  [MessageModes.BeyondLast or "BeyondLast"] = MessageSettings.centerWhite,
  [MessageModes.Report or "Report"] = MessageSettings.consoleRed,
  [MessageModes.HotkeyUse or "HotkeyUse"] = MessageSettings.centerGreen,

  [254] = MessageSettings.private
}
for k, v in pairs(defaultTypes) do
  if type(k) == "number" then
    MessageTypes[k] = v
  end
end

messagesPanel = nil

function init()
  for messageMode, _ in pairs(MessageTypes) do
    registerMessageMode(messageMode, displayMessage)
  end

  connect(g_game, 'onGameEnd', clearMessages)
  messagesPanel = g_ui.loadUI('textmessage', modules.game_interface.getRootPanel())
end

function terminate()
  for messageMode, _ in pairs(MessageTypes) do
    unregisterMessageMode(messageMode, displayMessage)
  end

  disconnect(g_game, 'onGameEnd', clearMessages)
  clearMessages()
  messagesPanel:destroy()
end

function calculateVisibleTime(text)
  return math.max(#text * 50, 3000)
end

function displayMessage(mode, text)
  if not g_game.isOnline() then return end

  local msgtype = MessageTypes[mode]
  if not msgtype then
    return
  end

  if msgtype == MessageSettings.none then return end

  if msgtype.consoleTab ~= nil and (msgtype.consoleOption == nil or modules.client_options.getOption(msgtype.consoleOption)) then
    modules.game_console.addText(text, msgtype, tr(msgtype.consoleTab))
    --TODO move to game_console
  end

  if msgtype.screenTarget then
    local label = messagesPanel:recursiveGetChildById(msgtype.screenTarget)
    label:setText(text)
    label:setColor(msgtype.color)
    label:setVisible(true)
    removeEvent(label.hideEvent)
    label.hideEvent = scheduleEvent(function() label:setVisible(false) end, calculateVisibleTime(text))
  end
end

function displayPrivateMessage(text)
  displayMessage(254, text)
end

function displayStatusMessage(text)
  displayMessage(MessageModes.Status, text)
end

function displayFailureMessage(text)
  displayMessage(MessageModes.Failure, text)
end

function displayGameMessage(text)
  displayMessage(MessageModes.Game, text)
end

function displayBroadcastMessage(text)
  displayMessage(MessageModes.Warning, text)
end

function clearMessages()
  for _i,child in pairs(messagesPanel:recursiveGetChildren()) do
    if child:getId():match('Label') then
      child:hide()
      removeEvent(child.hideEvent)
    end
  end
end

function LocalPlayer:onAutoWalkFail(player)
  modules.game_textmessage.displayFailureMessage(tr('There is no way.'))
end
