# A collection of general bioinformatics modules

To use the modules, load the `bioinfo-ugrp-modules` metamodule first.

```bash
ml bioinfo-ugrp-modules
ml av Other
ml Other/<your-favorite-module>
```

Here are installation snippets to help the members of the bioinfo user group to update the modules.

## TETools

Downloaded singularity image from <https://github.com/Dfam-consortium/TETools>:

```
APP=TETools
VER=1.95
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR/$VER/bin
cd $APPDIR/$VER
singularity pull docker://dfam/tetools:$VER
CMDS="BuildDatabase famdb.py generateSeedAlignments.pl RepeatMasker RepeatModeler"
for cmd in $CMDS; do
  cat > "bin/$cmd" <<EOF
#!/bin/sh
VER=${VER}
COMMAND=${cmd}
LC_ALL=C singularity exec /bucket/.deigo/BioinfoUgrp/Other/TETools/\${VER}/tetools_\${VER}.sif \$COMMAND "\$@"
EOF
  chmod +x "bin/$cmd"
done
cd $MODROOT/modulefiles/
mkdir -p $APP
cd $APP
cp 1.94.lua ${VER}.lua
```

### Module file template

```
-- Default settings
local modroot    = "/bucket/BioinfoUgrp"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package information
whatis("Name: "..appname)
whatis("Version: "..appversion)
whatis("URL: ".."https://github.com/Dfam-consortium/TETools")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."Dfam, RepeatMasker, RepeatModeller")
whatis("Description: ".."Dfam Transposable Element Tools Container.")

-- Package settings
depends_on("singularity")
prepend_path("PATH", apphome.."/bin")
```

## Tandem Repeat Finder (TRF)

- Home page: https://github.com/Benson-Genomics-Lab/TRF
- Source code: https://github.com/Benson-Genomics-Lab/TRF/releases

### Installation on Deigo

```bash
APP=trf
VER=4.09.1
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR
wget https://github.com/Benson-Genomics-Lab/TRF/releases/download/v$VER/trf409.linux64 && mv trf409.linux64 $APP && chmod +x $APP
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
whatis("URL: ".."https://github.com/Benson-Genomics-Lab/TRF")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."DNA, repeat")
whatis("Description: ".."Tandem Repeats Finder: a program to analyze DNA sequences.")

-- Package settings
prepend_path("PATH", apphome.."")
__END__
```

### Example commands for running Tandem Repeat Finder on Deigo

```bash
module load Other/trf
srun -p compute -c 1 --mem 40G -t 10:00:00 --pty \
    trf <arguments>
```
