-- -*- coding: utf-8 -

-- -------------------------------------------------------------------------------------------------------
-- menu contextuel
-- le script 015utils.lua a initilisé ``menucontextuel = {}``
-- Les scripts lua traversés peuvent ajouter des entrées dans ``menucontextuel``
-- le script 999menucontextuel.lua (chargé en dernier) est en charge d'ajouter le menu contectuel à SciTE 
-- -------------------------------------------------------------------------------------------------------
-- exemple : props['user.context.menu']="||Next File|IDM_NEXTFILE|Prev File|IDM_PREVFILE|"
-- rappel :: ``||`` = séparateur
-- -------------------------------------------------------------------------------------------------------
-- revoir http://code.google.com/p/scitelatexide/source/browse/trunk/Sc1IDE/SciTEGlobal.properties qui a mis en place un menu contectuel dynamique : menucmds.lua
--      [Context Menu]:: define context menus (updated by menucmds.lua automatically)
--        user.context.menu.*=$(user.context.menu)
--        user.tabcontext.menu.*=$(user.tabcontext.menu)
--        user.outputcontext.menu.*=$(user.outputcontext.menu)
-- revoir http://goran.aleksic.org/projects/files/wsciteconffiles/SciTEUser.properties ou j'ai compris que le n° etait 11xx (d'ou la limitation à 100 commandes)
-- -----------------------------------------------------------------------------------------------------------------------
if (withUtils_menucontextuel==1) then  -- cf 015utils.lua
    props['user.context.menu']=table.concat(menucontextuel, "|")
    _ALERT('[module] ContextMenu' )
else
    _ALERT('[FAIL] ContextMenu, 015utils.lua not load' )
end
