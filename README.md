![github](https://img.shields.io/badge/GitHub-000000.svg?style=for-the-badge&logo=GitHub&logoColor=white)
![markdown](https://img.shields.io/badge/Markdown-000000.svg?style=for-the-badge&logo=Markdown&logoColor=white)

# How to Use `create-mern-project` Script Globally

Follow these steps to run the `create-mern-project.sh` script from **any folder** in your system as a global command.

---

## 1. Create a directory for your custom scripts

Create a folder to store your scripts (if it doesn’t already exist):

```bash
mkdir -p ~/.local/bin
```

## 2. Move the script to the custom scripts folder

Move or copy the script to this folder and rename it (optional) to remove the `.sh` extension:

```bash
mv /path/to/create-mern-project.sh ~/.local/bin/create-mern-project
```

## 3. Make the script executable

Run:

```bash
chmod +x ~/.local/bin/create-mern-project
```

## 4. Add the scripts folder to your PATH

Add the following line to your shell configuration file (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then reload the shell config:

```bash
source ~/.bashrc  # or source ~/.zshrc
```

### Run the script from anywhere

Now you can execute the script from any directory using:

```bash
create-mern-project
```
### Notes

To check your PATH, run:

```bash
echo $PATH
```

<p align="center"><a href="https://github.com/hritesh-saha/tw-mern-starter/blob/main/LICENSE"><img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=BSD-3-Clause&logoColor=d9e0ee&colorA=363a4f&colorB=b7bdf8"/></a></p>
