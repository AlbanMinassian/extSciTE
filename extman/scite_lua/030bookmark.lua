-- -*- coding: utf-8 -

-- -------------------------------------------------------------------------------------------------------
-- Bookmark : affiche la liste des bookmarks
-- Si double click sur un bookmark ( en relation avec execlua ) :
--    - ouvre le fichier dans scite ( cf ["FilePath"] )
--    - exécute une commande lua (cf ["doStringCode"] )
-- -------------------------------------------------------------------------------------------------------
function fncBookmarkFile()

    varArrayBookmark = {
        {["sep"]="www - bitnami"}
        , {["label"]="apache/access.log", ["FilePath"] = "C:\\Program Files\\BitNami WAPPStack\\apache2\\logs\\access.log", ["Line"] = "1000000000"}
        , {["sep"]="ssh"}
        , {["label"]="show kimsufi login & password", ["doStringCode"] = "print 'login=ami44,mdp=123456,IP=95.64.123.456';"}
    }

    _ALERT('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    _ALERT('Bookmark (Ctrl+B)')
    _ALERT('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    for j,varTable in ipairs(varArrayBookmark) do -- (ipairs)=(i)ndice (pairs)
    
        if ( varTable["sep"] ~= nil ) then
            stringOutput = '--[ '
            stringOutput = stringOutput..varTable["sep"]
            stringOutput = stringOutput..' ]--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
        else
            if ( varTable["FilePath"] ~= nil ) then
                varLine = 1
                if ( varTable["Line"] ~= nil ) then
                    varLine = varTable["Line"]
                end
                stringOutput = varTable["label"]..string.rep(' ',100)..' File "'..varTable["FilePath"]..'", line '..varLine..': '
            end
            
            -- ajouter execlua ( cf fichier 020execlua.lua)
            if ( varTable["doStringCode"] ~= nil ) then
                stringOutput = 'run : ' .. varTable["label"]..string.rep(' ',100)..' '..'execlua['..varTable["doStringCode"]..']'
            end
        end
        
        -- afficher le bookmark
        _ALERT(stringOutput)
        
    end

end

idx =  30
props['command.name.'..idx..'.*'] ="my Bookmark"
props['command.'..idx..'.*'] ="fncBookmarkFile"
props['command.subsystem.'..idx..'.*'] ="3"
props['command.mode.'..idx..'.*'] ="savebefore:no"
props['command.shortcut.'..idx..'.*'] ="Ctrl+B"

_ALERT('[module] Bookmark, Ctrl+B')

