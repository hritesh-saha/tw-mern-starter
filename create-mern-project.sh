#!/bin/bash

# Exit on error
set -e

echo "🔧 Creating Vite + React frontend..."
read -p "Enter project name: " project_name

# Create root folder
mkdir "$project_name"
cd "$project_name"

# ----------------- Frontend Setup -----------------
mkdir client
cd client

npm create vite@latest . -- --template react
npm install
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# Add Tailwind config to tailwind.config.js
echo "✅ Configuring Tailwind..."
sed -i.bak 's/content: \[\]/content: \[".\/index.html", ".\/src\/*.{js,ts,jsx,tsx}"\]/' tailwind.config.js

# Inject Tailwind into styles
cat > src/index.css <<EOL
@tailwind base;
@tailwind components;
@tailwind utilities;
EOL

# Add frontend .gitignore
cat > .gitignore <<EOL
node_modules/
dist/
.env
.env.local
.DS_Store
EOL

cd ..

# ----------------- Backend Setup -----------------
echo "🛠 Setting up backend with extended folder structure and configs..."
mkdir server
cd server

# Initialize npm and install packages
npm init -y
npm install express cors dotenv mongoose

# Insert "type": "module" and "scripts": {...} just after the opening {
# Using sed with GNU/Linux syntax:
sed -i '1s/{/{\n  "type": "module",\n  "scripts": {\n    "start": "nodemon index.js"\n  },/' package.json

# Create folder structure
mkdir routes models configs utilities Controllers middlewares

# Create db.js in configs/ with ES module style
cat > configs/db.js <<EOL
import mongoose from "mongoose";
import dotenv from "dotenv";
dotenv.config();
const DB_URI = process.env.DB_URI;

const connectDB = async () => {
  try {
    const con = await mongoose.connect(DB_URI);
    console.log('MongoDB Connected');
  } catch (error) {
    console.error('MongoDB Connection Error:', error);
    process.exit(1);
  }
}

export default connectDB;
EOL

# Create basic server index.js (using ES modules now)
cat > index.js <<EOL
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
dotenv.config();

import connectDB from './configs/db.js';

const app = express();
app.use(cors());
app.use(express.json());

// Connect to MongoDB
connectDB();

app.get('/', (req, res) => {
  res.send('API is working!');
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(\`Server running on port \${PORT}\`));
EOL

# .env example
cat > .env <<EOL
PORT=5000
DB_URI=mongodb://localhost:27017/${project_name}
EOL

# Add backend .gitignore
cat > .gitignore <<EOL
node_modules/
.env
.DS_Store
EOL

# Create nodemon.json
cat > nodemon.json <<EOL
{
  "watch": ["index.js", "routes", "models", "configs", "utilities", "Controllers"],
  "ext": "js,json",
  "ignore": ["node_modules/"],
  "exec": "node index.js"
}
EOL

cd ..

echo "🎉 $project_name created with Vite + Tailwind + Express!"
echo "🗃️  .gitignore files have been added to both client/ and server/"
