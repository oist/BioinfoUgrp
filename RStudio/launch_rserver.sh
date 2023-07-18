#!/bin/sh -e

RSTUDIO_TEMP=$(mktemp -d -p ~)
trap "{ rm -rf $RSTUDIO_TEMP; }" EXIT

cat <<__DBCONF__ > $RSTUDIO_TEMP/dbconf
provider=sqlite
directory=$RSTUDIO_TEMP/db.sqlite3
__DBCONF__


export RSTUDIO_PASSWORD=${RSTUDIO_PASSWORD-`date -R | md5sum | cut -c-16`}

if [ -z "$RSTUDIO_PORT" ]
then
	# Taken from https://gitlab.oit.duke.edu/chsi-informatics/containers/singularity-rstudio-base/-/blob/master/port_and_password_1_3.sh
	LOWERPORT=50000
	UPPERPORT=65535
	for RSTUDIO_PORT in $(seq $LOWERPORT $UPPERPORT);
	do
	    RSTUDIO_PORT="`shuf -i $LOWERPORT-$UPPERPORT -n 1`"
	    # echo "Testing port: $RSTUDIO_PORT"
	    ss -lpn | grep -q ":$RSTUDIO_PORT " || break
	done
fi

RSTUDIO_HOST=$(hostname -A | cut -f1 -d' ')
RSTUDIO_HOST=${RSTUDIO_HOST:-localhost}

printf "\nRStudio URL:\t\thttp://${RSTUDIO_HOST}:${RSTUDIO_PORT}/\n"
printf "RStudio Username:\t$USER\n"
printf "RStudio Password:\t$RSTUDIO_PASSWORD\n"
if [ ! $RSTUDIO_HOST = "localhost" ]
then
	printf "\nIf you remote work, you can forward the server to port 1664 on your computer with:\n"
	printf "ssh ${USER}@${RSTUDIO_HOST} -J login.oist.jp,deigo.oist.jp -L 1664:localhost:${RSTUDIO_PORT}\n"
fi
printf "\nYou may need to clean your temporary files by yourself:\n"
printf "RStudio temporary files:\t$RSTUDIO_TEMP\n"
printf "\nThis image will build its packages in the following directory if it exists:\n"
grep ^R_LIBS_USER /etc/R/Renviron.site
printf "\n"

/usr/lib/rstudio-server/bin/rserver \
	--server-working-dir $RSTUDIO_TEMP \
	--server-data-dir $RSTUDIO_TEMP \
	--database-config-file $RSTUDIO_TEMP/dbconf \
	--server-user=$USER \
	--www-port=$RSTUDIO_PORT \
	--auth-none 0 \
	--auth-pam-helper rstudio_auth
