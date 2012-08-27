-- -*- coding: utf-8 -

-- -------------------------------------------------------------------------------------------------------
-- execlua : Si on double click dans la console une ligne qui se termine par ``execlua[doluaeval]\n`` alors on exécute le code ``doluaeval``.
-- note : quand 030bookmark.lua affiche la liste des bookmarks, il a aussi parfois ajouté des lignes (après 500 caractères ) complété de ``execlua[xxxx]``
-- note : 040dir.lua abuse de execlua 
-- -------------------------------------------------------------------------------------------------------
function trim1(s) -- ( http://lua-users.org/wiki/StringTrim )
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end
scite_OnDoubleClick(function()
    if (output.Focus) then -- not editor.Focus  -- tester si click dans editor ou output

--~         -- détecter présence du caractère shift ou ctrl
--~         -- lastChar a été initialisé par OnKey ci-dessus
--~         -- @todo : utiliser search
--~         if (lastChar == 65508) then
--~             search = 'execlua_ctrl';
--~         elseif (lastChar == 65505) then
--~             search = 'execlua_shift';
--~         else
--~             search = 'execlua';
--~         end

        if (output.CurrentPos > 0) then
            local varOutputCurrentLine = output:LineFromPosition( output.CurrentPos )
            lineOutput = output:GetLine(varOutputCurrentLine)
            if ( lineOutput ~= nil ) then
                lineOutput = trim1(lineOutput)
                if ( lineOutput ~= '' ) then
                    if (string.find(lineOutput, 'execlua') ~= nil) then
                        -- extraire le code entre ``execlua[xxxx]\n``
                        execlua = string.match(lineOutput, "execlua.*") -- @todo revoir extraction car pour le moment nécessite execlua strictement à la fin
                        execlua = string.sub(execlua, 9, -2) -- -2 car `]\n`
                        dostring(execlua) -- exécuter ce code lua
                    end
                end
            end
        end

    end
end)

_ALERT('[module] execlua');
withExeclua=1;
