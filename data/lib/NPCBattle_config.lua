NPC_CONFIGS = {
	Npc_Other_Player_Can_Attack = false,
	Npc_AutoWalk = false,
	Final_Pos = {x = 95, y = 112, z = 7},
}

NPC_REWARD_ITEMS = {
	[1] = {id = 13281, ammount = 1},
}

NPC_REWARD_EXP = {
	reward_xp = true,
	experience = 10000,
}

NPC_MESSAGEAS = {
	["Hi Duel"] = "Ola pn, Vejo que voce derrotou alguns dos meus subordinados, deja me enfretar agora ?",
	["Yes Duel"] = "Então vamos lá!",
	["No Duel"] = "Então tá.",
	["No Duel [Creature Disappear]"] = "Então... Tchau!",
	["Win Duel"] = "pn voce me venceu!, tome aqui esses prêmios.",
	["Lose Duel"] = "Voce não é tão bom quanto eu imaginava.",
	["Again Duel"] = "Nós dois ja duelamos.",
	["Attack Other Player"] = "Desculpe pn, acho que confundi as coisas.",
}
-- OBS: A String "pn", no NPC Messages, equivale ao nome do jogador.

STORAGES_DUEL = {
	["Duel"] = 12378,
	["Player"] = 12344,
	["Duel_Attacker"] = 12370,
	["Duel_AntiDeath"] = 12399,
}

