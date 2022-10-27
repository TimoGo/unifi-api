#!/bin/bash
set -u

terminatescript(){
 echo "$2"
 exit $1
}

source config.txt

test $# = 2 || terminatescript 1 "unifi-api.sh <api_endpoint> <tmp_file>"

if [ ! $# = 2 ]; then
 echo "Usage: $0 <domain> <string>"
 exit $STATE_UNKNOWN
fi


which curl jq &>/dev/null || terminatescript 1 "curl and jq neccessary"

# jq minimum version: 1.6 
echo $(jq --version) |grep jq-0 >/dev/null 2>/dev/null && terminatescript 1 "jq version is too old"
echo $(jq --version) |grep jq-1.[012345] >/dev/null 2>/dev/null && terminatescript 1 "jq version is too old"


cookie=$(mktemp)
curl_cmd="curl -k --tlsv1 --silent --cookie ${cookie} --cookie-jar ${cookie} "

unifi_login() {
    ${curl_cmd} --data "{\"username\":\"$username\", \"password\":\"$password\"}" $baseurl/api/login 
}

unifi_logout() {
    # logout
    ${curl_cmd} $baseurl/logout
}

unifi_api() {
    if [ $# -lt 1 ] ; then
        echo "Usage: $0 <uri> [json]"
        echo "    uri example /stat/sta "
        return
    fi
    uri=$1
    shift
    [ "${uri:0:1}" != "/" ] && uri="/$uri"
    json="$@"
    [ "$json" = "" ] && json="{}"
    ${curl_cmd} --data "$json" $baseurl/api/s/$site$uri
}


loginoutput=$(mktemp)
unifi_login >$loginoutput || terminatescript 2 "Login failed, check credentials or $loginoutput"
test $( cat $loginoutput | jq -r '.meta.rc' ) = "ok" || terminatescript 2 "Login failed, check credentials or $loginoutput"
rm $loginoutput

unifi_api "$1" >$2
test $( cat $2 | jq -r '.meta.rc' ) = "ok" || terminatescript 2 "Problem with API-Endpoint $1 -  see $2"

if ! jq empty $2 2>/dev/null; then
  terminatescript 2 "Problem with API-Endpoint $1 -  see $2"
fi

unifi_logout

