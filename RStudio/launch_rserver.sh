#!/bin/sh -e

RSTUDIO_TEMP=$(mktemp -d -p ~)
trap "{ rm -rf $RSTUDIO_TEMP; }" EXIT

cat <<__DBCONF__ > $RSTUDIO_TEMP/dbconf
provider=sqlite
directory=$RSTUDIO_TEMP/db.sqlite3
__DBCONF__

export RSTUDIO_PASSWORD="`date -R | md5sum | cut -c-16`"

# Taken from https://gitlab.oit.duke.edu/chsi-informatics/containers/singularity-rstudio-base/-/blob/master/port_and_password_1_3.sh
LOWERPORT=50000
UPPERPORT=65535
for RSTUDIO_PORT in $(seq $LOWERPORT $UPPERPORT);
do
    RSTUDIO_PORT="`shuf -i $LOWERPORT-$UPPERPORT -n 1`"
    echo "Testing port: $RSTUDIO_PORT"
    ss -lpn | grep -q ":$RSTUDIO_PORT " || break
done

printf "\n\nRStudio URL:\t\thttp://`hostname -A | cut -f1 -d' '`:${RSTUDIO_PORT}/\n"
printf "\nRStudio Username:\t$USER\n"
printf "RStudio Password:\t$RSTUDIO_PASSWORD\n"
printf "RStudio temporary files:\t$RSTUDIO_TEMP\n"

/usr/lib/rstudio-server/bin/rserver \
	--server-working-dir $RSTUDIO_TEMP \
	--server-data-dir $RSTUDIO_TEMP \
	--database-config-file $RSTUDIO_TEMP/dbconf \
	--server-user=$USER \
	--www-port=$RSTUDIO_PORT \
	--auth-none 0 \
	--auth-pam-helper rstudio_auth
