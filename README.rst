.. -*- coding: utf-8 -

extSciTE
=============================

Installation sous Linux
--------------------------------------------

@todo

Installation sous Windows
--------------------------------------------

- Installer luaforwindows : http://code.google.com/p/luaforwindows/
- Lancer la console et exécuter la commande ``lua`` : un prompt s'affiche invitant à saisir du code lua. Tester le code ``socket = require "socket";`` sans génèrer une erreur dans la console. Si erreur alors corriger les variables d'environnement :

    - Windows XP : Démarrer --> Panneau de configuration --> Système --> Avancé --> Variables d'environnement --> Variables système
    - LUA_CPATH = ``C:\Program Files\Lua\5.1\clibs\?.dll``
    - LUA_PATH = ``;C:\Program Files\Lua\5.1\lua\?.luac;C:\Program Files\Lua\5.1\lua\?.lua``

- Installer SciTE ( http://www.scintilla.org/SciTEDownload.html ) dans le répertoire ``C:\Documents and Settings\myloginname\wscite`` et ajouter le raccourci de SciTE sur le bureau + barre de lancement rapide (explorer --> SciTE.exe --> clic droit --> Envoyer vers --> Bureau (créer un raccourci)) 
- Télécharger https://github.com/ami44/extSciTE.git dans ``C:\Documents and Settings\myloginname\extSciTE``
- Exécuter SciTE 

    - Editer ``SciTEUser.properties`` (menu --> Options --> Open User Options File) pour ajouter des options spécifiques à ``extman.lua`` : 
    
        - Indiquer à ``extman.lua`` où se trouve les scripts lua à charger ::
        
            -- -*- coding: utf-8 -
            # ------------------------------------------------------------------------
            # extman.lua
            # ------------------------------------------------------------------------
            ext.lua.directory=C:\Documents and Settings\myloginname\extSciTE\extman\scite_lua
            
        - si on modifie le fichier ``SciTEStartup.lua`` alors SciTE le relancera automatique ( cf aussi SHIFT+CTRL+R) ::
        
            ext.lua.auto.reload=1
            
        - option utile pour le développement ::
        
            ext.lua.debug.traceback=1

        - (facultatif) Emplacement spécifique du script de chargement si on n'utilise pas le fichier ``SciTEStartup.lua`` par défaut  ::
        
            # ext.lua.startup.script=$(SciteUserHome)/SciTEStartup.lua
            
        ..
            - ? ::
        
                #ext.lua.reset=1
                
    - Editer le script de chargement principal ``SciTEStartup.lua`` (menu --> Options --> Open Lua Startup Scripts) et ajouter ::

        -- -*- coding: utf-8 -
        -- -------------------------------------------------------------------------------------------------------
        -- Extension
        -- charger les extensions *avant* d'exécuter extman.lua
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
        -- extman.lua
        -- ce script exécutera ensuite les scripts présents dans le répertoire extman/scite_lua
        -- -------------------------------------------------------------------------------------------------------
        dofile "C:\\Documents and Settings\\myloginname\\extSciTE\\extman\\extman.lua"

    
- Redémarrer SciTE et constater dans la console que les modules de extSciTE se chargent :

    .. image:: https://github.com/ami44/extSciTE/raw/master/assets/console.png
        :alt: chargement des modules extSciTE
        :align: center
    
- installer/démarrer nodeSciTE (cf ci-dessous) 

.. 
        - BUG Si le mesage "hello extSciTE" ne s'affiche pas dans la console, c'est qu'il a peut être un pb de droit.
            - corriger le fichier ``"C:\\Documents and Settings\\myloginname\\extSciTE\\extman\\extman.lua"`` et à la ligne 294, corriger ``tmpfile = '\\scite_temp1'`` en ``tmpfile = '"C:\\Documents and Settings\\myloginname\\scite_temp1"'``
            - sinon corriger le code extman.lua et corriger la fonction qui récupère liste des *.lua ::
            
                local files = {}
                append(files, path..'001first.lua')
                append(files, path..'020execlua.lua')
                append(files, path..'030bookmark.lua')
                append(files, path..'040dir.lua')
                append(files, path..'800nodeSciTE.lua')
                return files

            ==> NE MARCHE PAS, NECESSITE DROIT ADMINISTRATEUR ????
        
Lua Startup Scripts
--------------------------------------------

Emplacement du fichier ``SciTEStartup.lua`` : menu --> Options --> Open Lua Startup Scripts

Ce script est exécuté à chaque démarrage de SciTE. On exécute le script ``extman.lua`` (http://lua-users.org/wiki/SciteExtMan) qui étend les fonctionnalités lua de SciTE. 

Extman se charge ensuite d'exécuter les scripts présents dans le répertoire extSciTE/extman/scite_lua (cf option ``ext.lua.directory``)

Le script ``extman.lua`` ajoute aussi un raccourci clavier SHIFT+CTRL+R qui permet de recharger le script lua en cours d'édition. Cf aussi présence dans le menu --> Tools --> Reload Script.
Si on édite le fichier ``SciTEStartup.lua`` alors on relancera ``extman.lua`` et les autres scripts en cascade.

nodeSciTE
------------------------------------------------------

.. note :: nodeSciTE analyse que les scripts ``*.js`` pour le moment

Compagnon de SciTE en charge d'analyser le code en cours d'édition (jslint...)


Installation de nodeSciTE
.............................................................

- installer ``extSciTE`` au préalable
- installer nodejs & npm : http://nodejs.org/download :

    - Linux : @todo
    - Windows : 
    
        - si administrateur : télécharger node-vX.Y-x86.msi (installe node et npm en même temps)
        - si non-administrateur (si échec avec msi) , il faut installer node puis npm séparément :
        
            - installer node : 
            
                - télécharger node.exe depuis http://nodejs.org/download dans ``C:\Documents and Settings\myloginname\node``
                - mettre à jour la variable d'environnement PATH vers ``C:\Documents and Settings\myloginname\node``
                - dans la console tester ``node -v``
                
            - installer npm ( https://npmjs.org/doc/README.html) : 
            
                - télécharger fichier npm-X.Y.Z.zip à cette adresse http://npmjs.org/dist/
                - extraire le contenu dans ``C:\Documents and Settings\myloginname\node``
                - dans la console tester ``npm -v``
        
        
- ouvrir la console
- linux : ``cd "pathto/extSciTE/nodeSciTE"``
- windows : ``cd "C:\Documents and Settings\myloginname\extSciTE\nodeSciTE"``
- ``npm install``
- exécuter nodeSciTE (lire ci-après)

Exécution de nodeSciTE (manuel ou automatique)
.....................................................................

Manuel : 

    - linux : 
    
        - ouvrir la console bash
        - ``cd "pathto/extSciTE/nodeSciTE"``
        - ``node nodeSciTE.js``

    - windows : 
    
        - ouvrir la console ``cmd``
        - ``cd "C:\Documents and Settings\myloginname\extSciTE\nodeSciTE"``
        - ``nodeSciTE.bat`` ou ``node nodeSciTE.js``
        

Automatique, Lancer le serveur nodeSciTE au démarrage de votre session : 
    
    - windows : @todo
    - linux : @todo
    
    .. 
        windows ? ajouter un fichier dans ``C:\Documents and Settings\myloginname\Menu Démarrer\Programmes\Démarrage\`` 
    
Corriger le port de nodeSciTE
.............................................................

Le serveur nodeSciTE écoute par défaut le port 3891 en local.

Si on corrige en dur le port dans le fichier ``extSciTE/nodeSciTE/nodeSciTE.js`` ou que ce service est sur un autre serveur, alors éditer le fichier ``SciTEUser.properties`` (menu --> Options --> Open User Options File) et ajouter ces options : :: 
    
    # ------------------------------------------------------------------------
    # nodeSciTE
    # ------------------------------------------------------------------------
    extscite.node.host=http://127.0.0.1
    extscite.node.port=9999


Modules extSciTE
=============================


extSciTE/extman/scite_lua/001first.lua
--------------------------------------------

Indique que extSciTE est bien chargé

extSciTE/extman/scite_lua/020execlua.lua
--------------------------------------------

Permet d'éxécuter code lua présent dans la console. 
Utilisé par 030bookmark.lua et 040dir.lua. 

extSciTE/extman/scite_lua/030bookmark.lua
--------------------------------------------

.. note:: version alpha. Editer le fichier ``extSciTE/extman/scite_lua/030bookmark.lua`` pour ajouter/éditer/supprimer les bookmarks.

CTRL+B : affiche les bookmarks dans la console SciTE :

    - fichiers préférés ( on peut même définir la ligne à afficher : utile pour descendre à la dernière ligne du fichier apache2/access.log par exemple : initialiser alors à 10000000000 )
    - code lua à exécuter ( afficher un message, fonction à lancer ... )
    
Pour aérer les bookmark, il y a aussi possibilité d'affichers des séparateurs

extSciTE/extman/scite_lua/040dir.lua
--------------------------------------------

CTRL+SHIFT+O : affiche dans la console SciTE le contenu du répertoire du fichier courant.

extSciTE/extman/scite_lua/800node.lua
--------------------------------------------

se charge d'envoyer le contenu du buffer à analyser au serveur nodeSciTE ( jslint, etc ... ). 
Afficher le résultat sous forme d'annotation.

Voir la section ci-dessus nodeSciTE pour installer et démarrer ce serveur.

        
    

Enjoy !    