# Dotfiles for my Fedora Workstation
- Automation Tool: [Ansible](https://github.com/ansible/ansible)
- Distro: [Fedora](https://alt.fedoraproject.org/)

## Install
```bash
# Manually update the system
sudo dnf update --refresh

# Install git
sudo dnf install git

# Clone dotfiles repo
git clone https://github.com/devnnys/dotfiles.git $HOME/.dotfiles

# Make install script executable
chmod 755 $HOME/.dotfiles/bin/dotfiles

# Run install script
bash $HOME/.dotfiles/bin/dotfiles
```

## TODO
- [ ] Essential dev tools
- [ ] Essential tools for system
- [ ] Programming Languages
- [ ] Language Servers
- [ ] Spotify
- [ ] RPM fusion
- [ ] Create github ssh key
- [ ] Add user to appropriate usergroups
- [ ] Add conditonals to roles
- [ ] Add autorandr role
- [ ] Add Pip install (ueberzug, autorandr)
