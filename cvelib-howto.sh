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
		statPerms='stat -c %OLp'
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

pause()
{
	read -sn1
}

run_wait()
{
	if [ "$2" == 'c' ]; then
		pause
		clear
	fi
	echo -n "\$ "
	${bold}
	echo "$1"
	${reset}
	while read -srn1 key; do
		if [ "$key" = 'r' ]; then
			eval "$1"
			echo
			return
		elif [ "$key" = 's' ]; then
			echo "Skipping command"
			echo
			return
		fi
	done
}

run_wait2()
{
	echo -n "\$ "
	${bold}
	echo "$1"
	${reset}
	while read -srn1 key; do
		if [ "$key" = 'r' ]; then
			eval "$1"
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
echo "Reading CVE_API_KEY from $cveAPIKeys..."
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
echo "# This script will clone the cvelib GitHub repository from the current"
echo "# directory (./cvelib)."
echo "#"
pause

#
# Versions of some things
#
clear
echo "#"
echo "# 1. Versions of some things"
echo "#"
echo
run_wait "bash --version"
run_wait "python -V"
# actual check for Python 3
python -V | grep -q 'Python 3.'
if [ $? != 0 ]; then
	echo "cvelib requires Python 3."
	echo
	exit 94
fi
run_wait "git --version"
pause

#
# Install cvelib
#
clear
echo "#"
echo "# 2. Install cvelib, configure environment"
echo "#"
echo
run_wait "git clone https://github.com/RedHatProductSecurity/cvelib.git"
run_wait "cd cvelib"
run_wait "pwd"
echo "# Using venv (Python 3.6+), venv is not necessary"
#run_wait "python3 -m venv venv"
run_wait "python -m venv venv"
run_wait "source venv/bin/activate"
run_wait "pip install --upgrade pip"
run_wait "pip install -e ."
run_wait "which cve"
run_wait "export CVE_ENVIRONMENT="$CVE_ENVIRONMENT""
run_wait "export CVE_USER="$CVE_USER""
run_wait "export CVE_ORG="$CVE_ORG""
run_wait "export CVE_API_KEY=************************************"
export CVE_API_KEY="$s_CVE_API_KEY"
run_wait "cve --help | less"
pause

clear
echo "#"
echo "# 3. User management"
echo "#"
echo
run_wait "cve org"
run_wait "cve org users"
run_wait "cve user create --help" c
run_wait "cve user create --username $oldUserID --name-first $oldUserNameFirst --name-last $oldUserNameLast" c
run_wait "cve user --username $oldUserID"
run_wait "cve user update --help" c
run_wait "cve user update --username $oldUserID --name-first $newUserNameFirst" c
run_wait "cve user --username $oldUserID"
run_wait "cve user update --username $oldUserID --new-username $newUserID"
run_wait "cve user --username $newUserID"
run_wait "cve user update --username $newUserID --add-role ADMIN"
run_wait "cve user --username $newUserID"
run_wait "cve user update --username $newUserID --remove-role ADMIN"
run_wait "cve user --username $newUserID"
run_wait "cve user update --username $newUserID --mark-inactive"
run_wait "cve user --username $newUserID"
run_wait "cve user update --username $newUserID --mark-active"
run_wait "cve user --username $newUserID"
pause

clear
echo "#"
echo "# 4. Reservation"
echo "#"
echo
run_wait "cve list --help"
run_wait "cve list" c
run_wait "cve list --state rejected" c
run_wait "cve list --state published" c
run_wait "cve list --state reserved" c
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
run_wait "cve reserve --raw | tee $reserveTemp"
newID=$(cat $reserveTemp | python -c 'import json,sys;cve=json.load(sys.stdin);print(cve["cve_ids"][0]["cve_id"])')
run_wait "cve list | grep $newID" c
pause

clear
echo "#"
echo "# 5. Publication"
echo "#"
echo
set -x
run_wait2 "cve publish $newID --json '{"affected":[{"versions":[{"version":"0","status":"affected","lessThan":"1.0.3","versionType":"semver"}],"product":"Software","vendor":"Example"}],"descriptions":[{"lang":"en","value":"Example Software prior to 1.0.3 has a vulnerability, using ${0}, this is ${newID}."}],"providerMetadata":{"orgId":"77e550a0-813d-44aa-8a55-a59814101335","shortName":"Paleozoic"},"references":[{"url":"https://www.example.com/security/EA-1234.html","name":"Example Security Advisory EA-1234"}]}'"
run_wait "cve list --state published | grep $newID"
run_wait "cve show $newID"
run_wait "cve show --show-record $newID | less"
run_wait2 "cve publish $newID --json '{"affected":[{"versions":[{"version":"0","status":"affected","lessThan":"1.0.3","versionType":"semver"}],"product":"Software","vendor":"Example"}],"descriptions":[{"lang":"en","value":"Example Software prior to 1.0.3 has a vulnerability, using ${0}, this is ${newID}, with a recent update."}],"providerMetadata":{"orgId":"77e550a0-813d-44aa-8a55-a59814101335","shortName":"Paleozoic"},"references":[{"url":"https://www.example.com/security/EA-1234.html","name":"Example Security Advisory EA-1234"}]}'"
run_wait "cve show --show-record $newID | less"
pause

deactivate
echo "Fin"
echo

exit 0
