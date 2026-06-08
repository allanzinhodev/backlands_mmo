# Relatório de Revisão (TODO) - Duplicatas no items.xml / items.otb

> [!WARNING]
> Foram identificadas colisões de IDs duplicados no arquivo [items.xml](file:///C:/Users/allan/OneDrive/Desktop/Project/data/items/items.xml). 
> Esta inconsistência precisa ser revisada e resolvida também no arquivo binário correspondente [items.otb](file:///C:/Users/allan/OneDrive/Desktop/Project/data/items/items.otb) usando um editor de OTB (como o Item Editor) para evitar conflitos no servidor.

---

## 📋 Itens Duplicados a Corrigir

A tabela abaixo resume os IDs duplicados encontrados no `items.xml` e as ações recomendadas:

| ID | Nome XML 1 | Linha 1 | Nome XML 2 | Linha 2 | Ação Recomendada |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **12296** | `Dynamic Marking` | [L18432](file:///C:/Users/allan/OneDrive/Desktop/Project/data/items/items.xml#L18432) | `aian nakkuru` | [L18727](file:///C:/Users/allan/OneDrive/Desktop/Project/data/items/items.xml#L18727) | Verificar qual item deve manter o ID original e remapear o outro para um ID livre no OTB. |
| **12691** | `sword` | [L18648](file:///C:/Users/allan/OneDrive/Desktop/Project/data/items/items.xml#L18648) | `itsumo sword` | [L18760](file:///C:/Users/allan/OneDrive/Desktop/Project/data/items/items.xml#L18760) | Avaliar se o ID `12691` no OTB corresponde à `sword` genérica ou à `itsumo sword` customizada. |
| **13227** | `Explosive Kunai` | [L19588](file:///C:/Users/allan/OneDrive/Desktop/Project/data/items/items.xml#L19588) | `coal` | [L19600](file:///C:/Users/allan/OneDrive/Desktop/Project/data/items/items.xml#L19600) | Ajustar no OTB para que a `Explosive Kunai` e o `coal` tenham IDs únicos, evitando substituição visual. |

---

## 🔍 Detalhes dos Itens em Conflito

### 1. ID `12296`
* **Definição A:**
  ```xml
  <item id="12296" name="Dynamic Marking">
    <attribute key="description" value="Dynamic Marking."/>
    <attribute key="weight" value="0" />
  </item>
  ```
* **Definição B:**
  ```xml
  <item id="12296" article="a" name="aian nakkuru">
    <attribute key="weight" value="400" />
    <attribute key="attack" value="28"/>
    <attribute key="weaponType" value="axe" />
    <attribute key="attackSpeed" value="1500" />
    <attribute key="showattributes" value="1" />
  </item>
  ```

### 2. ID `12691`
* **Definição A:**
  ```xml
  <item id="12691" article="a" name="sword">
    <attribute key="weight" value="800" />
    <attribute key="attack" value="9"/>
    <attribute key="weaponType" value="axe" />
    <attribute key="attackSpeed" value="2200" />
    <attribute key="showattributes" value="1" />
  </item>
  ```
* **Definição B:**
  ```xml
  <item id="12691" name="itsumo sword">
    <attribute key="description" value="sword forged by Itsumo." />
    <attribute key="attack" value="18"/>
    <attribute key="weaponType" value="axe"/>
    <attribute key="weight" value="160" />
  </item>
  ```

### 3. ID `13227`
* **Definição A:**
  ```xml
  <item id="13227" article="a" name="Explosive Kunai">
    <attribute key="weight" value="70" />
    <attribute key="weaponType" value="shield"/>
  </item>
  ```
* **Definição B:**
  ```xml
  <item id="13227" name="coal">
    <attribute key="duration" value="8" />
    <attribute key="decayTo" value="0" />
  </item>
  ```

---

## 🛠️ Passos para Resolução no `items.otb`
1. Abra o arquivo [items.otb](file:///C:/Users/allan/OneDrive/Desktop/Project/data/items/items.otb) em um Editor de Itens (Item Editor) compatível com a versão do servidor.
2. Busque pelos IDs `12296`, `12691` e `13227` para ver a qual item físico/gráfico (Client ID / Sprite) eles estão atualmente associados.
3. Decida quais novos IDs (não utilizados) serão atribuídos aos itens colidentes.
4. Ajuste as referências tanto no [items.otb](file:///C:/Users/allan/OneDrive/Desktop/Project/data/items/items.otb) quanto no [items.xml](file:///C:/Users/allan/OneDrive/Desktop/Project/data/items/items.xml).
