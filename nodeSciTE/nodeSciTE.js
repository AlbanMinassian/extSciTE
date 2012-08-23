var _ = require("underscore");
var crypto = require('crypto');
var JSLINT = require(__dirname + "/node_modules/jslint/lib/nodelint");
var express = require('express');
var app = express();
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(app.router);

// -------------------------------------------------------------------------------------------
// database interne
// -------------------------------------------------------------------------------------------
var dbAction = {}; // liste des actions en cours de traitement
var dbFilePath = {}; // fast global json dbFilePath ;-)


// -------------------------------------------------------------------------------------------
// get
// -------------------------------------------------------------------------------------------
app.get('/', function(req, res){
    res.send('ok'); // indique que serveur ecout�
});



// -------------------------------------------------------------------------------------------
// post
// -------------------------------------------------------------------------------------------
app.post('/', function(req, res){
    
    //~ console.log(req.params);
    
    // -------------------------------------------------------------------------------------------
    // Lire les params
    // Rappel : car POST alors req.body
    // -------------------------------------------------------------------------------------------
    var SciteDefaultHome = req.body.SciteDefaultHome;
    var SciteUserHome = req.body.SciteUserHome;
    var FilePath = req.body.FilePath;
    var actions = req.body.actions;
    var code = req.body.code;
    
    // -------------------------------------------------------------------------------------------
    // si avec param action alors on a re�u du code 
    // -------------------------------------------------------------------------------------------
    if ( typeof(actions)!='undefined' && actions.length > 0 ) {
        
        console.log('post/set');
        
        
        actions = actions.split(","); // convertir chaine ``action1,action2`` en liste
        md5 = crypto.createHash('md5').update(code).digest("hex");
        
        //~ console.log('-------------------');  
        //~ console.log(actions); 
        //~ console.log(FilePath); 
        //~ console.log(SciteDefaultHome); 
        //~ console.log(SciteUserHome); 
        //~ console.log(code); 
        //~ console.log(md5); 
        
        // -----------------------------------------------------------------------
        // initialiser dbFilePath avec ce fichier si n'existe pas
        // -----------------------------------------------------------------------
        if ( ! _.has(dbFilePath, FilePath)) { 
            dbFilePath[FilePath] = { 
                lastcode : { md5 : '', code : ''},
                lastresult : {},
            };
        }
        
        // + initialiser dbFilePath.fichier.lastresult.action si n'existe pas
        _.each(actions, function(actionName){ 
            
            if ( ! _.has(dbFilePath[FilePath]['lastresult'], actionName)) {
                dbFilePath[FilePath]['lastresult'][actionName] = { 
                    md5 : '', // md5 du dernier fichier . eviter de relancer si �gal � lastcode.md5
                    count : -1, // -1 indique que l'action n'a pas �t� lanc�
                    errors : []
                };
            }
        
            // + mettre � jour dbAction pour lui indiquer de traiter en priorit� ce fichier
            // car le buffer de ce code est actuellement ouvert/visualis� dans SciTE
            if ( ! _.has(dbAction, actionName)) {     
                dbAction[actionName] = { 'nextFilePath' : '', 'workInProgress' : false }
            }
            dbAction[actionName]['nextFilePath'] = FilePath;
            
        });
        
        // -----------------------------------------------------------------------
        // sauvegarder tout de suite le nouveau code soumis pour ce fichier
        // -----------------------------------------------------------------------
        dbFilePath[FilePath]['lastcode']['code'] = code;
        dbFilePath[FilePath]['lastcode']['md5'] = md5;
        
        // -----------------------------------------------------------------------
        // Fin
        // -----------------------------------------------------------------------
        // fin r�ception des donn�es 
        // on �crase seulement les donn�es filles de ``lastcode``
        // setInterval() va lancer les actions (si pas d�j� en cours, si md5 �volue ... )
        // et renseignera les donn�es filles de ``lastresult``en mode asynchrone
        // retourner statut 200
        res.send('ok');
        

    } else {
        
        console.log('post/get'); 
        
        // -----------------------------------------------------------------------
        // construire r�ponse 
        // -----------------------------------------------------------------------
        var msg = '';
        if ( _.has(dbFilePath, FilePath) ) { // ca arrive quand on d�marre SciTE, on  pas encore eu le temps de lui passer le code � analyser
            msg = JSON.stringify(dbFilePath[FilePath]['lastresult']);
        }
        res.send(msg);

    }    

    
});   

// @todo : tester que nodeSciTE n'est pas d�j� d�marr� !
app.listen(3891);   

console.log('Listening on port 3891');


// -----------------------------------------------------------------------
// toutes les X millisecondes, regarder si il n'y a pas une action � ex�cuter
// -----------------------------------------------------------------------
var interval = 1000; // millisecondes
setInterval(function () {
    
    //~ console.log(dbAction);
    
    _.each(dbAction, function(obj, actionName){ 
        if ( dbAction[actionName]['workInProgress'] == false ) {
            // -----------------------------------------------------------------------
            // jslint
            // -----------------------------------------------------------------------
            if ( actionName == 'jslint' ) {
                // -----------------------------------------------------------------------
                // positionn� comme en cours
                // -----------------------------------------------------------------------
                dbAction[actionName]['workInProgress'] = true;
                // -----------------------------------------------------------------------
                // regarder si le md5 du lastcode n'est pas �gal au dernier r�sultat calcul�, signifiant que le travail a d�j� �t� fait
                // -----------------------------------------------------------------------
                if ( dbFilePath[obj.nextFilePath]['lastcode']['md5'] !== dbFilePath[obj.nextFilePath]['lastresult']['jslint']['md5'] ) {
                    // -----------------------------------------------------------------------
                    // sauvegarder le md5 
                    // -----------------------------------------------------------------------
                    dbFilePath[obj.nextFilePath]['lastresult']['jslint']['md5'] = dbFilePath[obj.nextFilePath]['lastcode']['md5'];
                    // -----------------------------------------------------------------------
                    // jslint
                    // -----------------------------------------------------------------------
                    var jslintOptions = {};  
                    if (!JSLINT(dbFilePath[obj.nextFilePath]['lastcode']['code'], jslintOptions))  { 
                        //~ console.log('errors = ' + JSLINT.errors.length); 
                        dbFilePath[obj.nextFilePath]['lastresult']['jslint']['count'] = JSLINT.errors.length; // sauvegarder 
                        for (i = 0; i < JSLINT.errors.length; i += 1) {
                            e = JSLINT.errors[i];                               
                            if (e) {
                                //~ console.log(e.line + ':' + e.character + ': ' + e.reason);
                                // print((e.evidence || '').replace(/^\s*(\S*(\s+\S+)*)\s*$/, "$1"));
                                dbFilePath[obj.nextFilePath]['lastresult']['jslint']['errors'].push({
                                        'line' : e.line,
                                        'character' : e.character,
                                        'reason' : e.reason,
                                        //~ 'evidence' : e.evidence,
                                });            
                            }
                        }   
                    } else {
                        // jslint: No problems found 
                        dbFilePath[obj.nextFilePath]['lastresult']['jslint']['count'] = 0; 
                        dbFilePath[obj.nextFilePath]['lastresult']['jslint']['errors'] = []; 
                    }                   
                }
                // -----------------------------------------------------------------------
                // fin de jslint, indiquer que le travail est termin�
                // -----------------------------------------------------------------------
                dbAction[actionName]['workInProgress'] = false;
            }
            // -----------------------------------------------------------------------
            // jshint
            // -----------------------------------------------------------------------
            if ( actionName == 'jshint' ) {
                // @todo
            }
            // -----------------------------------------------------------------------
            // ...
            // -----------------------------------------------------------------------
            if ( actionName == 'xxx' ) {
                // @todo
            }
        }
    });
}, interval);


