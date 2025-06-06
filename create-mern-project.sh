#!/bin/bash

# Exit on error
set -e

# Trap errors and print message with line number
trap 'echo "❌ Script failed at line $LINENO. Please check the error above." >&2' ERR

# ----------------- Project Setup -----------------
echo "🔧 Creating Vite + React frontend..."
read -p "Enter project name: " project_name

# Create root folder
mkdir "$project_name"
cd "$project_name"

# ----------------- Frontend Setup -----------------
echo "📁 Setting up frontend..."
mkdir client && cd client

npm create vite@latest . -- --template react
npm install
npm install -D tailwindcss postcss autoprefixer @tailwindcss/postcss

# ✅ Manually create Tailwind and PostCSS config files
echo "✅ Creating Tailwind and PostCSS config files..."

# tailwind.config.js
cat > tailwind.config.js <<EOL
/** @type {import('tailwindcss').Config} */
export default {
    content: [
      "./index.html",
      "./src/**/*.{js,jsx,ts,tsx}",
    ],
    theme: {
      extend: {},
    },
    plugins: [],
};
EOL

# postcss.config.js
cat > postcss.config.js <<EOL
import tailwindcssPostcss from "@tailwindcss/postcss";
import autoprefixer from "autoprefixer";

export default {
  plugins: [tailwindcssPostcss, autoprefixer],
};
EOL

# Create index.css with import
cat > src/index.css <<EOL
@import "tailwindcss";
EOL

# Add .gitignore to frontend
cat > .gitignore <<EOL
node_modules/
dist/
.env
.env.local
.DS_Store
EOL

cd ..

# ----------------- Backend Setup -----------------
echo "🛠 Setting up backend with folder structure and configs..."
mkdir server && cd server

# Initialize npm and install dependencies
if npm init -y; then
  echo "📦 Installing backend packages..."
  npm install express cors dotenv mongoose
  npm install --save-dev nodemon
else
  echo "❌ npm init failed."
  exit 1
fi

# Add type module at top
sed -i '1s/{/{\n  "type": "module",/' package.json

# Add nodemon start script under scripts block
sed -i '/"scripts": {/a \    "start": "nodemon index.js",' package.json

# Create folder structure
mkdir routes models configs utilities Controllers middlewares

# MongoDB config file
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

# Basic server file
cat > index.js <<EOL
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
dotenv.config();

import connectDB from './configs/db.js';

const app = express();
app.use(cors());
app.use(express.json());

connectDB();

app.get('/', (req, res) => {
  res.send('API is working!');
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(\`Server running on port \${PORT}\`));
EOL

# .env for backend
cat > .env <<EOL
PORT=5000
DB_URI=mongodb://localhost:27017/${project_name}
EOL

# Backend .gitignore
cat > .gitignore <<EOL
node_modules/
.env
.DS_Store
EOL

# nodemon config
cat > nodemon.json <<EOL
{
  "watch": ["index.js", "routes", "models", "configs", "utilities", "Controllers"],
  "ext": "js,json",
  "ignore": ["node_modules/"],
  "exec": "node index.js"
}
EOL

cd ..

# ----------------- Done -----------------
echo "🎉 $project_name created with Vite + Tailwind + Express!"
echo "🗃️  .gitignore files have been added to both client/ and server/"