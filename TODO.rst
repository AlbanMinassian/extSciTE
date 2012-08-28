.. -*- coding: utf-8 -

- améliorer ``01execlua.lua`` => tester CTRL, SHIFT, tester ``execlua[`` et ``]`` ...
- tous les script scite_lua\XXyyyy.lua => accéder rapidement au code source !
- ou utiliser udp depusi nodejs pour indiquer une évolution ? : 

    - https://love2d.org/wiki/Tutorial:Networking_with_UDP
    
- tester md5 de la réponse avant d'appliquer annotations
- configurer le port d'écoute de nodeSciTE 
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

- refactoriser code bookmark ( doString en execlua, [] en label ...)
- bookmark & web : télécharger bookmark que si écart md5

- rappeller comment compiler SciTE sous Linux :: rappelelr scintilla\README + scite\README + résumé des actions
- comment compiler SciTE sous WINDOWS :: scintilla\README + scite\README

- interval : si pas d'activité alors OnUpdateUi n'est pas sollicité. Pour forcer cette activité :: depuis programme externe (via cron) , 
sollicité scite avec des commandes passé depuis l'extérieur via Command line arguments  ( http://www.scintilla.org/SciTEDoc.html) ==> a teser ?????

- utiliser lua namespace