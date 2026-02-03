function Div(el)
  -- Classi che vogliamo gestire
  local special_classes = {"readaloud", "paperbox", "commentbox", "monster", "spell", "dndtable"}
  
  local is_special = false
  for _, class in ipairs(special_classes) do
    if el.classes:includes(class) then is_special = true break end
  end

  if is_special then
    -- Cerca "title" OPPURE "name"
    local title_text = el.attributes["title"] or el.attributes["name"]
    
    if title_text then
      print(">> Creazione Header per: " .. title_text)
      -- Usa H3 per i mostri, H4 per gli altri (più piccoli)
      local level = 3
      if el.classes:includes("monster") then level = 3 else level = 4 end

      local header = pandoc.Header(level, title_text)
      table.insert(el.content, 1, header)
    end
    
    return el
  end
end

function Link(el)
  if el.target:match("%.md$") then
    el.target = string.gsub(el.target, "%.md$", ".html")
  end
  return el
end