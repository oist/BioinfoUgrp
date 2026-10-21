# Installation recipes: Nextflow, nf-test and nf-core tools

User documentation: [Nextflow.md](../Nextflow.md).  General conventions:
[CONTRIBUTING.md](../CONTRIBUTING.md).

Nextflow
========

Installation on deigo
---------------------

See also <https://groups.oist.jp/scs/install-software-your-unit>.

### Release or edge versions from GitHub

Source: https://github.com/nextflow-io/nextflow

```
APP=Nextflow3
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
VER=26.04.7
mkdir -p $APPDIR/$VER/bin
cd $APPDIR/$VER
wget https://github.com/nextflow-io/nextflow/releases/download/v${VER}/nextflow-${VER}-dist
mv nextflow-${VER}-dist bin/nextflow
chmod 775 bin/nextflow
mkdir -p $MODROOT/$APP/modulefiles/
cd $MODROOT/$APP/modulefiles/
cat <<'__END__' > $VER.lua
-- Default settings
local modroot    = "/bucket/BioinfoUgrp/Other"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package information
whatis("Name: "..appname)
whatis("Version: "..appversion)
whatis("URL: ".."https://github.com/nextflow-io/nextflow/releases")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."pipeline, SLURM")
whatis("Description: ".." Data-driven computational pipelines.")

help([[Nextflow version downloaded from GitHub

See https://www.nextflow.io/ for help.]])

-- Package settings
depends_on("singularity")
depends_on("java-jdk/17")
setenv("NXF_OPTS", "-Xms500M -Xmx2G")
prepend_path("PATH", apphome.."/bin")
__END__
```

nf-test
=======

Testing framework for Nextflow pipelines (<https://www.nf-test.com/>).

Installation on deigo
---------------------

```
APP=nf-test
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
VER=0.9.5
mkdir -p $APPDIR/$VER/bin
cd $APPDIR/$VER
wget https://github.com/askimed/nf-test/releases/download/v${VER}/nf-test-${VER}.tar.gz
pushd bin
tar xvfz ../nf-test-${VER}.tar.gz
chmod 775 nf-test
chmod 664 nf-test.jar
popd
rm nf-test-${VER}.tar.gz
cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER.lua
-- Default settings
local modroot    = "/bucket/BioinfoUgrp"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package information
whatis("Name: "..appname)
whatis("Version: "..appversion)
whatis("URL: ".."https://github.com/askimed/nf-test/releases")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."pipeline, SLURM")
whatis("Description: ".."Testing framework for Nextflow pipelines.")

help([[nf-test version downloaded from GitHub

See https://www.nf-test.com/ for help.]])

-- Package settings
depends_on("Nextflow2")
prepend_path("PATH", apphome.."/bin")
__END__
```

nf-core
=======

Python package with helper tools for the nf-core community (<https://nf-co.re/docs/nf-core-tools>).

To install a new latest version, update the `VER` variable below and run the commands.

```
ml purge
ml bioinfo-ugrp-modules Nextflow2
ml python/3.11.4
APP=nf-core
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
VER=4.1.0
mkdir -p $APPDIR/$VER
cd $APPDIR/$VER
PYTHONUSERBASE=$(pwd) pip3 install --no-warn-script-location --user $APP 
PYTHONUSERBASE=$(pwd) pip3 install --no-warn-script-location --user pre-commit
cd $MODROOT/$APP/modulefiles/
cp 4.0.2.lua ${VER}.lua
```

Contents of `4.0.2.lua`:

```
-- Default settings
local modroot    = "/bucket/BioinfoUgrp/Other"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())
-- setenv("Nextflow_MOD_HOME", apphome)
-- setenv("Nextflow_MOD_VERSION", appversion)

-- Package information
whatis("Name: "..appname)
whatis("Version: "..appversion)
whatis("URL: ".."https://nf-co.re/docs/nf-core-tools")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."pipeline, SLURM")
whatis("Description: ".." Python package with helper tools for the nf-core community.")

help([[nf-core tools installed with pip

See https://nf-co.re/ for help.]])

-- Package settings
depends_on("singularity")
prepend_path("PATH", apphome.."/bin")
prepend_path("PYTHONPATH", apphome.."/lib/python3.11/site-packages/")
if not (isloaded("Nextflow2") or isloaded("Nextflow3")) then
    load("Nextflow2")
end
depends_on("python/3.11.4")
depends_on("Other/nf-test")
depends_on("Other/prek")
```
