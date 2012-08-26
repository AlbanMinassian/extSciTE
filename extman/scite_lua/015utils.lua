-- -*- coding: utf-8 -

-- -------------------------------------------------------------------------------------------------------
-- sqlite
-- -------------------------------------------------------------------------------------------------------
withUtils_sqlite3Rows=1;
function sqlite3Rows (connection, sql_statement)
  local cursor = assert (connection:execute (sql_statement))
  return function ()
    return cursor:fetch()
  end
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

_ALERT('-- utils (vardump, sqlite3Rows ... )');
