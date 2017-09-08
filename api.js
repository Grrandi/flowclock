const JsonDB = require('node-json-db');
const express = require('express');
const bodyParser = require('body-parser');
const app = express();

app.use(bodyParser.json()); // support json encoded bodies
app.use(bodyParser.urlencoded({ extended: true })); // support encoded bodies

var db = new JsonDB("FlowClockDB", true, false);

app.post('/', function (req, res) {
  res.send(req.body.foo)
});

app.post('/register', function (req, res) {
  // tee jotain requestilla
  // db.push("/riksa", {"salasana": "kissa123", "tuntipalkka": 12})
  username = req.body.username;
  password = req.body.password;
  salary = req.body.salary;
  res.setHeader('Content-Type', 'application/json');
  try {
    var data = db.getData("/" + username);
    res.status(403).send(JSON.stringify({"error": "User already exists"}))
  } catch(error) {
    db.push("/" + username, {"password": password, "salary": salary, "flows": []});
    res.status(200).send(JSON.stringify({"flows": []}))
  }
});

app.post('/login', function (req, res) {
  // kato käyttätunnus
  // hae käyttätunnukselle salasana
  // jos täsmää palauta kaikki kirjaukset
  // jos ei niin error tms
  username = req.body.username;
  password = req.body.password;
  res.setHeader('Content-Type', 'application/json');
  try {
    var data = db.getData("/" + username);
    if(data.password === password) {
      res.status(200).send(JSON.stringify(data.flows));
    } else {
      res.status(403).send(JSON.stringify({"error": "Password incorrect"}))
    }
  } catch(error) {
    res.status(404).send(JSON.stringify({"error": "User does not exist"}))
  }
});

app.post('/log', function (req, res) {
  seconds = req.body.seconds;
  username = req.body.username;
  
  // kirjaa käyttäjtunnukselle uusi flow
  // palauta tallennuksen jälkeen kaikki käyttäjän flowt ja elm rakentaa listan uusiksi
  res.send('Hello World!')
});


app.listen(8081, function () {
  console.log('Example app listening on port 8081!')
});
