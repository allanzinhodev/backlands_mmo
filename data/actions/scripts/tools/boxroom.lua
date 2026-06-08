--instruções: registrar isso no XML com action ou uniqueID e por na alavanca que iniciará

--functions--
local function sendBlueMessage(cid, msg)
    return doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, msg)
end  

local function registerPosInStorage(cid, storage, pos)
    setPlayerStorageValue(cid, storage.."X", pos.x)
    setPlayerStorageValue(cid, storage.."Y", pos.y)
    setPlayerStorageValue(cid, storage.."Z", pos.z) 
end

local function registerPlayerInQuest(params)
    setPlayerStorageValue(params.player, "hasActiveInQuest", 1)
    setPlayerStorageValue(params.player, "genericQuestString", params.globalStorage)
    registerPosInStorage(params.player, "genericQuestPos", params.posExit)
end 

local function getSecsString(sec)
    local sec = tonumber(sec)
    local days = 0
    local hours = 0
    local minutes = 0
    local seconds = 0

    repeat
        if sec >= 60 then
            minutes = minutes+1
            sec = sec-60
        end
    until sec < 60

    repeat
        if minutes >= 60 then
            hours = hours+1
            minutes = minutes-60
        end
    until minutes < 60

    repeat
        if hours >= 24 then
            days = days+1
            hours = hours-24
        end
    until hours < 24

    if days > 0 then
        if tostring(days):len() < 2 then
            days = "0"..days
        end
    end

    if hours > 0 then
        if tostring(hours):len() < 2 then
            hours = "0"..hours
        end
    end

    if minutes > 0 then
        if tostring(minutes):len() < 2 then
            minutes = "0"..minutes
        end
    end

    if sec > 0 then
        if tostring(sec):len() < 2 then
            sec = "0"..sec
        end
    end

    if tonumber(days) > 0 then
        return days.." day(s), "..hours.." hour(s), "..minutes.." minute(s) and "..sec.." second(s)"
    elseif tonumber(hours) > 0 then
        return hours.." hour(s), "..minutes.." minute(s) and "..sec.." second(s)"
    else
        if tonumber(minutes) > 0 then
            return minutes.." minute(s) and "..sec.." second(s)"
        else
            return sec.." second(s)"
        end
    end
end
--end--

local MyLocal = {
    price = 100, --ValorPago na entrada
    posEnter = {x=2576,y=1696,z=8}, 
    posExit = {x=2578,y=1696,z=8}, 
    trueDoll = 10306, --ID da doll que ficará dentro da caixa
    maxBoxs = 10, --Máximo de caixas na sala
    boxId = 1714, --ID das boxes, precisa ser container
    topLeftPosition = {x=2570,y=1692,z=8},
    underRightPosition = {x=2576,y=1698,z=8},
    timeInSeconds = 5000, --tempo máximo para se completar
    expWin = 1000, {x=2576,y=1696,z=8},
    moneyWin = 1000,

    --Não mexa nas variasveis abaixo--
    globalStorage = "cidBoxGame",
    timeLeft = 0,
    isActive = false,
    roomReady = true,
    currentPlayer = 0,
    avaliableTiles = {},
    boxUids = {}
}

doSetStorage(MyLocal.globalStorage, 0)

local function clean(pos)
    pos.stackpos = 0
    doCleanTile(pos)  
    doSendMagicEffect(pos, 2)
end

local function clearBoxArea()
    local topLeftPosition = MyLocal.topLeftPosition
    local underRightPosition = MyLocal.underRightPosition
    local number = 1

    for x = topLeftPosition.x, underRightPosition.x do
        for y = topLeftPosition.y, underRightPosition.y do
            addEvent(clean, 100*number, {x=x,y=y,z=8})   
            number = number+1
        end
    end
end

local function setRoomState(state)
    MyLocal.roomReady = state
end

local function stopBoxGame(remPlayer, win)
    local cid = getStorage(MyLocal.globalStorage)
    MyLocal.timeLeft = 0
    MyLocal.currentPlayer = 0
    doSetStorage(MyLocal.globalStorage, 0)

    if remPlayer == nil then
        doTeleportThing(cid, MyLocal.posExit)
    end

    if isPlayer(cid) then
        setPlayerStorageValue(cid, "hasActiveInQuest", -1)
    end

    MyLocal.isActive = false
    addEvent(setRoomState, 5000, true)
    clearBoxArea()
    MyLocal.roomReady = false

    if win then
        if isCreature(cid) then
            sendBlueMessage(cid, "Congratulations, you won! You have completed the challenge in , and received "..MyLocal.expWin.." points of experience plus "..MyLocal.moneyWin.." gold coins.")
            doPlayerAddMoney(cid, MyLocal.moneyWin) 
            doPlayerAddExp(cid, MyLocal.expWin)
            doSendAnimatedText(getPlayerPosition(cid), MyLocal.expWin, TEXTCOLOR_WHITE)
            doSendMagicEffect(getCreaturePosition(cid), 29)
        end
    end
end

local function putBoxinArea()
	local randomTrueDoll = math.random(1, MyLocal.maxBoxs)
	print(randomTrueDoll)

	for x = MyLocal.topLeftPosition.x, MyLocal.underRightPosition.x do
  		for y = MyLocal.topLeftPosition.y,  MyLocal.underRightPosition.y do
   			table.insert(MyLocal.avaliableTiles, {x = x, y = y, z = MyLocal.topLeftPosition.z, amount = 0})
  		end
	end

	for boxes = 1, MyLocal.maxBoxs do
		local container = nil
		for currentTile = 1, #MyLocal.avaliableTiles do
			if MyLocal.avaliableTiles[currentTile].amount < 4 then
				container = doCreateItem(MyLocal.boxId, 1, MyLocal.avaliableTiles[currentTile])
				MyLocal.avaliableTiles[currentTile].amount = MyLocal.avaliableTiles[currentTile].amount+1
				break
			end			
		end

		if randomTrueDoll == boxes then
			doAddContainerItem(container, MyLocal.trueDoll, 1)
		end
	end
    
    return true
end

local function startBoxGame(cid)
    MyLocal.isActive = true
    MyLocal.currentPlayer = cid
    putBoxinArea()
    doTeleportThing(cid, MyLocal.posEnter)
    MyLocal.timeLeft = os.time()+MyLocal.timeInSeconds
    registerPlayerInQuest({player = cid, posExit = MyLocal.posExit, globalStorage = MyLocal.globalStorage}) --{player, posExit, globalStorage}
    doSetStorage(MyLocal.globalStorage, cid)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You need to find the real doll inside the boxs in 2 minutes.")
end

local function loopBoxGame()
    if MyLocal.isActive == true then
        if getStorage(MyLocal.globalStorage) ~= MyLocal.currentPlayer and MyLocal.isActive then
          stopBoxGame(false)
            return true   
        end

        local currentTime = os.time()

        if MyLocal.timeLeft <= currentTime then
            sendBlueMessage(MyLocal.currentPlayer, "Your time is up, try again!")
            stopBoxGame()
            return true  
        end

        addEvent(loopBoxGame, 1000, nil)
    end
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if item.itemid == MyLocal.trueDoll then
        if cid == getStorage(MyLocal.globalStorage) then
            stopBoxGame(nil, true)
        else
            sendBlueMessage(cid, "This item belongs to a challenge and was removed.")
            doRemoveItem(item.uid, 1)
        end

        doRemoveItem(item.uid, 1)
        return true
    end

    if MyLocal.roomReady == false then
        doPlayerSendCancel(cid, "Wait a minute to get the room ready.")
        return true
    end

    if MyLocal.isActive == true then
        doPlayerSendCancel(cid, "Sorry the room is in use, wait please.")
        return true   
    end
              
    if isPlayerPzLocked(cid) then
        doPlayerSendCancel(cid, "You cannot start the chellenge with battle active.")
        return true
    end

    if doPlayerRemoveMoney(cid, MyLocal.price) == true then
        if item.itemid == 1945 then
            doTransformItem(item.uid, 1946)
        else
            doTransformItem(item.uid, 1945)
        end
                
        addEvent(loopBoxGame, 1000, nil)
        startBoxGame(cid)
    else
        sendBlueMessage(cid, "You don't have enough money.")
    end

    return true
end