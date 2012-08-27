-- -*- coding: utf-8 -

-- -------------------------------------------------------------------------------------------------------
-- Bookmark : affiche la liste des bookmarks
-- Si double click sur un bookmark ( en relation avec execlua ) :
--    - ouvre le fichier dans scite ( cf ["FilePath"] )
--    - exécute une commande lua (cf ["doStringCode"] )
-- -------------------------------------------------------------------------------------------------------


function fncBookmarkFile()

    if withSqlite3Bookmark == 1 then
    
        
        varArrayBookmark = {}
        for id, label, FilePath, FilePathLine, doStringCode, isSep in sqlite3Rows (connSqlite3, "select id, label, FilePath, FilePathLine, doStringCode, isSep from bookmark order by ordre ") do -- cf sqlite3Rows in 015sqlite3.lua
        
            -- vardump({id, label, FilePath, FilePathLine, doStringCode, isSep})
        
            -- réinitialiser TOUT row sinon c'est le bazar
            row = {}
            
            if isSep == '1' then
                row["sep"] = label
            else 
                if FilePath ~= nil then
                    row["label"] = label
                    row["FilePath"] = FilePath
                    row["Line"] = FilePathLine
                else
                    row["label"] = label
                    row["doStringCode"] = doStringCode
                end
            end
            
            table.insert(varArrayBookmark,row)
            
        end        
    else 
        -- Exemple !
        varArrayBookmark = {
            {["sep"]="www - bitnami"}
            , {["label"]="apache/access.log", ["FilePath"] = "C:\\Program Files\\BitNami WAPPStack\\apache2\\logs\\access.log", ["Line"] = "1000000000"}
            , {["sep"]="ssh"}
            , {["label"]="show kimsufi login & password", ["doStringCode"] = "print 'login=ami44,mdp=123456,IP=95.64.123.456';"}
        }
        
    end

    -- vardump(varArrayBookmark)
    
    _ALERT('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    _ALERT('Bookmark (Ctrl+B) ')
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


withSqlite3Bookmark=0
bookmarkSqlite3 = scite_GetProp('extscite.bookmark.sqlite3') -- fichier sqlite3 à utiliser
if bookmarkSqlite3 ~= nil then 

    local f=io.open(bookmarkSqlite3,"r")
    if f~=nil then 
        io.close(f) 
        withSqlite3Bookmark=1
        envSqlite3 = luasql.sqlite3() -- 
        connSqlite3 = envSqlite3:connect(bookmarkSqlite3)
    else 
        print('> erruer lecture database '..bookmarkSqlite3)
    end
else 
    bookmarkSqlite3 = ' (no bookmark database ``extscite.bookmark.sqlite3`` define)';
end



idx =  30
props['command.name.'..idx..'.*'] ="my Bookmark"
props['command.'..idx..'.*'] ="fncBookmarkFile"
props['command.subsystem.'..idx..'.*'] ="3"
props['command.mode.'..idx..'.*'] ="savebefore:no"
props['command.shortcut.'..idx..'.*'] ="Ctrl+B"

_ALERT('[module] Bookmark, Ctrl+B ' .. bookmarkSqlite3 )

