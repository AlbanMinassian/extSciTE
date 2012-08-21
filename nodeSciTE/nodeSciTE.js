var express = require('express');
var app = express();

app.get('/', function(req, res){
    //~ console.log('get');
    res.send('Hello World GET');
});

app.post('/', function(req, res){
    //~ console.log('post');
    res.send('Hello World POST');
});

app.listen(3891);
console.log('Listening on port 3891');