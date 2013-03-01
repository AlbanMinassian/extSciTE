-- -*- coding: utf-8 -

-- -------------------------------------------------------------------------------------------------------
-- http://lua-users.org/wiki/SciteAsciiTable
-- ASCII Table for SciTE
-- khman 20050812; public domain
-- Ben Fisher, 2006, Public domain
-- adapté pour s'afficher dans la console et accélérer copier/coller 
-- -------------------------------------------------------------------------------------------------------

function ASCIITable()

     
    local hl = "    +----------------+\n"
    output:AddText("ASCII Table:\n"..hl.."Hex |0123456789ABCDEF|\n"..hl)
    for x = 32, 240, 16 do
        output:AddText(string.format(" %02X |", x))
        for y = x, x+15 do output:AddText(string.char(y)) end
        output:AddText("|\n")
    end
    output:AddText(hl)
  
    -- Afficher les caractères spéciaux
    local padnum = function (nIn)
        if nIn < 10 then return "00"..nIn
        elseif nIn < 100 then return "0"..nIn
        else return nIn
        end
    end
    local overrides = { [0]="(Null)", [9]="(Tab)",[10]="(\\n Newline)", [13]="(\\r Return)", [32]="(Space)"}
    local c
    for n=0,31 do
        if overrides[n] then c = overrides[n] else c = string.char(n) end
        print (padnum(n).."  "..c)
    end
    
    -- forcer la console à s'afficher nn mode 0 et pas utf8
    -- Default (single byte character set)  0
    -- UTF-8	65001
    -- Japanese Shift-JIS	932
    -- Simplified Chinese GBK	936
    -- Korean Wansung	949
    -- Traditional Chinese Big5	950
    -- Korean Johab	1361
    props['output.code.page']=0


end

idx =  33
props['command.name.'..idx..'.*'] ="ASCII table"
props['command.'..idx..'.*'] ="ASCIITable"
props['command.subsystem.'..idx..'.*'] ="3"
props['command.mode.'..idx..'.*'] ="savebefore:no"
_ALERT('[module] ASCII table')
