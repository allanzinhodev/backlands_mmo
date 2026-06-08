-- Gambler NPC by Ricardo Ianelli (Ramza)
 
 
local function getLanguage(cid)
  return 0
end
 
local focuses, controlId = {}, 3586
 
local talkState = {}
 
function onCreatureDisappear(cid)
    if isFocused(cid, focuses) then
     removeFocus(cid, focuses)
        if isPlayer(cid) then
         closeShopWindow(cid)
        end
    end
end
 
 
function onCreatureSay(cid, type, msg)
 local travelWindow = {}
    if msgcontains(msg, "hi", "hello") and not isFocused(cid, focuses) and getDistanceToCreature(cid) < 4 then
    if getLanguage(cid) == 0 then selfSay("Hiho " .. getCreatureName(cid) .. ", are you ready to try your luck? I can play a little {game} with you if you want.", cid) else selfSay("Opa opa! Olá " .. getCreatureName(cid) .. ", você está aqui para tentar a sorte? Nós podemos jogar um pequeno {joguinho}, se você quiser.", cid)  end
     addFocus(cid, focuses)
     selfFocus(cid)
     talkState[cid] = nil
   
   elseif msgcontains(msg, "play", "game", "yes") then
    if getLanguage(cid) == 0 then selfSay("The game is simple. You bet some money (10-99 gold coin) and i'll roll my dice. If it rolls a 6, you win 5x what you bet. So, how much you want to bet?", cid) else selfSay("O jogo é simples. Você aposta dinheiro (10-99 gold coin) e eu rolarei meu dado. Se cair um 6, você ganha 5x o valor que apostou. Então, quanto quer apostar?", cid) end
     talkState[cid] = 2
     doRemoveCondition(cid, CONDITION_MUTED)
     
    elseif talkState[cid] == 2 and isNumber(msg) then
     if((msg+0 >= 10) and (msg+0 <= 99)) then
       if getPlayerMoney(cid) >= (msg + 0) then
            doPlayerRemoveMoney(cid, msg)  
           local rand = math.random(1,6)
           if rand == 6 then
           if getLanguage(cid) == 0 then selfSay("It rolled a 6. Congratulations! You have won "..(msg * 5).." gold coin!", cid) else selfSay("Rolou um 6. Parabéns! Você ganhou "..(msg * 5).." gold coin!", cid) end
           doSendAnimatedText(getCreaturePosition(cid), "You Win!", TEXTCOLOR_GREEN)
           doPlayerAddMoney(cid, (msg * 5))
           else
           if getLanguage(cid) == 0 then selfSay("It rolled a "..rand..". Sorry dude, it wasn't that time. Want to play again?", cid)  else selfSay("Rolou um "..rand..". Desculpe, cara, não foi dessa vez. Quer jogar novamente?", cid) end
           doSendAnimatedText(getCreaturePosition(cid), "You lose", TEXTCOLOR_DARKRED)
           end
       talkState[cid] = 0
       
       else
           if getLanguage(cid) == 0 then selfSay("Sorry dude, you do not have enough money for that. How much you want to bet? (10-99 gold coin)", cid) else  selfSay("Desculpe cara, mas você não tem dinheiro suficiente pra essa aposta. Quanto você quer apostar? (10-99 gold coin)", cid) end
 
       end
     else
        if getLanguage(cid) == 0 then  selfSay("Sorry dude, you cannot bet that value. How much you want to bet? (10-99 gold coin)", cid) else selfSay("Desculpe, mas você não pode apostar este valor. Quanto você deseja apostar? (10-99 gold coin)", cid) end
     end  
     elseif msgcontains(msg, "bye", "goodbye", "adeus", "tchau") and isFocused(cid, focuses) then
    talkState[cid] = nil
     if getLanguage(cid) == 0 then selfSay("See you later!", cid) else selfSay("Até logo!", cid) end
     removeFocus(cid, focuses)
     lookAtFocus(focuses)
    end
end
 
function onThink()
    for _, focus in pairs(focuses) do
        if not isCreature(focus) then
         removeFocus(focus, focuses)
        else
         local distance = getDistanceTo(focus) or 5
            if distance > 4 then
                if getLanguage(focus) == 0 then selfSay("Oh, don't give up right now! Come here and try one more, i'm sure you'll win this time!", focus) else selfSay("Oh, vamos lá, não desista agora! Volte e tente mais uma, aposto que conseguirá desta vez!", focus) end
                closeShopWindow(focus)
                removeFocus(focus, focuses)
            end
        end
    end
    lookAtFocus(focuses)
end