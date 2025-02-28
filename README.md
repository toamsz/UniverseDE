## Table of Contents
- [what is it](#UniverseDE)
- [Installation](#installation)
- [License](#license)

# UniverseDE
Desktop Environment with mutter purposelly made for BakeryOS,<br />
a Linux Distribution(now) based on fedora in development by PiekarniaEklerki dicodrd community.:
# License
see [GNU GPL3](LICENSE)
# Installation
now only fedora linux installation:<br />
first clone repository<br />
`git clone https://github.com/BakeryOS/UniverseDE`<br />
next you need to go to folder where code it is <br />
`cd UniverseDE`<br />
after that you compile it <br />
`sh build.sh`<br />
now you need to open this file<br />
`nano /usr/share/xsessions/Universe.desktop`<br />
and copy this in <br />
```
[Desktop Entry]
  Name=Universe
  Comment=idk
  Exec=/usr/local/bin/start-universe
  Type=Application
  X-LightDM-DesktopName=universe
```
and save it,<br />
now open <br />
`nano /usr/local/bin/start-universe`<br />
and copy this<br />
```
#!/bin/sh<br />
  mutter &<br />
  exec (path to your Universe.elf)<br />
```

