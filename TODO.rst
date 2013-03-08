.. -*- coding: utf-8 -

- déplacer documentation dans le wiki

    - cf exemple : https://github.com/hadley/devtools/wiki => necessite gollum https://github.com/github/gollum

        - https://github.com/mojombo/gollum-demo
        - http://killring.org/blog/2012/06/28/gollum-the-ultimate-personal-wiki/
        - http://alblue.bandlem.com/2011/05/git-tip-of-week-gollum.html
        - http://www.nomachetejuggling.com/2012/05/15/personal-wiki-using-github-and-gollum-on-os-x/
        - http://michaelchelen.net/articles/git-wiki-gollum-smeagol.html
        - https://blog.theroux.ca/ruby/Markdown-based-wiki-using-gollum/
        - http://blackbe.lt/github-wiki-sidebar-table-contents-header-footer/
        - https://github.com/dreverri/gollum-site ( Static Site Generator for Gollum Wikis )
        - https://github.com/remino/blankgollum ( A blank gollum wiki repo template for you to use )
        - https://github.com/tub78/gollum-bootstrap ( Bootstrap your repository's wiki with Gollum )
        - http://vincent.demeester.fr/2012/12/gollum-comme-wiki-personnel/



- documenter bookmark (sep, doStringCode, Filepath = File ou Dir )
- déplacer openFileOrDirectory (de 042projet.lua) dans 015utils.lua
- doc dir et tree : indiquer qu'un clic dans output ouvre le fichier ou liste les fichiers 
- renommer en printDir
- quand on liste les modules au démarrage de SciTE : ``[module] xxxxxx, Ctrl+`` => ajouter execlua[openFileorDir('chemin vers le code source du module')]
    ===> fait dans 015utils ``_ALERT(outputModuleMessage('[module] utils (vardump, luasqlrows ... )', props['FilePath']))`` ==> déployer dans les autres *.lua
    
- tree : ctml enfoncé = fichier caché ( ou props/option dans SciTEUser.propertises pour activer cette option systématiquement ? ) 

- coder exemple pour tester notify (win ou windows)
- coder exemple pour tester status bar avec message personnalisé ( cf $(StatusMsg), props["StatusMsg"]='Mon message'; )
- coder exemple pour coloriser output ( décommenter code de 016outputcolor.lua )

-  execlua qui détecte CTRL ou SHIFT
    SIGNALER qu'il faut relacher la touche CTRL ou SHIFT avant de double cliquer sinon scite met in certaisn temps avant de ne plus détecter de touche relaché (qui n'existe pas d'ailleurs ...) 
    (donc pas la peine de maintenir enfoncé .. scite ne sait pas gérer ce cas)
    + revoir code sqlite ???

    ++++ ajouter action si ctrl engoncé = 
    [open]
    [open into other editor gimp, xmleditor]
    [run validateur si fichier .....]
    [run behat --dd --fr]
    [open dir in console]
    [delete]
    [move]
    [etc]

- bookmark : option qui afficher bookmark au démarrage de SciTE
- bookmark : afficher [edit] que si configuration réelle de webadmin ou exe ....
- rappeller dans README.txt qu'il faut un double click  dans la console (les lignes avec execlua) pour executer code lua  ( + trouver une image pour illustrer ?)

- renommer fichier bookmark.sqlite3.db EN bookmark.sqlite3.db.rename pour éviter d'écraser lors maj accidentel de extSciTE

- supprimer 001first.lua et retirer de README OU Y PLACER TOUT LE CODE PAR DEFAUT : execlua et autres ....


- console vers dans editor => ajouter dans le menu contextuel !!!! 
- remonter execlua dans utils

-------------------------------------------------------


- améliorer ``01execlua.lua`` => tester CTRL, SHIFT, tester ``execlua[`` et ``]`` ...
- ou utiliser udp depuis nodejs pour indiquer une évolution ? : 

    - https://love2d.org/wiki/Tutorial:Networking_with_UDP
    
- tester md5 de la réponse avant d'appliquer annotations

- expliquer comment démarrer nodeSciTE automatiquement au démarrage de la session

install windows : 

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
                
            - ou utiliser lfs ???

            ==> NE MARCHE PAS, NECESSITE DROIT ADMINISTRATEUR ????    

- quand tester démarrage de nodeSciTE depuis SciTE : afficher la liste des services disponibles : jslint, jhlint ....
- jslint : comment corriger ``maxerr`` reste bloqué a une valeur !!!! ::

    option.maxerr = +option.maxerr || 100000; ===> option.maxerr = 100000; ne fonctionne pas 
    => toujours ``Stopping (83% scanned)`` !!!
    
- ajoute site web (nodejs) pour sauvegarder bookmark sur le serveur dédié et arrêter base sqlite3    

- bookmark & web : télécharger bookmark que si écart md5

- rappeller comment compiler SciTE sous Linux :: rappellrr scintilla\README + scite\README + résumé des actions
- comment compiler SciTE sous WINDOWS :: scintilla\README + scite\README + http://code.google.com/p/scite-ru/wiki/CompileSciTEwithMinGW ??

- interval : si pas d'activité alors OnUpdateUi n'est pas sollicité. Pour forcer cette activité :: depuis programme externe (via cron) , 
sollicité scite avec des commandes passé depuis l'extérieur via Command line arguments  ( http://www.scintilla.org/SciTEDoc.html) ==> a tester ?????

- utiliser lua namespace

