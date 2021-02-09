#!/bin/bash -e
ml singularity
APP=$1
DEBVERSION=10.7
MODROOT=/apps/unit/BioinfoUgrp/DebianMed/$DEBVERSION
DEBMEDIMAGE=$MODROOT/DebianMed_$DEBVERSION.sif
APPDIR=$MODROOT/modules/$APP
VER=$(singularity exec $DEBMEDIMAGE dpkg-query -W -f='${Version}' $APP)
mkdir -p $APPDIR/$VER
cd $APPDIR/$VER
mkdir -p bin
for prog in $($DEBMEDIMAGE dpkg -L $APP | grep /bin/ | xargs basename -a)
do
cat <<__END__ > bin/$prog
#!/bin/sh
LC_ALL=C singularity exec $DEBMEDIMAGE $prog "\$@" 
__END__
chmod 775 bin/$prog
done
cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<__END__ > $APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package information
whatis("Name: "..appname)
whatis("Version: "..appversion)
whatis("URL: ".."https://github.com/oist/BioinfoUgrp")
whatis("Category: ".." bioinformatics")
whatis("Keywords: ".." Bioinformatics, Debian")
whatis("Description: ".." Module automatically generated by the Bioinfo user group.")

help([[This module runs from Singularity image of Debian Med.
Please contact the Bioinfo user group for details.]])

-- Package settings
depends_on("singularity")
prepend_path("PATH", apphome.."/bin")
__END__
