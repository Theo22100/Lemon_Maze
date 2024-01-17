const express = require("express");
const mysql = require("mysql2/promise");

let db = null;
const app = express();

app.use(express.json());


app.post('/create-user', async(req, res, next)=>{
  try {
    const name = req.body.name;
    await db.query("INSERT INTO users (name) VALUES (?);", [name]);
    res.json({ status: "OK" });
    console.log("user reussi");
  } catch (error) {
    console.log("user pas reussi");
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});
app.get('/users', async (req, res) => {
  try {
    const [rows] = await db.query("SELECT * FROM users;");
    res.json(rows);console.log("SELECT reussi");
  } catch (error) {
    console.log("SELECT PAS REUSSI");
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

async function main(){
  db = await mysql.createConnection({
    host:"localhost",
    user: "root",
    password: "root",
    database: "lemonmaze",
    charset: "utf8mb4_general_ci",
    port: 3309,
  });

  app.listen(8000);
}

main();