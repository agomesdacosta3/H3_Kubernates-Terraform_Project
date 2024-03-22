const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql');

const app = express();
const port = process.env.PORT || 3344;

// Middleware pour parser le corps des requêtes en JSON
app.use(bodyParser.json());

// Configuration de la connexion à la base de données MySQL
const connection = mysql.createConnection({
  host: 'caps-mysql-server.mysql.database.azure.com',
  user: 'mysqladmin@caps-mysql-server',
  password: 'Passord1234',
  database: 'mydatabase',
  port: 3306,
  ssl: true
});

// Établir la connexion à la base de données MySQL
connection.connect((err) => {
  if (err) {
    console.error('Erreur de connexion à la base de données:', err);
    return;
  }
  console.log('Connexion à la base de données MySQL réussie');
});

// Endpoint GET simple
app.get('/', (req, res) => {
  connection.query('SELECT * FROM mytable', (error, results, fields) => {
    if (error) {
      console.error('Erreur lors de l\'exécution de la requête:', error);
      res.status(500).send('Erreur lors de l\'exécution de la requête');
      return;
    }
    res.send(results);
  });
});

// Endpoint POST simple
app.post('/', (req, res) => {
  const { message } = req.body;
  connection.query('INSERT INTO mytable (message) VALUES (?)', [message], (error, results, fields) => {
    if (error) {
      console.error('Erreur lors de l\'exécution de la requête:', error);
      res.status(500).send('Erreur lors de l\'exécution de la requête');
      return;
    }
    res.send(`Message reçu : ${message}`);
  });
});

// Démarrer le serveur
app.listen(port, () => {
  console.log(`Le serveur écoute sur le port ${port}`);
});
