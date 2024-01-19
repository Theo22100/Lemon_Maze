const express = require("express");
const mysql = require("mysql2/promise");
const cors = require("cors");  // Pour connecter les différents domaines
const config = require('config');
const crypto = require('crypto');

let db = null;
const app = express();

app.use(cors());  
app.use(express.json());

app.post('/login', async (req, res) => {
  try {
    const pseudo = req.body.pseudo;
    const password = req.body.password;
    console.log(pseudo);
    console.log(password);

    // Recherchez l'utilisateur dans la base de données par pseudo
    const user = await db.query("SELECT * FROM users WHERE pseudo = ?;", [pseudo]);
    console.log(user);

    if (user.length === 0) {
      res.status(401).json({ error: "Utilisateur non trouvé." });
      return;
    }else{
      console.log("on a réussi")
    }

    // Comparez le mot de passe haché stocké avec le mot de passe fourni
    const hashedPassword = hashPassword(password);
    if (user[0].password !== hashedPassword) {
      res.status(401).json({ error: "Mot de passe incorrect." });
      console.log("mauvais mdp")
      return;
    }else{
      console.log("bon mdp")
    }

    res.json({ status: "OK" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

// Fonction pour hasher le mot de passe
function hashPassword(password) {
  const hash = crypto.createHash('sha256');
  hash.update(password);
  return hash.digest('hex');
}


app.post('/create-user', async (req, res, next) => {
  try {
    const { pseudo, mail, name, surname, password } = req.body;

    if (!pseudo) {
      return res.status(400).json({ error: "Pseudo is required" });
    }
    if (!surname) {
      return res.status(400).json({ error: "Mail is required" });
    }
    if (!name) {
      return res.status(400).json({ error: "Name is required" });
    }

    if (!surname) {
      return res.status(400).json({ error: "Surname is required" });
    }

    if (!surname) {
      return res.status(400).json({ error: "Password is required" });
    }

    await db.query("INSERT INTO users (pseudo, mail, name, surname, password) VALUES (?, ?, ?, ?, ?);", [pseudo, mail, name, surname, password]);

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
  res.json({ message: 'Lemonmaze !' });
});

async function main() {
  try {
    // Créer une connexion à la base de données MySQL
    db = await mysql.createConnection({
      host: config.get('db.host'),
      user: config.get('db.user'),
      password: config.get('db.password'),
      database: config.get('db.database'),
      charset: config.get('db.charset'),
      port: config.get('db.port'),
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
