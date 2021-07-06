# A collection of general bioinformatics modules

## Usage

```bash
module load bioinfo-ugrp-modules
module load Other/<your-favorite-module>
```

## hifiasm

- Home page: https://github.com/chhylp123/hifiasm
- Source code: https://github.com/chhylp123/hifiasm/archive/refs/tags/0.15.4.tar.gz

### Installation on Deigo

```bash
APP=hifiasm
VER=0.15.4
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/chhylp123/hifiasm/archive/refs/tags/$VER.tar.gz | tar xzvf -
mv hifiasm-$VER $VER
cd $VER && make
cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER.lua
-- Default settings
local modroot    = "/apps/unit/BioinfoUgrp"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package information
whatis("Name: "..appname)
whatis("Version: "..appversion)
whatis("URL: ".."https://github.com/chhylp123/hifiasm")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."PacBio, hifi, assembly")
whatis("Description: ".." Hifiasm: a haplotype-resolved assembler for accurate Hifi reads.")

-- Package settings
prepend_path("PATH", apphome)
__END__
```

### Example commands for running hifiasm on Deigo

```bash
module load Other/hifiasm
srun -p compute -c 64 --mem 500G -t 24:00:00 --pty \
    hifiasm <arguments>
```

## TODO

- Write descriptions for BEAST, DIAMOND, SPAdes, bioawk, interproscan (who installed?)
