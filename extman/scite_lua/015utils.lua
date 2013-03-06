-- -*- coding: utf-8 -

-- -------------------------------------------------------------------------------------------------------
-- menu contextuel
-- le script 999menucontextuel.lua (chargé en dernier) sera en charge d'ajouter le menu contextuel à SciTE selon les scripts lua traversés
-- -------------------------------------------------------------------------------------------------------
withUtils_menucontextuel=1;
menucontextuel = {}

-- -------------------------------------------------------------------------------------------------------
-- sqlite
-- -------------------------------------------------------------------------------------------------------
withUtils_luasqlrows=1;
function luasqlrows (connection, sql_statement)
  local cursor = assert (connection:execute (sql_statement))
  return function ()
    return cursor:fetch()
  end
end

-- -------------------------------------------------------------------------------------------------------
-- escapeExecluaPath
-- SI ( windows ET directory ou file ) ALORS ( \ en \\ ) CAR le path sera inséré dans une chaine string pour être exécuté par execlua
-- -------------------------------------------------------------------------------------------------------
function escapeExecluaPath(argPath)
    local path = argPath;
    if (props['PLAT_WIN']=='1') then
        path = string.gsub(path, "\\", "\\\\")
    end       
    return path
end

-- -------------------------------------------------------------------------------------------------------
-- execluaOpenFileOrDirectory
-- -------------------------------------------------------------------------------------------------------
function execluaOpenFileOrDirectory(argPath)
    return 'execlua[openFileOrDirectory("'..escapeExecluaPath(argPath)..'")]'
end

-- -------------------------------------------------------------------------------------------------------
-- outputModuleMessage
-- retourne chaine avec chaine ET execlua pour ouvrir et éditer le code du module
-- -------------------------------------------------------------------------------------------------------
function outputModuleMessage(argString, argPath)
    return argString..string.rep(' ',500)..' '..execluaOpenFileOrDirectory(props['FilePath'])
end

-- -------------------------------------------------------------------------------------------------------
-- vardump
-- -------------------------------------------------------------------------------------------------------
-- source : 
--          http://www.lua.org/gems/vardump.lua
-- auteur : 
--          http://www.lua.org/gems/
--          Lua Programming Gems 
--              edited by L. H. de Figueiredo, W. Celes, R. Ierusalimschy 
--              Lua.org, December 2008 
--              ISBN 978-85-903798-4-3 (also available as an e-book) 
-- usage : 
--      foo="Hello world"
--      vardump(foo)
--      foo = {"zero",1,2,3,{["sep"]= "aaa" },"last value"}
--      vardump(foo)
-- -------------------------------------------------------------------------------------------------------
withUtils_vardump=1;
function vardump(value, depth, key)
  local linePrefix = ""
  local spaces = ""
  
  if key ~= nil then
    linePrefix = "["..key.."] = "
  end
  
  if depth == nil then
    depth = 0
  else
    depth = depth + 1
    for i=1, depth do spaces = spaces .. "  " end
  end
  
  if type(value) == 'table' then
    mTable = getmetatable(value)
    if mTable == nil then
      print(spaces ..linePrefix.."(table) ")
    else
      print(spaces .."(metatable) ")
        value = mTable
    end  	
    for tableKey, tableValue in pairs(value) do
      vardump(tableValue, depth, tableKey)
    end
  elseif type(value)	== 'function' or 
      type(value)	== 'thread' or 
      type(value)	== 'userdata' or
      value		== nil
  then
    print(spaces..tostring(value))
  else
    print(spaces..linePrefix.."("..type(value)..") "..tostring(value))
  end
end

_ALERT(outputModuleMessage('[module] utils (vardump, luasqlrows ... )', props['FilePath']))
