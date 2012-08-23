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
_ALERT('[module] Open Explorer, Ctrl+6')