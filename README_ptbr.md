# Conversão de Estilos do Word para Classes CSS do SEI  
Utilizando Pandoc + Filtro Lua

Este repositório contém um fluxo de conversão que permite transformar **estilos de parágrafo do Microsoft Word** em **classes CSS reconhecidas pelo SEI (Sistema Eletrônico de Informações)** através de:

- **Pandoc** (como conversor principal DOCX → HTML)
- **Lua Filters** (para mapear estilos → classes CSS do SEI)
- Preservação completa de formatação (negrito, itálico, links etc.)

O objetivo principal é permitir que documentos produzidos no Word possam ser convertidos em **HTML totalmente compatível com o CSS do SEI**, facilitando copiar e colar conteúdo diretamente no editor do sistema.


---

## Motivação

O Word armazena estilos internos usando nomes *minúsculos* no XML do DOCX, por exemplo:

```xml
<w:style w:styleId="textojustificado">
    <w:name w:val="texto_justificado"/>
</w:style>
````

Já o SEI exige classes CSS **com letras maiúsculas**, como:

```css
p.Texto_Justificado {
    text-align: justify;
}
```

Assim, um DOCX com estilo `"texto_justificado"` precisa ser convertido para:

```html
<p class="Texto_Justificado">...</p>
```

O Pandoc + Lua Filter permite fazer exatamente esse mapeamento.

---

## Como funciona o fluxo

### **1. No Word**

* Utilize estilos de parágrafo fornecidos com o arquivo Estilos_SEI.dotx. Esse arquivo possui estilos com nomes equivalentes aos estilos do SEI
  (por exemplo: `texto_justificado`, `citacao`, `item_nivel1`).

### **2. Geração do HTML**

Use o Pandoc com suporte aos estilos:

```bash
pandoc -f docx+styles -t html \
  --lua-filter=map-styles.lua \
  -o output.html \
  Estilos_SEI.docx
```

### **3. Papel do filtro Lua**

O arquivo `map-styles.lua` faz:

* leitura do atributo `custom-style` gerado pelo `docx+styles`;
* tradução do nome do estilo (sempre minúsculo) para a classe CSS correta do SEI (com maiúsculas);
* substituição da tag `<p>` por `<p class="Nome_Do_Estilo">`;
* **preserva toda a formatação interna**:

  * `<strong>`, `<em>`, `<a>`, `<code>`, etc.

### **4. No SEI**

Basta copiar o HTML para:

* editor de código-fonte, ou
* campo de texto (dependendo da unidade/versão do SEI)

e o CSS padrão aplica as formatações automaticamente.

---

## Instalação

### 1. Instalar Pandoc

[https://pandoc.org/installing.html](https://pandoc.org/installing.html)

### 2. Clonar o repositório

```bash
git clone https://github.com/ecostadelle/from_word_to_sei.git
cd from_word_to_sei
```

### 3. Executar o conversor

```bash
pandoc -f docx+styles -t html \
  --lua-filter=map-styles.lua \
  -o output.html \
  Estilos_SEI.docx
```

---

## Exemplo de saída

Entrada:

* Estilo no Word: `texto_justificado`
* Parágrafo com negrito e itálico

Saída:

```html
<p class="Texto_Justificado">
  Texto com <em>itálico</em> e <strong>negrito</strong>.
</p>
```

Perfeitamente compatível com o CSS do SEI.

---

## Licença

Este projeto é licenciado sob **Apache License 2.0**.
Veja os arquivos `LICENSE` e `NOTICE` para mais detalhes.

---

## Contribuições

Pull requests são bem-vindos.
Caso queira adicionar novos estilos ou melhorar o parser de listas, sinta-se à vontade.

---

## Contato

Se tiver dúvidas sobre o uso ou quiser sugerir melhorias, abra uma **Issue** no repositório.
