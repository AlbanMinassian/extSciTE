-- -*- coding: utf-8 -

-- -------------------------------------------------------------------------------------------------------
-- fileinfo
-- affiche dans la console les informations relatives au fichier courant
-- -------------------------------------------------------------------------------------------------------

function fileInfo()
--~     projectPath = scite_GetProp('extscite.project.path')
--~     if projectPath == nil then projectPath = ''; end

    -- ------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- http://www.scintilla.org/SciTEDoc.html
    -- ------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- FilePath	full path of the current file
    -- FileDir	directory of the current file without a trailing slash
    -- FileName	base name of the current file
    -- FileExt	extension of the current file
    -- FileNameExt	$(FileName).$(FileExt)
    -- SessionPath	full path of the current session
    -- CurrentSelection	value of the currently selected text
    -- CurrentWord	value of word which the caret is within or near
    -- Replacements	number of replacements made by last Replace command
    -- SelectionStartColumn	column where selection starts
    -- SelectionStartLine	line where selection starts
    -- SelectionEndColumn	column where selection ends
    -- SelectionEndLine	line where selection ends
    -- CurrentMessage	most recently selected output pane message
    -- SciteDefaultHome	directory in which the Global Options file is found
    -- SciteUserHome	directory in which the User Options file is found
    -- SciteDirectoryHome	directory in which the Directory Options file is found
    -- APIPath	list of full paths of API files from api.filepattern
    -- AbbrevPath	full path of abbreviations file
    -- ------------------------------------------------------------------------------------------------------------------------------------------------------------------

    _ALERT('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    _ALERT('File[Path|Dir|NameExt|Name|Ext] & stat')
    _ALERT('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    
    _ALERT(props['FilePath'])
    _ALERT(props['FileDir'])
    _ALERT("cd \""..props['FileDir'].."\"")
    _ALERT(props['FileNameExt'])
    _ALERT(props['FileName'])
    _ALERT(props['FileExt'])
    
    if ( posix ~= nil) then
        local T=assert(posix.stat(props['FilePath']))
        
        --for key,value in pairs(T) do
        --    _ALERT(key .. " = " ..value )
        --end 
        
        local p=assert(posix.getpasswd(T.uid))
        local g=assert(posix.getgroup(T.gid))
        _ALERT(T.mode)
        _ALERT(p.name)
        _ALERT(g.name)
        _ALERT(T.size)
        _ALERT(os.date("%b %d %H:%M",T.mtime))
        _ALERT(T.type)
        _ALERT("")
        
    end
    
end

scite_Command('File Info|fileInfo|Ctrl+I')
lastIdx=getLastSciteCommandIdx(); -- cf extman.lua, récupérer identifiant de ce raccourci
_ALERT('[module] File Info, Ctrl+I')

-- ajouter dans le menu contextuel
if (withUtils_menucontextuel==1) then  -- cf 015utils.lua
    table.insert(menucontextuel, "|") -- séparateur
    table.insert(menucontextuel, "File Info|11"..lastIdx) -- 11 est absolument nécessaire
end
