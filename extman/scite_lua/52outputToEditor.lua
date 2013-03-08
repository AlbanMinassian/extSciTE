-- -*- coding: utf-8 -

-- -------------------------------------------------------------------------------------------------------
-- copyOutputToNewBuffer
-- -------------------------------------------------------------------------------------------------------
function copyOutputToNewBuffer()

    -- Ancien code
    -- scite.Open("") -- vide sinon dialogue indiquant que le fichier n'existe pas
    -- editor:ClearAll()
    -- editor:AddText( output:textrange(0, output.Length) )
    
    -- nouvelle version : permet de tout de suite placer résulta dans un fichier ( et aussi que Scite demande si on veut recharger le contenu si celui a évolué  )
    
    
    local GTK = scite_GetProp('PLAT_GTK');
    local default_path; local tmpfile;
    if GTK then
        default_path = props['SciteUserHome']
        tmpfile = default_path..'/console.txt'
    else
        default_path = props['SciteDefaultHome']
        tmpfile = default_path..'\\console.txt'
    end
    
    local f = assert(io.open(tmpfile, "w")); -- créer fichier si  n'existe pas
    f:write( output:textrange(0, output.Length) )
    f:close()
    scite.Open(tmpfile) -- vide sinon dialogue indiquant que le fichier n'existe pas

end

scite_Command('Open Console In New Buffer|copyOutputToNewBuffer|Ctrl+7')
_ALERT(outputModuleMessage('[module] Console to buffer, Ctrl+7', "52outputToEditor.lua"))