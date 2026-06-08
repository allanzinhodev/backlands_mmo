function onTimer()
    local cor =  22
    local mensagens = {
[[DingDong: Pressão, loucura e horário, são essas três palavras que definem o ritmo da noite que só os ninjas conseguem compreender e acompanhar...]],
[[DingDong: Galera da verdura... Virando a noite no efeito da Loucura!]],
[[DingDong: Não importa o dia da semana e nem data, nas noites que dita o ritmo somos nós... Quem tem coragm acompanha, que não tem encosta e espera o amanhecer.]],
[[DingDong: A noite esconde os segredos mais profundos na estrada. Só fica quem não tem medo!]],
[[DingDong: Prefiro o brilho da noite do que as queimaduras do sol!]]
}
	for i, pid in ipairs(getPlayersOnline()) do
		doSendPlayerExtendedOpcode(pid, 124,  "Sepia")
	end
	setGlobalStorageValue(pid, 910562, 1)
	doBroadcastMessage(mensagens[math.random(1,table.maxn(mensagens))], cor)
return true
end
