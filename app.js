const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

app.use(bodyParser.json());

// Endpoint GET simple
app.get('/', (req, res) => {
  res.send('Hello, this is a GET endpoint!');
});

// Endpoint POST simple
app.post('/', (req, res) => {
  const { message } = req.body;
  res.send(`Received message: ${message}`);
});

// Démarrer le serveur
app.listen(port, () => {
  console.log(`Server is listening at http://localhost:${port}`);
});
