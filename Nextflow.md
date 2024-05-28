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
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
VER=24.04.1
mkdir -p $APPDIR/$VER/bin
cd $APPDIR/$VER
wget https://github.com/nextflow-io/nextflow/releases/download/v${VER}/nextflow-${VER}-all
mv nextflow-${VER}-all bin/nextflow
chmod 775 bin/nextflow
mkdir -p $MODROOT/$APP/modulefiles/
cd $MODROOT/$APP/modulefiles/
cat <<'__END__' > $VER.lua
-- Default settings
local modroot    = "/apps/unit/BioinfoUgrp/Other"
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

nf-core
=======

Python package with helper tools for the nf-core community.

https://bioconda.github.io/recipes/nf-core/README.html

As a convenience, the [pytest-workflow](https://pytest-workflow.readthedocs.io/) package is also installed.

Installation on deigo
---------------------

See also <https://groups.oist.jp/scs/install-software-your-unit>.

### Stable versions from bioconda

To install a new latest version, update the `VER` variable below and run the commands.

```
ml purge
ml bioinfo-ugrp-modules Nextflow2
APP=nf-core
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
VER=2.14.1
mkdir -p $APPDIR
cd $APPDIR
curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh -b -p $APPDIR/$VER
cd $VER
./bin/conda config --add channels defaults
./bin/conda config --add channels bioconda
./bin/conda config --add channels conda-forge
./bin/conda install -y $APP=$VER
./bin/conda install -y pytest-workflow
mkdir -p $MODROOT/$APP/modulefiles/
cd $MODROOT/$APP/modulefiles/
cat <<'__END__' > $VER.lua
-- Default settings
local modroot    = "/apps/unit/BioinfoUgrp/Other"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())
-- setenv("Nextflow_MOD_HOME", apphome)
-- setenv("Nextflow_MOD_VERSION", appversion)

-- Package information
whatis("Name: "..appname)
whatis("Version: "..appversion)
whatis("URL: ".."https://bioconda.github.io/recipes/nf-core/README.html")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."pipeline, SLURM")
whatis("Description: ".." Python package with helper tools for the nf-core community.")

help([[nf-core tools installed with bioconda

See https://nf-co.re/ for help.]])

-- Package settings
depends_on("singularity")
prepend_path("PATH", apphome.."/bin")
depends_on("Nextflow2")
__END__
```

### Dev versions from GitHub

Development versions are provided "as is",
with an arbitrary version number to not interfere with stable versions.

```
NFMODULE=Nextflow/21.10.6  # Change the LUA file too !!
ml bioinfo-ugrp-modules $NFMODULE
APP=nf-core
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
VER=0.dev_`date -u +%F`
mkdir -p $APPDIR
cd $APPDIR
curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh -b -p $APPDIR/$VER
cd $VER
./bin/conda config --add channels defaults
./bin/conda config --add channels bioconda
./bin/conda config --add channels conda-forge
./bin/conda install -y pytest-workflow
PYTHONUSERBASE=$(pwd) ./bin/pip install --upgrade --force-reinstall git+https://github.com/nf-core/tools.git@dev
mkdir -p $MODROOT/$APP/modulefiles/
cd $MODROOT/$APP/modulefiles/
cat <<'__END__' > $VER.lua
-- Default settings
local modroot    = "/apps/unit/BioinfoUgrp/Other"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())
-- setenv("Nextflow_MOD_HOME", apphome)
-- setenv("Nextflow_MOD_VERSION", appversion)

-- Package information
whatis("Name: "..appname)
whatis("Version: "..appversion)
whatis("URL: ".."https://bioconda.github.io/recipes/nf-core/README.html")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."pipeline, SLURM")
whatis("Description: ".." Python package with helper tools for the nf-core community.")

help([[nf-core tools (development version) installed with pip3 from GitHub

See https://github.com/nf-core/tools for help.]])

-- Package settings
depends_on("singularity")
depends_on("Nextflow2")
prepend_path("PATH", apphome.."/bin")
prepend_path("PYTHONPATH", apphome.."/lib/python3.9/site-packages")
__END__
```
