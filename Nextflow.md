Nextflow
========

A DSL for data-driven computational pipelines <http://nextflow.io>

https://github.com/nextflow-io/nextflow

Installation on deigo
---------------------

See also <https://groups.oist.jp/scs/install-software-your-unit>.

To install a new latest version, update the `VER` variable below and run the commands.

```
APP=Nextflow
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
VER=20.10.0
mkdir -p $APPDIR
cd $APPDIR
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh -b -p $APPDIR/$VER
cd $VER
./bin/conda install -y -c bioconda nextflow 
cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER.lua
-- Default settings
local modroot    = "/apps/unit/BioinfoUgrp/"
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

nf-core
=======

Python package with helper tools for the nf-core community.

https://bioconda.github.io/recipes/nf-core/README.html

Installation on deigo
---------------------

See also <https://groups.oist.jp/scs/install-software-your-unit>.

To install a new latest version, update the `VER` variable below and run the commands.

```
APP=nf-core
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
VER=1.12.1-0
mkdir -p $APPDIR
cd $APPDIR
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh -b -p $APPDIR/$VER
cd $VER
./bin/conda install -y -c bioconda nextflow 
cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER.lua
-- Default settings
local modroot    = "/apps/unit/BioinfoUgrp/"
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
__END__
```
