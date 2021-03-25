Modules related to Nanopore sequencing
======================================

Usage
-----

```
module load bioinfo-ugrp-modules
module load Guppy
# If needed:
module load Rerio
```

Note that for GPU acceleration on _Saion_, `srun` needs `-pgpu --gres gpu:1` and `guppy_basecaller` needs `--device auto`.

Please ask further questions on the _BioinfoUgrp_ group on [Teams](https://teams.microsoft.com/l/team/19%3a3183bd7fe2844138a49996a2bd376873%40thread.tacv2/conversations?groupId=cc78e114-c544-43e2-b4b1-29c7428aa305&tenantId=d8c0fb8d-bb56-44bb-9f4a-c58e7465652e) (OIST login needed).

Guppy
-----

 - Homepage: https://community.nanoporetech.com/protocols/Guppy-protocol
 - Source code: Proprietary.

### Example module update on Saion

```
VER=4.4.2
cd /apps/unit/BioinfoUgrp/Guppy/
wget https://mirror.oxfordnanoportal.com/software/analysis/ont-guppy-${VER}-1.el7.x86_64.rpm
rpm2cpio ont-guppy-${VER}-1.el7.x86_64.rpm | cpio -idmv
mkdir $VER
mv opt $VER
cd /apps/.bioinfo-ugrp-modulefiles/Guppy
cp 2.3.5 $VER
```

### Example commands for running Guppy on Saion

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

Rerio
-----

 - Homepage: https://github.com/nanoporetech/rerio
 - Source code: Proprietary (the GitHub repository is only a facility to dowload the models from ONT).

### Notes on module creation on Saion

Important: there are some additions and deletions of models without change
of version number.  In that case I download and add the models by hand, without
removing the old ones.

2021/03: addition of v032 CRF models (https://github.com/nanoporetech/rerio/commit/3bc3a94c7a396a85026958e04a0be5a84c352397)

```
VER=4.4.0
cd /apps/unit/BioinfoUgrp/Rerio/
git clone https://github.com/nanoporetech/rerio rerio-GitHub-$VER
cd rerio-GitHub-$VER
git checkout $VER
./download_model.py
cp -a basecall_models ../$VER
cp /apps/unit/BioinfoUgrp/Guppy/4.4.0/ont/guppy/data/lambda_3.6kb.fasta ../$VER

cd /apps/.bioinfo-ugrp-modulefiles/Rerio
cat > $VER<< '__END__'
#%Module1.0##################################################################
#
set appname    [lrange [split [module-info name] {/}] 0 0]
set appversion [lrange [split [module-info name] {/}] 1 1]
set apphome    /apps/unit/BioinfoUgrp/$appname/$appversion

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

### Example commands for running Guppy on Saion

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

ont-fast5-api
-------------

 - Homepage: https://pypi.org/project/ont-fast5-api/
 - Sourcecode: https://github.com/nanoporetech/ont_fast5_api

### Installation on Deigo

```
module load python/3.7.3
APP=ont_fast5_api
MODROOT=/apps/unit/BioinfoUgrp/
APPDIR=$MODROOT/$APP
VER=3.3.0
mkdir -p $APPDIR/$VER
cd $APPDIR/$VER
PYTHONUSERBASE=$(pwd) pip3 install --user ont_fast5_api
cd /apps/.bioinfo-ugrp-modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER.lua
-- Default settings
local modroot    = "/apps/unit/LuscombeU/"
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

### Installation on Saion

```
module load python/3.7.3
APP=ont_fast5_api
MODROOT=/apps/unit/BioinfoUgrp/
APPDIR=$MODROOT/$APP
VER=3.3.0
mkdir -p $APPDIR/$VER
cd $APPDIR/$VER
PYTHONUSERBASE=$(pwd) pip3 install --user ont_fast5_api
cd /apps/.bioinfo-ugrp-modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER
#%Module1.0##################################################################
#
set modulehome /apps/unit/BioinfoUgrp
set appname    [lrange [split [module-info name] {/}] 0 0]
set appversion [lrange [split [module-info name] {/}] 1 1]
set apphome    $modulehome/$appname/$appversion

## URL of application homepage:
set appurl     https://pypi.org/project/ont-fast5-api/

## Short description of package:
module-whatis   "Oxford Nanopore Technologies fast5 API software"

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
