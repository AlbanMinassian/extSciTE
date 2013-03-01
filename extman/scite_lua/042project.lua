-- -*- coding: utf-8 -

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- printTree
-- affiche la liste des fichiers du projets dans la console
-- affiche l'arbre des fichiers et répertoires avec l'utilitaire ``tree`` (http://www.computerhope.com/unix/tree.htm)
-- Windows : télécharger tree depuis http://gnuwin32.sourceforge.net/packages/tree.htm
-- Linux : installé par défaut SINON sudo apt-get install tree 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- usage : ajouter dans bookmark.doStringCode : 
--     printTree('C:\\BitNami\\wappstack-5.4.9-0\\apache2\\htdocs\\qcm') 
--     printTree('C:\\BitNami\\wappstack-5.4.9-0\\apache2\\htdocs\\qcm', '-a')  <== -a pour afficher les fichiers et rep hidden
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function printTree(argDirectory, argTreeOptions)

    _ALERT("--------------------------------------------------------------------------------")
    _ALERT( "tree \""..argDirectory .. "\"")
    _ALERT("--------------------------------------------------------------------------------")

    -- -------------------------------------------------------------------------------------------------------------------
    -- dir ?
    -- -------------------------------------------------------------------------------------------------------------------
    local attr = lfs.attributes (argDirectory)
    if attr.mode ~= "directory" then
        _ALERT("n'est pas un répertoire")
        return
    end
    
    -- -------------------------------------------------------------------------------------------------------------------
    -- argument complémentaire pour ``tree``
    -- -------------------------------------------------------------------------------------------------------------------
    local argTreeOptions = argTreeOptions or '' -- 

    -- -------------------------------------------------------------------------------------------------------------------
    -- définir emplacement du programme tree selon OS
    -- -------------------------------------------------------------------------------------------------------------------
    local treeFullPath = 'tree'
    if (props['PLAT_GTK']=='1') then
        treeFullPath = 'tree'
    elseif (props['PLAT_WIN']=='1') then
        -- treeFullPath = '"D:\\Utilisateurs\\xxxyyyyyz\\Mes Programmes\\tree.exe"'; <=== ne fonctionne pas
        treeFullPath = 'tree.exe'
    end
    
    -- -------------------------------------------------------------------------------------------------------------------
    -- définir le pattern utilisé pour retirer une partie du chemin complet
    -- Rapel : un path comme ``C:\BitNami\wappstack-5.4.9-0\apache2\htdocs\qcm`` doit avoir comme pattern ``C:%\\BitNami%\\wappstack%-5%.4%.9%-0%\\apache2%\\htdocs%\\qcm`` ( you need use % to escape it in Lua)
    -- Rappel : lua pattern magic char : ( ) . % + - * ? [ ^ $
    -- -------------------------------------------------------------------------------------------------------------------
    local pattern = argDirectory
    pattern = string.gsub(pattern, "%\\", "%%\\"); -- par sécurité
    pattern = string.gsub(pattern, "%+", "%%+");
    pattern = string.gsub(pattern, "%-", "%%-");
    pattern = string.gsub(pattern, "%.", "%%.");
    pattern = string.gsub(pattern, "%(", "%%(");
    pattern = string.gsub(pattern, "%)", "%%)");
    pattern = '('..pattern..')'

    -- -------------------------------------------------------------------------------------------------------------------
    -- lancer commande tree
    -- source http://www.computerhope.com/unix/tree.htm : 
    --   -F : Append a `/' for directories, a `=' for socket files, a `*' for executable files and a `|' for FIFO's, as per ls
    --   -f : Prints the full path prefix for each file.
    --   --noreport : Omits printing of the file and argDirectory report at the end of the tree listing.
    --   -n : Turn colorization off always, over-ridden by the -C option
    -- -------------------------------------------------------------------------------------------------------------------
    local i = 0;
    local cmd=treeFullPath..' "'..argDirectory..'" -F -f -n --noreport '..argTreeOptions
    for treeFilename in io.popen(cmd):lines() do
    
        i = i + 1
        if (i == 1) then
            -- pass, car répertoire de départ
        else
    
            -- retirer ``|       |-- `` dans nom des fichiers ou répertoires
            filename = string.gsub(treeFilename, "^[|`%s%-]*", "")
        
            -- retirer le nom du répertoire de départ pour alléger l'affichage
            shortFilename, number = string.gsub(treeFilename, pattern, '');
            
            -- SI ( windows) ALORS corriger fichier ou répertoire
            if (props['PLAT_WIN']=='1') then
                filename = string.gsub(filename, "%\\", "\\\\"); 
            end       

            -- Afficher ligne
            stringOutput = shortFilename..string.rep(' ',300)..'execlua[openFileOrDirectory("'..filename..'")]'
            _ALERT(stringOutput)
            
        end
        
    end

end

function trimEndPath(s) -- ( http://lua-users.org/wiki/StringTrim )
--~   return (s:gsub("(.-)[\\/]*$", "%1"))
  return s:gsub("(.-)[\\/]*$", "%1")
end

function openFileOrDirectory(argFileOrDirectory)

    -- -------------------------------------------------------------------------------------------------------------------
    -- argument complémentaire pour ``tree``
    -- -------------------------------------------------------------------------------------------------------------------
    local argFileOrDirectory = argFileOrDirectory or '.' -- 

    -- -------------------------------------------------------------------------------------------------------------------
    -- 
    -- -------------------------------------------------------------------------------------------------------------------
    if (props['PLAT_WIN']=='1') then
        argFileOrDirectory = string.gsub(argFileOrDirectory, "/", "\\"); -- ALORS convertir les ``/`` (retournés par ``tree``) en ``\\``
    end       

    -- -------------------------------------------------------------------------------------------------------------------
    -- Nettoyage fin de path avec ``\`` sinon pb avec lfs.attributes
    -- -------------------------------------------------------------------------------------------------------------------
    argFileOrDirectory = trimEndPath(argFileOrDirectory) -- retirer path qui se termine par ``\`` ou ``//``

    -- -------------------------------------------------------------------------------------------------------------------
    -- file or dir
    -- -------------------------------------------------------------------------------------------------------------------
    local attr = lfs.attributes(argFileOrDirectory)
    if (attr ~= nil ) then
        if attr.mode ~= "directory" then -- Fichier
            scite.Open(argFileOrDirectory);
        else -- Répertoire
            printListFileInDirCommun(argFileOrDirectory);
        end
    else
        _ALERT('pb avec '..argFileOrDirectory)
    end

end


if (withExeclua ~= 1) then -- tester présence de 020execlua.lua => execlua()
    _ALERT('[FAIL] List dir, 020execlua.lua not load' )
end

if (withDir ~= 1) then -- tester présence de 040dir.lua => printListFileInDirCommun()
    _ALERT('[FAIL] List dir, 040dir.lua not load' )
end

function printTreeFromFile()
    -- printTree(props['FileDir'], '-a')
    printTree(props['FileDir'], '')
end

idx =  32
props['command.name.'..idx..'.*'] ="Tree : liste des fichiers et répertoires depuis répertoire du fichier courant"
props['command.'..idx..'.*'] ="printTreeFromFile"
props['command.subsystem.'..idx..'.*'] ="3"
props['command.mode.'..idx..'.*'] ="savebefore:no"
props['command.shortcut.'..idx..'.*'] ="Ctrl+Shift+T"
_ALERT('[module] tree, Ctrl+Shift+T)')

withDir=1;
