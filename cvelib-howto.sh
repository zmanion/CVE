#!/usr/bin/env bash

#
# Configuration
#
CVE_ENVIRONMENT=test
CVE_USER=zmanion@protonmail.com
CVE_ORG=Paleozoic
CVE_API_KEY=

# format of file containing API key:
# ${environment}:${key}
# e.g.,
# test:1234567890abcde
# production:43434343434343
cvecreds=~/.cve

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
	echo -n "\$ "
	${bold}
	echo "$1"
	${reset}
	while read -srn1 key; do
		if [ "$key" = 'r' ]; then
			$1
			echo
			return
		elif [ "$key" = 's' ]; then
			echo "Skipping command"
			echo
			return
		fi
	done
}

echo "Reading CVE_API_KEY..."
if [ $(stat -f %u ${cvecreds}) != $(id -u) ]; then
	echo "$cvecreds not owned by current user."
	echo
	exit 90
fi
if [ $(stat -f "%OMp%OLp" ${cvecreds}) != '0600' ]; then
	echo "$cvecreds file permissions are not 0600."
	echo
	exit 91
fi
CVE_API_KEY=$(grep "$CVE_ENVIRONMENT" "$cvecreds" | cut -d: -f2)
sleep 1

clear
echo "#"
echo "# 1. Example script and commands to install, configure, and demonstrate cvelib."
echo "#"
echo "# Press 'r' to run the proposed command, 's' to skip."
echo "#"
echo "# You will need the following information:"
echo "#"
echo "# CVE_ENVIRONMENT"
echo "# CVE_USER"
echo "# CVE_ORG"
echo "# CVE_API_KEY"
echo "#"
pause

#
# Versions of some things
#
echo
echo "#"
echo "# 2. Versions of some things"
echo "#"
echo
run_wait "bash --version"
run_wait "python -V"
run_wait "jq -V"
run_wait "git --version"
pause

#
# Install cvelib
#
echo "#"
echo "# 3. Install cvelib"
echo "#"
echo
run_wait "git clone https://github.com/RedHatProductSecurity/cvelib.git"
run_wait "cd cvelib"
run_wait "pwd"
run_wait "git checkout cve-services-2.1.0"

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
run_wait "export CVE_API_KEY="$CVE_API_KEY""

run_wait "cve --help"
pause

echo
echo "#"
echo "# 4. User management"
echo "#"
echo
run_wait "cve org"
run_wait "cve org users"
run_wait "cve user create --help"


run_wait "cve user create --username fu@example.com --name-first Fu --name-last Bar"
run_wait "cve user --username fu@example.com"
run_wait "cve user update --help"
run_wait "cve user update --username foo@example.com --name-first Foo"
run_wait "cve user update --username fu@example.com --new-username foo@example.com"
run_wait "cve user --username foo@example.com"
run_wait "cve user update --username foo@example.com --add-role ADMIN"
run_wait "cve user --username foo@example.com"
run_wait "cve user update --username foo@example.com --remove-role ADMIN"
run_wait "cve user --username foo@example.com"
run_wait "cve user update --username foo@example.com --mark-inactive"
run_wait "cve user --username foo@example.com"
run_wait "cve user update --username foo@example.com --mark-active"
run_wait "cve user --username foo@example.com"
pause

echo "#"
echo "# 5. Reservation"
echo "#"
echo
run_wait "cve list --help"
run_wait "cve list"
run_wait "cve list --state rejected"
run_wait "cve list --state published"
run_wait "cve list --state reserved"
pause

echo "N.B. API changes from 1.1 to 2.1 include:"
echo "  'reject' --> 'rejected'"
echo "  'public' --> 'published'"
echo
pause

reserveTemp=$(mktemp)
trap 'rm -f "$reserveTemp"' EXIT
run_wait "cve reserve --raw | tee $reserveTemp" 
newID=$(cat $reserveTemp | jq -r '.cve_ids[0].cve_id'))

run_wait "cve list"
run_wait "cve list | grep $newID"

echo "#"
echo "# 5. Publication"
echo "#"
echo
run_wait "cve list"
run_wait "cve publish $newID --json '{"affected":[{"versions":[{"version":"0","status":"affected","lessThan":"1.0.3","versionType":"semver"}],"product":"Software","vendor":"Example"}],"descriptions":[{"lang":"en","value":"Example Software prior to 1.0.3 has a vulnerability, using cvelib-howto.sh, this is $newID"}],"providerMetadata":{"orgId":"77e550a0-813d-44aa-8a55-a59814101335","shortName":"Paleozoic"},"references":[{"url":"https://www.example.com/security/EA-1234.html","name":"Example Security Advisory EA-1234"}]}'"
run_wait "cve list --state-published"
run_wait "cve list --state-published | grep $newID"

deactivate
echo "Fin"
echo

exit 0
