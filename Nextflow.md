Nextflow
========

A DSL for data-driven computational pipelines <http://nextflow.io>

https://github.com/nextflow-io/nextflow

Installation on deigo
---------------------

See also <https://groups.oist.jp/scs/install-software-your-unit>.

### Stable versions from bioconda (preferred)

To install a new latest version, update the `VER` variable below and run the commands.

```
APP=Nextflow
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
VER=21.04.0
mkdir -p $APPDIR
cd $APPDIR
curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh -b -p $APPDIR/$VER
cd $VER
./bin/conda install -y -c bioconda nextflow 
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
whatis("URL: ".."https://bioconda.github.io/recipes/nextflow/README.html")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."pipeline, SLURM")
whatis("Description: ".." Data-driven computational pipelines.")

help([[Nextflow installed with bioconda

See https://www.nextflow.io/ for help.]])

-- Package settings
depends_on("singularity")
prepend_path("PATH", apphome.."/bin")
__END__
```

### Edge versions from GitHub

```
APP=Nextflow
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
VER=21.04.0-edge
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
-- setenv("Nextflow_MOD_HOME", apphome)
-- setenv("Nextflow_MOD_VERSION", appversion)

-- Package information
whatis("Name: "..appname)
whatis("Version: "..appversion)
whatis("URL: ".."https://github.com/nextflow-io/nextflow/releases")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."pipeline, SLURM")
whatis("Description: ".." Data-driven computational pipelines.")

help([[Nextflow edge version downloaded from GitHub

See https://www.nextflow.io/ for help.]])

-- Package settings
depends_on("singularity")
prepend_path("PATH", apphome.."/bin")
__END__
```

nf-core
=======

Python package with helper tools for the nf-core community.

https://bioconda.github.io/recipes/nf-core/README.html

Installation on deigo
---------------------

See also <https://groups.oist.jp/scs/install-software-your-unit>.

### Stable versions from bioconda

To install a new latest version, update the `VER` variable below and run the commands.

```
APP=nf-core
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
VER=1.13.3-0
mkdir -p $APPDIR
cd $APPDIR
curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh -b -p $APPDIR/$VER
cd $VER
./bin/conda config --add channels defaults
./bin/conda config --add channels bioconda
./bin/conda config --add channels conda-forge
./bin/conda install -y $APP
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
depends_on("Nextflow")
prepend_path("PATH", apphome.."/bin")
__END__
```

### Dev versions from GitHub

```
NFMODULE=Nextflow/21.04.0  # Change the LUA file too !!
ml bioinfo-ugrp-modules $NFMODULE
APP=nf-core
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
VER=0.dev_`date -u +%F`
mkdir -p $APPDIR/$VER
cd $APPDIR/$VER
PYTHONUSERBASE=$(pwd) pip3 install --user $APP git+https://github.com/nf-core/tools.git@dev
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
depends_on("Nextflow/21.04.0")
prepend_path("PATH", apphome.."/bin")
prepend_path("PYTHONPATH", apphome.."/lib/python3.8/site-packages")
__END__
```
