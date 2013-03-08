-- -*- coding: utf-8 -

-- -------------------------------------------------------------------------------------------------------
-- dir ; liste les autres fichiers dans le répertoire du fichier édité
-- -------------------------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------------------------
-- Afficher la liste des fichiers du répertoire
-- utilise lua file system
-- -------------------------------------------------------------------------------------------------------
if (props['PLAT_GTK']=='1') then
    osSeparator = '/'
    cmdLs = 'ls'
elseif (props['PLAT_WIN']=='1') then
    osSeparator = '\\'
    cmdLs = 'dir'
end

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ordonner lfs.dir
-- http://lists.luaforge.net/pipermail/kepler-project/2008-May/002610.html
-- RAPPEL : ECRIRE SOUS CETTE FORME: for i,name in sortedir(path) do <--- ecriture obligatoire
-- RAPPEL : NE PAS ECRIRE: table = sortedir(path)  <--- génère une erreur
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function iter (a, i) -- taken from PiL, page 59
     i = i + 1
     local v = a[i]
     if v then
         return i, v
     end
end
function sortedir(dir)
     local entries = {}
     local i = 0
     for name in lfs.dir(dir) do
         i = i + 1
         entries[i] = name
     end
     table.sort(entries) -- sort method
     return iter, entries, 0
end

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- afficher les fichiers du répertoire
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function printListFileInDirCommun(argFileDir)
    -- lfs.dir(path) <-- retourne la liste des fichiers et répertoire NON trié
    -- sortedir retourne la liste des fichiers et répertoire trié ( utilise en interne lfs.dir. cf sortedir déclaré plus haut )
    
    _ALERT("--------------------------------------------------------------------------------")
    _ALERT( ""..cmdLs .. " \""..argFileDir .. "\"")
    _ALERT("--------------------------------------------------------------------------------")

    -- Afficher les répertoires en premier
    local path = argFileDir
    for i,name in sortedir(path) do
        if ( name ~= "." ) then
            local f = argFileDir..osSeparator..name
            local attr = lfs.attributes (f)
            if attr.mode == "directory" then
            
                -- SI ( windows ET directory ) ALORS ( \ en \\ ) CAR le path sera inséré dans une chaine string pour être exécuté par execlua
                if (props['PLAT_WIN']=='1') then
                    f = string.gsub(f, "\\", "\\\\")
                end       
    
                -- OLD STYLE : stringOutput = ' [ ' .. name..' ] '..string.rep(' ',500)..' '..'execlua[printListFileInDirCommun("'..f..'")]'
                stringOutput = '|-- [' .. name..'] '..string.rep(' ',500)..' '..'execlua[openFileOrDirectory("'..f..'")]'
                _ALERT(stringOutput)
            end
        end
    end

    -- Afficher les fichiers ensuite
    -- @TODO : utiliser execlua(scite.open(nom du fichier)) .. POUR EVITER LES COLORATION SYNTAXIQUES pénibles
    local path = argFileDir
    for i,name in sortedir(path) do
        local f = argFileDir..osSeparator..name
        local attr = lfs.attributes (f)
        if attr.mode ~= "directory" then
            if string.sub(name, -4) == '.pyc' then -- ne pas afficher fichier pyc
                -- pass
            else
                -- OLD STYLE : stringOutput = ' ' .. name..string.rep(' ',500)..' File "'..path..osSeparator..name..'", line 1: '


                -- SI ( windows ET directory ) ALORS ( \ en \\ ) CAR le path sera inséré dans une chaine string pour être exécuté par execlua
                f = path..osSeparator..name
                if (props['PLAT_WIN']=='1') then
                    f = string.gsub(f, "\\", "\\\\")
                end       
                stringOutput = '|-- /' .. name..' '..string.rep(' ',500)..' '..'execlua[openFileOrDirectory("'..f..'")]'
                
                _ALERT(stringOutput)
            end
        end
    end
end

function printListFileInDir()
    printListFileInDirCommun( props['FileDir'] )
end

if (withExeclua == 1) then -- tester présence de 020execlua.lua

    idx =  31
    props['command.name.'..idx..'.*'] ="Dir : liste des fichiers dans le répertoire courant"
    props['command.'..idx..'.*'] ="printListFileInDir"
    props['command.subsystem.'..idx..'.*'] ="3"
    props['command.mode.'..idx..'.*'] ="savebefore:no"
    props['command.shortcut.'..idx..'.*'] ="Ctrl+Shift+O"

    _ALERT(outputModuleMessage('[module] List dir, Ctrl+Shift+O', "040dir.lua"))
    withDir=1;

        
else 

    _ALERT(outputModuleMessage('[FAIL] List dir, 020execlua.lua not load', "040dir.lua"))
end
