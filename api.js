const jsonServer = require('json-server')
const jsonDB = require('node-json-db');
const express = require('express')
const app = express()

var db = new JsonDB("FlowClockDB", true, false);

app.get('/', function (req, res) {
  res.send('Hello World!')
});

app.push('/register', function (req, res) {
  // tee jotain requestilla
  // db.push("/riksa", {"salasana": "kissa123", "tuntipalkka": 12})
  res.send('Hello World!')
});

app.push('/login', function (req, res) {
  // kato käyttätunnus
  // hae käyttätunnukselle salasana
  // jos täsmää palauta kaikki kirjaukset
  // jos ei niin error tms
  res.send('Hello World!')
});

app.push('/log', function (req, res) {
  // kirjaa käyttäjtunnukselle uusi flow
  // palauta tallennuksen jälkeen kaikki käyttäjän flowt ja elm rakentaa listan uusiksi
  res.send('Hello World!')
});


app.listen(8081, function () {
  console.log('Example app listening on port 3000!')
}
