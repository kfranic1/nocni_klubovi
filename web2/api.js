const {Client} = require("pg")
const express = require("express")
const app = express()
const bodyParser = require('body-parser')
const fs = require('fs');
const { parse } = require('json2csv')

app.use(bodyParser.json());

const client = new Client({
  user: "postgres",
  password: "123654",
  host: "localhost",
  port: 5432,
  database: "postgres",
  connectionTimeoutMillis: 10000
})
//#region GET
app.get('/clubs', (req, res) => {
  client.query('SELECT * FROM clubs', (err, result) =>{
    if(err){
      res.status(500).send(err.toString());
    }
    else{
      res.status(200).json( {data:result.rows,
      context:{"Instagram":"Displays username on social network",
      "Club_name":"Name of a night club."}})
    }
  })
})

app.get('/clubs/:id', (req, res) => {
  id = req.params.id
  client.query(`SELECT * FROM clubs WHERE club_id = ${id}`, (err, result) =>{
    if(err){
      res.status(500).send(err.toString());
    }
    else if(result.rowCount == 0){
      res.status(404).send(`Club with id ${id} doesn't exist`);
    }
    else{
      res.status(200).json(result.rows)
    }
  })
})

app.get('/clubs/city/:city', (req, res) => {
  city = req.params.city
  client.query(`SELECT * FROM clubs WHERE city = '${city}'`, (err, result) =>{
    if(err){
      res.status(500).send(err.toString());
    }
    else if(result.rowCount == 0){
      res.status(404).send(`Club with city ${city} doesn't exist`);
    }
    else{
      res.status(200).json(result.rows)
    }
  })
})

app.get('/clubs/name/:name', (req, res) => {
  clubName = req.params.name
  client.query(`SELECT * FROM clubs WHERE club_name LIKE '%${clubName}%'`, (err, result) =>{
    if(err){
      res.status(500).send(err.toString());
    }
    else if(result.rowCount == 0){
      res.status(404).send(`Club with name ${clubName} doesn't exist`);
    }
    else{
      res.status(200).json(result.rows)
    }
  })
})

app.get('/clubs/rating/:rating', (req, res) => {
  rating = req.params.rating
  client.query(`SELECT * FROM clubs WHERE rating >= ${rating}`, (err, result) =>{
    if(err){
      res.status(500).send(err.toString());
    }
    else{
      res.status(200).json(result.rows)
    }
  })
})

app.get('/clubs/top/:top', (req, res) => {
  top = req.params.top
  client.query(`SELECT * FROM clubs ORDER BY rating DESC LIMIT ${top};`, (err, result) =>{
    if(err){
      res.status(500).send(err.toString());
    }
    else{
      res.status(200).json(result.rows)
    }
  })
})

app.get('/docs', (req, res) => {
  res.sendFile('./openapi.json', { root: __dirname });
});


//#endregion

//#region Other
app.post('/clubs', (req, res) => {
    let columns = [], values = []
    if(req.body){
        data = req.body;
        columns = Object.keys(data)
        values = Object.values(data)
        console.log(columns)
        console.log(values)
    }
    else console.log("Body is empty")

    let queryText = `INSERT INTO clubs (${columns.join(', ')}) VALUES (${values.map(x => `'${x}'`).join(', ')})`

    console.log(queryText)

    client.query(queryText, (err, result) =>{
      if(err){
        res.status(500).send(err.toString());
      }
      else{
        res.status(200).json(result.rows)
      }
    })
})

app.put('/clubs/:id', (req, res) => {
    id = req.params.id
    let columns = [], values = []
    if(req.body){
        data = req.body;
        columns = Object.keys(data)
        values = Object.values(data)
    }
    else console.log("Body is empty")

    elements = ""

    for(let i = 0; i < columns.length; i++){
        elements += columns[i] + " = " + `'${values[i]}'` + '\n'
    }

    console.log(elements)

    let queryText = `UPDATE clubs SET ${elements}  WHERE club_id = ${id}`

    console.log(queryText)

    client.query(queryText, (err, result) =>{
      if(err){
        res.status(500).send(err.toString());
      }
      else if(result.rowCount == 0){
        res.status(404).send(`Club with id ${id} doesn't exist`);
      }
      else{
        res.status(200).json(result.rows)
      }
    })
})

app.delete('/clubs/:id', (req, res) => {
    id = req.params.id;
    client.query(`DELETE FROM clubs WHERE club_id = ${id}`, (err, result) =>{
      if(err){
        res.status(500).send(err.toString());
      }
      else if(result.rowCount == 0){
        res.status(404).send(`Club with id ${id} doesn't exist`);
      }
      else{
        res.status(200).json(result.rows)
      }
    })
  })
//#endregion

// #region auth
const { auth } = require('express-openid-connect');
const { requiresAuth } = require('express-openid-connect');

const config = {
  authRequired: false,
  auth0Logout: true,
  secret: 'a long, randomly-generated string stored in env',
  baseURL: 'http://localhost:8080',
  clientID: 'PDAZeG1reB0iQOACjqAXd5NSmxs4UYUm',
  issuerBaseURL: 'https://dev-6c4acg7ufelo6yyp.us.auth0.com'
};

// auth router attaches /login, /logout, and /callback routes to the baseURL
app.use(auth(config));

// req.isAuthenticated is provided from the auth router
app.get('/', (req, res) => {
  res.send(req.oidc.isAuthenticated() ? 
    '<a href="/profile">Korisnički profil</a><br>' +
    '<a href="/download">Osviježi preslike</a><br>' +
    '<a href="/logout">Odjava</a>' :
    '<a href="/login">Prijava</a>');
});

app.get('/profile', requiresAuth(), (req, res) => {
  res.send(JSON.stringify(req.oidc.user));
});

app.get('/download', requiresAuth(), (req, res) => {
  client.query('SELECT * FROM clubs', (err, result) =>{
    if(err){
      res.status(500).send(err.toString());
    }
    else{
      saveCsvFile(result.rows)
      saveJsonFile(result.rows)
      res.status(200).json(result.rows)
    }
  })
})

//#endregion

//#region JSON_CSV
function saveJsonFile(json) {
  fs.writeFile('C:/Users/Karlo/Downloads/data.json', JSON.stringify(json), (err) => {
    if (err) throw err;
    console.log(`json file has been saved!`);
  });
}

function saveCsvFile(csv) {
  fs.writeFile('C:/Users/Karlo/Downloads/data.csv', parse(csv), (err) => {
    if (err) throw err;
    console.log(`csv file has been saved!`);
  });
}

//#endregion

app.all('*', (req, res) => {
  res.status(405).send(`Method ${req.method} not allowed`);
});
  
app.listen(8080, () => console.log("Listening"))

start()
async function start(){
  await connect();
}

async function connect(){
  try{
    await client.connect();
  }
  catch(e){
    console.log(e);
  }
}
