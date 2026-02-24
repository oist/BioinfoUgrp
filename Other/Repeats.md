# A collection of general bioinformatics modules

To use the modules, load the `bioinfo-ugrp-modules` metamodule first.

```bash
ml bioinfo-ugrp-modules
ml av Other
ml Other/<your-favorite-module>
```

Here are installation snippets to help the members of the bioinfo user group to update the modules.

## DfamTEBrowser

```
APP=DfamTEBrowser
VER=1.0.0
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget https://github.com/Dfam-consortium/DfamTEBrowser/archive/refs/tags/${VER}.tar.gz
tar xvfz ${VER}.tar.gz
mv DfamTEBrowser-$VER $VER
rm ${VER}.tar.gz
cd ${VER}/Libraries
ln -s /bucket/BioinfoUgrp/DB/Dfam/3.9/RepeatPeps.lib
ln -s /bucket/BioinfoUgrp/DB/Dfam/3.9/Dfam-RepeatMasker.lib Dfam-curated.fa
#### TODO #####  Depend on TETools for blastdb instead of hardcoding
/bucket/BioinfoUgrp/Other/TETools/1.95/bin/makeblastdb -in /bucket/BioinfoUgrp/Other/DfamTEBrowser/1.0.0/Libraries/Dfam-curated.fa -dbtype nucl
/bucket/BioinfoUgrp/Other/TETools/1.95/bin/makeblastdb -in /bucket/BioinfoUgrp/Other/DfamTEBrowser/1.0.0/Libraries/RepeatPeps.lib  -dbtype prot
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
whatis("URL: ".."https://github.com/Dfam-consortium/DfamTEBrowser")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."Dfam, RepeatMasker, RepeatModeller")
whatis("Description: ".."Dfam Transposable Element Family Genome Browser")

-- Package settings
depends_on("Other/TETools", "Other/ULTRA")
prepend_path("PATH", apphome)
```

## TETools

Downloaded singularity image from <https://github.com/Dfam-consortium/TETools>:

```
APP=TETools
VER=1.96
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR/$VER/bin
cd $APPDIR/$VER
singularity pull docker://dfam/tetools:$VER
CMDS="BuildDatabase calcDivergenceFromAlign.pl createRepeatLandscape.pl famdb.py generateSeedAlignments.pl RepeatMasker RepeatModeler rmblastn makeblastdb blastx"
for cmd in $CMDS; do
  cat > "bin/$cmd" <<EOF
#!/bin/sh
VER=${VER}
COMMAND=${cmd}
LC_ALL=C singularity exec /bucket/BioinfoUgrp/Other/TETools/\${VER}/tetools_\${VER}.sif \$COMMAND "\$@"
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

## ULTRA

```
APP=ULTRA
VER=1.2.1
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/TravisWheelerLab/ULTRA $VER
cd $VER
git checkout $VER
cmake .
make
cd $MODROOT/modulefiles/$APP
cp 1.2.1.lua ${VER}.lua
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
whatis("URL: ".."https://github.com/TravisWheelerLab/ULTRA")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."DNA, repeat")
whatis("Description: ".."ULTRA Locates Tandemly Repetitive Areas")

-- Package settings
prepend_path("PATH", apphome)
```
