#!/bin/bash
set -u

# purpose: 
# find out whether someone is present (eg wifi-MAC of cellphone) or unpresent
# to switch on/off thermostats.

# -----------------------------------

cprotate() {
#       $1 => source (for cp)
#       $2 => dest (for cp)
#       $3 => number (how many backups)
#       $4 => suffix (name of suffix)

test $# = 4 || return 1
source=$1
dest=$2
number=$3
suffix=$4

# cprotate is a simple bash function with x backups of old files.
# After a few iterations with:
#   "cprotate dummy new 3 old"
# there are these four file:
#   neu         newest copy of dummy
#   neu.old1    older
#   neu.old2    even older
#   neu.old3    oldest copy of dummy

# remove oldest backup if present
test -f $dest.$suffix.${number} && rm $dest.$suffix.${number}

# delete oldest backup:
test -f ${dest}.${suffix}.${number} && rm ${dest}.${suffix}.${number}

for (( c=number; c>1; c-- ))
do
 test -f ${dest}.${suffix}.$((( c-1 ))) && mv ${dest}.$suffix.$((( c-1 ))) ${dest}.${suffix}.$((( c )))
done

# mv file (without suffix) to file.suffix.1
test -f ${dest} && mv $dest ${dest}.${suffix}.1

# cp command
cp $source $dest
}
# -----------------------------------

tmpfile1=$(mktemp)
tmpfile2=$(mktemp)

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
API="${DIR}/unifi-api.sh"

cd $DIR

$API /stat/sta $tmpfile1
cat $tmpfile1 | jq -r '.data[]|.mac'  >$tmpfile2

cprotate $tmpfile2 maclist.txt 5 old

# Thermostat is switched on, when both MACs could not
# be found in all maclist.txt* files:

found=0
for i in maclist.txt*
do
 egrep -e '(60:1d:91:61:xx:yy|f8:0f:f9:dd:xx:yy)' $i &>/dev/null && found=1
done

if [ $found = 0 ]; then
 echo "nobody at home..."
fi



