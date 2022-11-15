const {Client} = require("pg")
const express = require("express")
const app = express()

const client = new Client({
  user: "postgres",
  password: "123654",
  host: "localhost",
  port: 5432,
  database: "postgres",
  connectionTimeoutMillis: 10000
})

app.get("/", (req, res) => res.sendFile(`${__dirname}/index.html`))  

app.get("/clubs", async (req, res) => {
  const rows = await readData();
  res.setHeader("Content-Type", "application/json")
  res.send(JSON.stringify(rows))
})
app.listen(8080, () => console.log("Listening"))

start()
async function start(){
  await connect();
}

app.get("/json", async (req, res) => {
  await client.query("copy (select jsonb_agg(out_json) from out_json) to 'C:/Users/Karlo/Desktop/faks/Diplomski/Sem1/OR/nocni_klubovi/nocni_klubovi.json'")
})


async function connect(){
  try{
    await client.connect();
  }
  catch(e){
    console.log(e);
  }
}

async function readData(){
  try{
    return (await client.query("SELECT * FROM clubs")).rows
  }
  catch(e){
    return []
  }
}