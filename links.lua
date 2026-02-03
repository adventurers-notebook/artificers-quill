function Link(el)
  -- Controlla se il link finisce con .md
  if el.target:match("%.md$") then
    -- Sostituisce .md con .html
    el.target = string.gsub(el.target, "%.md$", ".html")
  end
  return el
end