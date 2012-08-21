.. -*- coding: utf-8 -

extSciTE
=============================

Installation sous Windows
--------------------------------------------

- Installer luaforwindows : http://code.google.com/p/luaforwindows/
- Corriger les variables d'environnement (sinon le code lua ne trouvera pas les dll) :

    - Windows XP : Démarrer --> Panneau de configuration --> Système --> Avancé --> Variables d'environnement --> Variables système : 
    
        - LUA_CPATH = ``C:\Program Files\Lua\5.1\clibs\?.dll``
        - LUA_PATH = ``;C:\Program Files\Lua\5.1\lua\?.luac;C:\Program Files\Lua\5.1\lua\?.lua``
    
- Lancer la console et exécuter la commande ``lua`` : un prompt s'affiche invitant à saisir du code lua. Tester le code ``socket = require "socket";`` sans génèrer une erreur dans la console.
- Installer SciTE ( http://www.scintilla.org/SciTEDownload.html ) dans le répertoire ``C:\Documents and Settings\myloginname\wscite``
- Ajouter le raccourci de SciTE sur le bureau + barre de lancement rapide (explorer --> SciTE.exe --> clic droit --> Envoyer vers --> Bureau (créer un raccourci))
- Télécharger https://github.com/ami44/extSciTE.git dans ``C:\Documents and Settings\myloginname\extSciTE``
- Exécuter SciTE 

    - Editer ``SciTEUser.properties`` pour ajouter des options spécifiques à ``extman`` (menu --> Options --> Open User Options File) : 
    
        - Indiquer à ``extman`` où se trouve les scripts lua à charger ::
        
            # ------------------------------------------------------------------------
            # extman
            # ------------------------------------------------------------------------
            ext.lua.directory=C:\Documents and Settings\myloginname\extSciTE\extman\scite_lua
            
        - Emplacement spécifique du script de chargement si on n'utilise pas le fichier ``SciTEStartup.lua`` par défaut  ::
        
            # ext.lua.startup.script=$(SciteUserHome)/SciTEStartup.lua
            
        - si on modifie le fichier ``SciTEStartup.lua`` alors SciTE le relancera automatique ( cf aussi SHIFT+CTRL+R) ::
        
            ext.lua.auto.reload=1
            
        - option utile pour le dévelopment ::
        
            ext.lua.debug.traceback=1
            
        - ? ::
        
            #ext.lua.reset=1
            
    - Configurer le script de chargement principal ``SciTEStartup.lua`` (menu --> Options --> Open Lua Startup Scripts) et ajouter ::

        -- -*- coding: utf-8 -

        -- -------------------------------------------------------------------------------------------------------
        -- Extension
        -- charger les extensions *avant* d'exécuter extman
        -- -------------------------------------------------------------------------------------------------------
        io = require "io";
        socket = require "socket";
        mime = require "mime";
        ltn12 = require "ltn12";
        http = require "socket.http";
        url = require "socket.url";
        ftp = require "socket.ftp";
        tp = require "socket.tp";
        lfs = require "lfs";

        -- -------------------------------------------------------------------------------------------------------
        -- Extman
        -- ce script exécutera ensuite les scripts présents dans le répertoire extman/scite_lua
        -- -------------------------------------------------------------------------------------------------------
        dofile "C:\\Documents and Settings\\myloginname\\extSciTE\\extman\\extman.lua"



Lua Startup Scripts
--------------------------------------------

Ce script est exécuté à chaque démarrage de SciTE. On exécute alors le script ``extman`` (http://lua-users.org/wiki/SciteExtMan) qui étend les fonctionnalités lua de SciTE. 

Extman se charge ensuite d'exécuter les scripts présents dans le répertoire extman/scite_lua (cf option ``ext.lua.directory``)

``extman`` ajoute aussi un raccourci clavier SHIFT+CTRL+R qui permet de recharger le script lua en cours d'édition. Cf aussi présence dans le menu --> Tools --> Reload Script.
Si on édite le fichier ``SciTEStartup.lua`` alors on relancera ``extman.lua`` et les autres scripts en cascade.


scite_lua/001first.lua
--------------------------------------------

Indique que extSciTE est bien chargé

scite_lua/020execlua.lua
--------------------------------------------

Permet d'éxécuter code lua présent dans la console. 
Utilisé par 030bookmark.lua et 040dir.lua. 

scite_lua/030bookmark.lua
--------------------------------------------

CTRL+B : affiche les bookmarks de deux natures :

    - fichiers préférés ( on peut même définir la ligne à afficher : utile pour descendre à la dernière ligne du fichier apache2/access.log par exemple : initialiser alors à 10000000000 )
    - code lua à exécuter ( afficher un message, fonction à lancer ... )
    
Pour aérer les bookmark, il y a aussi possibilité d'affichers des séparateurs

scite_lua/040dir.lua
--------------------------------------------

CTRL+SHIFT+O : liste les autres fichiers dans le répertoire du fichier édité

scite_lua/800node.lua
--------------------------------------------

se charge d'envoyer le contenu du buffer à analyser au serveur node ( jslint, etc ... ). Afficher le résultat sous forme d'annotation.


    

    