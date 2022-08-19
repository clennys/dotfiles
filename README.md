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

```bash
# Run single role
ansible localhost -m include_role -a name=<ROLE_NAME> --ask-become-pass

```

- [ ] Spotify
- [ ] Add Pip install (ueberzug, autorandr)
