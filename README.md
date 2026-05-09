# dotfiles
Personal dot configuration files


## Shell Profiles
Similar prompt configuration and colours for both bash and zsh. ZSH profile best used with oh-my-zsh and plugins.

```terminal
┌──(user@pcname)-[/path]
└─$
```

ZSH
[.zshrc](.zshrc)

BASH PROFILE
[.bashrc](.bashrc)


```terminal
bash -c '
[ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.bak
[ -f ~/.bashrc ] && cp ~/.bashrc ~/.bashrc.bak

curl -fsSL https://raw.githubusercontent.com/bradsec/dotfiles/main/.zshrc -o ~/.zshrc &&
curl -fsSL https://raw.githubusercontent.com/bradsec/dotfiles/main/.bashrc -o ~/.bashrc
'
```
