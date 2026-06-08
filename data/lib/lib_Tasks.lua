TABLE_TASKS = { 
  ["bat"]         = {id = 0, level = 01, count = 50,  exp = 7000,   coin = 0, point = 1},
  ["wolf"]          = {id = 1, level = 06, count = 70, exp = 10000,  coin = 0,    point = 1},
  ["hizoku"]          = {id = 2, level = 08, count = 90, exp = 15000,  coin = 0,    point = 1},
  ["maka"]          = {id = 3, level = 12, count = 110, exp = 17500,  coin = 0,    point = 1},
  ["sanzoku"]          = {id = 4, level = 15, count = 130, exp = 22000,  coin = 0,    point = 1},
  ["touzoku"]          = {id = 5, level = 27, count = 150, exp = 24000,  coin = 0,    point = 1},
  ["dorobou"]         = {id = 6, level = 28, count = 190, exp = 27000,  coin = 0,    point = 1},
}

TABLE_TASKS_MONSTERS = { -- NOME DOS BIXOS MINUSCULO !!!!!!!!!!!!!
  ["bat"]            = "bat",
  ["wolf"]            = "wolf",
  ["hizoku"]            = "hizoku", 
  ["maka"]            = "maka", 
  ["sanzoku"]            = "sanzoku",  
  ["touzoku"]            = "touzuko",
  ["dorobou"]            = "dorobou",      
}
--------------- NAO ALTERE A PARTIR DAQUI --------------------------------------
--------------------------------------------------------------------------------
  local TASK_OFFSETS       = 10 -- existem 10 slots de storages pra cada task 
  local OFFSET_KILLS       = 1  -- offset pra ver a quantidade de bixos que matou
  local OFFSET_FINISHED    = 2  -- offset pra ver se terminou a task
  local OFFSET_KILLED_BOSS = 3  -- offset pra ver se matou o boss (caso tenha boss nesta task)   
  local MAX_TASKS_TOGETHER = 1 -- quantidade maxima de tasks simultaneas 
-------------------------------------------------------------------------------- 

task = {
  avaiable = function(cid, taskname) -- se tem level, se ainda nao fez, se ja nao esta fazendo
    if getPlayerLevel(cid) >= TABLE_TASKS[taskname].level then
      if not task.finished(cid, taskname) then
        if not task.doing(cid, taskname) then
          return true
        end
      end 
    end
    
    return false      
  end, 

  finished = function(cid, taskname) -- se matou all e ja reportou no npc 
    return getPlayerStorageValue(cid, TASK_STORAGE_START + (TABLE_TASKS[taskname].id * TASK_OFFSETS) + OFFSET_FINISHED) == 1  
  end,
  
  kills = function(cid, taskname) -- quantidade de vezes que ja matou determinado bixo
    return getPlayerStorageValue(cid, TASK_STORAGE_START + (TABLE_TASKS[taskname].id * TASK_OFFSETS) + OFFSET_KILLS)
  end,
  
  killedNeededCount = function(cid, taskname)
    return task.kills(cid, taskname) >= TABLE_TASKS[taskname].count
  end,
  
  slot = function(cid, number) -- tem no maximo "MAX_TASKS_TOGETHER" de slots
    if number > MAX_TASKS_TOGETHER then
      print("[ERROR] lib_Tasks.lua excedeu o limite de slots!!!!!!!!!!!!!!!!!!!!!!")
    end  
    return getPlayerStorageValue(cid, TASK_STORAGE_DOING + number) 
  end,
  
  doing = function(cid, taskname) -- ve se essa task ja nao esta sendo feita por mim
    for i = 1, MAX_TASKS_TOGETHER do
      if task.slot(cid, i) == taskname then
        return true
      end
    end
    
    return false -- nao esta fazendo esta task  
  end, 
  
  doSaveSlot = function(cid, taskname)
    if task.doing(cid, taskname) then -- ja esta fazendo essa task em algum slot 
      return false
    end 
  
    for i = 1, MAX_TASKS_TOGETHER do
      if not TABLE_TASKS[ task.slot(cid, i) ]  then -- linha vazia   
        setPlayerStorageValue(cid, TASK_STORAGE_DOING + i, taskname)
        return true  
      end   
    end
    
    return false -- nao encontrou nenhum slot disponivel 
  end,
  
  doSetKills = function(cid, taskname, count) -- define a quantidade de monstros matados em determinado slot 
    setPlayerStorageValue(cid, TASK_STORAGE_START + (TABLE_TASKS[taskname].id * TASK_OFFSETS) + OFFSET_KILLS, count)
  end,
  
  doSetFinished = function(cid, taskname, count) -- define se ja terminou (-1 = nunca tentou, 0 = NO, 1 = YES)
    setPlayerStorageValue(cid, TASK_STORAGE_START + (TABLE_TASKS[taskname].id * TASK_OFFSETS) + OFFSET_FINISHED, count)
  end,
  
  doCancel = function(cid, taskname) -- cancelar slot de task (ou por cancelar ou quando termina mesmo) 
    if task.doing(cid, taskname) then  
      for i = 1, MAX_TASKS_TOGETHER do
        if task.slot(cid, i) == taskname then    
          setPlayerStorageValue(cid, TASK_STORAGE_DOING + i, "")
          return true 
        end   
      end
    end
    
    return false -- nao encontrou nenhum slot de taskname para cencelar  
  end,
  
  doStart = function(cid, taskname) -- se o storage == 0, entao ele ja comecou essa task alguma vez na vida 
    task.doSetKills(cid, taskname, 0)
    task.doSetFinished(cid, taskname, 0)
    --setPlayerStorageValue(cid, TASK_APPEAR_QUESTLOG, 0) -- aparecer na quest log
    if getPlayerStorageValue(cid, TASK_STORAGE_POINTS) < 0 then
      setPlayerStorageValue(cid, TASK_STORAGE_POINTS, 0)
    end
  end,
  
  doComplete = function(cid, taskname)
    task.doCancel(cid, taskname)
    task.doSetFinished(cid, taskname, 1)
      if TABLE_TASKS[taskname].exp then
        doPlayerAddExperience(cid, TABLE_TASKS[taskname].exp)
      end
      if TABLE_TASKS[taskname].coin then
        doPlayerAddMoney(cid, TABLE_TASKS[taskname].coin)
      end
      if TABLE_TASKS[taskname].point then
        setPlayerStorageValue(cid, TASK_STORAGE_POINTS, getPlayerStorageValue(cid, TASK_STORAGE_POINTS) + TABLE_TASKS[taskname].point)
      end
      if TABLE_TASKS[taskname].msg then
        doPlayerSendTextMessage(cid, 20, TABLE_TASKS[taskname].msg)
      end
  end,
  
  getTaskTableByTarget = function(cid, targetname) -- funcao retorna duplo parametro 
    if TABLE_TASKS_MONSTERS[targetname] then -- da mesma especie mas tem nome diferente Ex: dragon lord
      return TABLE_TASKS_MONSTERS[targetname], TABLE_TASKS[ TABLE_TASKS_MONSTERS[targetname] ]
    end
    return nil
  end,
  
}
--------------------------------------------------------------------------------
function getAvaiableTasks(cid)
local retorno = ""
  for index, v in pairs(TABLE_TASKS) do
    if task.avaiable(cid, index) then -- index de string 
      retorno = retorno .. "{" .. index .. "}, "
    end
  end
return string.sub(retorno, 1, string.len(retorno)-2) -- pra retirar o ultimo caracter (virgula) da string
end

function getDoingTasks(cid)
local retorno = ""
  for indexName, v in pairs(TABLE_TASKS) do
    if task.doing(cid, indexName) then -- index de string 
      retorno = retorno .. "{" .. indexName .. "}, "
    end
  end
return string.sub(retorno, 1, string.len(retorno)-2) -- pra retirar o ultimo caracter (virgula) da string
end
--------------------------------------------------------------------------------
----------------- Gerador de Quests.xml Para as Tasks --------------------------
--------------------------------------------------------------------------------
--[[
local function doGenerateTaskQuestLog()
local questxml = '  <quest name="Tasks" startstorageid="' .. TASK_APPEAR_QUESTLOG .. '" startstoragevalue="0" endstoragevalue="1"> \n' 

  for name, v in pairs(TABLE_TASKS) do -- gerar cada quest log
    local storage = TASK_STORAGE_START + (v.id * TASK_OFFSETS) + OFFSET_FINISHED
    questxml = questxml ..
               '    <mission name="' .. name .. '" storageid="' .. storage .. '" startvalue="0" endvalue="1"> \n' .. 
               '      <missionstate id="0" description="Kill ' .. v.count .. ' ' ..  name .. 's and report to take you prize."/> \n' .. 
               '    </mission> \n \n' 
  end  
questxml = questxml .. '  </quest>'
local file = io.open("quests.txt", "w")
file:write(questxml)
file:close()
end

doGenerateTaskQuestLog()
--]]
--------------------------------------------------------------------------------