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


echo "🎉 $project_name created with Vite + Tailwind!"
echo "🗃️  .gitignore file has been added to $project_name"