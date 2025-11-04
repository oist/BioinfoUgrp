# Bioinformatics modules for genome assembly

To use the modules, load the `bioinfo-ugrp-modules` metamodule first.

```bash
ml bioinfo-ugrp-modules
ml av Other
ml Other/<your-favorite-module>
```

## assembly-stats

- Home page: https://github.com/sanger-pathogens/assembly-stats
- Source code: https://github.com/sanger-pathogens/assembly-stats

### Installation on Deigo

```bash
APP=assembly-stats
VER=1.0.1
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/sanger-pathogens/assembly-stats/archive/refs/tags/v1.0.1.tar.gz | tar xzvf -
mv $APP-$VER $VER
cd $VER && mkdir build && cd build
cmake -DINSTALL_DIR:PATH=$APPDIR/$VER ..
make test
make install
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
whatis("URL: ".."https://github.com/sanger-pathogens/assembly-stats")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly-stats")
whatis("Description: ".."Get assembly statistics from FASTA and FASTQ files.")

-- Package settings
prepend_path("PATH", apphome)
__END__
```

### Example commands for running assembly-stats on Deigo

```bash
ml Other/assembly-stats
srun -p compute -c 1 --mem 10G -t 00:10:00 --pty \
    assembly-stats contigs.fasta
```

## BandageNG

- Home page: https://github.com/asl/BandageNG
- Source code: https://github.com/asl/BandageNG

### Installation on Deigo

I created a Singularity image with the following definition file on my Linux laptop.

```
Bootstrap: docker
From: debian:bookworm


%runscript
    exec /squashfs-root/AppRun "$@"

%post
    # Update the image
    apt update
    apt upgrade -y
    
    # Add a package needed to suppress some debconf error messages
    apt install -y whiptail
    
    # Install all locales
    apt install -y locales-all

    # Install FUSE to extract and run the AppImage
    apt install -y fuse3
    # X11 and other dependencies
    apt install -y x11-apps mesa-utils libgl1 libglu1-mesa
    apt install -y dbus
    dbus-uuidgen > /etc/machine-id

    # Download BandageNG
    apt install -y wget
    wget https://github.com/asl/BandageNG/releases/download/continuous/BandageNG-Linux-827c5cb.AppImage
    chmod 775 BandageNG-Linux-827c5cb.AppImage
    ./BandageNG-Linux-827c5cb.AppImage --appimage-extract

    # Clean downoladed package cache.  Yes I know about /var/libs.
    apt clean
```

Then, I copied it in my home directory on _deigo_.

```bash
APP=BandageNG
VER=2025-03-28
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR/$VER
cd $APPDIR/$VER
cp ~/BandageNG.sif BandageNG
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
whatis("URL: ".."https://github.com/chaoszhang/ASTER")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."BandageNG")
whatis("Description: ".." a Bioinformatics Application for Navigating De novo Assembly Graphs Easily")

-- Package settings
depends_on("singularity")
prepend_path("PATH", apphome)
__END__
```

## pbgzip

- Home page: https://github.com/nh13/pbgzip
- Source code: https://github.com/nh13/pbgzip

### Installation on Deigo

```bash
APP=pbgzip
VER=20160804
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/nh13/pbgzip
mv pbgzip $VER && cd $VER 
sh autogen.sh && ./configure --prefix=$APPDIR/$VER && make 
make install
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
whatis("URL: ".."https://github.com/nh13/pbgzip")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."pbgzip")
whatis("Description: ".."This tool and API implements parallel block gzip.")

-- Package settings
prepend_path("PATH", apphome)
__END__
```

### Example commands for running pbgzip on Deigo

```bash
module load Other/pbgzip
srun -p compute -c 128 --mem 100G -t 1:00:00 --pty \
    pbgzip <arguments>
```

## SMARTdenovo

```bash
APP=SMARTdenovo
VER=2021-02-24
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP/$VER
mkdir -p $MODROOT/$APP
cd $MODROOT/$APP
git clone https://github.com/ruanjue/smartdenovo $VER
ml gcc
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
whatis("URL: ".."https://github.com/ruanjue/smartdenovo")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."PacBio, Nanopore, genome, assembler")
whatis("Description: ".."de novo assembler for PacBio and Oxford Nanopore (ONT) data")

-- Package settings
prepend_path("PATH", apphome)
__END__
```

## BUSCO

- Home page: https://busco.ezlab.org/
- Source code: https://gitlab.com/ezlab/busco

### Installation on Deigo

```bash
module load singularity
APP=BUSCO
VER=5.8.2
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR
singularity pull busco.sif docker://ezlabgva/busco:v${VER}_cv1
echo '#!/bin/sh' > busco && echo "singularity exec $APPDIR/busco.sif busco \$*" >> busco && chmod +x busco
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
whatis("URL: ".."https://busco.ezlab.org/")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly")
whatis("Description: ".."Assessing genome assembly and annotation completeness with Benchmarking Universal Single-Copy Orthologs (BUSCO).")

-- Package settings
depends_on("singularity")
prepend_path("PATH", apphome)

LmodMessage([[
================================================================================
The BUSCO module runs a read-only Singularity image.

If you need to change AUGUSTUS configuration, you can do a local copy with the
following command that will place it in $HOME/augustus_config.

    singularity exec /bucket/BioinfoUgrp/Other/BUSCO/5.8.2/busco.sif cp -r /usr/local/config $HOME/augustus_config

You can then pass the information by exporting the AUGUSTUS_CONFIG_PATH variable.

    export AUGUSTUS_CONFIG_PATH="$HOME/augustus_config"
================================================================================
]])
__END__
```

### Example commands for running BUSCO on Deigo

The following command executes `$ busco` using the Singularity image:

```bash
module load Other/BUSCO
srun -p compute -c 128 --mem 500G -t 24:00:00 --pty \
    busco.sif <arguments> 
```

We also provide a command `busco` that is effectively the same as above:

```bash
module load Other/BUSCO
srun -p compute -c 128 --mem 500G -t 24:00:00 --pty \
    busco <arguments>
```

**IMPORTANT: Using Augustus for BUSCO running via its Singularity image requires the Augustus' config directory to be copied (from inside of Singularity container environment) to your own environment (outside Singularity in Deigo). The module we provide automatically copy the config directory to `$HOME/augustus_config` if it does not exist yet, and also set the `AUGUSTUS_CONFIG_PATH` varieble as `$HOME/augustus_config`, when the module is loaded.**

## gfatools

- Home page: https://github.com/lh3/gfatools
- Source code: https://github.com/lh3/gfatools/releases

### Installation on Deigo

```bash
APP=gfatools
VER=0.5
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/lh3/gfatools/archive/refs/tags/v$VER.tar.gz | tar xzvf -
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
whatis("URL: ".."https://github.com/lh3/gfatools")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."gfa, assembly")
whatis("Description: ".."Tools for manipulating sequence graphs in the GFA and rGFA formats.")

-- Package settings
prepend_path("PATH", apphome)
__END__
```

### Example commands for running gfatools on Deigo

```bash
module load Other/gfatools
srun -p compute -c 1 --mem 40G -t 1:00:00 --pty \
    gfatools <arguments>
```

## hifiasm

- Home page: https://github.com/chhylp123/hifiasm
- Source code: https://github.com/chhylp123/hifiasm/releases

### Installation on Deigo

```bash
APP=hifiasm
VER=0.25.0
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/chhylp123/hifiasm/archive/refs/tags/$VER.tar.gz | tar xzvf -
mv $APP-$VER $VER
cd $VER
ml purge && ml gcc/11.2.1
make CXXFLAGS="-g -O3 -mavx2 -mpopcnt -fomit-frame-pointer -Wall"  # Replace SSE with AVX.  When updating, check that the other flags did not change.
cd /bucket/BioinfoUgrp/Other/modulefiles/hifiasm
cp 0.20.0.lua ${VER}.lua
```

### Example commands for running hifiasm on Deigo

```bash
module load Other/hifiasm
srun -p compute -c 64 --mem 500G -t 24:00:00 --pty \
    hifiasm <arguments>
```

## Canu (and HiCanu)

- Home page: https://github.com/marbl/canu
- Source code: https://github.com/marbl/canu/releases

### Installation on Deigo

```bash
APP=canu
VER=2.1.1
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/marbl/canu/releases/download/v$VER/$APP-$VER.Linux-amd64.tar.xz | tar Jxvf -
mv $APP-$VER $VER
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
whatis("URL: ".."https://github.com/marbl/canu")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly")
whatis("Description: ".."A single molecule sequence assembler for genomes large and small.")

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
```

### Example commands for running Canu on Deigo

```bash
module load Other/canu
srun -p compute -c 128 --mem 500G -t 24:00:00 --pty \
    canu <arguments>
```

## purge_dups

- Home page: https://github.com/dfguan/purge_dups
- Source code: https://github.com/dfguan/purge_dups

### Installation on Deigo

**WARNING: This module currently does not support the optional runner script nor k-mer comparision plot.**

```bash
APP=purge_dups
VER=1.2.5
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/dfguan/purge_dups
mv purge_dups $VER && cd $VER/src && make
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
whatis("URL: ".."https://github.com/dfguan/purge_dups")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly")
whatis("Description: ".."haplotypic duplication identification tool.")

-- Package settings
depends_on("Other/minimap2")
prepend_path("PATH", apphome.."/bin")
prepend_path("PATH", apphome.."/scripts")
__END__
```

### Example commands for running purge_dups on Deigo

To load the module, run:

```bash
module load Other/purge_dups
```

Then, the following commands become available:

- `calcuts`
- `get_seqs`
- `ngscstat`
- `pbcstat`
- `purge_dups`
- `split_fa`

See the [README](https://github.com/dfguan/purge_dups) written by the developer for details about how to use the programs.

## Asset

- Home page: https://github.com/dfguan/asset
- Source code: https://github.com/dfguan/asset

### Installation on Deigo

**WARNING: This module currently does not support the optional runner script.**

```bash
APP=asset
VER=1.0.3
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/dfguan/asset
mv asset $VER && cd $VER/src && make
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
whatis("URL: ".."https://github.com/dfguan/asset")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly")
whatis("Description: ".."assembly evaluation tool.")

-- Package settings
depends_on("samtools", "bedtools", "bwa", "Other/minimap2")
prepend_path("PATH", apphome.."/bin")
prepend_path("PATH", apphome.."/scripts")
__END__
```

### Example commands for running Asset on Deigo

To load the module, run:

```bash
module load Other/asset
```

Then, the following commands become available:

- `10x`
- `acc`
- `ast_10x`
- `ast_bion`
- `ast_bion_bnx`
- `ast_hic`
- `ast_hic2`
- `ast_pb`
- `col_conts`
- `detgaps`
- `pchlst`
- `pchlst0`
- `split_fa`
- `union`
- `union_brks`

See the [README](https://github.com/dfguan/asset) written by the developer or [another workflow](https://github.com/VGP/vgp-assembly/tree/master/pipeline/asset) written by researchers of the Vertebrate Genome Project for details about how to use the programs.

## SPAdes
- Home page: https://github.com/ablab/spades
- Source code: http://cab.spbu.ru/files/release3.15.1/SPAdes-3.15.1-Linux.tar.gz

### Installation on Deigo
```bash
APP=SPAdes
VER=3.15.1
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - http://cab.spbu.ru/files/release3.15.1/SPAdes-3.15.1-Linux.tar.gz | tar xzvf -
mv $APP-$VER-Linux $VER
cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER
#%Module1.0##################################################################
set approot    [lrange [split [module-info name] {/}] 0 0]
set appname    [lrange [split [module-info name] {/}] 1 1]
set appversion [lrange [split [module-info name] {/}] 2 2]
set apphome    /bucket/BioinfoUgrp/$approot/$appname/$appversion

## URL of application homepage:
set appurl     https://github.com/ablab/spades

## Short description of package:
module-whatis  "SPAdes is an assembly toolkit containing various assembly pipelines."

## Load any needed modules:
module load python/3.7.3

## Modify as needed, removing any variables not needed.
## Non-path variables can be set with "setenv VARIABLE value"
prepend-path    PATH            $apphome
prepend-path    PATH            $apphome/bin
__END__
```

## Flye
- Home page: https://github.com/mikolmogorov/Flye/tree/flye
- Installation: https://github.com/mikolmogorov/Flye/tree/flye

### Installation on Deigo
```bash
APP=Flye
VER=2.9.5
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/mikolmogorov/Flye/archive/refs/tags/$VER.tar.gz | tar xzvf -
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
whatis("URL: ".."https://github.com/mikolmogorov/Flye/tree/flye")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."flye")
whatis("Description: ".."Flye is a de novo assembler for single-molecule sequencing reads, such as those produced by PacBio and Oxford Nanopore Technologies..")

-- Package settings
depends_on("python/3.7.3")
prepend_path("PATH", apphome.."/bin")
__END__
```
