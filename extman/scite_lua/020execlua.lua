-- -*- coding: utf-8 -

-- -------------------------------------------------------------------------------------------------------
-- execlua : Si on double click dans la console une ligne qui se termine par ``execlua[doluaeval]\n`` alors on exécute le code ``doluaeval``.
-- note : quand 030bookmark.lua affiche la liste des bookmarks, il a aussi parfois ajouté des lignes (après 500 caractères ) complété de ``execlua[xxxx]``
-- note : 040dir.lua abuse de execlua 
-- -------------------------------------------------------------------------------------------------------
function trim1(s) -- ( http://lua-users.org/wiki/StringTrim )
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- -------------------------------------------------------------------------------------------------------
-- enregistrer dernier caractère saisie
-- utilisé par execlua pour terminer quelle action effectuer en fonction de la touche CTRL ou SHIFT 
-- -------------------------------------------------------------------------------------------------------
local lastKeyForExecLuaBeforeDoubleClick=nil
scite_OnKey(function(argKey)
    lastKeyForExecLuaBeforeDoubleClick=argKey
end)

-- -------------------------------------------------------------------------------------------------------
-- Comportement non souhaité : il ne faut double cliquer en même temps que CTRL ou SHIFT : donc pas la peine de maintenir enfoncé .. scite ne sait pas gérer ce cas de KeyUp
-- -------------------------------------------------------------------------------------------------------
scite_OnDoubleClick(function()
    
    if (output.Focus) then -- not editor.Focus  -- tester si click dans editor ou output

        if (output.CurrentPos > 0) then
            local varOutputCurrentLine = output:LineFromPosition( output.CurrentPos )
            lineOutput = output:GetLine(varOutputCurrentLine)
            if ( lineOutput ~= nil ) then
                lineOutput = trim1(lineOutput)
                if ( lineOutput ~= '' ) then
                
                    -- détecter présence du caractère shift ou ctrl AVANT double click (donc pas la peine de maintenir enfoncé .. scite ne sait pas gérer ce cas)
                    -- lastKeyForExecLuaBeforeDoubleClick a été initialisé par OnKey ci-dessus
                    -- _ALERT(lastKeyForExecLuaBeforeDoubleClick)
                    if ( (props['PLAT_WIN']=='1' and lastKeyForExecLuaBeforeDoubleClick == 17 ) or lastKeyForExecLuaBeforeDoubleClick == 65508) then
                        searchExecluaString = 'execluaCtrl';
                    elseif ( (props['PLAT_WIN']=='1' and lastKeyForExecLuaBeforeDoubleClick == 16 ) or lastKeyForExecLuaBeforeDoubleClick == 65505) then
                        searchExecluaString = 'execluaShift';
                    else
                        searchExecluaString = 'execlua';
                    end
                    lastKeyForExecLuaBeforeDoubleClick=nil -- réinitialiser
        
                    -- if (string.find(lineOutput, 'execlua%[') ~= nil) then
                    if (string.find(lineOutput, searchExecluaString..'%[') ~= nil) then
                        -- execlua = (lineOutput:gsub("^.*execlua%[(.*)%].*$", "%1")) -- extraire le code xxxx présent dans la chaine ``....execlua[xxxx]....\n``
                        luaCode = (lineOutput:gsub("^.*"..searchExecluaString.."%[(.*)%].*$", "%1")) -- extraire le code xxxx présent dans la chaine ``....execlua[xxxx]....\n``
                        if (luaCode ~= nil) then
                            dostring(luaCode) -- exécuter ce code lua
                        else
                            _ALERT('pb '..searchExecluaString..' avec cette chaine : '..lineOutput)
                        end 
                    end
                    
                end
            end
        end
    end
    
end)

_ALERT(outputModuleMessage('[module] execlua / execluaCtrl / execluaShift', "020execlua.lua"))
withExeclua=1;

