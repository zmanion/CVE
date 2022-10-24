# cvelib-howto

Scripts to demonstrate [cvelib](https://github.com/RedHatProductSecurity/cvelib) in bash and Windows cmd environments.

Copy `cvelib.conf` and `cvelib-howto.conf` to

- bash: `$HOME/.config`
- Windows cmd: `%USERPROFILE%\.config`

Edit the files to your liking, `cvelib.conf` will contain your secret CVE Services API key,  protect it appropriately.

In Windows cmd, you probably want to run `cmd /c cvelib-howto.cmd` to keep a command prompt open when the script exits.

The scripts check for some basic requirements (like git and Python 3), check and load configuration files, then run a series of cvelib commands. In most cases, press 'r' to run the proposed command, 's' to skip, and '2' to quit.
