.. -*- coding: utf-8 -

Introduction
=============================

``SciTE`` est un éditeur multiplatforme léger et hautement configurable. 

J'utilise ``extSciTE`` comme mémo pour réinstaller cet éditeur sur une nouvelle machine
et rapidement ajouter quelques scripts pratiques pour un usage quotidien.


extSciTE
=============================


Installation sous Linux
--------------------------------------------

- ``sudo apt-get install git``
- ``sudo apt-get install lua5.1``
- ``sudo apt-get install liblua5.1-socket2``
- ``sudo apt-get install liblua5.1-socket-dev``
- ``sudo apt-get install lua5.1-filesystem``
- Lancer la console et exécuter la commande ``lua`` : un prompt s'affiche invitant à saisir du code lua. Tester le code ``socket = require "socket";print(socket._VERSION);`` sans génèrer une erreur dans la console. 
- ``sudo apt-get install scite``
- Télécharger https://github.com/ami44/extSciTE.git dans ``/home/myloginname/extSciTE`` : ``cd /home/myloginname && git clone https://github.com/ami44/extSciTE.git``
- Exécuter SciTE : 

    - Editer ``.SciTEUser.properties`` (menu --> Options --> Open User Options File) pour ajouter des options spécifiques à ``extman.lua`` : ::

            -- -*- coding: utf-8 -
            # ------------------------------------------------------------------------
            # extman.lua
            # ------------------------------------------------------------------------
            # Indiquer à ``extman.lua`` où se trouve les scripts lua à charger
            ext.lua.directory=/home/myloginname/extSciTE/extman/scite_lua
            # si on modifie le fichier ``SciTEStartup.lua`` alors SciTE le relancera automatique ( cf aussi SHIFT+CTRL+R)
            ext.lua.auto.reload=1
            # option utile pour le développement
            ext.lua.debug.traceback=1
            # (facultatif) Emplacement spécifique du script de chargement si on n'utilise pas le fichier ``SciTEStartup.lua`` par défaut
            #~ ext.lua.startup.script=$(SciteUserHome)/SciTEStartup.lua
            
    - Editer le script de chargement principal ``SciTEStartup.lua`` (menu --> Options --> Open Lua Startup Scripts) et ajouter ::

        -- -*- coding: utf-8 -
        -- -------------------------------------------------------------------------------------------------------
        -- Extension
        -- charger les extensions *avant* d'exécuter extman.lua
        -- -------------------------------------------------------------------------------------------------------
        -- corriger le chemin des extensions (à revoir)
        package.path = package.path..';/usr/share/lua/5.1/?.lua'
        package.cpath = package.path..';/usr/lib/lua/5.1/?.so'
        -- charger les extensions
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
        dofile "/home/myloginname/extSciTE/extman/extman.lua"
        
- Redémarrer SciTE et constater dans la console que les modules de extSciTE se chargent :

    .. image:: https://github.com/ami44/extSciTE/raw/master/assets/console.png
        :alt: chargement des modules extSciTE
        :align: center
    
- installer/démarrer nodeSciTE (cf ci-dessous) 

Installation sous Windows
--------------------------------------------

- Installer luaforwindows : http://code.google.com/p/luaforwindows/
- Lancer la console et exécuter la commande ``lua`` : un prompt s'affiche invitant à saisir du code lua. Tester le code ``socket = require "socket";print(socket._VERSION);`` sans génèrer une erreur dans la console. Si erreur alors corriger les variables d'environnement :

    - Windows XP : Démarrer --> Panneau de configuration --> Système --> Avancé --> Variables d'environnement --> Variables système
    - LUA_CPATH = ``C:\Program Files\Lua\5.1\clibs\?.dll``
    - LUA_PATH = ``;C:\Program Files\Lua\5.1\lua\?.luac;C:\Program Files\Lua\5.1\lua\?.lua``

- Installer SciTE ( http://www.scintilla.org/SciTEDownload.html ) dans le répertoire ``C:\Documents and Settings\myloginname\wscite`` et ajouter le raccourci de SciTE sur le bureau + barre de lancement rapide (explorer --> SciTE.exe --> clic droit --> Envoyer vers --> Bureau (créer un raccourci)) 
- Télécharger https://github.com/ami44/extSciTE.git dans ``C:\Documents and Settings\myloginname\extSciTE`` (télécharger le zip)
- Exécuter SciTE : 

    - Editer ``SciTEUser.properties`` (menu --> Options --> Open User Options File) pour ajouter des options spécifiques à ``extman.lua`` : ::
        
            -- -*- coding: utf-8 -
            # ------------------------------------------------------------------------
            # extman.lua
            # ------------------------------------------------------------------------
            # Indiquer à ``extman.lua`` où se trouve les scripts lua à charger
            ext.lua.directory=C:\Documents and Settings\myloginname\extSciTE\extman\scite_lua
            # si on modifie le fichier ``SciTEStartup.lua`` alors SciTE le relancera automatique ( cf aussi SHIFT+CTRL+R)
            ext.lua.auto.reload=1
            # option utile pour le développement
            ext.lua.debug.traceback=1
            # (facultatif) Emplacement spécifique du script de chargement si on n'utilise pas le fichier ``SciTEStartup.lua`` par défaut
            #~ ext.lua.startup.script=$(SciteUserHome)/SciTEStartup.lua
            
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

        
Lua Startup Scripts
--------------------------------------------

Emplacement du script ``SciTEStartup.lua`` : menu --> Options --> Open Lua Startup Scripts

Le script ``SciTEStartup.lua`` est exécuté au démarrage de SciTE. 
On exécute tout de suite le script ``extman.lua`` (http://lua-users.org/wiki/SciteExtMan) qui étend les 
fonctionnalités lua de SciTE. J'ai amélioré ``extman.lua`` en ajoutant la méthode ``scite_OnKey()``. 

Le script ``extman.lua`` se charge ensuite d'exécuter les scripts présents dans 
le répertoire extSciTE/extman/scite_lua (cf option ``ext.lua.directory``). Il ajoute aussi un raccourci clavier 
SHIFT+CTRL+R qui permet de recharger le script lua en cours d'édition (Cf menu --> Tools --> Reload Script ).
Si on édite le fichier ``SciTEStartup.lua`` alors on relancera ``extman.lua`` et les autres scripts en cascade.


nodeSciTE
------------------------------------------------------


.. note:: nodeSciTE n'analyse que les scripts ``*.js`` pour le moment

Compagnon de SciTE en charge d'analyser le code en cours d'édition (jslint...)


Installation de nodeSciTE
.............................................................

- installer ``extSciTE`` au préalable
- installer nodejs & npm : http://nodejs.org/download :

    - Linux : 
        
        - sudo ``apt-get install nodejs``
        
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
- linux : ``cd "/home/myloginname/extSciTE/nodeSciTE"``
- windows : ``cd "C:\Documents and Settings\myloginname\extSciTE\nodeSciTE"``
- ``npm install``
- @revoir : ne fonctionne pas !!! corriger ``extSciTE\nodeSciTE\node_modules\jslint\lib\jslint.js`` et corriger ``maxerr    : 1000`` en ``maxerr    : 10000``
- exécuter nodeSciTE (lire ci-après)

Exécution de nodeSciTE (manuel ou automatique)
.....................................................................

Manuel : 

    - linux : 
    
        - ouvrir la console bash
        - ``cd "/home/myloginname/extSciTE/nodeSciTE"``
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


SciTE
=============================

Liste des options : http://www.scintilla.org/SciTEDoc.html

Editer ``SciTEUser.properties`` (menu --> Options --> Open User Options File) : ::


    buffers=30
    save.session=1
    check.if.already.open=1
    open.dialog.in.file.directory =1
    find.replace.advanced =1
    # code.page=65001
    # output.code.page=65001
    properties.directory.enable=1
    title.full.path=1
    title.show.buffers=1    
    pathbar.visible=1
    save.position=1
    line.margin.visible=1
    highlight.current.word=1
    find.files=*
    tabsize=4
    indent.size=4
    use.tabs=0
    
    if PLAT_GTK
        all.files=All Files (*)|*|Hidden Files (.*)|.*|
    open.filter=\
    $(all.files)




Modules extSciTE
=============================

.. note:: pour désactiver un module : simplement renommer le fichier sans l'extension ``.lua`` pour ne plus être pris en compte. Pour le réactiver : remettre l'extension ``.lua``.


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

extSciTE/extman/scite_lua/52outputToEditor.lua
--------------------------------------------

CTRL+7 : copier le contenu de la console dans un fichier ``console.txt`` et l'ouvre tout de suite dans SciTE.

extSciTE/extman/scite_lua/ 100tictacto.lua
--------------------------------------------

CTRL+8 : A utiliser avec font monospace (CTRL+F11)

extSciTE/extman/scite_lua/101eliza.lua
--------------------------------------------

CTRL+9 : crazy elisa


extSciTE/extman/scite_lua/800node.lua
--------------------------------------------

.. note:: version alpha, très instable ;-)

Scite envoie le contenu du code à analyser au serveur nodeSciTE ( jslint, etc ... ). 
Afficher le résultat sous forme d'annotation dans SciTE :

    .. image:: https://github.com/ami44/extSciTE/raw/master/assets/nodescite.png
        :alt: chargement des modules extSciTE
        :align: center

Voir la section ci-dessus nodeSciTE pour installer et démarrer ce serveur.
       
  

Enjoy !    
