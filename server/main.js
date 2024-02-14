const express = require("express");
const mysql = require("mysql2/promise");
const cors = require("cors"); // Pour connecter différents domaines
const config = require('config');
const crypto = require('crypto');

let db = null;
const app = express();

app.use(cors());
app.use(express.json());

app.post('/login', async (req, res) => {
  try {
    const mail = req.body.mail;
    const password = req.body.password;

    const user = await db.query("SELECT pseudo, mail, password FROM users WHERE mail = ?;", [mail]);

    // Verif si utilisateur trouvé
    if (user[0].length === 0) {
      res.status(401).json({
        status: "Utilisateur non trouvé."
      });
      return;
    }

    const userData = user[0][0];
    const userPassword = userData.password;
    if (userPassword !== password) {
      res.status(401).json({
        status: "Mot de passe incorrect."
      });
      return;
    } else {
      res.json({
        status: "Connecté",
        mail: userData.mail // Ajout du champ mail dans la réponse JSON
      });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({
      error: "Internal Server Error"
    });
  }
});

















app.post('/create-user', async (req, res, next) => {
  try {
    const {
      pseudo,
      mail,
      password
    } = req.body;

    if (!pseudo) {
      return res.status(400).json({
        error: "Pseudo is required"
      });
    }
    if (!mail) {
      return res.status(400).json({
        error: "Mail is required"
      });
    }

    if (!password) {
      return res.status(400).json({
        error: "Password is required"
      });
    }

    // Vérifier si le pseudo est déjà pris
    const existingUser = await db.query("SELECT * FROM users WHERE pseudo = ?;", [pseudo]);

    if (existingUser[0].length > 0) {
      console.log("pseudo pris");
      return res.status(400).json({
        status: "Ce pseudo est déjà pris !"
      });
    }

    // Vérifier si le mail est déjà pris
    const existingMail = await db.query("SELECT * FROM users WHERE mail = ?;", [mail]);

    if (existingMail[0].length > 0) {
      return res.status(400).json({
        status: "Ce mail est déjà associé à un compte !"
      });
    }

    await db.query("INSERT INTO users (pseudo, mail, password) VALUES (?, ?, ?);", [pseudo, mail, password]);

    res.json({
      status: "OK"
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      error: "Internal Server Error"
    });
  }
});



app.get('/users', async (req, res) => {
  try {
    const [rows] = await db.query("SELECT * FROM users;");
    res.json(rows);
    console.log("SELECT reussi");
  } catch (error) {
    console.log("SELECT PAS REUSSI");
    console.error(error);
    res.status(500).json({
      error: "Internal Server Error"
    });
  }
});






app.get('/', (req, res) => {
  res.json({
    message: 'Lemonmaze !'
  });
});








async function main() {
  try {
    // Créer connexion
    db = await mysql.createConnection({
      host: config.get('db.host'),
      user: config.get('db.user'),
      password: config.get('db.password'),
      database: config.get('db.database'),
      charset: config.get('db.charset'),
      port: config.get('db.port'),
    });

    // Tester si connexion réussie
    await db.query("SELECT 1");
    console.log("Connexion à la base de données réussie");

    // Démarrer serveur
    app.listen(8000);
    console.log("Serveur démarré sur le port 8000");
  } catch (error) {
    // ERREUR
    console.log("Échec de la connexion à la base de données");
    console.error(error);

    // Arrêter processus
    process.exit(1);
  }
}

main();
