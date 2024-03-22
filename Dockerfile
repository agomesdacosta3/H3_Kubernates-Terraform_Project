# Utilisation de l'image officielle Node.js comme base
FROM node:14

# Définition du répertoire de travail dans le conteneur
WORKDIR /app

# Copie des fichiers package.json et package-lock.json pour installer les dépendances
COPY package*.json ./

# Installation des dépendances
RUN npm install

# Copie de tous les fichiers de l'application dans le répertoire de travail du conteneur
COPY . .

# Exposition du port sur lequel l'application écoute
EXPOSE 3000

# Commande pour démarrer l'application lorsque le conteneur démarre
CMD [ "node", "app.js" ]
