# 📖 Guia de Compilação Prática - TFS 0.4 Naruto

Para facilitar o uso e compilação do seu servidor em **outros computadores** sem que você precise reconfigurar dependências ou instalar pacotes manualmente toda vez, criamos um script de automação robusto no PowerShell: **`compile.ps1`**.

Com este script, a compilação torna-se um processo praticamente de **1 clique**.

---

## 🚀 Como Compilar em um Novo Computador (Passo a Passo)

Sempre que você transferir a pasta do servidor para um novo computador Windows, siga estes passos simples para compilar:

### Passo 1: Abrir o PowerShell como Administrador
1. Clique no menu Iniciar do Windows e digite **PowerShell**.
2. Clique com o botão direito sobre **Windows PowerShell** e selecione **Executar como Administrador**.

### Passo 2: Permitir a execução de scripts locais
Por padrão, o Windows bloqueia a execução de scripts baixados da internet ou criados localmente. Execute o seguinte comando para liberar o script de compilação temporariamente nesta sessão do terminal:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
```

### Passo 3: Navegar até a pasta do servidor e executar
Substitua pelo caminho onde a pasta do seu servidor está localizada (ou apenas navegue até ela):
```powershell
cd "C:\Caminho\Ate\Seu\Servidor"
```
E então inicie o script de compilação automática:
```powershell
.\compile.ps1
```

---

## 🛠️ O que o Script de Automação faz?

O script `compile.ps1` é inteligente e executa todo o fluxo de instalação por você:

1. **Detecta o MSYS2:** Verifica se o `C:\msys64` existe. Se não existir, instala o MSYS2 silenciosamente via **Winget** (o gerenciador de pacotes padrão do Windows 10 e 11).
2. **Atualiza os Repositórios:** Sincroniza e atualiza o banco de dados do MSYS2 (`pacman -Sy`).
3. **Instala as Dependências:** Baixa e configura de uma só vez todo o compilador (GCC 16, Make, Autotools) e as bibliotecas requeridas (`Boost 1.91.0`, `Lua 5.1`, `MariaDB/MySQL Client`, `SQLite3`, `Crypto++`, `LibXML2` e `Zlib`).
4. **Detecta o Caminho de Forma Dinâmica:** Não importa qual computador ou pasta você esteja usando, ele converte dinamicamente o caminho da pasta `source` do Windows para o padrão do terminal MSYS2 (exemplo: `C:\pasta` vira `/c/pasta`).
5. **Configura e Compila:** Executa o `autoreconf`, configura o suporte a MySQL/SQLite e compila utilizando múltiplos núcleos do seu processador de forma extremamente rápida.
6. **Entrega o Executável:** Pega o arquivo final `theforgottenserver.exe` gerado dentro da pasta `source/` e o coloca automaticamente na **pasta raiz** do seu servidor.
7. **Copia Dinâmica de DLLs (Portabilidade Total):** Analisa dinamicamente todas as DLLs dependentes (Boost, Lua, SQLite, MariaDB, etc.) utilizando a ferramenta `ldd` do MSYS2 e as copia automaticamente da pasta do compilador para a **pasta raiz** do servidor. Isso resolve de forma definitiva qualquer erro de "DLL ausente" (`libboost_thread-mt.dll`, etc.) e permite que a pasta do seu servidor seja executada diretamente em outros computadores Windows sem nenhuma dependência adicional!

---

## 🏁 Como Iniciar o Servidor

Após o término da execução do script (que mostrará uma mensagem verde de SUCESSO), você poderá iniciar o seu servidor diretamente pela pasta raiz:

```powershell
.\theforgottenserver.exe
```

---

## ❓ Solução de Problemas Comuns

### 1. Mensagem de erro de permissão (Script bloqueado)
Se o PowerShell reclamar de permissão ao tentar rodar o script, execute primeiro:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
```
E tente novamente.

### 2. O comando 'winget' não foi reconhecido
Em versões muito antigas ou desatualizadas do Windows 10, o `winget` pode não estar instalado por padrão.
*   **Solução:** Baixe e instale o MSYS2 manualmente do site oficial [msys2.org](https://www.msys2.org/) mantendo a pasta padrão `C:\msys64`. Depois disso, execute o `.\compile.ps1` normalmente e ele pulará o download, indo direto para a compilação!
