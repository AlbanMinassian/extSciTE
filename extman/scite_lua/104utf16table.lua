-- -*- coding: utf-8 -

-- -------------------------------------------------------------------------------------------------------
-- http://lua-users.org/wiki/SciteUsingUnicode
-- <khman@users.sf.net> 20061017 public domain
-- -------------------------------------------------------------------------------------------------------
-- return value of UTF-8 character <khman@users.sf.net> 20061017 public domain
-- (see Markus Kuhn's UTF-8 and Unicode FAQ or RFC3629 for more info)
function FromUTF8(pos)
  local mod = math.mod
  local function charat(p)
    local v = editor.CharAt[p]; if v < 0 then v = v + 256 end; return v
  end
  local v, c, n = 0, charat(pos), 1
  if c < 128 then v = c
  elseif c < 192 then
    error("Byte values between 0x80 to 0xBF cannot start a multibyte sequence")
  elseif c < 224 then v = mod(c, 32); n = 2
  elseif c < 240 then v = mod(c, 16); n = 3
  elseif c < 248 then v = mod(c,  8); n = 4
  elseif c < 252 then v = mod(c,  4); n = 5
  elseif c < 254 then v = mod(c,  2); n = 6
  else
    error("Byte values between 0xFE and OxFF cannot start a multibyte sequence")
  end
  for i = 2, n do
    pos = pos + 1; c = charat(pos)
    if c < 128 or c > 191 then
      error("Following bytes must have values between 0x80 and 0xBF")
    end
    v = v * 64 + mod(c, 64)
  end
  return v, pos, n
end

-- return UTF-8 sequence string <khman@users.sf.net> 20061017 public domain
-- (see Markus Kuhn's UTF-8 and Unicode FAQ or RFC3629 for more info)
function ToUTF8(v)
  local math = math
  local n, s, b = 1, "", 0
  -- delete this if your version of SciTE goes beyond UCS-2
  if v > 65535 then error("SciTE does not support codes above U+FFFF") end
  if v >= 55296 and v <= 57343 then
    error("failed to convert UTF-16 surrogate pairs to UTF-8")
  end
  if    v >= 67108864 then n = 6; b = 252
  elseif v >= 2097152 then n = 5; b = 248
  elseif v >=   65536 then n = 4; b = 240
  elseif v >=    2048 then n = 3; b = 224
  elseif v >=     128 then n = 2; b = 192
  end
  for i = 2, n do
    local c = math.mod(v, 64); v = math.floor(v / 64)
    s = string.char(c + 128)..s
  end
  s = string.char(v + b)..s
  return s, n
end

-- demonstrate use of FromUTF8() function: display the character code
-- value of the current character under the cursor in the output window
function Demo_FromUTF8()
  print("Character code: "..(FromUTF8(editor.CurrentPos)))
end

-- demonstrate use of ToUTF8() function: display two characters based
-- on the given unicode value
function Demo_ToUTF8()
  editor:AppendText(ToUTF8(tonumber("0x4E2D", 16)))
  editor:AppendText(ToUTF8(tonumber("0x6587", 16)))
end

function UTF16Table()
  scite.Open("")
  editor.CodePage = SC_CP_UTF8
  editor:AppendText("-*- coding: utf-8 -*-\n")
  editor:AppendText("   Dec ( Hex ) : 0123456789ABCDEF0123456789ABCDEF\n")
  editor:AppendText("-------------------------------------------------\n")
  for p = 0, 65535, 32 do
    ln = string.format("%6d (0x%4X): ", p, p)
    for q = p, p+31 do
      if q < 32 or (q >= 55296 and q <= 57343) then ln = ln.."?"
      else ln = ln..ToUTF8(q)
      end
    end
    ln = ln.."\n"
    editor:AppendText(ln)
  end
end

idx =  34
props['command.name.'..idx..'.*'] ="UTF16 table"
props['command.'..idx..'.*'] ="UTF16Table"
props['command.subsystem.'..idx..'.*'] ="3"
props['command.mode.'..idx..'.*'] ="savebefore:no"

_ALERT(outputModuleMessage('[module] UTF16 table, menu > '..props['command.name.'..idx..'.*'] , "104utf16table.lua"))
