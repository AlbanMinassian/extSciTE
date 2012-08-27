-- -*- coding: utf-8 -

-- -------------------------------------------------------------------------------------------------------
-- openexplorer
-- -------------------------------------------------------------------------------------------------------
function openexplorer()

    local GTK = scite_GetProp('PLAT_GTK');
    if GTK then
        os.execute("dolphin \""..props['FileDir'].."\" &");
    else
        -- os.execute("%SystemRoot%\explorer.exe \""..props['FileDir'].."\"");
        os.execute("explorer.exe \""..props['FileDir'].."\"");
    end

end

scite_Command('Open Explorer|openexplorer|Ctrl+6')
lastIdx=getLastSciteCommandIdx(); -- cf extman.lua, récupérer identifiant de ce raccourci
_ALERT('[module] Open Explorer, Ctrl+6')

-- ajouter dans le menu contextuel
if (withUtils_menucontextuel==1) then  -- cf 015utils.lua
    table.insert(menucontextuel, "|") -- séparateur
    table.insert(menucontextuel, "Open Explorer|11"..lastIdx) -- 11 est absolument nécessaire
end