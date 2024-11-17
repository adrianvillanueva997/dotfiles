# Dotfiles

Generally everything is self-managed by stow. The only exception is the `paccache` systemd timer.

```text
/etc/systemd/system/paccache.timer
sudo systemctl enable paccache.timer
```
