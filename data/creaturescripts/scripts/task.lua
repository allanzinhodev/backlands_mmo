function onKill(cid, target, lastHit)
  local _creature_name = getCreatureName(target):lower() -- lembrando que o nome da task é sempre diferente
  local _taskname, _tasktable = task.getTaskTableByTarget(cid, _creature_name) -- funcao retorna duplo parametro  

  -- Sistema de Tasks de Monstros
  if not _taskname or not _tasktable then
    return true
  end

  if task.doing(cid, _taskname) then
    if not task.killedNeededCount(cid, _taskname) then
      local kills = task.kills(cid, _taskname)
      task.doSetKills(cid, _taskname, kills + 1) -- inc +1
      doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Task: [" .. kills + 1 .. "/" .. _tasktable.count .. "] " .. _taskname .. " defeated.")

      if kills + 1 == _tasktable.count then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "You finished the " .. _creature_name .. " task. Now you can take the prize.")
      end
      
    end
  end

return true
end