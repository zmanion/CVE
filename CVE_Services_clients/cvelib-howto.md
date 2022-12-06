# cvelib-howto

Scripts to demonstrate [cvelib](https://github.com/RedHatProductSecurity/cvelib) in bash and Windows cmd environments.

Copy `cvelib.conf.sample` and `cvelib-howto.conf.sample` to

- bash: `$HOME/.config`
- Windows cmd: `%USERPROFILE%\.config`

and rename both files to remove the `'.sample'` extension.

Edit the files to your liking, `cvelib.conf` will contain your secret CVE Services API key,  protect it appropriately. `cvelib-howto.conf` is used to set variables for the user management part of the demonstration.

In Windows cmd, you probably want to run `cmd /c cvelib-howto.cmd` to keep a command prompt open when the script exits.

The scripts check for some basic requirements (like git and Python 3), check and load configuration files, then run a series of cvelib commands. Press 'r' to **r**un the proposed command or advance the script, 's' to **s**kip, and 'q' to **q**uit.
