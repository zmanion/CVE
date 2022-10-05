#!/usr/bin/env bash

#
# Configuration
#
CVE_ENVIRONMENT=test
CVE_USER=zmanion@protonmail.com
CVE_ORG=Paleozoic
CVE_API_KEY=

oldUserID=fu@paleozoic.example.com
oldUserNameFirst=Fu
oldUserNameLast=Bar
newUserID=foo@@paleozoic.example.com
newUserNameFirst=Foo
newUserNameLast="$oldUserNameLast"

# testing
oldUserID=fu@bar.net
oldUserNameFirst=Fum
oldUserNameLast=Ble
newUserID=foo@bar.org
newUserNameFirst=Fume
newUserNTameLast="$oldUserNameLast"

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
# Store secret CVE_API_KEYs elsewhere
# format of file containing API key:
# ${CVE_ENVIRONMENT}:${CVE_API_KEY}
# e.g.,
# test:1234567890abcde
# production:43434343434343
#
# CVE_ENVIRONMENT must be unique
#
cveAPIKeys=~/.cve

#
# Text formatting
#
reset='tput sgr0'
bold='tput bold'

#
# Displaying and executing complex commands correctly is hard
#
_eval=

pause()
{
	read -sn1
}

pause_clear()
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
	run_skip "$@"
}

run_skip()
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
		fi
	done
}

clear
echo "#"
echo "# Example script and commands to install, configure, and demonstrate cvelib."
echo "#"
echo "# Press 'r' to run the proposed command, 's' to skip."
echo "#"
echo "# Configure this script with the following information:"
echo "#"
echo "# CVE_ENVIRONMENT"
echo "# CVE_USER"
echo "# CVE_ORG"
echo "# CVE_API_KEY"
echo "#"
echo "# Secret API keys are read from the file ~/.cve with the format:"
echo "#"
echo "# \${CVE_ENVIRONMENT}:\${CVE_API_KEY}"
echo "# e.g.,"
echo "# test:1234567890abcde"
echo "# production:43434343434343"
echo "#"
echo "# This script will clone the cvelib GitHub repository from the current"
echo "# directory ($(pwd)/cvelib)."
echo "#"
pause

echo
echo "Reading CVE_API_KEY from $cveAPIKeys for $CVE_ENVIRONMENT environment..."
if ! [ -f ${cveAPIKeys} ]; then
	echo "$cveAPIKeys does not exist."
	echo
	exit 92
fi
if [ $(${statUser} ${cveAPIKeys}) != $(id -u) ]; then
	echo "$cveAPIKeys not owned by current user."
	echo
	exit 90
fi
if [ $(${statPerms} ${cveAPIKeys}) != '600' ]; then
	echo "$cveAPIKeys file permissions are not 600."
	echo
	exit 91
fi
s_CVE_API_KEY=$(grep "$CVE_ENVIRONMENT" "$cveAPIKeys" | cut -d: -f2)
if [ -z "$s_CVE_API_KEY" ]; then
	echo "Problem reading \$CVE_API_KEY from $cveAPIKeys."
	echo
	exit 95
fi
sleep 1

#
# Versions of some things
#
clear
echo "#"
echo "# 1. Versions of some things"
echo "#"
echo
show bash --version
show python -V
# actual check for Python 3
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

export CVE_API_KEY="$s_CVE_API_KEY"
show cve --help
#_eval=eval
#show "cve --help | less"
#_eval=
pause

clear
echo "#"
echo "# 3. User management"
echo "#"
echo
show cve org
show cve org users
pause_clear cve user create --help
pause_clear cve user create --username $oldUserID --name-first $oldUserNameFirst --name-last $oldUserNameLast
show cve user --username $oldUserID
pause_clear cve user update --help
pause_clear cve user update --username $oldUserID --name-first $newUserNameFirst
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
pause

clear
echo "#"
echo "# 4. Reservation"
echo "#"
echo
show cve list --help
pause_clear cve list
pause_clear cve list --state rejected
pause_clear cve list --state published
pause_clear cve list --state reserved
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
_eval=eval
show "cve reserve --raw | tee $reserveTemp"
_eval=
newID=$(cat $reserveTemp | python -c 'import json,sys;cve=json.load(sys.stdin);print(cve["cve_ids"][0]["cve_id"])')
pause_clear cve show $newID
pause

clear
echo "#"
echo "# 5. Publication"
echo "#"
echo

_sq="'"
echo -n "\$ "
${bold}
echo cve publish $newID --cve-json $_sq'{"affected":[{"versions":[{"version":"0","status":"affected","lessThan":"1.0.3","versionType":"semver"}],"product":"Software","vendor":"Example"}],"descriptions":[{"lang":"en","value":"Example Software prior to 1.0.3 has a vulnerability, using cvelib, this is '${newID}'."}],"providerMetadata":{"orgId":"77e550a0-813d-44aa-8a55-a59814101335","shortName":"Paleozoic"},"references":[{"url":"https://www.example.com/security/EA-1234.html","name":"Example Security Advisory EA-1234"}]}'$_sq
${reset}
run_skip cve publish $newID --cve-json '{"affected":[{"versions":[{"version":"0","status":"affected","lessThan":"1.0.3","versionType":"semver"}],"product":"Software","vendor":"Example"}],"descriptions":[{"lang":"en","value":"Example Software prior to 1.0.3 has a vulnerability, using cvelib, this is '${newID}'."}],"providerMetadata":{"orgId":"77e550a0-813d-44aa-8a55-a59814101335","shortName":"Paleozoic"},"references":[{"url":"https://www.example.com/security/EA-1234.html","name":"Example Security Advisory EA-1234"}]}'
show cve show $newID
pause_clear cve show --show-record $newID
echo -n "\$ "
${bold}
echo cve publish $newID --cve-json $_sq'{"affected":[{"versions":[{"version":"0","status":"affected","lessThan":"1.0.3","versionType":"semver"}],"product":"Software","vendor":"Example"}],"descriptions":[{"lang":"en","value":"Example Software prior to 1.0.3 has a vulnerability, using cvelib, this is '${newID}', with a recent update."}],"providerMetadata":{"orgId":"77e550a0-813d-44aa-8a55-a59814101335","shortName":"Paleozoic"},"references":[{"url":"https://www.example.com/security/EA-1234.html","name":"Example Security Advisory EA-1234"}]}'$_sq
${reset}
run_skip cve publish $newID --cve-json '{"affected":[{"versions":[{"version":"0","status":"affected","lessThan":"1.0.3","versionType":"semver"}],"product":"Software","vendor":"Example"}],"descriptions":[{"lang":"en","value":"Example Software prior to 1.0.3 has a vulnerability, using cvelib, this is '${newID}', with a recent update."}],"providerMetadata":{"orgId":"77e550a0-813d-44aa-8a55-a59814101335","shortName":"Paleozoic"},"references":[{"url":"https://www.example.com/security/EA-1234.html","name":"Example Security Advisory EA-1234"}]}'
pause_clear cve show --show-record $newID
pause

deactivate
echo "Fin"
echo

exit 0
