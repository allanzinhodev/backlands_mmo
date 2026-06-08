function Missao1(cid)
if (getPlayerStorageValue(cid, sto_missao[1]) < 1) then
	doPlayerAddItem(cid, 11879, 1)
	setPlayerStorageValue(cid, sto_missao[1], 1)
	doPlayerAddMapMark(cid, {x = 2576, y = 1819, z = 7,}, 9, 'Hospital')
	selfSay('Obrigado e Boa Sorte na sua jornada', cid)
else
	selfSay('Desculpe, Mas voce ja realizou todas as missoes, nao tem mais missoes por enquanto.', cid)
end
end

function Missao2(cid)
if (getPlayerStorageValue(cid, sto_missao[1]) == 2) then
	selfSay('Obrigado e Boa Sorte na sua jornada', cid)
else
	selfSay('Desculpe, Mas voce ja realizou todas as missoes, nao tem mais missoes por enquanto.', cid)
end
end

function Missao3(cid)
if (getPlayerStorageValue(cid, sto_missao[1]) == 3) then
	selfSay('Obrigado e Boa Sorte na sua jornada', cid)
else
	selfSay('Desculpe, Mas voce ja realizou todas as missoes, nao tem mais missoes por enquanto.', cid)
end
end

function Missao4(cid)
if (getPlayerStorageValue(cid, sto_missao[1]) == 4) then
	selfSay('Obrigado e Boa Sorte na sua jornada', cid)
else
	selfSay('Desculpe, Mas voce ja realizou todas as missoes, nao tem mais missoes por enquanto.', cid)
end
end

function Missao5(cid)
if (getPlayerStorageValue(cid, sto_missao[1]) == 5) then
	selfSay('Obrigado e Boa Sorte na sua jornada', cid)
else
	selfSay('Desculpe, Mas voce ja realizou todas as missoes, nao tem mais missoes por enquanto.', cid)
end
end

function Missao6(cid)
if (getPlayerStorageValue(cid, sto_missao[1]) == 6) then
	selfSay('Obrigado e Boa Sorte na sua jornada', cid)
else
	selfSay('Desculpe, Mas voce ja realizou todas as missoes, nao tem mais missoes por enquanto.', cid)
end
end

function Missao7(cid)
if (getPlayerStorageValue(cid, sto_missao[1]) == 7) then
	selfSay('Obrigado e Boa Sorte na sua jornada', cid)
else
	selfSay('Desculpe, Mas voce ja realizou todas as missoes, nao tem mais missoes por enquanto.', cid)
end
end

function Missao8(cid)
if (getPlayerStorageValue(cid, sto_missao[1]) == 8) then
	selfSay('Obrigado e Boa Sorte na sua jornada', cid)
else
	selfSay('Desculpe, Mas voce ja realizou todas as missoes, nao tem mais missoes por enquanto.', cid)
end
end

function Missao9(cid)
if (getPlayerStorageValue(cid, sto_missao[1]) == 9) then
	selfSay('Obrigado e Boa Sorte na sua jornada', cid)
else
	selfSay('Desculpe, Mas voce ja realizou todas as missoes, nao tem mais missoes por enquanto.', cid)
end
end

function Missao10(cid)
if (getPlayerStorageValue(cid, sto_missao[1]) == 10) then
	selfSay('Obrigado e Boa Sorte na sua jornada', cid)
if getPlayerStorageValue(cid, 165651) < 1 then
	doPlayerSendTextMessage(cid,24,"Você recebeu 'fishing basket'.")
	doPlayerAddItem(cid, 12667, 1)
	setPlayerStorageValue(cid, 165651, 1)
end
else
	selfSay('Desculpe, Mas voce ja realizou todas as missoes, nao tem mais missoes por enquanto.', cid)
end
end

function Missao1C(cid)
if (getPlayerStorageValue(cid, sto_missao[8]) < 1) then
	setPlayerStorageValue(cid, sto_missao[8], 1)
	selfSay('Obrigado e Boa Sorte na sua jornada', cid)
else
	selfSay('Desculpe, Mas voce ja realizou todas as missoes, nao tem mais missoes por enquanto.', cid)
end
end