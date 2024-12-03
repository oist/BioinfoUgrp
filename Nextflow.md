Nextflow
========

A DSL for data-driven computational pipelines <http://nextflow.io>.

In 2022, _Nextflow_ had a backwards-incompatible change that depreacated an old
syntax called _DSL1_ in favor of the _DSL2_ syntax.  We still provide the old
version `21.10.6` in the `Nextflow` module on _deigo_.  Newer versions are in
the `Nextflow2` module.  To use a _DSL1_ pipeline with the `Nextflow2` module,
pass the `-dsl1` flag to the `nextflow` program.

The `Nextflow2` module also limits the use of memory by setting the environment
variable `NXF_OPTS` to `-Xms500M -Xmx2G`.  Please contact us or open an issue
if you hit the limit.


Installation on deigo
---------------------

See also <https://groups.oist.jp/scs/install-software-your-unit>.

### Release or edge versions from GitHub

Source: https://github.com/nextflow-io/nextflow

```
APP=Nextflow2
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
VER=24.10.2
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
depends_on("java-jdk/14")
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
VER=0.8.4
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
APP=nf-core
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
VER=3.0.2
cd $APPDIR/bin
singularity pull docker://nfcore/tools:3.0.2
mv tools_${VER}.sif nf-core
cat <<"__END__" > pre-commit
#!/bin/sh
singularity exec nf-core pre-commit "$@"
__END__
chmod 775 pre-commit
cd $MODROOT/$APP/modulefiles/
cp 3.0.2.lua ${VER}.lua
```
