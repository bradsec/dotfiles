# dotfiles
Personal dot configuration files

```terminal
bash -c '
[ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.bak
[ -f ~/.bashrc ] && cp ~/.bashrc ~/.bashrc.bak

curl -fsSL https://raw.githubusercontent.com/bradsec/dotfiles/main/.zshrc -o ~/.zshrc &&
curl -fsSL https://raw.githubusercontent.com/bradsec/dotfiles/main/.bashrc -o ~/.bashrc
`
```
