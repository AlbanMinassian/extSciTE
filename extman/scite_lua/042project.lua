-- -*- coding: utf-8 -

-- -------------------------------------------------------------------------------------------------------
-- project
-- affiche la liste des fichiers du projets dans la console
-- -------------------------------------------------------------------------------------------------------

--~ function projectList()
--~     projectPath = scite_GetProp('extscite.project.path')
--~     if projectPath == nil then projectPath = ''; end

--~     _ALERT('projectList');
--~ end

--~ if (withExeclua == 1) then -- tester présence de 020execlua.lua

--~     idx =  32
--~     props['command.name.'..idx..'.*'] ="Project : liste les fichiers du projet"
--~     props['command.'..idx..'.*'] ="projectList"
--~     props['command.subsystem.'..idx..'.*'] ="3"
--~     props['command.mode.'..idx..'.*'] ="savebefore:no"
--~     props['command.shortcut.'..idx..'.*'] ="Alt+P"
--~     _ALERT('[module] project show, Alt+P')

--~         
--~ else 
--~     _ALERT('[FAIL] project show, 020execlua.lua not load' )
--~ end
