-- -*- coding: utf-8 -

-- -------------------------------------------------------------------------------------------------------
-- node : envoyer le contenu du buffer à node por analyse
-- note : ne pas utiliser protocole udp  car limité à 64ko
-- -------------------------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------------------------
-- conf serveur nodejs
-- note : ajouter dans SciTEUser.properties : 
--    extscite.nodeSciTE.host=127.0.0.1
--    extscite.nodeSciTE.port=3891
-- -------------------------------------------------------------------------------------------------------
nodeHost = scite_GetProp('extscite.nodeSciTE.host') -- host du serveur nodejs. Ne pas écrire "local nodeHost = ", nodeHost doit être global
if nodeHost == nil then nodeHost = 'http://127.0.0.1'; end
nodePort = scite_GetProp('extscite.nodeSciTE.port') -- port du serveur nodejs. Ne pas écrire "local nodePort = ", nodePort doit être global
if nodePort == nil then nodePort = '3891'; end
nodeURL = nodeHost..':'..nodePort;

-- -------------------------------------------------------------------------------------------------------
-- Définir socket variable
-- -------------------------------------------------------------------------------------------------------
--~ print(socket._VERSION);print(http.PORT);
http.USERAGENT = "extSciTE"

-- -------------------------------------------------------------------------------------------------------
-- formencode
-- -------------------------------------------------------------------------------------------------------
-- source : 
--      http://prosody.im/, This project is MIT/X11 licensed.
--      http://hg.prosody.im/trunk/file/0ed617f58404/net/http.lua#l31
-- usage :
--      local form_data = formencode({ field1 = value1, field2 = value2 }) -- The standards say you /should/ return the fields in the order they were in in the original form. 
--      local form_data = formencode({ { "field1", "value1" }, { "field2", "value2" } }) -- If you want to preserve order you can use this syntax
-- -------------------------------------------------------------------------------------------------------
local t_insert, t_concat = table.insert, table.concat;
local function _formencodepart(argString)
	return argString and (argString:gsub("%W", function (c)
		if c ~= " " then
			return string.format("%%%02x", c:byte());
		else
			return "+";
		end
	end));
end
function formencode(form)
	local result = {};
	if form[1] then -- Array of ordered { name, value }
		for _, field in ipairs(form) do
			t_insert(result, _formencodepart(field.name).."=".._formencodepart(field.value));
		end
	else -- Unordered map of name -> value
		for name, value in pairs(form) do
			t_insert(result, _formencodepart(name).."=".._formencodepart(value));
		end
	end
	return t_concat(result, "&");
end

-- -------------------------------------------------------------------------------------------------------
-- luasocket/GET
-- exmple : response, code, header = get('http://127.0.0.1')
-- -------------------------------------------------------------------------------------------------------
local function get(argUrl)

    response_body = {}
    r, code, header = socket.http.request{ 
        method = "GET",
        url = argUrl,
        sink = ltn12.sink.table(response_body)
    }
    response = table.concat(response_body, "")
    
    -- print(r); print(code); 
    -- for k,v in pairs(header) do print(k,v) end
    -- print(response)    

    return response, code, header;
end

-- -------------------------------------------------------------------------------------------------------
-- luasocket/POST
-- -------------------------------------------------------------------------------------------------------
-- exemple : response, code, header = post('http://127.0.0.1', {a='10', c='dd'})
-- -------------------------------------------------------------------------------------------------------
-- http://comments.gmane.org/gmane.comp.lang.lua.general/84632
-- http://lua-users.org/lists/lua-l/2006-02/msg00014.html
-- -------------------------------------------------------------------------------------------------------
local function post(argUrl, argFormElement)

    response_body = {}
    request_body = formencode(argFormElement)
    r, code, header = socket.http.request{
        method = "POST",
        url = argUrl,
        headers = {
             ["Content-Length"] = string.len(request_body),
             ["Content-Type"] =  "application/x-www-form-urlencoded" -- obligatoire si POST
         },
         source = ltn12.source.string(request_body),
         sink = ltn12.sink.table(response_body) 
    }
    response = table.concat(response_body, "")    
    
    -- print(r); print(code); 
    -- for k,v in pairs(header) do print(k,v) end
    -- print(response)

    return response, code, header;
end



-- ---------------------------------------------------------------------------------------- 
-- send to node
-- TODO : plante avec \node_modules\jslint\lib\jslint.js revoir !!!
-- ----------------------------------------------------------------------------------------   
function SendToNodejs()      

    -- ------------------------------------------------------------------------------------------------------------------------------------
    -- Envoyer tout le texte pour analyse selon extension    
    -- ------------------------------------------------------------------------------------------------------------------------------------
    local FileExt = props['FileExt']; 
    if ( FileExt == 'js') then 
        response, code, header = post(nodeURL, {
            SciteDefaultHome = props['SciteDefaultHome'],
            SciteUserHome = props['SciteUserHome'],
            FilePath = props['FilePath'],
            actions = 'jslint,jshint',
            code = editor:GetText()
        })
        if (code ~= 200) then
            print('pb avec le serveur nodeSciTE !')
            print("response = "..response)
            print("code = "..code)
            -- for k,v in pairs(header) do print(k,v) end <== plante car pas de header
        end
    end 
end

-- ---------------------------------------------------------------------------------------- 
-- get from node
-- ----------------------------------------------------------------------------------------   
function GetFromNodejs()      
    
--~     print('GetFromNodejs');
    
    response, code, header = post(nodeURL, {
        SciteDefaultHome = props['SciteDefaultHome'],
        SciteUserHome = props['SciteUserHome'],
        FilePath = props['FilePath'],
    })

    if code == 200 and response ~= '' then
--~         print('--[ dostring --------------------------------------');
--~         print(response);            
--~         print('--] --------------------------------------');
        dostring(response); -- nodeSciTE renvoie directement une réponse lua prête à être consommé
    end
end

-- ---------------------------------------------------------------------------------------- 
-- tester si nodejs est démarré
-- ---------------------------------------------------------------------------------------- 
withNodeSciTE = 0;
response, code, header = get(nodeURL);
if (code == 200) then
	withNodeSciTE = 1;
    _ALERT('[module] nodeSciTE (listening '..nodeURL..')')
else

--~     print(response); print(code); 
    
	withNodeSciTE = 0;
    _ALERT('[module] nodeSciTE')
    _ALERT('> le serveur nodeSciTE n\'est pas démarré')
    _ALERT('> ou n\'écoute pas à cette adresse '..nodeURL..'')
    _ALERT('> cd extSciTE/nodeSciTE')
    _ALERT('> node nodeSciTE.js')
    _ALERT('> lire README.rst !')
    _ALERT('[/module]')
end

-- ---------------------------------------------------------------------------------------- 
-- scite_OnOpen
-- ---------------------------------------------------------------------------------------- 
scite_OnOpen(function()
	if ( withNodeSciTE == 1 ) then SendToNodejs(); end;
end)

-- ---------------------------------------------------------------------------------------- 
-- scite_OnChar 
-- ---------------------------------------------------------------------------------------- 
-- Avantage : OnChar() c'est qu'il ne se déclenche que quand on ajoute/supprimer un caractère 
-- et ne déclenche pas lors du déplacement du curseur ( sinon utiliser OnKey ou OnUpdateUI ... )
-- Inconvénient : editor:GetText() ne tient pas compte du buffer mis à jour
-- Inconvénient : se déclenche apres scite_OnKey()
-- ---------------------------------------------------------------------------------------- 
--~ scite_OnChar(function(charAdded)
--~ 	if ( withNodeSciTE == 1 ) then 
--~         print('scite_OnChar');
--~         print(editor:GetText());
--~         SendToNodejs(); 
--~     end;
--~ end)

-- ---------------------------------------------------------------------------------------- 
-- scite_OnKey 
-- ---------------------------------------------------------------------------------------- 
--~ scite_OnKey(function(argKey)
--~     if ( withNodeSciTE == 1 ) then 
--~         if ( -- car scite_OnChar ne réagit pour ces caractères
--~             argKey == 8 -- touche ``backspace``
--~             or argKey == 46 -- touche ``supprimer``
--~         ) then 
--~             SendToNodejs()
--~         end
        -- lire si résultat quoi qu'il arrive
--~         GetFromNodejs(); 
--~     end
--~ end)


-- ---------------------------------------------------------------------------------------- 
-- scite_OnUpdateUI
-- en l'absence d'interval, je vais utiliser cette méthode pour aller chercher les infos nécessaire
-- ABANDON, TROP HARD A GERER
-- ---------------------------------------------------------------------------------------- 
--~ scite_OnUpdateUI(function() -- function system
--~     if ( withNodeSciTE == 1 ) then 
--~             GetFromNodejs(); 
--~     end;
--~ end)

-- ---------------------------------------------------------------------------------------- 
-- scite_OnUpdateUI
-- Si on ne met pas de protection içi, on rentre très vite dans une boucle infini avec OnUpdateUI 
-- en l'absence d'interval intégré dans SciTE je vais ruser en codant un faux interval à l'aide de os.clock() tant qu'il y a de l'activité ;-) 
-- envoyer le code entier toutes les secondes pour analyse 
-- ---------------------------------------------------------------------------------------- 
previousosclock = math.ceil (os.clock()) -- Return CPU time since Lua started in seconds. Exemple ``1.23`` = ``1 second + 230 millisecons``
scite_OnUpdateUI(function() -- function system
    
    if ( withNodeSciTE == 1 ) then 
    
        -- toutes les secondes environ tant qu'il y a de l'activité
        if ( math.ceil (os.clock()) ~= previousosclock ) then
            previousosclock = math.ceil (os.clock());
            -- envoyer le buffer à analyser
            SendToNodejs(); 
            -- lire si résultat quoi qu'il arrive
            GetFromNodejs(); 
        end
        
    end
end)


