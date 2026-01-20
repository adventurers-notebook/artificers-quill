-- dnd_pro.lua
-- Script avanzato per Pandoc: converte blocchi e statistiche in stile D&D 5e

local text_boxes = {
    "readaloud", "paperbox", "commentbox", "quotebox", "spell"
}

-- Funzione ausiliaria per creare la tabella delle statistiche
local function create_stats_table(text)
    -- Cerca i pattern dei punteggi. Esempio input: "STR 10 (+0) DEX..."
    -- Cattura il nome (es. STR) e il valore completo (es. 10 (+0))
    local stats = {}
    for stat, val in text:gmatch("(%u%u%u)%s+(%d+%s*%(?[%+%-%d]*%)?)") do
        table.insert(stats, {name = stat, value = val})
    end

    -- Se non troviamo esattamente 6 statistiche, non tocchiamo nulla (ritorna nil)
    if #stats ~= 6 then return nil end

    -- Costruiamo la tabella LaTeX
    local latex = "\\begin{tabular}{cccccc}\n"
    
    -- Riga Intestazioni (STR DEX ...) in grassetto e rosse (stile D&D)
    for i, s in ipairs(stats) do
        latex = latex .. "\\textbf{" .. s.name .. "}"
        if i < 6 then latex = latex .. " & " end
    end
    latex = latex .. " \\\\\n"
    
    -- Riga Valori (10 (+0) ...)
    for i, s in ipairs(stats) do
        latex = latex .. s.value
        if i < 6 then latex = latex .. " & " end
    end
    latex = latex .. "\n\\end{tabular}\n"

    return pandoc.RawBlock("latex", latex)
end

function Div(el)
    local env_name = el.classes[1]
    
    -- 1. Gestione Box di Testo (Standard)
    for _, box in ipairs(text_boxes) do
        if env_name == box then
            local title = el.attributes["title"]
            local latex_begin = ""
            
            if title then
                latex_begin = "\\begin{" .. env_name .. "}{" .. title .. "}"
            elseif env_name == "readaloud" then
                latex_begin = "\\begin{" .. env_name .. "}"
            else
                latex_begin = "\\begin{" .. env_name .. "}{}"
            end

            return {
                pandoc.RawBlock("latex", latex_begin),
                el,
                pandoc.RawBlock("latex", "\\end{" .. env_name .. "}")
            }
        end
    end

    -- 2. Gestione Monsterbox con Automazione Statistiche
    if env_name == "monster" then
        local name = el.attributes["name"] or "Creatura"
        
        -- Processiamo il contenuto del mostro per trovare la riga delle statistiche
        local new_content = pandoc.Walk(el.content, {
            Para = function(para)
                -- Otteniamo il testo puro del paragrafo
                local text = pandoc.utils.stringify(para)
                
                -- Se inizia con "STR", proviamo a convertirlo in tabella
                if text:match("^STR") then
                    local stats_table = create_stats_table(text)
                    if stats_table then return stats_table end
                end
                
                -- Bonus: Grassetto automatico per HP, AC, Speed se l'utente lo dimentica
                -- Esempio: "Armor Class 15" diventa "**Armor Class** 15"
                if text:match("^Armor Class") or text:match("^Hit Points") or text:match("^Speed") then
                     -- Qui usiamo una sostituzione semplice sulle stringhe
                     -- Nota: questo è un trick visivo per LaTeX
                     local key, val = text:match("^(.-)%s(%d.+)")
                     if key and val then
                        return pandoc.Para{
                            pandoc.Strong(pandoc.Str(key)),
                            pandoc.Space(),
                            pandoc.Str(val)
                        }
                     end
                end
                
                return nil -- Nessuna modifica
            end
        })

        return {
            pandoc.RawBlock("latex", "\\begin{monsterbox}{" .. name .. "}"),
            new_content, -- Usiamo il contenuto processato
            pandoc.RawBlock("latex", "\\end{monsterbox}")
        }
    end
end
