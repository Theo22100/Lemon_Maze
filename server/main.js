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
  } catch (error) {
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

app.get('/', (req, res) => {
  res.json({ message: 'Welcome to the API!' });
});

async function main() {
  try {
    // Créer une connexion à la base de données MySQL
    db = await mysql.createConnection({
      host: "localhost",
      user: "root",
      password: "root",
      database: "lemonmaze",
      charset: "utf8mb4_general_ci",
      port: 3309,
    });

    // Tester si la connexion est réussie
    await db.query("SELECT 1");
    console.log("Connexion à la base de données réussie");

    // Démarrer le serveur
    app.listen(8000);
    console.log("Serveur démarré sur le port 8000");
  } catch (error) {
    // En cas d'erreur
    console.log("Échec de la connexion à la base de données");
    console.error(error);

    // Arrêter le processus
    process.exit(1);
  }
}

// Appeler la fonction principale pour démarrer le serveur
main();
