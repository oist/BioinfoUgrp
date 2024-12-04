#%Module1.0##################################################################
#
set appname    [lrange [split [module-info name] {/}] 0 0]
set appversion [lrange [split [module-info name] {/}] 1 1]
set apphome    /bucket/BioinfoUgrp/$appname/$appversion

## URL of application homepage:
set appurl     https://github.com/nanoporetech/dorado

## Short description of package:
module-whatis   "Basecalling models and configuration files for Dorado"

## Load any needed modules:

## Modify as needed, removing any variables not needed.  Non-path variables
## can be set with "setenv VARIABLE value".
setenv DORADO_MODELS $apphome

## These lines are for logging module usage.  Don't remove them:
set modulefile [lrange [split [module-info name] {/}] 0 0]
set version    [lrange [split [module-info name] {/}] 1 1]
set action     [module-info mode]
system logger -t module -p local6.info DATE=\$(date +%FT%T),USER=\$USER,JOB=\$\{SLURM_JOB_ID=NOJOB\},APP=$modulefile,VERSION=$version,ACTION=$action
## Don't remove this line!  For some reason, it has to be here...
