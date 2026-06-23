# Referência — Protocolo TFS/OTX 8.54 ↔ OTClientV8

Documento de apoio da skill `protocol-map`. Cobre a arquitetura da camada de rede,
os primitivos de wire, as faixas de opcode, os opcodes/modificações custom do projeto,
o esquema dos dados do `protocol_map.html` e as lacunas conhecidas.

---

## 1. Arquitetura da camada de rede

### Servidor (`source/`)
- **`connection.cpp` / `protocol.cpp`** — camada de socket; aceita conexão, decide entre
  `ProtocolLogin`, `ProtocolGame`, `ProtocolOld`, `ProtocolHttp`.
- **`networkmessage.cpp` / `outputmessage.cpp`** — buffer de leitura/escrita. Métodos:
  - Ler (do cliente): `msg.get<T>()`, `msg.getString()`, `msg.skip(n)`, `msg.getPosition()`.
  - Escrever (pro cliente): `msg->put<T>(v)`, `msg->putString(s)`, `msg->putPosition(p)`.
- **`protocollogin.cpp`** — login server: autentica a conta e devolve MOTD + lista de personagens.
- **`protocolgame.cpp`** — o grosso do protocolo in-game (3200+ linhas). Dividido em:
  - `parseFirstPacket()` (~L402) — handshake do game server.
  - `parsePacket()` (~L517) — `switch(recvbyte)` que despacha tudo que o cliente manda (C→S).
  - `sendXxx()` / `AddXxx()` — montam e enviam pacotes ao cliente (S→C).
- **`protocolold.cpp`** — protocolo antigo/login legado (não usado pelo OTClientV8 8.54 normal).

### Cliente (`otclientv8/src/client/`)
- **`protocolcodes.h`** — enums `GameServerOpcodes` (S→C), `ClientOpcodes` (C→S),
  `LoginServerOpts`, `CreatureType`, `CreaturesIdRange`. **Valores em decimal.**
- **`protocolgame.cpp`** — conexão e loop. `protocolgameparse.cpp` — `parseMessage()` (S→C).
  `protocolgamesend.cpp` — funções `sendXxx` (C→S).
- **InputMessage / OutputMessage** — buffers do cliente. Ler: `msg->getU8/getU16/getU32/getString/getPosition`.
  Escrever: `msg->addU8/addU16/addU32/addString/addPosition`.
- Login fica em **Lua**: `otclientv8/modules/gamelib/protocollogin.lua` (`parseCharacterList`),
  com a UI em `otclientv8/modules/client_entergame/` (`characterlist.lua`, `entergame.lua`).

### Criptografia / handshake
- Login server e game server: o primeiro pacote tem um bloco **RSA** (1024 bits). Após decifrar,
  extraem-se 4 uint32 da **chave XTEA**; daí em diante todo pacote é cifrado com XTEA.
- Servidor: `RSA_decrypt(msg)`, `enableXTEAEncryption()`, `setXTEAKey(key)` em
  `parseFirstPacket` (login e game).
- Cliente: `sendLoginPacket()` em `protocolgamesend.cpp` monta o bloco e ativa XTEA.

---

## 2. Primitivos de wire (servidor ↔ cliente)

| Significado | Servidor escreve | Servidor lê | Cliente escreve | Cliente lê | Tag catálogo |
|---|---|---|---|---|---|
| byte | `put<char>` / `put<uint8_t>` | `get<char>` | `addU8` | `getU8` | `u8` |
| word (16b LE) | `put<uint16_t>` | `get<uint16_t>` | `addU16` | `getU16` | `u16` |
| dword (32b LE) | `put<uint32_t>` | `get<uint32_t>` | `addU32` | `getU32` | `u32` |
| string (u16 len + bytes) | `putString` | `getString` | `addString` | `getString` | `str` |
| posição (x:u16, y:u16, z:u8) | `putPosition` | `getPosition` | `addPosition` | `getPosition` | `pos` |
| item (clientId + extras) | inline em `AddItem` | — | — | inline | `item` |
| bloco composto / lista | vários puts | — | — | vários gets | `arr` |

> A **ordem** dos `put`/`add` no emissor define exatamente a sequência de bytes; o receptor
> precisa fazer os `get` na mesma ordem. É assim que se valida um pacote.

---

## 3. Faixas de opcode

O OTClientV8 reserva faixas (ver comentários em `protocolcodes.h`):

- **< 50** — pré-jogo: login/pending/ping/challenge/enter game.
- **`50`** — Extended Opcode (`0x32`) — canal custom OTClient ↔ Lua (ver §4).
- **50–63** — OTClient-only base.
- **64–82** — **faixa custom do OTClientV8** (NewPing 64, ChangeMapAwareRange 66, Features 67,
  NewWalk/cancel 69–71, CreatureAction 78, FloorDescription 75, Processes/Dlls/Windows 80–82).
- **≥ 100** — protocolo Tibia "original" (mapa, container, inventário, criaturas, chat, etc.).

Regra prática: **todo opcode de jogo é ≥ 50**; abaixo disso é handshake/sistema.

---

## 4. Opcodes custom e modificações DESTE projeto

Estes são os pontos onde o projeto diverge de um TFS 8.54 puro — prioridade numa auditoria.

### Implementados nos dois lados
- **`0x32` / 50 — Extended Opcode.**
  Servidor: `parseExtendedOpcode` (C→S) e `sendExtendedOpcode` (S→C), `protocolgame.cpp`.
  Cliente: `Proto::ClientExtendedOpcode` / `GameServerExtendedOpcode`.
  Layout: `u8 opcode` + `str buffer`. Ponte genérica servidor ↔ Lua.
- **`0x42` / 66 — Change Map Aware Range.**
  Servidor: `parseChangeMapAwareRange` (C→S) / `sendAwareRange` (S→C), `updateAwareRange`.
  Permite ao cliente pedir uma área de visão maior que a 18×14 padrão.
- **`0x4E` / 78 — Creature Action (S→C, custom do projeto).**
  Servidor: `sendCreatureAction(creature, actionId, duration)` — `put<char>(0x4E)`, `u32 creatureId`,
  `u8 actionId`, `u16 duration`. Cliente: `case GameServerCreatureAction` em `parseMessage`.
  Faz a criatura tocar a animação do frame group `actionId` por `duration` ms. Documentado no commit
  "render character ground and vocation flags / Creature Action opcode".

### No enum do cliente mas NÃO tratados pelo servidor 8.54 (não catalogar como ativos)
- `GameServerNewPing` 64 / `ClientNewPing` 64, `ClientNewWalk` 69, `GameServerFeatures` 67,
  `GameServerWalkId` 71, `GameServerPredictiveCancelWalk` 70, `GameServerNewCancelWalk` 69,
  `GameServerFloorDescription` 75, Processes/Dlls/Windows (80–82), e todo o bloco moderno
  (store, prey, market, imbuing, cyclopedia, daily reward, 1077+). O `parsePacket` do servidor
  **não** tem esses `case` — se o cliente enviar, cai no `default` (e pode até banir, ver
  `BAN_UNKNOWN_BYTES`).

### Modificação da CHAR LIST do login (importante)
O `protocollogin.cpp` (`parseFirstPacket`) foi modificado para enviar, **por personagem**, além de
`name`/`world`/`ip`/`port`, também dados de aparência:
```
str  name
str  worldName (ou "Online"/"Offline")
u32  serverIp
u16  gamePort
u16  level        ← custom
u16  vocation     ← custom
u16  lookType     ← custom
u8   lookHead     ← custom
u8   lookBody     ← custom
u8   lookLegs     ← custom
u8   lookFeet     ← custom
u8   lookAddons   ← custom
```
O cliente lê isso em `protocollogin.lua` `parseCharacterList` (`character.level`, `.vocation`,
`.outfit{type,head,body,legs,feet,addons}`) e a UI usa em `characterlist.lua` (Level + flag de
vocação por imagem `/images/flags/<vocation>.png`).

---

## 5. Resumo dos pacotes (interseção 8.54 ativa)

### Client → Server (`parsePacket` em `protocolgame.cpp`)
`0x14` logout · `0x1E` ping · `0x32` extended · `0x42` change aware range · `0x64` autowalk ·
`0x65–0x68` walk N/E/S/O · `0x69` stop autowalk · `0x6A–0x6D` walk diagonais ·
`0x6F–0x72` turn N/E/S/O · `0x78` throw/move · `0x79` look shop · `0x7A` buy · `0x7B` sell ·
`0x7C` close shop · `0x7D` request trade · `0x7E` look trade · `0x7F` accept trade · `0x80` close trade ·
`0x82` use item · `0x83` use item with · `0x84` battle window · `0x85` rotate · `0x87` close container ·
`0x88` up container · `0x89` text window · `0x8A` house window · `0x8C` look at · `0x96` say ·
`0x97` get channels · `0x98` open channel · `0x99` close channel · `0x9A` open priv ·
`0x9B–0x9D` rule violation · `0x9E` close NPC · `0xA0` fight modes · `0xA1` attack · `0xA2` follow ·
`0xA3–0xA8` party · `0xAA–0xAC` private channel · `0xBE` cancel move · `0xC9` update tile ·
`0xCA` update container · `0xD2` request outfit · `0xD3` set outfit · `0xDC` add vip · `0xDD` remove vip ·
`0xE6` bug report · `0xE7` violation window · `0xE8` debug assert · `0xF0` quests · `0xF1` quest info ·
`0xF2` violation report.

### Server → Client (1º `put<char>` de cada `sendXxx`/`AddXxx`)
`0x0A` self appear · `0x0B` GM actions · `0x14` disconnect · `0x15` FYI box · `0x16` login wait ·
`0x1E` ping · `0x1F` challenge · `0x28` re-login · `0x32` extended · `0x42` aware range · `0x4E` creature action ·
`0x64` full map · `0x65–0x68` map rows · `0x69` update tile · `0x6A` add thing · `0x6B` update thing ·
`0x6C` remove thing · `0x6D` move creature · `0x6E` open container · `0x6F` close container ·
`0x70–0x72` container item add/update/remove · `0x78/0x79` inventory set/clear · `0x7A–0x7C` NPC shop ·
`0x7D/0x7E/0x7F` trade · `0x82` world light · `0x83` magic effect · `0x84` animated text ·
`0x85` distance shot · `0x86` creature square · `0x8C` creature health · `0x8D` creature light ·
`0x8E` creature outfit · `0x8F` creature speed · `0x90` skull · `0x91` party shield · `0x92` (impassable) ·
`0x96` edit text window · `0x97` house window · `0xA0` player stats · `0xA1` player skills ·
`0xA2` player icons · `0xA3` cancel target · `0xAA` creature speak · `0xAB` channels dialog ·
`0xAC` open channel · `0xAD` open private channel · `0xAE` RVR channel · `0xAF` remove report ·
`0xB0` cancel RVR · `0xB1` lock RVR · `0xB2` open own channel · `0xB3` close channel · `0xB4` text message ·
`0xB5` cancel walk · `0xBE` floor up · `0xBF` floor down · `0xC8` outfit window · `0xD2/0xD3/0xD4` VIP ·
`0xDC` tutorial · `0xDD` minimap flag · `0xF0` quest log · `0xF1` quest line.

> A lista acima é o índice; o layout campo-a-campo de cada um vem de ler o `sendXxx`/`AddXxx`
> correspondente. Não confie de memória — releia a função ao documentar.

### Login (`protocollogin.cpp` + `protocollogin.lua`)
- **C→S** `0x01` login packet: `u16 OS`, `u16 version`, 12 bytes de assinaturas dat/spr/pic,
  bloco RSA → `u32 xteaKey[4]`, `str account`, `str password`.
- **S→C** `0x0A` login error: `str message` (fecha conexão).
- **S→C** `0x14` MOTD: `str "id\nmensagem"`.
- **S→C** `0x64` char list: `u8 count` + N×{personagem (ver §4, com campos custom)} + `u16 premiumDays`.
- **C→S (game server)** `parseFirstPacket`: `u16 OS`, `u16 version`, bloco RSA → `u32 xteaKey[4]`,
  `u8 isGamemaster`, `str account`, `str character`, `str password`.

---

## 6. Esquema dos dados do `docs/protocol_map.html`

O catálogo é renderizado de três arrays JS no próprio HTML (procure `const C2S =`, `const S2C =`,
`const LOGIN =`). Cada entrada:

```js
{ hex:"0x82", dec:130, name:"Use Item", method:"parseUseItem", cat:"inventory",
  fields:[{t:"pos",n:"pos"},{t:"u16",n:"spriteId"},{t:"u8",n:"stackpos"},{t:"u8",n:"index"}],
  desc:"Usa um item (abrir container, usar runa, etc)." }
```

- `hex` — string `"0xNN"` (servidor). `dec` — inteiro (cliente).
- `name` — rótulo humano. `method` — função-fonte (`parseXxx`/`sendXxx`/`AddXxx`) para rastreio.
- `cat` — categoria; usadas hoje: `system, movement, inventory, container, shop, trade, combat,
  channel, party, violation, creature, map, effect, ui, outfit, vip, quest, extended`.
- `fields` — lista ordenada `{t, n}`. `t` ∈ `u8 | u16 | u32 | str | pos | item | arr`. `n` = nome do campo.
- `desc` — descrição em pt-BR.
- `LOGIN` aceita também `dir:"C→S"`/`"S→C"` porque mistura as duas direções.

Mantenha cada array **ordenado por `hex` crescente**. Ao renderizar, só os 3 primeiros `fields`
aparecem na linha; o resto abre no detalhe — então liste os campos completos mesmo assim.

---

## 7. Comandos úteis de extração

```bash
# C→S: todos os case do dispatcher do servidor
grep -nE "case 0x" source/protocolgame.cpp

# S→C: 1º opcode escrito por cada função de envio
grep -nE "put<char>\(0x" source/protocolgame.cpp

# Assinaturas de todas as funções do ProtocolGame (servidor)
grep -nE "^(void|bool) ProtocolGame::" source/protocolgame.cpp

# Cliente: dispatch S→C e funções de envio C→S
grep -nE "case Proto::GameServer" otclientv8/src/client/protocolgameparse.cpp
grep -nE "void ProtocolGame::send|addU8\(Proto::Client" otclientv8/src/client/protocolgamesend.cpp

# Enum mestre de opcodes do cliente
sed -n '/enum GameServerOpcodes/,/};/p; /enum ClientOpcodes/,/};/p' otclientv8/src/client/protocolcodes.h
```

---

## 8. Lacunas conhecidas (atualizar a cada auditoria)

- [x] **LOGIN `0x64` char list** — corrigido no `protocol_map.html`: agora inclui
  `level/vocation/lookType/head/body/legs/feet/addons` por personagem (ver §4).
- [ ] **`0x42` aware range (S→C)** — `sendAwareRange` envia `0x42` + `u8 width` + `u8 height`;
  ainda não consta no array `S2C` do HTML. (Adicionado nesta passagem.)
- [x] **`0x92` creature impassable** — `sendCreatureImpassable` está **inteiramente comentado**
  na fonte (`protocolgame.cpp` ~L1588); o servidor **nunca** envia. NÃO catalogar como ativo,
  mesmo o cliente tendo `GameServerCreatureUnpass`.
- [ ] Revisar se há `sendXxx` no servidor sem `case` correspondente no `parseMessage` do cliente
  (pacote enviado e ignorado) e vice-versa.

> Ao fechar um item, mova a anotação para o histórico de commits e desmarque aqui.
