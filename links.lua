-- Funzione per correggere i link da .md a .html
function Link(el)
  if el.target:match("%.md$") then
    el.target = string.gsub(el.target, "%.md$", ".html")
  end
  return el
end

-- Funzione per gestire i Box (Div)
function Div(el)
  -- Controlla se il div ha una delle nostre classi speciali
  if el.classes:includes("readaloud") or el.classes:includes("paperbox") or el.classes:includes("commentbox") then
    
    -- Cerca se c'è un attributo "title" (es. {title="La Grotta"})
    if el.attributes["title"] then
      -- Crea un elemento Header (H3) con il titolo
      local header = pandoc.Header(3, el.attributes["title"])
      
      -- Inserisci il titolo come PRIMO elemento dentro il box
      table.insert(el.content, 1, header)
    end
    
    return el
  end
end