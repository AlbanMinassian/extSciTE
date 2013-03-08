-- coding: utf-8 -

--~ -- -------------------------------------------------------------------------------------------------------
--~ -- http://lua-users.org/wiki/SciteColouriseDemo
--~ -- demo to provide custom colours and styles to a specific buffer
--~ -- <khman@users.sf.net> public domain 20060906
--~ -- -------------------------------------------------------------------------------------------------------
--~ local function SetColours(lexer, scheme)
--~     local function dec(s) return tonumber(s, 16) end
--~     if lexer then output.Lexer = lexer end
--~     for i, style in pairs(scheme) do
--~         for prop, value  in pairs(style) do
--~             if (prop == "StyleFore" or prop == "StyleBack") and type(value) == "string" then -- convert from string
--~                 local hex, hex, r, g, b = string.find(value, "^(%x%x)(%x%x)(%x%x)$")
--~                 value = hex and (dec(r) + dec(g)*256 + dec(b)*65536) or 0
--~             end
--~             output[prop][i] = value
--~         end--each property
--~     end--each style
--~ end

--~ local ColourScheme = { -- a sample colour scheme
--~   [1] = {StyleFore = "800000", StyleBold = true,},
--~   [2] = {StyleFore = "008000", StyleBack = "E0E0E0", StyleItalic = true,},
--~ }

--~ function ColourTest()

--~     SetColours(SCLEX_CONTAINER, ColourScheme)
--~     
--~     text = "The quick brown fox jumped over the lazy dog.\n"
--~     textLen = string.len(text)
--~     
--~     output:StartStyling(--[[position pos]]  output.CurrentPos, --[[int mask]] 31)
--~     output:AddText("The quick brown fox jumped over the lazy dog.\n")
--~     output:SetStyling(--[[int length]] textLen, --[[int style]] 1)
--~     
--~     -- @todo / ON PERD LE STYLE SI ON CHANGE DE buffer 
--~     -- +> ID2EE , => sauvegarder style dans table annexe ? => uniquement si c'est depuis ce fichier qu'a été appellé la coloration 
--~         --[[ enregitrer
--~             - nom du fichier (
--~             - n° de ligne
--~             - texte complet de la ligne 
--~             
--~             Si on revient sur le buffer X
--~                 ->= tester si avec ligne 
--~                 - lire ligne
--~                 - si ligne = texte enregistré alors coloriser
--~                 
--~         ]]
--~     -- avec code scite_OnSwitchFile
--~     
--~ end
--~ ColourTest()

_ALERT(outputModuleMessage('[module] outputcolor (@todo, cf code)', "016outputcolor.lua"))
