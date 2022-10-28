#!/usr/bin/env bash

#
# A script to demonstrate cvelib, much hackery to support flow
# during a live presentation and to both display and execute
# shell commands correctly.
#
# https://github.com/RedHatProductSecurity/cvelib
#

#
# config files
#
cvelibConf=~/.config/cvelib.conf
cvelibHowToConf=~/.config/cvelib-howto.conf

#
# Functions
#

error()
{
	echo
	echo "Error: $1 ($2)"
	#echo
	exit $2
}

# when eval is on, call display/execute fuctions with "quoted command and args"
evalOn()
{
	_eval=eval
}

# when eval is off, call display/execute fuctions with no quoted command and args
evalOff()
{
	_eval=
}

pause()
{
	while read -srn1 key; do
		if [ "$key" = 'r' ]; then
			return
		elif [ "$key" = 'q' ]; then
			echo
			echo "Quitting"
			echo
			exit 1
		fi
	done
}

pauseClear()
{
	pause
	clear
	show "$@"
}

show()
{
	echo -n "\$ "
	${bold}
	echo "$@"
	${reset}
	runSkip "$@"
}

runSkip()
{
	while read -srn1 key; do
		if [ "$key" = 'r' ]; then
			$_eval "$@"
			echo
			return
		elif [ "$key" = 's' ]; then
			echo "Skipping command"
			echo
			return
		elif [ "$key" = 'q' ]; then
			echo
			echo "Quitting"
			echo
			exit 1
		fi
	done
}

#
# Try to be cross-platform
#
# https://github.com/dylanaraps/neofetch/issues/433
#
case $OSTYPE in
	linux* )
		statUser='stat -c %u'
		statPerms='stat -c %a'
	;;
	darwin* )
		statUser='stat -f %u'
		statPerms='stat -f %OLp'
	;;
	cygwin* )
		statCmd='stat -c'
	;;
	FreeBSD )
		statCmd='stat -f'
	;;
	* )
		statCmd='stat -c'
esac

#
# Text formatting, often works
#
reset='tput sgr0'
bold='tput bold'

#
# Intro material
#
clear
echo "#"
echo "# Example script and commands to install, configure, and demonstrate cvelib."
echo "#"
echo "# Type 'r' to run the proposed command or advance the script."
echo "# Type 's' to skip the prposed command."
echo "# Type 'q' to quit."
echo "#"
echo "# Configuration for cvelib, including the private API key, is read from"
echo "# ${cvelibConf}."
echo "#"
echo "# Configuration for cvelib-howto.sh is read from"
echo "# ${cvelibHowToConf}."
echo "#"
echo "# This script will clone the cvelib GitHub repository from the current"
echo "# directory ($(pwd)/cvelib)."
echo "#"
pause

#
# Check ownership and permissions then read cvelib config
#
echo
echo "Reading ${cvelibConf}"
if [ $(${statUser} ${cvelibConf}) != $(id -u) ]; then
	error "${cvelibConf} not owned by current user." 80
fi
if [ $(${statPerms} ${cvelibConf}) != '600' ]; then
	error "${cvelibConf} file permissions are not 600." 81
fi
source "${cvelibConf}" || error "Problem reading ${cvelibConf}" 9{$?}
_CVE_API_KEY=$CVE_API_KEY
pause

#
# Read cvelib-howto config
#
echo
echo "Reading ${cvelibHowToConf}"
source "${cvelibHowToConf}" || error "Problem reading ${cvelibHowToConf}" 9{$?}
pause

#
# Versions of some things
#
clear
echo "#"
echo "# 1. Versions of some things"
echo "#"
echo
pause
show bash --version
show python -V
# check for Python 3
python -V | grep -q 'Python 3.'
if [ $? != 0 ]; then
	echo "cvelib requires Python 3."
	echo
	exit 94
fi
show git --version
pause

#
# Install cvelib
#
clear
echo "#"
echo "# 2. Install cvelib, configure environment"
echo "#"
echo
pause
show git clone https://github.com/RedHatProductSecurity/cvelib.git
show cd cvelib
show pwd
echo # Using venv (Python 3.6+), venv is not necessary"
#show python3 -m venv venv
show python -m venv venv
show source venv/bin/activate
show pip install --upgrade pip
show pip install -e .
show which cve
show export CVE_ENVIRONMENT="$CVE_ENVIRONMENT"
show export CVE_USER="$CVE_USER"
show export CVE_ORG="$CVE_ORG"
show export CVE_API_KEY="************************************"
CVE_API_KEY="$_CVE_API_KEY"
show cve --help
pause

#
# User management
#
clear
echo "#"
echo "# 3. User management"
echo "#"
echo
pause
show cve org
show cve org users
pauseClear cve user create --help
pauseClear cve user create --username $oldUserID --name-first $oldUserNameFirst --name-last $oldUserNameLast
cve user reset-key --username $oldUserID >/dev/null 2>&1
show cve user --username $oldUserID
pauseClear cve user update --help
pauseClear cve user update --username $oldUserID --name-first $newUserNameFirst
show cve user --username $oldUserID
show cve user update --username $oldUserID --new-username $newUserID
show cve user --username $newUserID
show cve user update --username $newUserID --add-role ADMIN
show cve user --username $newUserID
show cve user update --username $newUserID --remove-role ADMIN
show cve user --username $newUserID
show cve user update --username $newUserID --mark-inactive
show cve user --username $newUserID
show cve user update --username $newUserID --mark-active
show cve user --username $newUserID
show cve user reset-key --username $newUserID
cve user reset-key --username $newUserID >/dev/null 2>&1
pause

#
# Reservation
#
clear
echo "#"
echo "# 4. Reservation"
echo "#"
echo
pause
show cve list --help
pauseClear cve list
pauseClear cve list --state rejected
pauseClear cve list --state published
pauseClear cve list --state reserved
pause
clear
echo "N.B. API changes from 1.1 to 2.1 include:"
echo "  'reject' --> 'rejected'"
echo "  'public' --> 'published'"
echo
pause
clear
reserveTemp=$(mktemp)
trap 'rm -f "$reserveTemp"' EXIT
evalOn # needed to pass pipe to function
show "cve reserve --raw | tee $reserveTemp"
evalOff
newID=$(cat $reserveTemp | python -c 'import json,sys;cve=json.load(sys.stdin);print(cve["cve_ids"][0]["cve_id"])')
pauseClear cve show $newID
pause

#
# Publication
#
# Hacks to display exactly what will be executed
# Passing quotes, spaces, braces to a bash function is tricky
#
clear
echo "#"
echo "# 5. Publication"
echo "#"
echo
pause

#
# publish with inline JSON
#
_sq="'"
echo -n "\$ "
${bold}
echo cve publish $newID --cve-json $_sq'{"affected":[{"versions":[{"version":"0","status":"affected","lessThan":"1.0.3","versionType":"semver"}],"product":"Software","vendor":"Example"}],"descriptions":[{"lang":"en","value":"Example Software prior to 1.0.3 has a vulnerability, using cvelib, this is '${newID}'."}],"references":[{"url":"https://www.example.com/security/EA-1234.html","name":"Example Security Advisory EA-1234"}]}'$_sq
${reset}
runSkip cve publish $newID --cve-json '{"affected":[{"versions":[{"version":"0","status":"affected","lessThan":"1.0.3","versionType":"semver"}],"product":"Software","vendor":"Example"}],"descriptions":[{"lang":"en","value":"Example Software prior to 1.0.3 has a vulnerability, using cvelib, this is '${newID}'."}],"references":[{"url":"https://www.example.com/security/EA-1234.html","name":"Example Security Advisory EA-1234"}]}'
show cve show $newID
pauseClear cve show --show-record $newID
pause
clear
echo -n "\$ "
${bold}
echo cve publish $newID --cve-json $_sq'{"affected":[{"versions":[{"version":"0","status":"affected","lessThan":"1.0.3","versionType":"semver"}],"product":"Software","vendor":"Example"}],"descriptions":[{"lang":"en","value":"Example Software prior to 1.0.3 has a vulnerability, using cvelib, this is '${newID}', with a recent update."}],"references":[{"url":"https://www.example.com/security/EA-1234.html","name":"Example Security Advisory EA-1234"}]}'$_sq
${reset}
runSkip cve publish $newID --cve-json '{"affected":[{"versions":[{"version":"0","status":"affected","lessThan":"1.0.3","versionType":"semver"}],"product":"Software","vendor":"Example"}],"descriptions":[{"lang":"en","value":"Example Software prior to 1.0.3 has a vulnerability, using cvelib, this is '${newID}', with a recent update."}],"references":[{"url":"https://www.example.com/security/EA-1234.html","name":"Example Security Advisory EA-1234"}]}'
pauseClear cve show --show-record $newID

#
# publish with JSON file
#
publishTemp=$(mktemp)
trap 'rm -f "$publishTemp"' EXIT
cat <<-EOM > $publishTemp
{
    "affected": [
        {
            "product": "Software",
            "vendor": "Example",
            "versions": [
                {
                    "lessThan": "1.0.3",
                    "status": "affected",
                    "version": "0",
                    "versionType": "semver"
                }
           ]
        }
    ],
    "descriptions": [
        {
            "lang": "en",
            "value": "Example Software prior to 1.0.3 has a vulnerability, using cvelib, this is $newID, with another update, using --cve-json-file $publishTemp."
        }
    ],
    "references": [
        {
            "name": "Example Security Advisory EA-1234",
            "url": "https://www.example.com/security/EA-1234.html"
        }
    ]
}
EOM
pauseClear cat $publishTemp
pauseClear cve publish $newID --cve-json-file $publishTemp
pauseClear cve show --show-record $newID

pause
show source venv/bin/deactivate

#
# done
#
clear
echo
echo "Thanks Red Hat!"
echo
echo "<https://github.com/RedHatProductSecurity/cvelib>"
echo
echo "<https://github.com/zmanion/CVE>"
echo
echo "Fin"
echo

exit 0
