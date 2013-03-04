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
        for id, label, FilePath, FilePathLine, doStringCode, isSep in luasqlrows (connSqlite3, "select id, label, FilePath, FilePathLine, doStringCode, isSep from bookmark order by ordre ") do -- cf luasqlrows in 015utils.lua
        
            -- vardump({id, label, FilePath, FilePathLine, doStringCode, isSep})
        
            row = {}
            if isSep == '1' then
                row["sep"] = label
            else 
                if doStringCode ~= nil and string.len(doStringCode) > 0  then
                    row["label"] = label
                    row["doStringCode"] = doStringCode
                else
                    row["label"] = label
                    row["FilePath"] = FilePath
                    row["Line"] = FilePathLine
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

    vardump(varArrayBookmark)
    
    
    -- -------------------------------------------------------------------------------------------------------
    -- nouveau : definir raccourci pour éditer sqlite via interface web (adminer par exemple : http://www.adminer.org/ )
    -- nécessite variable extscite.bookmark.navigateur & extscite.bookmark.http
    -- -------------------------------------------------------------------------------------------------------
    local execuaBookmark='print("--> @TODO : open sqlite editor (sqliteditor, adminer ....);-)")';
    local bookmarkHttp = scite_GetProp('extscite.bookmark.http') -- emplacement de l'interface web pour editer données sqlite (adminer par exemple)
    local bookmarkNavigateur = scite_GetProp('extscite.bookmark.navigateur') -- navigateur à utiliser (ie, chrome, chromium, firefox ... )
    if (bookmarkNavigateur == nil) then bookmarkNavigateur = "firefox"; end
    if (bookmarkHttp ~= nil) then
        if (props['PLAT_WIN']=='1') then bookmarkHttp = string.gsub(bookmarkHttp, "&", "^&") end -- si DOS : echapper & avec ^ ( http://stackoverflow.com/questions/1327431/how-do-i-escape-ampersands-in-batch-files )
        execuaBookmark='os.execute(\''..bookmarkNavigateur..' '..bookmarkHttp..'\')'
    end
    
    -- -------------------------------------------------------------------------------------------------------
    -- Afficher les bookmarks
    -- -------------------------------------------------------------------------------------------------------
    _ALERT("--------------------------------------------------------------------------------")
    _ALERT('Bookmark (Ctrl+B) [edit]'..string.rep(' ',500)..'execlua['..execuaBookmark..']')
    _ALERT("--------------------------------------------------------------------------------")
    local tabLine = ''
    for j,varTable in ipairs(varArrayBookmark) do -- (ipairs)=(i)ndice (pairs)
    
        -- Séparateur ? 
        if ( varTable["sep"] ~= nil ) then
            -- stringOutput = '--[ '
            -- stringOutput = stringOutput..varTable["sep"]
            -- stringOutput = stringOutput..' ]--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

            stringOutput = varTable["sep"]
            tabLine = '    ';
        else
        
            -- doStringCode ? 
            -- ajouter execlua ( cf fichier 020execlua.lua)
            if ( varTable["doStringCode"] ~= nil ) then
                -- stringOutput = 'run : ' .. varTable["label"]..string.rep(' ',100)..' '..'execlua['..varTable["doStringCode"]..']'
                stringOutput = tabLine..'|= /' .. '' .. varTable["label"]..' '..string.rep(' ',500)..' '..'execlua['..varTable["doStringCode"]..']'
            else

                -- FilePath ?
                -- Ancien code : trop dépendant du lexer de editor (affichage en rouge ...) 
                --  Nouveau : 
                --    * FilePath peut contenir un fichier ou un répetoire en utilisant openFileOrDirectory
                --    * style dir ou tree plus sympa
                --    * plus de pb couleur
                if ( varTable["FilePath"] ~= nil ) then
                
                    -- SI ( windows ET directory ) ALORS ( \ en \\ ) CAR le path sera inséré dans une chaine string pour être exécuté par execlua
                    f = varTable["FilePath"]
                    if (props['PLAT_WIN']=='1') then
                        f = string.gsub(f, "\\", "\\\\")
                    end     
                
                    varLine = 1
                    if ( varTable["Line"] ~= nil ) then
                        varLine = varTable["Line"]
                    end
                    
                    -- stringOutput = varTable["label"]..string.rep(' ',100)..' File "'..varTable["FilePath"]..'", line '..varLine..': ' <=== ancienne technique
                    stringOutput = tabLine..'|-- /' .. varTable["label"]..' '..string.rep(' ',500)..' '..'execlua[openFileOrDirectory("'..f..'", '..varLine..')]'
                    
                end
                
            end
            
        end
        
        -- afficher le bookmark
        _ALERT(stringOutput)
        
    end

end

if (withExeclua == 1) then -- tester présence de 020execlua.lua

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
    
else 
    _ALERT('[FAIL] Bookmark, 020execlua.lua not load' )
end
