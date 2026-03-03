-- map-styles.lua
-- Converte Divs com custom-style em <p class="..."> preservando formatação
-- e ajustando o nome da classe para o padrão do SEI (CamelCase com underscores)

local utils = require 'pandoc.utils'

-- Converte "texto_justificado_recuo_primeira_linha"
-- em "Texto_Justificado_Recuo_Primeira_Linha"
local function sei_class_from_style(style)
  local parts = {}
  for token in style:gmatch("[^_]+") do
    local first = token:sub(1, 1):upper()
    local rest  = token:sub(2)
    table.insert(parts, first .. rest)
  end
  return table.concat(parts, "_")
end

function Div(div)
  local style = div.attributes["custom-style"]
  if not style then
    return nil
  end

  -- Gera o nome da classe no padrão do SEI
  local class = sei_class_from_style(style)

  -- Só processa Divs com exatamente 1 parágrafo
  if #div.content == 1 and div.content[1].t == "Para" then
    -- mini-documento só com esse parágrafo
    local mini_doc = pandoc.Pandoc({ div.content[1] })

    -- converte esse mini-doc para HTML
    local html = pandoc.write(mini_doc, "html")

    -- substitui apenas a abertura do <p>
    html = html:gsub("<p>", '<p class="' .. class .. '">', 1)

    return pandoc.RawBlock("html", html)
  end

  return nil
end