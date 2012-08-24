-- -*- coding: utf-8 -

function sqlite3Rows (connection, sql_statement)
  local cursor = assert (connection:execute (sql_statement))
  return function ()
    return cursor:fetch()
  end
end

_ALERT('-- sqlite');