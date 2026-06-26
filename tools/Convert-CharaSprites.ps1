<#
.SYNOPSIS
  Converte uma spritesheet de personagens (posições ESQUERDA + NORTE) em uma
  spritesheet direcional completa (Norte, Direita, Sul, Esquerda) por personagem.

.DESCRIPTION
  Entrada: imagem com Rows linhas x Cols colunas de frames (padrão 3 x 6).
  Cada LINHA da entrada = um personagem. Os 6 frames de cada linha são:
      colunas [0,1,2] = posição ESQUERDA (idle, walk1, walk2)
      colunas [3,4,5] = posição NORTE    (idle, walk1, walk2)
  Direções derivadas (espelho horizontal):
      SUL     = ESQUERDA espelhada
      DIREITA = NORTE    espelhada

  Saída: para CADA personagem, uma sheet de 4 colunas x 3 linhas:
      colunas = Norte, Direita, Sul, Esquerda
      linhas  = idle, walk1, walk2

  Pixel art é preservado (NearestNeighbor + cópia exata de alfa, sem blend).

.EXAMPLE
  .\Convert-CharaSprites.ps1 -InputPath .\chocobos.png
.EXAMPLE
  .\Convert-CharaSprites.ps1 -InputPath .\chocobos.png -PreviewScale 6
#>
param(
    [Parameter(Mandatory = $true)][string]$InputPath,
    [string]$OutDir,
    [int]$Cols = 6,
    [int]$Rows = 3,
    [int]$PreviewScale = 0,
    # Cada frame de saida vira uma celula QUADRADA transparente com o conteudo
    # colado a direita. Padrao: faixa transparente a esquerda de (altura - largura)
    # px -> p/ frames 16x32 da 16px de margem e celula 32x32 (conteudo em x=16,y=0).
    # -1 = automatico; use >=0 para forcar a largura da margem esquerda.
    [int]$PadLeft = -1,
    [int]$PadTop  = 0
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

if (-not (Test-Path $InputPath)) { throw "Arquivo nao encontrado: $InputPath" }
$InputPath = (Resolve-Path $InputPath).Path
if (-not $OutDir) { $OutDir = Join-Path (Split-Path $InputPath -Parent) 'converted' }
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$fmt = [System.Drawing.Imaging.PixelFormat]::Format32bppArgb

# Extrai (e opcionalmente espelha na horizontal) um frame na coluna $c / linha $r.
function Get-Frame($bmp, $c, $r, $fw, $fh, $flip) {
    $rect = New-Object System.Drawing.Rectangle ($c * $fw), ($r * $fh), $fw, $fh
    $sub = $bmp.Clone($rect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    if ($flip) { $sub.RotateFlip([System.Drawing.RotateFlipType]::RotateNoneFlipX) }
    return $sub
}

function New-IsoGraphics($bmp) {
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.CompositingMode   = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
    $g.PixelOffsetMode   = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
    return $g
}

$src = [System.Drawing.Bitmap]::FromFile($InputPath)
try {
    if (($src.Width % $Cols) -ne 0 -or ($src.Height % $Rows) -ne 0) {
        Write-Warning "Dimensoes ($($src.Width)x$($src.Height)) nao dividem exatamente por ${Cols}x${Rows}; usando divisao inteira."
    }
    $fw = [int]($src.Width / $Cols)
    $fh = [int]($src.Height / $Rows)

    # Margem transparente a esquerda -> celula quadrada com conteudo colado a direita.
    $padL = if ($PadLeft -ge 0) { $PadLeft } else { [Math]::Max(0, $fh - $fw) }
    $cellW = $fw + $padL
    $cellH = $fh + $PadTop
    Write-Host "Entrada: $($src.Width)x$($src.Height) | frame ${fw}x${fh} | celula ${cellW}x${cellH} (pad esq=$padL topo=$PadTop) | personagens: $Rows | saida: $OutDir"

    for ($r = 0; $r -lt $Rows; $r++) {
        $outW = 4 * $cellW
        $outH = 3 * $cellH
        $out = New-Object System.Drawing.Bitmap $outW, $outH, $fmt
        $g = New-IsoGraphics $out

        # Para cada frame (0=idle, 1=walk1, 2=walk2) preenche a linha $f.
        # Entrada: Esquerda = colunas 0..2 ; Norte = colunas 3..5
        for ($f = 0; $f -lt 3; $f++) {
            $north = Get-Frame $src (3 + $f) $r $fw $fh $false   # Norte
            $right = Get-Frame $src (3 + $f) $r $fw $fh $true    # Direita = Norte espelhado
            $south = Get-Frame $src (0 + $f) $r $fw $fh $true    # Sul     = Esquerda espelhado
            $left  = Get-Frame $src (0 + $f) $r $fw $fh $false   # Esquerda

            $y = $f * $cellH + $PadTop                            # conteudo em y (topo + PadTop)
            # colunas de saida: 0=Norte 1=Direita 2=Sul 3=Esquerda
            # conteudo colado a direita da celula (x = inicio da celula + margem esquerda)
            $g.DrawImage($north, [int](0 * $cellW + $padL), [int]$y, [int]$fw, [int]$fh)
            $g.DrawImage($right, [int](1 * $cellW + $padL), [int]$y, [int]$fw, [int]$fh)
            $g.DrawImage($south, [int](2 * $cellW + $padL), [int]$y, [int]$fw, [int]$fh)
            $g.DrawImage($left,  [int](3 * $cellW + $padL), [int]$y, [int]$fw, [int]$fh)

            $north.Dispose(); $right.Dispose(); $south.Dispose(); $left.Dispose()
        }
        $g.Dispose()

        $outPath = Join-Path $OutDir ("char_{0}.png" -f $r)
        $out.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
        Write-Host "  salvo: $outPath (${outW}x${outH})"

        if ($PreviewScale -gt 1) {
            $pw = $outW * $PreviewScale; $ph = $outH * $PreviewScale
            $prev = New-Object System.Drawing.Bitmap $pw, $ph, $fmt
            $pg = New-IsoGraphics $prev
            $pg.DrawImage($out, [int]0, [int]0, [int]$pw, [int]$ph)
            $pg.Dispose()
            $prevPath = Join-Path $OutDir ("char_{0}_x{1}.png" -f $r, $PreviewScale)
            $prev.Save($prevPath, [System.Drawing.Imaging.ImageFormat]::Png)
            $prev.Dispose()
            Write-Host "  preview: $prevPath (${pw}x${ph})"
        }
        $out.Dispose()
    }
}
finally {
    $src.Dispose()
}
Write-Host "Concluido."
