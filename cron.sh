# m h  dom mon dow   command
@reboot root /usr/sbin/ntpd -n
# reinicio semanal
* 6 * * 0 /sbin/shutdown -r now
# reinicio puntual
# 00 6 * * * /usr/bin/bash reboot.sh
# Borrado de docker
0 3 * * * /usr/bin/docker system prune -f
