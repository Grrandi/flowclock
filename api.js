const jsonServer = require('json-server')
const jsonDB = require('node-json-db');
const express = require('express')
const app = express()

var db = new JsonDB("FlowClockDB", true, false);

app.get('/', function (req, res) {
  res.send('Hello World!')
});

app.push('/register', function (req, res) {
  res.send('Hello World!')
});

app.push('/login', function (req, res) {
  res.send('Hello World!')
});

app.push('/log', function (req, res) {
  res.send('Hello World!')
});

app.get('/user-data', function (req, res) {
  res.send('Hello World!')
});

app.listen(8081, function () {
  console.log('Example app listening on port 3000!')
}
