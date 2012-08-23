// -*- coding: utf-8 -
/*jslint node: true *//*Assume Node.js*/
/*jslint nomen: true *//*Tolerate dangling _ in identifiers (underscore)*/
"use strict";

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
app.get('/', function (req, res) {
    res.send('ok'); // indique que serveur ecouté 
});

// -------------------------------------------------------------------------------------------
// post
// -------------------------------------------------------------------------------------------
app.post('/', function (req, res) {

    // -------------------------------------------------------------------------------------------
    // Lire les params
    // Rappel : car POST alors req.body
    // -------------------------------------------------------------------------------------------
    var SciteDefaultHome = req.body.SciteDefaultHome,
        SciteUserHome = req.body.SciteUserHome,
        FilePath = req.body.FilePath,
        actions = req.body.actions,
        code = req.body.code,
        md5 = null,
        lua = [],
        resume = {};

    // -------------------------------------------------------------------------------------------
    // si avec param action alors on a reçu du code 
    // -------------------------------------------------------------------------------------------
    if (typeof (actions) !== 'undefined' && actions.length > 0) {

        //~ console.log('post/set code : ' + FilePath);
        //~ console.log(code);  
        md5 = crypto.createHash('md5').update(code).digest("hex");
        actions = actions.split(","); // convertir chaine ``jslint,jhlint`` en liste

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
        if (!_.has(dbFilePath, FilePath)) {
            dbFilePath[FilePath] = {
                lastcode : { md5 : "", code : ""},
                lastresult : {}
            };
        }

        // + initialiser dbFilePath.fichier.lastresult.action si n'existe pas
        _.each(actions, function (actionName) {

            if (!_.has(dbFilePath[FilePath]['lastresult'], actionName)) {
                dbFilePath[FilePath]['lastresult'][actionName] = {
                    md5 : '', // md5 du dernier fichier . eviter de relancer si égal à lastcode.md5
                    count : -1, // -1 indique que l'action n'a pas été lancé
                    errors : []
                };
            }

            // + mettre à jour dbAction pour lui indiquer de traiter en priorité ce fichier
            // car le buffer de ce code est actuellement ouvert/visualisé dans SciTE
            if (!_.has(dbAction, actionName)) {
                dbAction[actionName] = { 'nextFilePath' : '', 'workInProgress' : false };
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
        // fin réception des données  
        // on écrase seulement les données filles de ``lastcode``
        // setInterval() va lancer les actions (si pas déjà en cours, si md5 évolue ... )
        // et renseignera les données filles de ``lastresult``en mode asynchrone
        // retourner statut 200
        res.send('ok');
    } else {

        //~ console.log('post/get'); 
        // -----------------------------------------------------------------------
        // construire réponse au format lua  
        // -----------------------------------------------------------------------
        if (_.has(dbFilePath, FilePath)) { // ca arrive quand on démarre SciTE, on  pas encore eu le temps de lui passer le code à analyser

            // msg = JSON.stringify(dbFilePath[FilePath]['lastresult']);
            // -----------------------------------------------------------------------
            // supprimer les annotations déjà présentes et définir style des annotations
            // -----------------------------------------------------------------------
            lua = [];
            lua.push("-- FilePath = " + FilePath);
            //~ lua.push("-- "+JSON.stringify(dbFilePath[FilePath]['lastcode']));
            //~ lua.push("-- "+JSON.stringify(dbFilePath[FilePath]['lastresult']));
            lua.push("editor:AnnotationClearAll();");
            lua.push("editor.AnnotationVisible = ANNOTATION_BOXED;"); //  style contour annotation

            // -----------------------------------------------------------------------
            // rassembler par ligne les informations retournées par différents analyseurs de code
            // -----------------------------------------------------------------------
            resume = {};
            _.each(dbFilePath[FilePath]['lastresult'], function (obj, actionName) {
                if (obj.count > 0) {
                    _.each(obj.errors, function (detail) {
                        var line = detail.line - 1; // car SciTE, ligne commence à 0
                        if (!_.has(resume, line)) { resume[line] = []; } // ajouter cette clé ``line`` si n'existe pas encore
                        resume[line].push(actionName + ':' + detail.character + ':' + (detail.reason).replace("\\", "\\\\").replace("\"", "\\\""));
                    });
                }
            });

            // -----------------------------------------------------------------------
            // balayer resume
            // -----------------------------------------------------------------------
            _.each(resume, function (objList, line) {
                var label = objList.join("\\\n");
                lua.push("editor.AnnotationStyle[" + line + "] = 4;"); //  style interieur global ( couleur de contour + couleur text et background) : 0, 1, 2, 3, 4
                lua.push("editor:AnnotationSetText(" + line + ", \"" + label + "\");");
            });

        }
        res.send(lua.join("\n"));

    }

});

// @todo : tester que nodeSciTE n'est pas déjà démarré !
app.listen(3891);
console.log('Listening on port 3891');

// -----------------------------------------------------------------------
// toutes les X millisecondes, regarder si il n'y a pas une action à exécuter
// -----------------------------------------------------------------------
var interval = 1000; // millisecondes
setInterval(function () {

    //~ console.log(dbAction);

    _.each(dbAction, function (obj, actionName) {
        if (dbAction[actionName]['workInProgress'] === false) {
            // -----------------------------------------------------------------------
            // jslint
            // -----------------------------------------------------------------------
            if (actionName === 'jslint') {
                // -----------------------------------------------------------------------
                // positionné comme en cours
                // -----------------------------------------------------------------------
                dbAction['jslint']['workInProgress'] = true;
                // -----------------------------------------------------------------------
                // regarder si le md5 du lastcode n'est pas égal au dernier résultat calculé, signifiant que le travail a déjà été fait
                // -----------------------------------------------------------------------
                if (dbFilePath[obj.nextFilePath]['lastcode']['md5'] !== dbFilePath[obj.nextFilePath]['lastresult']['jslint']['md5']) {

                    // -----------------------------------------------------------------------
                    // réinitialiser la liste des erreurs 
                    // sauvegarder le md5 
                    // -----------------------------------------------------------------------
                    dbFilePath[obj.nextFilePath]['lastresult']['jslint']['errors'] = [];
                    dbFilePath[obj.nextFilePath]['lastresult']['jslint']['md5'] = dbFilePath[obj.nextFilePath]['lastcode']['md5'];

                    // -----------------------------------------------------------------------
                    // jslint
                    // -----------------------------------------------------------------------
                    var jslintOptions = {};
                    if (!JSLINT(dbFilePath[obj.nextFilePath]['lastcode']['code'], jslintOptions)) {
                        //~ console.log('errors = ' + JSLINT.errors.length); 
                        dbFilePath[obj.nextFilePath]['lastresult']['jslint']['count'] = JSLINT.errors.length; // sauvegarder 
                        for (var i = 0; i < JSLINT.errors.length; i += 1) {
                            var e = JSLINT.errors[i];                               
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
                // fin de jslint, indiquer que le travail est terminé
                // -----------------------------------------------------------------------
                dbAction['jslint']['workInProgress'] = false;
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


