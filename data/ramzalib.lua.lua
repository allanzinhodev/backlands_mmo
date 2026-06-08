-- RamzaLIB - Electrical Discharge Functions
--- Created by Ramza(Ricardo Ianelli) for Zodiac Legacy ATS.
---- For more informations, visit: http://forums.otserv.com.br/forumdisplay.php?493-Zodiac-Legacy

function isInArray3(array, array2) -- Function by Ramza (Ricardo Ianelli)
local x = array2[1]
local y = array2[2]

  for _,v in pairs(array) do
     if (v[1] == x and v[2] == array2[2]) or (v[2] == x and v[1] == y)  then
       return true    
     end
  end
return false
end

function chainRoute(init, r) -- Function by Ramza (Ricardo Ianelli)
 local route, targets, tam = {{init, init}}, {}, 0
 for i = 1,#route do
    repeat
    tam = #route 
       targets = getSpectators(getCreaturePosition(init), r, r, false)      
    if #targets > 1 then
       for _,v in pairs(targets) do
          if not isInArray3(route, {init, v}) and (init ~= v) then
             table.insert(route, {init,v})
          end 
       end
    end
    init = route[#route][2]
   until tam == #route
 end
return route 
end