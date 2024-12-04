#%Module1.0##################################################################
#
set appname    [lrange [split [module-info name] {/}] 0 0]
set appversion [lrange [split [module-info name] {/}] 1 1]
set apphome    /bucket/BioinfoUgrp/$appname/$appversion

## URL of application homepage:
set appurl     https://github.com/nanoporetech/dorado

## Short description of package:
module-whatis   "A LibTorch Basecaller for Oxford Nanopore Reads"

## Load any needed modules:
module load Dorado-models

## Modify as needed, removing any variables not needed.  Non-path variables
## can be set with "setenv VARIABLE value".
prepend-path    PATH            $apphome/bin
prepend-path    LD_LIBRARY_PATH $apphome/lib

## These lines are for logging module usage.  Don't remove them:
set modulefile [lrange [split [module-info name] {/}] 0 0]
set version    [lrange [split [module-info name] {/}] 1 1]
set action     [module-info mode]
system logger -t module -p local6.info DATE=\$(date +%FT%T),USER=\$USER,JOB=\$\{SLURM_JOB_ID=NOJOB\},APP=$modulefile,VERSION=$version,ACTION=$action
## Don't remove this line!  For some reason, it has to be here...
