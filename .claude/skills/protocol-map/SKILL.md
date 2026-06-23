---
name: protocol-map
description: >-
  Cataloga e audita a comunicação de rede entre o servidor TFS/OTX (source/) e o
  OTClientV8 (otclientv8/) deste projeto — protocolo Tibia 8.54. Use ao adicionar,
  documentar, verificar ou depurar qualquer opcode/pacote cliente↔servidor, ao
  manter docs/protocol_map.html, ou ao confirmar que os dois lados concordam no
  layout de um pacote. Gatilhos: "opcode", "pacote", "protocolo", "parsePacket",
  "sendXxx", "protocol_map", "comunicação cliente servidor".
---

# OT Protocol Map — Catálogo da comunicação TFS ↔ OTClientV8

Este projeto é um servidor **TFS/OTX (protocolo 8.54)** em `source/` falando com um
**OTClientV8** em `otclientv8/`. O catálogo vivo dos pacotes é o `docs/protocol_map.html`.
Esta skill encapsula **onde** o protocolo vive, **como** extraí-lo da fonte e **como**
manter o catálogo em sincronia.

## Princípios

1. **A fonte é a verdade, não o catálogo.** `protocol_map.html` pode estar desatualizado.
   Ao documentar/verificar um opcode, sempre confirme no `.cpp`/`.lua` dos dois lados.
2. **Todo pacote tem dois lados.** Um opcode só está correto quando o **emissor** e o
   **receptor** concordam no layout dos campos, na ordem e no tipo. Sempre cruze os dois.
3. **O servidor define o subconjunto real.** O enum do cliente (`protocolcodes.h`) lista o
   protocolo Tibia moderno inteiro (até opcode 254), mas só o que o **servidor** realmente
   faz `parse`/`send` está em uso. Catalogue a interseção 8.54 + os opcodes custom do projeto.
4. **Opcodes do servidor são hexadecimais; do cliente, decimais.** `0x82` (servidor) = `130`
   (cliente). O catálogo guarda os dois (`hex` e `dec`).

## Mapa de arquivos (onde olhar)

| Direção / papel | Arquivo | Como ler |
|---|---|---|
| **C→S** dispatch (servidor recebe) | `source/protocolgame.cpp` → `parsePacket()` (~L517) | `switch(recvbyte)` com `case 0xNN:` → `parseXxx(msg)` |
| **C→S** envio (cliente manda) | `otclientv8/src/client/protocolgamesend.cpp` | `void sendXxx(...)` → 1º `msg->addU8(Proto::ClientXxx)` |
| **S→C** envio (servidor manda) | `source/protocolgame.cpp` → `sendXxx`/`AddXxx` | 1º `msg->put<char>(0xNN)` é o opcode; campos seguem |
| **S→C** dispatch (cliente recebe) | `otclientv8/src/client/protocolgameparse.cpp` → `parseMessage()` (~L39) | `switch` com `case Proto::GameServerXxx:` → `parseXxx` |
| Enum de opcodes (cliente) | `otclientv8/src/client/protocolcodes.h` | `GameServerOpcodes` (S→C) e `ClientOpcodes` (C→S), em decimal |
| Login (servidor) | `source/protocollogin.cpp` → `parseFirstPacket()` | autenticação + char list (0x14 MOTD, 0x64 lista) |
| Login (cliente) | `otclientv8/modules/gamelib/protocollogin.lua` | `parseCharacterList()` lê a char list |
| First packet do game (servidor) | `source/protocolgame.cpp` → `parseFirstPacket()` (~L402) | handshake do game server (RSA/XTEA, conta, personagem) |
| **Catálogo (saída)** | `docs/protocol_map.html` | arrays JS `C2S`, `S2C`, `LOGIN` |

Detalhes de arquitetura, primitivos de wire, faixas de opcode, opcodes custom e
o esquema dos dados HTML estão em **[referencia.md](referencia.md)** — leia antes de
editar o catálogo ou de mapear um pacote novo.

## Receitas

### A. Documentar / auditar UM opcode
1. Identifique a direção e ache o handler nos dois lados (tabela acima).
2. Leia o corpo do handler **emissor** campo a campo (a ordem dos `put`/`add` É o layout do pacote).
3. Leia o **receptor** e confirme que os `get` casam em ordem e tipo. Divergência = bug a reportar.
4. Traduza os tipos para as tags do catálogo (`u8/u16/u32/str/pos/item/arr` — ver referência).
5. Insira/atualize a entrada no array certo (`C2S`/`S2C`/`LOGIN`) de `docs/protocol_map.html`,
   mantendo a ordem por `hex` crescente.

### B. Auditoria completa (catálogo vs. fonte)
1. Extraia a lista real de opcodes da fonte:
   - C→S: `grep -nE "case 0x" source/protocolgame.cpp`
   - S→C: `grep -nE "put<char>\(0x" source/protocolgame.cpp` (1º put de cada `sendXxx`/`AddXxx`)
   - cliente: os `switch` de `protocolgameparse.cpp` e `protocolgamesend.cpp`
2. Compare com os arrays `C2S`/`S2C`/`LOGIN`. Anote faltantes, sobrando e layouts divergentes.
3. Dê atenção especial aos **opcodes custom** e às **modificações do projeto** (ver referência) —
   é onde o catálogo costuma ficar para trás.

### C. Adicionar um opcode NOVO ao protocolo (mudança de código)
1. Servidor: novo `case` em `parsePacket` (C→S) ou novo `sendXxx` com `put<char>(0xNN)` (S→C).
2. Cliente: opcode no enum em `protocolcodes.h`, `case` no `parseMessage` ou função em `protocolgamesend.cpp`.
3. **Garanta que os dois lados leem/escrevem os campos na MESMA ordem.**
4. Documente no `protocol_map.html` (receita A) na mesma PR.

## Convenção de versão
Protocolo **8.54**. O servidor aceita `854`–`860` (`source/definitions.h`:
`CLIENT_VERSION_MIN/MAX`). Pacotes do client moderno (1077+, store, prey, market…) existem no
enum do cliente mas **não** são tratados pelo servidor — não catalogue como ativos.

## Estado conhecido / pendências
Lacunas já identificadas entre fonte e catálogo estão registradas no fim de
**[referencia.md](referencia.md)** (ex.: a char list do login foi modificada para incluir
level/vocation/outfit e o `protocol_map.html` ainda não reflete isso). Ao rodar uma auditoria,
atualize essa seção.
