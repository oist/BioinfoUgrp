# A collection of general bioinformatics modules

To use the modules, load the `bioinfo-ugrp-modules` metamodule first.

```bash
ml bioinfo-ugrp-modules
ml av Other
ml Other/<your-favorite-module>
```

Here are installation snippets to help the members of the bioinfo user group to update the modules.

## BWA

- Home page: https://github.com/lh3/bwa
- Source code: https://github.com/lh3/bwa

### Installation on Deigo

```bash
APP=bwa
VER=0.7.17
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/lh3/bwa/releases/download/v0.7.17/bwa-0.7.17.tar.bz2 | tar xjvf -
mv $APP-$VER $VER
cd $VER
make
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
whatis("URL: ".."https://github.com/lh3/bwa")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."bwa")
whatis("Description: ".."BWA is a software package for mapping DNA sequences against a large reference genome, such as the human genome.")

-- Package settings
prepend_path("PATH", apphome)
__END__
```

### Example commands for running bwa on Deigo

```bash
module load Other/bwa
srun -p compute -c 128 --mem 100G -t 1:00:00 --pty \
    bwa mem <arguments>
```


## samblaster

- Home page: https://academic.oup.com/bioinformatics/article/30/17/2503/2748175
- Source code: https://github.com/GregoryFaust/samblaster

### Installation on Deigo

```bash
APP=samblaster
VER=0.1.26
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/GregoryFaust/samblaster/releases/download/v.0.1.26/samblaster-v.0.1.26.tar.gz | tar xzvf -
mv $APP-v.$VER $VER
cd $VER && make
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
whatis("URL: ".."https://github.com/GregoryFaust/samblaster")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."samblaster")
whatis("Description: ".."samblaster is a fast and flexible program for marking duplicates in read-id grouped paired-end SAM files")

-- Package settings
prepend_path("PATH", apphome)
__END__
```

### Example commands for running samblaster on Deigo

```bash
module load Other/samblaster
srun -p compute -c 1 --mem 40G -t 1:00:00 --pty \
    bwa mem <idxbase> samp.r1.fq samp.r2.fq | samblaster | samtools view -Sb - > samp.out.bam
```

## hal

 - Homepage: https://github.com/ComparativeGenomicsToolkit/hal
 - Source code: https://github.com/ComparativeGenomicsToolkit/hal/releases

### Installation on Deigo

```bash
APP=hal
VER=2.2
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR/${VER}
cd $APPDIR/${VER}
wget https://github.com/ComparativeGenomicsToolkit/hal/archive/refs/tags/release-V${VER}.tar.gz
tar xvfz release-V${VER}.tar.gz
git clone https://github.com/ComparativeGenomicsToolkit/sonLib.git
pushd sonLib
git checkout a4d45c46c6b9ee580fbac89db10894bac8844fd9 # As of January 23 2023
make
popd
cd hal-release-V${VER}
make
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
whatis("URL: ".."https://github.com/ComparativeGenomicsToolkit/hal")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."hal, assembly, cactus")
whatis("Description: ".."Tools for manipulating sequence graphs in the HAL formats.")

-- Package settings
prepend_path("PATH", apphome.."/hal-release-V"..appversion.."/bin")
__END__
```

## k8 (Javascript shell)

- Home page: https://github.com/attractivechaos/k8
- Source code: https://github.com/attractivechaos/k8/releases

This module is installed just to satisfy the requirements by paftools.js in the minimap2 module.

### Installation on Deigo

```bash
APP=k8
VER=0.2.5
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/attractivechaos/k8/releases/download/$VER/$APP-$VER.tar.bz2 | tar xjvf -
mv $APP-$VER $VER && cd $VER
ln -sf k8-Linux k8
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
whatis("URL: ".."https://github.com/attractivechaos/k8")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."javascript")
whatis("Description: ".."k8 Javascript shell.")

-- Package settings
prepend_path("PATH", apphome)
__END__
```

### Example commands for running minimap2 on Deigo

```bash
module load Other/k8
srun -p compute -c 1 --mem 40G -t 10:00:00 --pty \
    k8 <arguments>
```

## minimap2

- Home page: https://github.com/lh3/minimap2
- Source code: https://github.com/lh3/minimap2/releases

### Installation on Deigo

```bash
APP=minimap2
VER=2.20
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/lh3/minimap2/archive/refs/tags/v$VER.tar.gz | tar xzvf -
mv $APP-$VER $VER
cd $VER && make
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
whatis("URL: ".."https://github.com/lh3/minimap2")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."alignment")
whatis("Description: ".."A versatile pairwise aligner for genomic and spliced nucleotide sequences.")

-- Package settings
depends_on("Other/k8")
prepend_path("PATH", apphome)
prepend_path("PATH", apphome.."/misc")
__END__
```

### Example commands for running minimap2 on Deigo

```bash
module load Other/minimap2
srun -p compute -c 64 --mem 500G -t 24:00:00 --pty \
    minimap2 <arguments>
```

The `paftools.js` command is also available:

```bash
module load Other/minimap2
srun -p compute -c 1 --mem 100G -t 24:00:00 --pty \
    paftools.js <arguments>
```

## winnowmap

- Home page: https://github.com/marbl/Winnowmap
- Source code: https://github.com/marbl/Winnowmap/releases

### Installation on Deigo

```bash
APP=winnowmap
VER=2.03
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/marbl/Winnowmap/archive/refs/tags/v$VER.tar.gz | tar xzvf -
mv Winnowmap-$VER $VER
cd $VER && make
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
whatis("URL: ".."https://github.com/marbl/Winnowmap")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."alignment")
whatis("Description: ".."Long read / genome alignment software")

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
```

### Example commands for running winnowmap on Deigo

```bash
module load Other/winnowmap
srun -p compute -c 64 --mem 500G -t 24:00:00 --pty \
    winnowmap <arguments>
```


## DAZZ_DB

- Home page: https://github.com/thegenemyers/DAZZ_DB
- Source code: https://github.com/thegenemyers/DAZZ_DB

### Installation on Deigo

```bash
APP=DAZZ_DB
VER=2021.03.30
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/thegenemyers/DAZZ_DB
mv DAZZ_DB $VER && cd $VER && make
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
whatis("URL: ".."https://github.com/thegenemyers/DAZZ_DB")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly, sequencing")
whatis("Description: ".."The Dazzler Data Base.")

-- Package settings
prepend_path("PATH", apphome)
__END__
```

### Example commands for running DAZZ_DB on Deigo

To load the module, run:

```bash
module load Other/DAZZ_DB
```

Then the following commands become available:

- `arrow2DB`
- `Catrack`
- `DAM2fasta`
- `DB2arrow`
- `DB2fasta`
- `DB2quiva`
- `DBa2b`
- `DBb2a`
- `DBdump`
- `DBdust`
- `DBmv`
- `DBrm`
- `DBshow`
- `DBsplit`
- `DBstats`
- `DBtrim`
- `DBwipe`
- `fasta2DAM`
- `fasta2DB`
- `quiva2DB`
- `rangen`
- `simulator`

See the [README](https://github.com/thegenemyers/DAZZ_DB) written by the developer for details about how to use the programs.

## FASTK

- Home page: https://github.com/thegenemyers/FASTK
- Source code: https://github.com/thegenemyers/FASTK

### Installation on Deigo

```bash
APP=FASTK
VER=2021.05.27
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/thegenemyers/FASTK
mv FASTK $VER && cd $VER && make
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
whatis("URL: ".."https://github.com/thegenemyers/FASTK")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."k-mer counter")
whatis("Description: ".."A fast K-mer counter for high-fidelity shotgun datasets.")

-- Package settings
prepend_path("PATH", apphome)
__END__
```

### Example commands for running FASTK on Deigo

To load the module, run:

```bash
module load Other/FASTK
```

Then the following commands become available:

- `Fastcp`
- `FastK`
- `Fastmv`
- `Fastrm`
- `Haplex`
- `Histex`
- `Homex`
- `Logex`
- `Profex`
- `Symmex`
- `Tabex`
- `Vennex`

See the [README](https://github.com/thegenemyers/FASTK) written by the developer for details about how to use the programs.


## SAMtools
- Home page: http://www.htslib.org
- Source code: https://github.com/samtools/samtools/releases/download/1.15.1/samtools-1.15.1.tar.bz2

### Installation on Deigo
```bash
APP=samtools
VER=1.15.1
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/samtools/samtools/releases/download/1.15.1/samtools-1.15.1.tar.bz2 | tar xjvf -
mv $APP-$VER $VER
cd $VER
./configure --prefix=$APPDIR/$VER && make && make install
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
whatis("URL: ".."http://www.htslib.org")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."samtools")
whatis("Description: ".."mpileup and other tools for handling SAM, BAM, CRAM.")

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
```


## DIAMOND
- Home page: https://github.com/bbuchfink/diamond
- Source code: https://github.com/bbuchfink/diamond/releases/download/v2.0.15/diamond-linux64.tar.gz

### Installation on Deigo
```bash
APP=DIAMOND
VER=2.0.15.153
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
mkdir $VER
cd $APPDIR/$VER
wget -O - https://github.com/bbuchfink/diamond/releases/download/v2.0.15/diamond-linux64.tar.gz | tar xzvf -
cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER
#%Module1.0##################################################################
set approot    [lrange [split [module-info name] {/}] 0 0]
set appname    [lrange [split [module-info name] {/}] 1 1]
set appversion [lrange [split [module-info name] {/}] 2 2]
set apphome    /bucket/BioinfoUgrp/$approot/$appname/$appversion

## URL of application homepage:
set appurl     https://github.com/bbuchfink/diamond

## Short description of package:
module-whatis  "DIAMOND is a sequence aligner for protein and translated DNA searches, designed for high performance analysis of big sequence data."

## Load any needed modules:

## Modify as needed, removing any variables not needed.
## Non-path variables can be set with "setenv VARIABLE value"
prepend-path    PATH            $apphome
__END__
```

## cactus
- Home page: (https://github.com/ComparativeGenomicsToolkit/cactus)
- Source code: quay.io/comparative-genomics-toolkit/cactus:v2.9.7

### Installation on Deigo
```
ml singularity
APP=cactus
VER=2.9.7
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR
singularity build $APP.sif docker:quay.io/comparative-genomics-toolkit/${APP}:v${VER}
echo '#!/bin/sh' > $APP && echo "singularity exec $APPDIR/$APP.sif $APP \$*" >> $APP && chmod +x $APP
echo '#!/bin/sh' > cactus-pangenome && echo "singularity exec $APPDIR/$APP.sif cactus-pangenome \$*" >> cactus-pangenome && chmod +x cactus-pangenome
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
whatis("URL: ".."https://github.com/ComparativeGenomicsToolkit/cactus")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."alignment")
whatis("Description: ".."reference-free whole-genome alignment program")

-- Package settings
depends_on("singularity")
prepend_path("PATH", apphome)
__END__
```
