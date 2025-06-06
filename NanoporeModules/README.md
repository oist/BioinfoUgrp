Modules related to Nanopore sequencing
======================================

Usage example
-------------

```
module load bioinfo-ugrp-modules
module load Guppy
srun --time 2-0 --mem 20G -pgpu --gres gpu:1 --pty guppy_basecaller \
   -i <where FAST5 files are> \
   --recursive \
   --flowcell FLO-MIN106 --kit SQK-LSK109 \
   --num_callers 16 --device auto \
   --records_per_fastq 0 --qscore_filtering --min_qscore 7 --calib_detect \
   -s <where to write the output>
```

Note that for GPU acceleration on _Saion_, `srun` needs `-pgpu --gres gpu:1` and `guppy_basecaller` needs `--device auto`.

Please ask further questions on the _BioinfoUgrp_ group on [Teams](https://teams.microsoft.com/l/team/19%3a3183bd7fe2844138a49996a2bd376873%40thread.tacv2/conversations?groupId=cc78e114-c544-43e2-b4b1-29c7428aa305&tenantId=d8c0fb8d-bb56-44bb-9f4a-c58e7465652e) (OIST login needed).

Module building
---------------

### Singularity image

Our [singularity image](./Singularity.def) contains the latest modules
available through `pip`.

Example command to build the image:

    singularity build --fakeroot NanoporeModules_2024-12-03.sif Singularity.def


### Dorado

 - Homepage: <https://github.com/nanoporetech/dorado>
 - License: Oxford Nanopore Technologies PLC. Public License Version 1.0
 - Template module file: [Dorado.tcl](./Dorado.tcl)
 - Update instructions:

```
VER=0.9.0
cd /bucket/BioinfoUgrp/Nanopore/Dorado/
FILE_TO_DOWNLOAD=dorado-${VER}-linux-x64.tar.gz
wget https://cdn.oxfordnanoportal.com/software/analysis/$FILE_TO_DOWNLOAD 
tar xvfz $FILE_TO_DOWNLOAD
rm $FILE_TO_DOWNLOAD
mv dorado-${VER}* $VER
cd modulefiles
cp 0.7.0 $VER
```

### Dorado models

The basecall models are distributed separately to be downloaded
with the `dorado` command.  They are available through `Dorado-models`
module that exports their path to the `$DORADO_MODELS` environment
variable, and which is loaded by the `Dorado` module.

At the moment the contents of the `Dorado-models/latest` module are
downloaded by hand in `/bucket/BioinfoUgrp/Dorado-models/latest/`
with the `dorado download` command.  Then the older models are copied
in the new directory with a command such as `for d in $(ls latest); do if [ ! -d new/$d ] ;then cp -av latest/$d new/$d ; fi; done`.

Template module file: [Dorado-models.tcl](./Dorado-models.tcl)

### Example commands for running Dorado on Saion

```
module load bioinfo-ugrp-modules
module load Dorado
# See the help:
srun -pgpu dorado basecaller -h
# Note that Dorado does not work with the P100 cards.
srun -pgpu --gres gpu:V100:1 --pty --mem 20G dorado basecaller $DORADO_MODELS/the_model_you_want path_to_POD5_or_FAST5_files
```

### Rerio

 - Homepage: https://github.com/nanoporetech/rerio
 - Source code: Proprietary (the GitHub repository is only a facility to dowload the models from ONT).

Important: there are some additions and deletions of models without change
of version number.  In that case I download and add the models by hand, without
removing the old ones.

2021/03: addition of v032 CRF models (https://github.com/nanoporetech/rerio/commit/3bc3a94c7a396a85026958e04a0be5a84c352397)

```
VER=4.4.0
cd /bucket/BioinfoUgrp/Rerio/
git clone https://github.com/nanoporetech/rerio rerio-GitHub-$VER
cd rerio-GitHub-$VER
git checkout $VER
./download_model.py
cp -a basecall_models ../$VER
cp /bucket/BioinfoUgrp/Guppy/4.4.0/ont/guppy/data/lambda_3.6kb.fasta ../$VER

cd /apps/.bioinfo-ugrp-modulefiles/Rerio
cat > $VER<< '__END__'
#%Module1.0##################################################################
#
set appname    [lrange [split [module-info name] {/}] 0 0]
set appversion [lrange [split [module-info name] {/}] 1 1]
set apphome    /bucket/BioinfoUgrp/$appname/$appversion

## URL of application homepage:
set appurl     https://github.com/nanoporetech/rerio

## Short description of package:
module-whatis   "research release basecalling models and configuration files"

## Load any needed modules:

## Modify as needed, removing any variables not needed.  Non-path variables
## can be set with "setenv VARIABLE value".
setenv RERIO_MODELS $apphome

## These lines are for logging module usage.  Don't remove them:
set modulefile [lrange [split [module-info name] {/}] 0 0]
set version    [lrange [split [module-info name] {/}] 1 1]
set action     [module-info mode]
system logger -t module -p local6.info DATE=\$(date +%FT%T),USER=\$USER,JOB=\$\{SLURM_JOB_ID=NOJOB\},APP=$modulefile,VERSION=$version,ACTION=$action
## Don't remove this line!  For some reason, it has to be here...
__END__
```

### Example commands for running Rerio models with Guppy on Saion

```
module load bioinfo-ugrp-modules
module load Guppy
module load Rerio
srun --time 2-0 --mem 20G -pgpu --gres gpu:1 --pty \
  guppy_basecaller \
    -i <fast5dir> \
    --recursive \
    -d $RERIO_MODELS \
    -c res_dna_r941_min_crf_v031.cfg \
    --num_callers 16 \
    --records_per_fastq 0 \
    --qscore_filtering --min_qscore 7 \
    --calib_detect \
    -s <outputdir>\
    --device auto
```

### Medaka

 - Homepage: https://github.com/nanoporetech/medaka
 - Source code: MPL-2.0 License 

```
VER=1.3.2
module load python/3.7.3
module load ont-fast5-api
APP=medaka
MODROOT=/bucket/BioinfoUgrp/
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR/$VER
cd $APPDIR/$VER
PYTHONUSERBASE=$(pwd) pip3 install --user $APP --no-warn-script-location
cd /apps/.bioinfo-ugrp-modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER
#%Module1.0##################################################################
#
set modulehome /bucket/BioinfoUgrp
set appname    [lrange [split [module-info name] {/}] 0 0]
set appversion [lrange [split [module-info name] {/}] 1 1]
set apphome    $modulehome/$appname/$appversion

## URL of application homepage:
set appurl     https://pypi.org/project/medaka/

## Short description of package:
module-whatis   "Tool to create consensus sequences and variant calls from nanopore sequencing data."

## Load any needed modules:
module load python/3.7.3

## Modify as needed, removing any variables not needed.  Non-path variables
## can be set with "setenv VARIABLE value".
prepend-path    PATH            $apphome/bin
prepend-path    PYTHONPATH      $apphome/lib/python3.7/site-packages/

## These lines are for logging module usage.  Don't remove them:
set modulefile [lrange [split [module-info name] {/}] 0 0]
set version    [lrange [split [module-info name] {/}] 1 1]
set action     [module-info mode]
system logger -t module -p local6.info DATE=\$(date +%FT%T),USER=\$USER,JOB=\$\{SLURM_JOB_ID=NOJOB\},APP=$modulefile,VERSION=$version,ACTION=$action
## Don't remove this line!  For some reason, it has to be here...
__END__
```

ont-fast5-api
-------------

 - Homepage: https://pypi.org/project/ont-fast5-api/
 - Sourcecode: https://github.com/nanoporetech/ont_fast5_api

#### Instalation with Singularity

First, create a proper Singularity image (see at the top).  Then:

```
APP=ont_fast5_api
MODROOT=/bucket/BioinfoUgrp/
APPDIR=$MODROOT/$APP
VER=3.3.0
VER=3.3.0
mkdir -p $APPDIR/$VER/bin
cd $APPDIR/$VER/bin
ln -s 


```

#### Installation with pip (old)

```
module load python/3.7.3
APP=ont_fast5_api
MODROOT=/bucket/BioinfoUgrp/
APPDIR=$MODROOT/$APP
VER=3.3.0
mkdir -p $APPDIR/$VER
cd $APPDIR/$VER
PYTHONUSERBASE=$(pwd) pip3 install --user ont_fast5_api
cd /apps/.bioinfo-ugrp-modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER.lua
-- Default settings
local modroot    = "/bucket/LuscombeU/"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package information
whatis("Name: "..appname)
whatis("Version: "..appversion)
whatis("URL: ".."https://github.com/nanoporetech/ont_fast5_api")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."Nanopore, sequence")
whatis("Description: ".." Oxford Nanopore Technologies fast5 API software.")

help([[ont_fast5_api installed with pip

See https://github.com/nanoporetech/ont_fast5_api for help.]])

-- Package settings
depends_on("python/3.7.3")
prepend_path("PATH", apphome.."/bin")
prepend_path("PYTHONPATH", apphome.."/lib/python3.7/site-packages")
__END__
```

### modkit

Tool for working with modified bases from ONT.

- Homepage: https://github.com/nanoporetech/modkit

```
APP=modkit
MODROOT=/bucket/BioinfoUgrp/Nanopore
APPDIR=$MODROOT/$APP
VER=0.4.4
mkdir -p $APPDIR/$VER/bin
cd $APPDIR/$VER/bin
wget https://github.com/nanoporetech/modkit/releases/download/v$VER/modkit_v$VER_u16_x86_64.tar.gz
gunzip modkit_v$VER_u16_x86_64.tar.gz
tar -xvf modkit_v$VER_u16_x86_64.tar
mv dist_modkit_v$VER_7cf558c/modkit .
rm -rf dist_modkit_v$VER_7cf558c

```

Example modulefile:

```
#%Module1.0##################################################################
#
set modulehome /bucket/BioinfoUgrp/Nanopore
set appname    [lrange [split [module-info name] {/}] 0 0]
set appversion [lrange [split [module-info name] {/}] 1 1]
set apphome    $modulehome/$appname/$appversion

## URL of application homepage:
set appurl     https://github.com/nanoporetech/modkit

## Short description of package:
module-whatis   "Oxford Nanopore Technologies modkit"

## Load any needed modules:

## Modify as needed, removing any variables not needed.  Non-path variables
## can be set with "setenv VARIABLE value".
prepend-path    PATH            $apphome/bin

## These lines are for logging module usage.  Don't remove them:
set modulefile [lrange [split [module-info name] {/}] 0 0]
set version    [lrange [split [module-info name] {/}] 1 1]
set action     [module-info mode]
system logger -t module -p local6.info DATE=\$(date +%FT%T),USER=\$USER,JOB=\
$\{SLURM_JOB_ID=NOJOB\},APP=$modulefile,VERSION=$version,ACTION=$action
## Don't remove this line!  For some reason, it has to be here...
```

### POD5 Python Package

Appears to be the successor of `pod5-format-tools`

 - Homepage: https://pypi.org/project/pod5/
 - Sourcecode: https://github.com/nanoporetech/pod5-file-format

```
APP=pod5
MODROOT=/bucket/BioinfoUgrp/Nanopore
APPDIR=$MODROOT/$APP
VER=0.3.10
mkdir -p $APPDIR/$VER/bin
cd $APPDIR/$VER/bin
ln -s ../../../Singularity/NanoporeModules_2024-12-02.sif pod5
```

Example modulefile:

```
#%Module1.0##################################################################
#
set modulehome /bucket/BioinfoUgrp/Nanopore
set appname    [lrange [split [module-info name] {/}] 0 0]
set appversion [lrange [split [module-info name] {/}] 1 1]
set apphome    $modulehome/$appname/$appversion

## URL of application homepage:
set appurl     https://pypi.org/project/pod5/

## Short description of package:
module-whatis   "Oxford Nanopore Technologies POD5 tools"

## Load any needed modules:
module load singularity

## Modify as needed, removing any variables not needed.  Non-path variables
## can be set with "setenv VARIABLE value".
prepend-path    PATH            $apphome/bin

## These lines are for logging module usage.  Don't remove them:
set modulefile [lrange [split [module-info name] {/}] 0 0]
set version    [lrange [split [module-info name] {/}] 1 1]
set action     [module-info mode]
system logger -t module -p local6.info DATE=\$(date +%FT%T),USER=\$USER,JOB=\$\{SLURM_JOB_ID=NOJOB\},APP=$modulefile,VERSION=$version,ACTION=$action
## Don't remove this line!  For some reason, it has to be here...
```

vbz compression plugin
----------------------

 - Homepage: https://github.com/nanoporetech/vbz_compression
 - Sourcecode: https://github.com/nanoporetech/vbz_compression

See also:

 - https://www.biostars.org/p/9504758/
 - https://github.com/nanoporetech/vbz_compression
 - https://portal.hdfgroup.org/display/support/HDF5+Filter+Plugins

### Installation on Deigo

```
APP=vbz_compression
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
VER=1.0.2
mkdir -p $APPDIR/$VER
cd $APPDIR/$VER
wget https://github.com/nanoporetech/vbz_compression/releases/download/1.0.2/ont-vbz-hdf-plugin_${VER}-1.focal_amd64.deb
mkdir hdf_plugin
dpkg --fsys-tarfile ont-vbz-hdf-plugin_${VER}-1.focal_amd64.deb | tar xOf - ./usr/local/hdf5/lib/plugin/libvbz_hdf_plugin.so > hdf_plugin/libvbz_hdf_plugin.so
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
whatis("URL: ".."https://github.com/nanoporetech/vbz_compression")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."Nanopore, sequence")
whatis("Description: ".." Oxford Nanopore Technologies vbz HDF5 plugin.")

help([[ont_fast5_api installed with pip

See [https://github.com/nanoporetech/ont_fast5_api](https://github.com/nanoporetech/vbz_compression) for help.]])

-- Package settings
setenv("HDF5_PLUGIN_PATH", apphome.."/hdf_plugin")
__END__
```

### Guppy

Guppy was the default Nanopore basecaller before Dorado and after Albatros.  No further updates are expected.
We still keep a lot of modules of older versions, for the sake of reproducible research.

 - Homepage: https://community.nanoporetech.com/protocols/Guppy-protocol
 - Source code: Proprietary.

#### Example module update:

```
VER=6.5.7
cd /bucket/BioinfoUgrp/Guppy/
wget https://mirror.oxfordnanoportal.com/software/analysis/ont-guppy-${VER}-1.el7.x86_64.rpm
rpm2cpio ont-guppy-${VER}-1.el7.x86_64.rpm | cpio -idmv
mkdir $VER
mv opt $VER
cd /apps/.bioinfo-ugrp-modulefiles/Guppy
cp 2.3.5 $VER
```
