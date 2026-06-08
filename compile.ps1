# =========================================================
#    TFS 0.4 Naruto - Instalador e Compilador Automatico
# =========================================================
# Script de Automacao para Compilar TFS 0.4 Naruto no Windows

$ErrorActionPreference = "Stop"

Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "   TFS 0.4 Naruto - Instalador e Compilador Automatico" -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Cyan

# 1. Detectar ou Instalar o MSYS2
$msysPath = "C:\msys64"
$bashExe = "$msysPath\usr\bin\bash.exe"

if (-not (Test-Path $bashExe)) {
    Write-Host "[!] MSYS2 nao encontrado em $msysPath." -ForegroundColor Yellow
    Write-Host "[*] Iniciando instalacao automatizada do MSYS2 via Winget..." -ForegroundColor Green
    
    try {
        Start-Process winget -ArgumentList "install --id MSYS2.MSYS2 --silent --accept-source-agreements --accept-package-agreements" -NoNewWindow -Wait
        Write-Host "[OK] Instalacao do MSYS2 concluida!" -ForegroundColor Green
    }
    catch {
        Write-Host "[ERRO] Falha ao instalar via Winget." -ForegroundColor Red
        Write-Host "Por favor, instale o MSYS2 manualmente de https://www.msys2.org/ na pasta padrao (C:\msys64) e execute este script novamente." -ForegroundColor Red
        Exit
    }
} else {
    Write-Host "[OK] MSYS2 encontrado em $msysPath!" -ForegroundColor Green
}

# Verificar novamente o bash.exe caso tenha sido instalado agora
if (-not (Test-Path $bashExe)) {
    Write-Host "[!] Aguardando a inicializacao do MSYS2..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    if (-not (Test-Path $bashExe)) {
        Write-Host "[ERRO] O executavel do MSYS2 ainda nao esta acessivel. Reinicie o PowerShell e execute o script novamente." -ForegroundColor Red
        Exit
    }
}

# 2. Instalar Dependencias e Toolchain no MSYS2
Write-Host "`n[*] Instalando dependencias e compiladores no MSYS2 (aguarde)..." -ForegroundColor Cyan

# Pacotes do sistema (Autotools, make, etc.)
$sysPackages = "make autoconf automake libtool pkg-config git"
# Dependencias do TFS 0.4 na arquitetura MinGW64
$mingwPackages = "mingw-w64-x86_64-gcc mingw-w64-x86_64-make mingw-w64-x86_64-pkgconf mingw-w64-x86_64-boost mingw-w64-x86_64-lua51 mingw-w64-x86_64-libmariadbclient mingw-w64-x86_64-sqlite3 mingw-w64-x86_64-crypto++ mingw-w64-x86_64-libxml2 mingw-w64-x86_64-zlib"

$installCmd = "pacman -Sy --needed --noconfirm $sysPackages $mingwPackages"

Write-Host "[*] Executando comando de pacotes no MSYS2..." -ForegroundColor Yellow
$env:MSYSTEM = "MINGW64"
& $bashExe -lc $installCmd

Write-Host "[OK] Dependencias instaladas com sucesso!" -ForegroundColor Green

# 3. Localizar Source e Converter Caminho
$sourceWinPath = Join-Path $PSScriptRoot "source"
if (-not (Test-Path $sourceWinPath)) {
    Write-Host "[ERRO] Pasta 'source' nao encontrada em: $sourceWinPath" -ForegroundColor Red
    Write-Host "Certifique-se de que este script esta na pasta raiz do seu servidor (ao lado da pasta 'source')." -ForegroundColor Red
    Exit
}

# Converter caminho do Windows para formato Unix/MSYS2 (Ex: C:\Users\allan -> /c/Users/allan)
$drive = $sourceWinPath.Substring(0, 1).ToLower()
$rest = $sourceWinPath.Substring(2).Replace('\', '/')
$sourceMsysPath = "/$drive$rest"

Write-Host "`n[*] Caminho da Source detectado:" -ForegroundColor Cyan
Write-Host "   Windows: $sourceWinPath" -ForegroundColor Gray
Write-Host "   MSYS2:   $sourceMsysPath" -ForegroundColor Gray

# 4. Configurar e Compilar
Write-Host "`n[*] Regenerando scripts de compilacao..." -ForegroundColor Cyan
& $bashExe -lc "cd $sourceMsysPath && autoreconf -vfi"

Write-Host "`n[*] Configurando o Makefile (MySQL + SQLite)..." -ForegroundColor Cyan
& $bashExe -lc "cd $sourceMsysPath && ./configure --enable-mysql --enable-sqlite"

Write-Host "`n[*] Iniciando compilacao paralela multi-core..." -ForegroundColor Cyan
& $bashExe -lc "cd $sourceMsysPath && sh build.sh"

# 5. Mover Executavel Gerado para a Raiz e Copiar DLLs
$exeSourcePath = Join-Path $sourceWinPath "theforgottenserver.exe"
$exeDestPath = Join-Path $PSScriptRoot "theforgottenserver.exe"

if (Test-Path $exeSourcePath) {
    Write-Host "`n[SUCCESS] Compilacao concluida com SUCESSO!" -ForegroundColor Green
    Write-Host "[*] Copiando executavel para a pasta raiz..." -ForegroundColor Yellow
    Copy-Item $exeSourcePath $exeDestPath -Force
    Write-Host "[OK] Executavel copiado para: $exeDestPath" -ForegroundColor Green
    
    # --- Copiar dependencias DLL do MSYS2 para a Raiz ---
    Write-Host "`n[*] Resolvendo e copiando dependencias DLL necessarias..." -ForegroundColor Cyan
    $mingwBinPath = Join-Path $msysPath "mingw64\bin"
    $copiedCount = 0
    $fallback = $true
    
    # 1. Tentar detectar dinamicamente via 'ldd'
    if (Test-Path $bashExe) {
        try {
            $lddCmd = "export PATH=/mingw64/bin:`$PATH; ldd $sourceMsysPath/theforgottenserver.exe"
            $lddOutput = & $bashExe -lc $lddCmd
            
            # Filtrar as DLLs do MinGW64
            $detectedDlls = @()
            foreach ($line in $lddOutput) {
                if ($line -match '=>\s+(/mingw64/bin/[^\s\(\)]+)') {
                    $msysDllPath = $Matches[1]
                    $dllName = Split-Path $msysDllPath -Leaf
                    $detectedDlls += $dllName
                }
            }
            
            if ($detectedDlls.Count -gt 0) {
                $fallback = $false
                foreach ($dll in $detectedDlls) {
                    $srcDllPath = Join-Path $mingwBinPath $dll
                    $destDllPath = Join-Path $PSScriptRoot $dll
                    if (Test-Path $srcDllPath) {
                        Copy-Item $srcDllPath $destDllPath -Force
                        Write-Host "   [+] Copiada: $dll" -ForegroundColor Gray
                        $copiedCount++
                    }
                }
            }
        }
        catch {
            Write-Host "[!] Erro ao executar ldd. Usando fallback estatico..." -ForegroundColor Yellow
        }
    }
    
    # 2. Fallback estatico caso a detecao dinamica nao encontre nada ou falhe
    if ($fallback) {
        Write-Host "[*] Copiando DLLs a partir da lista padrao de dependencias..." -ForegroundColor Yellow
        $commonDlls = @(
            "libboost_filesystem-mt.dll", "libboost_thread-mt.dll", "libcrypto-3-x64.dll",
            "libcryptopp.dll", "libgcc_s_seh-1.dll", "lua51.dll", "libmariadb.dll",
            "libwinpthread-1.dll", "libsqlite3-0.dll", "libstdc++-6.dll", "libxml2-16.dll",
            "zlib1.dll", "libzstd.dll", "libiconv-2.dll", "libcurl-4.dll", "libbrotlidec.dll",
            "libidn2-0.dll", "libnghttp3-9.dll", "libnghttp2-14.dll", "libngtcp2-16.dll",
            "libpsl-5.dll", "libssh2-1.dll", "libbrotlicommon.dll", "libintl-8.dll",
            "libngtcp2_crypto_ossl-0.dll", "libunistring-5.dll", "libssl-3-x64.dll"
        )
        foreach ($dll in $commonDlls) {
            $srcDllPath = Join-Path $mingwBinPath $dll
            $destDllPath = Join-Path $PSScriptRoot $dll
            if (Test-Path $srcDllPath) {
                Copy-Item $srcDllPath $destDllPath -Force
                Write-Host "   [+] Copiada (padrao): $dll" -ForegroundColor Gray
                $copiedCount++
            }
        }
    }
    
    if ($copiedCount -gt 0) {
        Write-Host "[OK] $copiedCount dependencias DLL copiadas com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "[!] Nenhuma DLL foi copiada. Verifique a pasta '$mingwBinPath'." -ForegroundColor Yellow
    }
    
    Write-Host "`n[*] Digite '.\theforgottenserver.exe' na raiz para iniciar seu servidor!" -ForegroundColor Cyan
} else {
    Write-Host "[ERRO] Ocorreu um erro na compilacao. O executavel nao foi gerado." -ForegroundColor Red
}
