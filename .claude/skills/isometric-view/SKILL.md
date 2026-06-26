---
name: isometric-view
description: >-
  Define e guia a intenção de design deste projeto: o mundo deve ser renderizado
  em PERSPECTIVA ISOMÉTRICA inspirada em Final Fantasy Tactics Advance (grid em
  losango), em vez do grid ortogonal top-down padrão do Tibia/OTClient — MAS
  mantendo o sistema de andares do Tibia (subir escada para mudar de andar, entrar
  em interiores). Use sempre que mexer na renderização do mapa, na projeção de
  posição→tela, no picking do mouse (tela→tile), na ordem de desenho ou ao discutir
  câmera/perspectiva. Gatilhos: "isométrico", "isometric", "perspectiva", "FFTA",
  "Final Fantasy Tactics", "projeção", "transformPositionTo2D", "renderização do mapa".
---

# Visão Isométrica — Intenção de design (estilo Final Fantasy Tactics Advance)

## A intenção

Este projeto **não** deve parecer um Tibia comum. O mundo deve ser exibido em
**perspectiva isométrica**, no estilo **Final Fantasy Tactics Advance (FFTA)**:

- O grid de tiles é desenhado em **losango (diamond)**, não em quadrado alinhado à tela.
- A câmera tem ângulo fixo (dimétrico 2:1, o "isométrico de videogame").

### O que MANTÉM do Tibia (decisões já tomadas pelo dono do projeto)

- **Sistema de andares do Tibia.** Continua sendo Z discreto por andar. Para mudar de andar
  você **sobe uma escada / rampa / buraco** (como no Tibia), e isso permite **entrar em
  interiores** (telhados que somem, andares de cima desenhados por cima). Não é altura
  contínua por tile como num heightmap; é o mesmo modelo de floors do OTClient, só que
  **renderizado em isométrico**.
- **Os sprites não são problema desta skill.** A arte atual é top-down e vai ficar "torta"
  num grid em losango — **isso é esperado e aceitável**. O dono do projeto vai substituir
  pelos sprites isométricos corretos depois. **Não distorça, não corrija e não invente
  arte; foque só na geometria/projeção.**

A regra base do OTClient é o oposto da projeção desejada: um grid **ortogonal top-down** onde
cada tile é um quadrado de `spriteSize` px e o Z só desloca o desenho para cima-e-esquerda.
Tornar isso isométrico é uma mudança **somente do cliente** — o servidor (`source/`) não
precisa saber de perspectiva (ele só fala posições x,y,z; ver [[../protocol-map/SKILL]]).

## Onde a perspectiva vive (mapa de arquivos — tudo em `otclientv8/`)

| Papel | Local | O que faz hoje (ortogonal) |
|---|---|---|
| **Projeção tile→tela** | `src/client/mapview.cpp` → `MapView::transformPositionTo2D()` (~L660) | `(dx - dz) * spriteSize`, `(dy - dz) * spriteSize`. **Núcleo a trocar.** |
| **Picking tela→tile** | `src/client/mapview.cpp` → `MapView::getPosition()` (~L490) | Inverso do acima: divide ponto por `spriteSize`. Precisa do inverso da nova projeção. |
| **Ordem de desenho** | `src/client/mapview.cpp` → `MapView::drawFloor()` (~L180) | Desenha andar por andar; tiles na ordem do cache. Iso precisa de painter order por profundidade dentro do andar. |
| **Desenho do tile/elevação** | `src/client/tile.cpp` → `drawGround/drawBottom/drawTop` | Usa `m_drawElevation * g_sprites.getOffsetFactor()` para empilhar itens no tile. |
| **Dimensões do framebuffer** | `src/client/mapview.cpp` → `updateGeometry`/`calcFramebufferSource` | Calcula área visível em múltiplos de `spriteSize` quadrado. |
| **Andares visíveis** | `mapview.cpp` → `calcFirstVisibleFloor/calcLastVisibleFloor` | Mantém a lógica de floors do Tibia — é isso que faz interiores/telhados funcionarem. |
| **Offsets de criatura/missile/texto** | `creature.cpp`, `mapview.cpp` (L246, L308, L325) | Walk offset e âncoras de barra/nome assumem grid quadrado. |

## A matemática da troca

**Hoje (ortogonal):**
```
screen.x = (cx + (x - rx) - (rz - z)) * S
screen.y = (cy + (y - ry) - (rz - z)) * S      // S = g_sprites.spriteSize()
```

**Isométrico dimétrico 2:1 (estilo FFTA):**
```
col = x - rx ;  row = y - ry ;  dz = rz - z
screen.x = ORIGIN.x + (col - row) * (TILE_W/2)
screen.y = ORIGIN.y + (col + row) * (TILE_H/2) - dz * FLOOR_HEIGHT
```
- `TILE_W:TILE_H` tipicamente `2:1` (ex.: 64×32, derivado de `spriteSize`).
- `FLOOR_HEIGHT` = quanto um andar inteiro sobe na tela (relevo). É o que dá o degrau de
  escada/andar do Tibia em iso.
- O **picking** (`getPosition`) é o sistema inverso:
  `col = (px/(TILE_W/2) + py/(TILE_H/2)) / 2`, `row = (py/(TILE_H/2) - px/(TILE_W/2)) / 2`.
- **Ordem de desenho**: dentro de cada andar, desenhar do fundo para a frente
  (`depth = row + col`), senão tiles da frente são cobertos pelos de trás. Entre andares,
  manter a ordem de floors do Tibia (de baixo para cima).

## Como abordar uma mudança aqui

1. **Constantes primeiro.** Defina `TILE_W/TILE_H`/`FLOOR_HEIGHT`/origem num só lugar
   (`src/client/const.h`, junto de `SEA_FLOOR`, `MAX_Z`). Sem números mágicos espalhados.
2. **Comece pela projeção isolada.** Troque `transformPositionTo2D` e meça: o chão deve formar
   losangos. Não mexa em picking/ordem antes do desenho básico aparecer.
3. **Atualize o picking junto.** `getPosition` quebra assim que a projeção muda — clicar no
   mapa deixa de bater no tile certo. São um par; nunca mude um sem o outro.
4. **Ordem de desenho por profundidade** dentro do andar; mantenha a iteração de floors do Tibia.
5. **Ajuste o framebuffer / dimensões visíveis.** A área em losango precisa de mais largura e
   margem que o grid quadrado, ou os cantos do mapa somem.
6. **Sprites: não toque.** Vão ficar tortos até a arte iso ser colocada pelo dono. Isso é esperado.
7. **Teste rodando o cliente** (`otclient_dx_x64.exe` / `otclient_debug_x64.exe`); recompilar via
   `compile.ps1` / `INSTRUCOES_COMPILACAO.md` na raiz.

## Princípios

- **A mudança é client-side.** O servidor só conhece posições; perspectiva é puramente do cliente.
- **Projeção e picking são um par.** Nunca mude uma sem a outra.
- **Andares continuam estilo Tibia** (escada para subir, interiores), só renderizados em iso.
- **Arte iso é responsabilidade do dono**, não desta skill. Sprites tortos no meio-tempo são ok.
- **Mudança incremental e visível.** Cada passo deve renderizar algo antes do próximo.

## Progresso e Soluções Implementadas (Status Atual)

As seguintes implementações e correções críticas já foram feitas no OTClient (`src/client/`) para consolidar a visão isométrica orientada ao estilo Tibia clássico:

1. **Orientação do Losango:**
   - A projeção foi rotacionada 90° em relação à câmera clássica isométrica.
   - **Norte (y-1)** move para Cima-Esquerda.
   - **Sul (y+1)** move para Baixo-Direita.
   - **Leste (x+1)** move para Cima-Direita.
   - **Oeste (x-1)** move para Baixo-Esquerda.
   - As funções `MapView::transformPositionTo2D` e `MapView::getPosition` usam o eixo `(col + row)` para X e `(row - col)` para Y na tela.

2. **Ordem de Desenho e Sobreposição de Camadas (Z-order):**
   - **Iteração Back-to-Front:** Os tiles visíveis do andar (floor) agora são iterados e populados através das diagonais baseadas em `iy - ix` (do menor para o maior), o que garante a varredura correta do fundo para a frente (`screenY`).
   - **Separação de Passes (Ground vs Top):** Em `MapView::drawFloor`, o loop que desenhava tudo de uma vez por tile foi dividido. Primeiro desenha-se o `Ground` e o `Bottom` para *todos* os tiles do andar, e só depois, num segundo loop separado, desenham-se as `Creatures` e o `Top` para *todos* os tiles. Isso resolve o bug crítico onde o chão (Bottom) da casa do lado sobrepunha os pés do personagem ao andar para os lados.

3. **Animação de Caminhada (Walk) Lida e Sem Tremores:**
   - Ao interpolar a posição isosmétrica durante a caminhada (`Creature::getIsoWalkOffsetFrom`), os valores antigos baseados em `float` com `std::lround` geravam travamentos ("tremedeira") em direções negativas (Norte e Oeste) devido a assimetrias de arredondamento inter-frame.
   - A solução implementada é **matemática estrita de inteiros**: `(totalTravelPixel * walkedPixels) / S`. Isso resulta numa interpolação pixel a pixel uniforme (sem saltos/stutters na metade do tile) que funciona perfeitamente para todas as direções.
   - As barras de HP e Nome recebem os mesmos offsets compensados (na base do tile de origem) em vez do sprite offset cru, anulando o "jump" no meio da caminhada (quando o `m_walkingTile` muda).
