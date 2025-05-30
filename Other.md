# A collection of general bioinformatics modules

To use the modules, load the `bioinfo-ugrp-modules` metamodule first.

```bash
ml bioinfo-ugrp-modules
ml av Other
ml Other/<your-favorite-module>
```

Here are installation snippets to help the members of the bioinfo user group to update the modules.

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

## ASTRAL
- Home page: https://github.com/smirarab/ASTRAL
- Source code: https://github.com/smirarab/ASTRAL

### Installation on Deigo
```
APP=astral
VER=5.7.8
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget https://github.com/smirarab/ASTRAL/raw/master/Astral.$VER.zip && unzip Astral.$VER.zip && rm Astral.$VER.zip
mv Astral $VER && cd $VER
chmod g+r * && chmod g+x *
cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER
#%Module1.0##################################################################
set approot    [lrange [split [module-info name] {/}] 0 0]
set appname    [lrange [split [module-info name] {/}] 1 1]
set appversion [lrange [split [module-info name] {/}] 2 2]
set apphome    /bucket/BioinfoUgrp/$approot/$appname/$appversion

## URL of application homepage:
set appurl     https://github.com/smirarab/ASTRAL

## Short description of package:
module-whatis  "ASTRAL is a tool for estimating an unrooted species tree given a set of unrooted gene trees. To be called in script with: java -jar dollarASTRAL. Replace dollar by the actual symbol"

## Load any needed modules:

## Modify as needed, removing any variables not needed.
## Non-path variables can be set with "setenv VARIABLE value"
prepend-path    PATH            $apphome    
prepend-path    PATH $apphome/lib
prepend-path    ASTRAL      $apphome/astral.5.7.8.jar
__END__
```

## ASTER

- Home page: https://github.com/chaoszhang/ASTER
- Source code: https://github.com/chaoszhang/ASTER

### Installation on Deigo

```bash
APP=aster
VER=1.20.4.6
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget https://github.com/chaoszhang/ASTER/archive/refs/heads/Linux.zip
unzip Linux.zip
cd ASTER-Linux
make
cd ..
mv ASTER-Linux/bin $VER
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
whatis("Keywords: ".."ASTER")
whatis("Description: ".." Accurate Species Tree EstimatoR: a family of optimation algorithms for species tree inference (including ASTRAL & CASTER).")

-- Package settings
prepend_path("PATH", apphome)
__END__
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

## NCBI command-line tools

- Home page: https://www.ncbi.nlm.nih.gov/datasets/docs/v2/download-and-install/

### Installation on Deigo

```bash
APP=ncbi-datasets-cli
VER=18.0.5 
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR/$VER
cd $APPDIR/$VER
wget https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/v2/linux-amd64/datasets
chmod 775 datasets
wget https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/v2/linux-amd64/dataformat
chmod 775 dataformat
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
whatis("URL: ".."https://www.ncbi.nlm.nih.gov/datasets/docs/v2/download-and-install/")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."NCBI")
whatis("Description: ".."Use datasets to download biological sequence data across all domains of life from NCBI. Use dataformat to convert metadata from JSON Lines format to other formats.")

-- Package settings
prepend_path("PATH", apphome)
__END__
```

### Example commands for running pairtools on Deigo

```bash
module load Other/pairtools
srun -p compute -c 128 --mem 20G -t 1:00:00 --pty \
    pairtools parse -c example.chrom.sizes -o example_R1.pairs.gz --drop-sam example_R1.bam 
```


## pairtools

- Home page: https://pairtools.readthedocs.io/en/latest/
- Source code: https://github.com/open2c/pairtools

### Installation on Deigo

```bash
module load python/3.7.3
APP=pairtools
VER=0.3.0
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/open2c/pairtools/archive/refs/tags/v0.3.0.tar.gz | tar xzvf -
mv $APP-$VER $VER
cd $VER
mkdir -p lib/python3.7/site-packages
PYTHONUSERBASE=$(pwd) python setup.py install --user
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
whatis("URL: ".."https://pairtools.readthedocs.io/en/latest/")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."pairtools")
whatis("Description: ".."pairtools is a simple and fast command-line framework to process sequencing data from a Hi-C experiment.")

-- Package settings
depends_on("python/3.7.3 ", "samtools", "pbgzip", "htslib")
prepend_path("PATH", apphome.."/bin")
prepend_path("PYTHONPATH", apphome.."/lib/python3.7/site-packages")
__END__
```

### Example commands for running pairtools on Deigo

```bash
module load Other/pairtools
srun -p compute -c 128 --mem 20G -t 1:00:00 --pty \
    pairtools parse -c example.chrom.sizes -o example_R1.pairs.gz --drop-sam example_R1.bam 
```

## preseq

- Home page: http://smithlabresearch.org/software/preseq/
- Source code: https://github.com/smithlabcode/preseq

### Installation on Deigo

```bash
APP=preseq
VER=3.1.2
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/smithlabcode/preseq/releases/download/v3.1.2/preseq-3.1.2.tar.gz | tar xzvf -
mv $APP-$VER $VER
cd $VER && mkdir build && cd build
../configure --prefix=$APPDIR/$VER && make && make install && cd .. && rm -r build
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
whatis("URL: ".."http://smithlabresearch.org/software/preseq/")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."preseq")
whatis("Description: ".."The preseq package is aimed at predicting and estimating the complexity of a genomic sequencing library, equivalent to predicting and estimating the number of redundant reads from a given sequencing depth and how many will be expected from additional sequencing using an initial sequencing experiment")

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
```

### Example commands for running preseq on Deigo

```bash
module load Other/preseq
srun -p compute -c 128 --mem 20G -t 1:00:00 --pty \
    preseq c_curve -o output.txt input.sort.bed
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

## seqkit

- Home page: https://bioinf.shenwei.me/seqkit/
- Source code: https://github.com/shenwei356/seqkit

### Installation on Deigo

```bash
APP=seqkit
VER=2.0.0
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/shenwei356/seqkit/releases/download/v$VER/seqkit_linux_amd64.tar.gz | tar xzvf -
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
whatis("URL: ".."https://github.com/shenwei356/seqkit")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."fasta, fastq, sequence analysis")
whatis("Description: ".."A cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang")

-- Package settings
prepend_path("PATH", apphome)
__END__
```

### Example commands for running seqkit on Deigo

```bash
module load Other/seqkit
srun -p compute -c 1 --mem 40G -t 24:00:00 --pty \
    seqkit <subcommand> <arguments>
```

## GNU parallel

- Home page: https://www.gnu.org/software/parallel
- Source code: https://ftp.gnu.org/gnu/parallel

### Installation on Deigo

```bash
APP=parallel
VER=20210622
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR/$VER
cd $APPDIR
wget -O - https://ftp.gnu.org/gnu/parallel/parallel-$VER.tar.bz2 | tar xjvf -
cd $APP-$VER && ./configure --prefix=$APPDIR/$VER && make && make install && cd .. && rm -r $APP-$VER
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
whatis("URL: ".."https://www.gnu.org/software/parallel")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."GNU, parallel")
whatis("Description: ".."A shell tool for executing jobs in parallel using one or more computers.")

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
```

### Example commands for running GNU parallel on Deigo

```bash
module load Other/parallel
srun -p compute -c 1 --mem 40G -t 1:00:00 --pty \
    parallel <arguments>
```

## mosdepth

- Home page: https://github.com/brentp/mosdepth
- Source code: https://github.com/brentp/mosdepth/releases

### Installation on Deigo

```bash
APP=mosdepth
VER=0.3.1
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR
wget https://github.com/brentp/mosdepth/releases/download/v$VER/mosdepth && chmod +x mosdepth
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
whatis("URL: ".."https://github.com/brentp/mosdepth")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly")
whatis("Description: ".."fast BAM/CRAM depth calculation for WGS, exome, or targeted sequencing.")

-- Package settings
prepend_path("PATH", apphome)
__END__
```

### Example commands for running mosdepth on Deigo

```bash
module load Other/mosdepth
srun -p compute -c 1 --mem 100G -t 24:00:00 --pty \
    mosdepth <arguments>
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

## Meryl

- Home page: https://github.com/marbl/meryl
- Source code: https://github.com/marbl/meryl/releases

### Installation on Deigo

```bash
APP=meryl
VER=1.3
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/marbl/meryl/releases/download/v$VER/meryl-$VER.Linux-amd64.tar.xz | tar Jxvf -
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
whatis("URL: ".."https://github.com/marbl/meryl")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly")
whatis("Description: ".."A genomic k-mer counter (and sequence utility) with nice features.")

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
```

### Example commands for running Meryl on Deigo

```bash
module load Other/meryl
srun -p compute -c 128 --mem 500G -t 24:00:00 --pty \
    meryl <arguments>
```

## Merqury

- Home page: https://github.com/marbl/merqury
- Source code: https://github.com/marbl/merqury/releases

### Installation on Deigo

```bash
module load R/4.0.4
APP=merqury
VER=1.3
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/marbl/merqury/archive/refs/tags/v$VER.tar.gz | tar zxvf -
mv $APP-$VER $VER && cd $VER
sed -i 's/echo $?/echo 1/' util/util.sh
for FILE in plot/*.R; do sed -i 's|#!/usr/bin/env Rscript|#!/usr/bin/env -S Rscript --vanilla|'
mkdir -p lib/R && Rscript -e 'install.packages(c("argparse","R6","jsonlite","findpython","ggplot2","scales"), lib="./lib/R")'
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
whatis("URL: ".."https://github.com/marbl/merqury")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly")
whatis("Description: ".."k-mer based assembly evaluation.")

-- Package settings
depends_on("R/4.0.4", "samtools/1.12", "bedtools/v2.29.2", "Other/meryl/1.3")
prepend_path("PATH", apphome)
prepend_path("R_LIBS", apphome.."/lib/R")
setenv("MERQURY", apphome)
__END__
```

### Example commands for running Merqury on Deigo

```bash
module load Other/merqury
srun -p compute -c 128 --mem 500G -t 24:00:00 --pty \
    merqury.sh <arguments>
```

## Peregrine

- Home page: https://github.com/cschin/Peregrine
- Source code: https://hub.docker.com/r/cschin/peregrine/tags

### Installation on Deigo

```bash
module load singularity
APP=peregrine
VER=1.6.3
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR
singularity pull $APP.sif docker://cschin/$APP:$VER
echo '#!/bin/sh' > $APP && echo "echo yes | singularity run $APPDIR/$APP.sif asm \$*" >> $APP && chmod +x $APP
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
whatis("URL: ".."https://github.com/cschin/Peregrine")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly")
whatis("Description: ".."Fast Genome Assembler Using SHIMMER Index.")

-- Package settings
depends_on("singularity")
prepend_path("PATH", apphome)
__END__
```

### Example commands for running Peregeine on Deigo

The following command executes `$ pg_run.py asm` using the Singularity image:

```bash
module load Other/peregrine
srun -p compute -c 128 --mem 500G -t 24:00:00 --pty \
    peregrine.sif asm <arguments> 
```

For simplicity and to skip the interactive prompt message, we also provide a command `peregrine` that is effectively the same as above:

```bash
module load Other/peregrine
srun -p compute -c 128 --mem 500G -t 24:00:00 --pty \
    peregrine <arguments>
```

## IPA (Improved Phased Assembler)

- Home page: https://github.com/PacificBiosciences/pbipa
- Source code: https://anaconda.org/bioconda/pbipa

IPA was installed with conda before and we had to remove the module for that reason.  Please let us know if you want IPA back.

## DeepVariant

- Home page: https://github.com/google/deepvariant
- Source code: https://hub.docker.com/r/google/deepvariant/tags

### Installation on Deigo

```bash
module load singularity
APP=deepvariant
VER=1.1.0
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR
singularity pull $APP.sif docker://google/$APP:$VER
for CMD in run_deepvariant make_examples call_variants postprocess_variants; do echo '#!/bin/sh' > $CMD && echo "singularity exec $APPDIR/$APP.sif $CMD \$*" >> $CMD && chmod +x $CMD; done
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
whatis("URL: ".."https://github.com/google/deepvariant")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."variant call")
whatis("Description: ".."DeepVariant is an analysis pipeline that uses a deep neural network to call genetic variants from next-generation DNA sequencing data.")

-- Package settings
depends_on("singularity")
prepend_path("PATH", apphome)
__END__
```

### Example commands for running DeepVariant on Deigo

The following command executes `$ run_deepvariant` using the Singularity image:

```bash
module load Other/deepvariant
srun -p compute -c 128 --mem 500G -t 24:00:00 --pty \
    deepvariant.sif <arguments> 
```

We also provide a command `run_deepvariant` that is effectively the same as above:

```bash
module load Other/deepvariant
srun -p compute -c 128 --mem 500G -t 24:00:00 --pty \
    run_deepvariant <arguments>
```

## arima_pipeline (ArimaGenomics Hi-C mapping pipeline)

- Home page: https://github.com/ArimaGenomics/mapping_pipeline
- Source code: https://github.com/ArimaGenomics/mapping_pipeline

### Installation on Deigo

```bash
APP=arima_pipeline
VER=2019.02.08
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/ArimaGenomics/mapping_pipeline
mv mapping_pipeline $VER && cd $VER
chmod +x *.pl
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
whatis("URL: ".."https://github.com/ArimaGenomics/mapping_pipeline")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."Hi-C, mapping")
whatis("Description: ".."Mapping pipeline for data generated using Arima-HiC.")

-- Package settings
depends_on("samtools", "picard", "bwa")
prepend_path("PATH", apphome)
__END__
```

### Example commands for running arima_pipeline on Deigo

To load the module, run:

```bash
module load Other/arima_pipeline
```

Then, the following executables become available as commands:

- `filter_five_end.pl`
- `two_read_bam_combiner.pl`
- `get_stats.pl`

See the pipeline script ([01_mapping_arima.sh](https://github.com/ArimaGenomics/mapping_pipeline/blob/master/01_mapping_arima.sh)) written by the developer for details about how to use the Perl scripts.

## SALSA

- Home page: https://github.com/marbl/SALSA
- Source code: https://github.com/marbl/SALSA/releases

### Installation on Deigo

```bash
APP=SALSA
VER=2.3
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/marbl/SALSA/archive/refs/tags/v$VER.tar.gz | tar xzvf -
mv $APP-$VER $VER && cd $VER && make
wget https://s3.amazonaws.com/hicfiles.tc4ga.com/public/juicer/juicer_tools_1.22.01.jar
cat <<'__END__' > convert.sh
#!/bin/bash
JUICER_JAR=/bucket/BioinfoUgrp/Other/SALSA/2.3/juicer_tools_1.22.01.jar
SALSA_OUT_DIR=$1

samtools faidx ${SALSA_OUT_DIR}/scaffolds_FINAL.fasta
cut -f 1,2 ${SALSA_OUT_DIR}/scaffolds_FINAL.fasta.fai > ${SALSA_OUT_DIR}/chromosome_sizes.tsv
alignments2txt.py -b ${SALSA_OUT_DIR}/alignment_iteration_1.bed -a ${SALSA_OUT_DIR}/scaffolds_FINAL.agp -l ${SALSA_OUT_DIR}/scaffold_length_iteration_1 > ${SALSA_OUT_DIR}/alignments.txt
awk '{if ($2 > $6) {print $1"\t"$6"\t"$7"\t"$8"\t"$5"\t"$2"\t"$3"\t"$4} else {print}}'  ${SALSA_OUT_DIR}/alignments.txt | sort -k2,2d -k6,6d -T $PWD --parallel=16 | awk 'NF'  > ${SALSA_OUT_DIR}/alignments_sorted.txt
java -jar -Xmx500G ${JUICER_JAR} pre ${SALSA_OUT_DIR}/alignments_sorted.txt ${SALSA_OUT_DIR}/salsa_scaffolds.hic ${SALSA_OUT_DIR}/chromosome_sizes.tsv
__END__
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
whatis("URL: ".."https://github.com/marbl/SALSA")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly, scaffolding")
whatis("Description: ".."SALSA: A tool to scaffold long read assemblies with Hi-C data.")

-- Package settings
depends_on("python/2.7.18", "bedtools")
prepend_path("PATH", apphome)
__END__
```

### Example commands for running SALSA on Deigo

The main routine is executed as follows:

```bash
module load Other/SALSA
srun -p compute -c 1 --mem 500G -t 48:00:00 --pty \
    run_pipeline.py <arguments>
```

Some hard-coded values specific to the developers' environment in (`convert.sh`; see SALSA's README for what the script itself does) are replaced so that it works in our environment:

```bash
module load Other/SALSA
srun -p compute -c 16 --mem 500G -t 48:00:00 --pty \
    convert.sh <salsa-out-dir>
```

## Juicer

- Home page: https://github.com/aidenlab/juicer
- Source code: https://github.com/aidenlab/juicer/releases

### Installation on Deigo

NOTE: Only the "CPU" mode is installed, as the codes for HPCs are hard to use.

```bash
APP=juicer
VER=1.6
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/aidenlab/juicer/archive/refs/tags/$VER.tar.gz | tar xzvf -
mv $APP-$VER/CPU scripts && mv $APP-$VER/misc/* . && rm -rf scripts/README.md $APP-$VER
sed -i 's|juiceDir="/opt/juicer"|juiceDir="."|' scripts/juicer.sh
CMD=juicer_copy_scripts_dir
echo '#!/bin/sh' > $CMD && echo "ln -sf $APPDIR/scripts/ ." >> $CMD
chmod +x * scripts/common/*
cd scripts/common && wget https://s3.amazonaws.com/hicfiles.tc4ga.com/public/juicer/juicer_tools_1.22.01.jar && ln -sf juicer_tools_1.22.01.jar juicer_tools.jar
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
whatis("URL: ".."https://github.com/aidenlab/juicer")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."Hi-C, scaffolding")
whatis("Description: ".."A One-Click System for Analyzing Loop-Resolution Hi-C Experiments.")

-- Package settings
depends_on("java-jdk/14", "bwa")
prepend_path("PATH", apphome)
__END__
```

### Example commands for running Juicer on Deigo

Juicer (and other tools by Aiden lab) adopts a very unique approach to run programs. Read carefully e.g. [their wiki](https://github.com/aidenlab/juicer/wiki/Installation) to understand their assumptions.

To copy the `scripts/` directory (of the CPU mode), we provide the following command:

```bash
module load Other/juicer
juicer_copy_scripts_dir   # A symlink `scripts` will be generated in the current directory
```

Note that `scripts/common/juicer_tools.jar` is already downloaded and put in the appropriate directory in the module.
Then, after creating some directories required, you will need to run the main shell script as follows:

```bash
module load Other/juicer
srun -p compute -c 128 --mem 500G -t 48:00:00 --pty \
    ./scripts/juicer.sh <arguments>
```

Note that the default path of the option `-D` is replaced from `/opt/juicer` to `.` (i.e. the directory you ran `juicer.sh`).

## 3D-DNA

- Home page: https://github.com/aidenlab/3d-dna
- Source code: https://github.com/aidenlab/3d-dna

### Installation on Deigo

**IMPORTANT: Currently only the normal mode is supported by this module. That is, the diploid mode, phasing mode, etc. are NOT supported.**

```bash
APP=3d-dna
VER=180922
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/aidenlab/3d-dna
mv 3d-dna $VER && cd $VER
ln -sf run-asm-pipeline.sh 3d-dna
ln -sf run-asm-pipeline-post-review.sh 3d-dna-post-review
cd visualize/ && ln -sf run-assembly-visualizer.sh 3d-dna-run-assembly-visualizer && cd ..
CMD=3d-dna-fasta2assembly
echo '#!/bin/sh' > $CMD && echo "awk -f $APPDIR/$VER/utils/generate-assembly-file-from-fasta.awk \$*" >> $CMD
chmod +x *.sh */*.sh $CMD
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
whatis("URL: ".."https://github.com/aidenlab/3d-dna")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."Hi-C, scaffolding")
whatis("Description: ".."3D de novo assembly (3D DNA) pipeline.")

-- Package settings
depends_on("bwa", "Other/bioawk", "Other/parallel", "Other/juicer")
prepend_path("PATH", apphome)
prepend_path("PATH", apphome.."/visualize")
__END__
```

### Example commands for running 3D-DNA on Deigo

3D-DNA (and other tools by Aiden lab) adopts a very unique approach to run programs. Read carefully e.g. [their manual](http://aidenlab.org/assembly/manual_180322.pdf) to understand their assumptions.

By loading the module, the following main commands become available via `PATH`. Additionally, we provide alias names for these programs to make it easier to remember the commands:

- `run-asm-pipeline.sh` (alias: `3d-dna`)
- `run-asm-pipeline-post-review.sh` (alias: `3d-dna-post-review`)
- `run-assembly-visualizer.sh` (alias: `3d-dna-run-assembly-visualizer`)

These commands can be executed like this:

```bash
module load Other/3d-dna
srun -p compute -c 128 --mem 500G -t 48:00:00 --pty \
    run-asm-pipeline.sh <arguments>
```

or using their alias names:

```bash
module load Other/3d-dna
srun -p compute -c 128 --mem 500G -t 48:00:00 --pty \
    3d-dna <arguments>   # This is exactly same as the previous example
```

We also provide a command `3d-dna-fasta2assembly`, which is an alias of `$ awk -f /path/to/utils/generate-assembly-file-from-fasta.awk`. A usage example of this command is as follows:

```bash
module load Other/3d-dna
srun -p compute -c 1 --mem 40G -t 1:00:00 --pty \
    3d-dna-fasta2assembly ${YOUR_ASSEMBLY}.fasta > ${YOUR_ASSEMBLY}.assembly
```

## hic2cool

- Home page: https://github.com/4dn-dcic/hic2cool
- Source code: https://github.com/4dn-dcic/hic2cool/releases

### Installation on Deigo

```bash
module load python/3.7.3
APP=hic2cool
VER=0.8.3
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/4dn-dcic/hic2cool/archive/refs/tags/$VER.tar.gz | tar xzvf -
mv $APP-$VER $VER && cd $VER
mkdir -p lib/python3.7/site-packages
sed -i 's|    name = "hic2cool",|    name = "hic2cool",\n    zip_safe = False,|' setup.py
PYTHONUSERBASE=$(pwd) python setup.py install --user
PYTHONUSERBASE=$(pwd) pip install -r requirements.txt --force-reinstall --user
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
whatis("URL: ".."https://github.com/4dn-dcic/hic2cool")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."Hi-C")
whatis("Description: ".."Lightweight converter between hic and cool contact matrices.")

-- Package settings
depends_on("python/3.7.3")
prepend_path("PATH", apphome.."/bin")
prepend_path("PYTHONPATH", apphome.."/lib/python3.7/site-packages")
__END__
```

### Example commands for running hic2cool on Deigo

```bash
module load Other/hic2cool
srun -p compute -c 128 --mem 500G -t 12:00:00 --pty \
    hic2cool <arguments>
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

## make_telomere_bed

- Home page: https://github.com/yoshihikosuzuki/make_telomere_bed
- Source code: https://github.com/yoshihikosuzuki/make_telomere_bed

### Installation on Deigo

```bash
module load python/3.7.3
APP=make_telomere_bed
VER=2021.05.20
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/yoshihikosuzuki/make_telomere_bed
mv make_telomere_bed $VER && cd $VER
mkdir -p lib/python3.7/site-packages
PYTHONUSERBASE=$(pwd) python setup.py install --user
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
whatis("URL: ".."https://github.com/yoshihikosuzuki/make_telomere_bed")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."telomere")
whatis("Description: ".."Make a .bed file for telomeres in a contig/scaffold file.")

-- Package settings
depends_on("python/3.7.3", "Other/trf")
prepend_path("PATH", apphome.."/bin")
prepend_path("PYTHONPATH", apphome.."/lib/python3.7/site-packages")
__END__
```

### Example commands for running make_telomere_bed on Deigo

```bash
module load Other/make_telomere_bed
srun -p compute -c 1 --mem 100G -t 12:00:00 --pty \
    make_telomere_bed <arguments>
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

## GeneScope

- Home page: https://github.com/thegenemyers/GENESCOPE.FK
- Source code: https://github.com/thegenemyers/GENESCOPE.FK

### Installation on Deigo

```bash
module load R/4.0.4
APP=genescope
VER=2021.03.26
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/thegenemyers/GENESCOPE.FK
mv GENESCOPE.FK $VER && cd $VER
mkdir -p lib/R && cat <<'__END__' > install.R
local_lib_path = "./lib/R"
install.packages('minpack.lm', lib=local_lib_path)
install.packages('argparse', lib=local_lib_path)
install.packages('.', repos=NULL, type="source", lib=local_lib_path)
__END__
Rscript install.R
Rscript -e 'install.packages(c("R6", "jsonlite", "findpython"), lib="./lib/R")'
sed -i 's|#!/usr/bin/env Rscript|#!/usr/bin/env -S Rscript --vanilla|' GeneScopeFK.R
mkdir -p bin && mv GeneScopeFK.R bin/
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
whatis("URL: ".."https://github.com/thegenemyers/GENESCOPE.FK")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."sequencing")
whatis("Description: ".."A derivative of GenomeScope2.0 modified to work with FastK.")

-- Package settings
depends_on("R/4.0.4", "Other/FASTK")
prepend_path("PATH", apphome.."/bin")
prepend_path("R_LIBS", apphome.."/lib/R")
__END__
```

### Example commands for running GeneScope on Deigo

```bash
module load Other/genescope
srun -p compute -c 1 --mem 40G -t 1:00:00 --pty \
    GeneScopeFK.R <arguments>
```

## KMC (for GenomeScope 2.0 and Smudgeplot)

- Home page: https://github.com/tbenavi1/KMC
- Source code: https://github.com/tbenavi1/KMC

### Installation on Deigo

```bash
APP=KMC
VER=genomescope
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/tbenavi1/KMC
mv KMC $VER && cd $VER && make
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
whatis("URL: ".."https://github.com/tbenavi1/KMC")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."k-mer counter")
whatis("Description: ".."Fast and frugal disk based k-mer counter (version for GenomeScope and Smudgeplot).")

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
```

### Example commands for running KMC (for GenomeScope/Smudgeplot) on Deigo

To load the module, run:

```bash
module load Other/KMC/genomescope
```

Then, the following commands become available:

- `kmc`
- `kmc_dump`
- `kmc_tools`
- `smudge_pairs`

Visit the [GitHub page](https://github.com/tbenavi1/KMC) for details about how to use the programs.

## GenomeScope 2.0

- Home page: https://github.com/tbenavi1/genomescope2.0
- Source code: https://github.com/tbenavi1/genomescope2.0

### Installation on Deigo

```bash
module load R/4.0.4
APP=genomescope
VER=2.0
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/tbenavi1/genomescope2.0
mv genomescope2.0 $VER && cd $VER
mkdir -p lib/R && sed -i 's|local_lib_path = "~/R_libs/"|local_lib_path = "./lib/R"|' install.R && Rscript install.R
Rscript -e 'install.packages(c("R6", "jsonlite", "findpython"), lib="./lib/R")'
sed -i 's|#!/usr/bin/env Rscript|#!/usr/bin/env -S Rscript --vanilla|' genomescope.R
mkdir -p bin && mv genomescope.R bin/
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
whatis("URL: ".."https://github.com/tbenavi1/genomescope2.0")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."sequencing")
whatis("Description: ".."Reference-free profiling of polyploid genomes.")

-- Package settings
depends_on("R/4.0.4", "Other/KMC/genomescope")
prepend_path("PATH", apphome.."/bin")
prepend_path("R_LIBS", apphome.."/lib/R")
__END__
```

### Example commands for running GenomeScope 2.0 on Deigo

```bash
module load Other/genomescope/2.0
srun -p compute -c 1 --mem 40G -t 1:00:00 --pty \
    genomescope.R <arguments>
```

## Smudgeplot

- Home page: https://github.com/KamilSJaron/smudgeplot
- Source code: https://github.com/KamilSJaron/smudgeplot

### Installation on Deigo

```bash
module load R/4.0.4
APP=smudgeplot
VER=0.2.3
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/KamilSJaron/smudgeplot
mv smudgeplot $VER && cd $VER
mkdir -p lib/R && Rscript -e 'install.packages(c("devtools","argparse","R6","jsonlite","findpython","viridis"), lib="./lib/R")'
sed -i '1ilocal_lib_path = "./lib/R"' install.R && sed -i 's|install.packages(".", repos = NULL, type="source")|install.packages(".", repos = NULL, type="source", lib=local_lib_path)|' install.R
R_LIBS=./lib/R Rscript install.R && unset R_LIBS
sed -i 's|#!/usr/bin/env Rscript|#!/usr/bin/env -S Rscript --vanilla|' exec/smudgeplot_plot.R
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
whatis("URL: ".."https://github.com/KamilSJaron/smudgeplot")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."qc, sequencing")
whatis("Description: ".."Inference of ploidy and heterozygosity structure using whole genome sequencing data.")

-- Package settings
depends_on("R/4.0.4", "Other/KMC/genomescope", "Other/genomescope/2.0")
prepend_path("PATH", apphome.."/exec")
prepend_path("R_LIBS", apphome.."/lib/R")
__END__
```

### Example commands for running Smudgeplot on Deigo

```bash
module load Other/smudeplot
srun -p compute -c 1 --mem 100G -t 24:00:00 --pty \
    smudgeplot.py <arguments>
```

## iqtree2
- Home page: http://www.iqtree.org
- Source code: https://github.com/iqtree/iqtree2/releases

### Installation on Deigo

```bash
DIS=iqtree2
APP=iqtree
VER=2.2.0
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/iqtree/iqtree2/archive/refs/tags/v2.2.0.tar.gz | tar xzvf -
mv $DIS-$VER $VER
cd $VER && mkdir build && cd build
cmake ..
make -j
cd $MODROOT/$APP/$VER
mkdir -p bin
cd bin
ln -s $MODROOT/$APP/$VER/build/iqtree2 .
ln -s iqtree2 iqtree
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
whatis("URL: ".."http://www.iqtree.org")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."iqtree")
whatis("Description: ".."A fast and effective stochastic algorithm to infer phylogenetic trees by maximum likelihood")

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
```

```bash
DIS=iqtree2
APP=iqtree
VER=2.2.2.5
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
## getting submodules for dating
# https://github.com/Cibiv/IQ-TREE/issues/151
# https://github.com/Cibiv/IQ-TREE/issues/151
# Submodule 'lsd2' (https://github.com/tothuhien/lsd2.git) registered for path 'lsd2'
# git checkout latest #VER=2.2.2.6
# git submodule init 
# git submodule update
### leads to compiling errors
# /bucket/BioinfoUgrp/Other/iqtree/2.2.2.6/alignment/superalignment.cpp:28:10: erreur fatale: boost/container_hash/hash.hpp : Aucun fichier ou dossier de ce type
# /bucket/BioinfoUgrp/Other/iqtree/2.2.2.6/alignment/alignment.cpp:24:10: erreur fatale: boost/container_hash/hash.hpp : Aucun fichier ou dossier de ce type
## switch to older distrib
wget -O - https://github.com/iqtree/iqtree2/archive/refs/tags/v2.2.2.5.tar.gz | tar xzvf -
mv $DIS-$VER $VER && cd $VER
git clone https://github.com/tothuhien/lsd2
mkdir build && cd build
## enabling dating
cmake -DUSE_LSD2=ON ..
make -j
cd $MODROOT/$APP/$VER
mkdir -p bin
cd bin
ln -s $MODROOT/$APP/$VER/build/iqtree2 .
ln -s iqtree2 iqtree
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
whatis("URL: ".."http://www.iqtree.org")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."iqtree")
whatis("Description: ".."A fast and effective stochastic algorithm to infer phylogenetic trees by maximum likelihood")

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
```

## FastTree
- Home page: http://www.microbesonline.org/fasttree/
- Source code: http://www.microbesonline.org/fasttree/#Install

### Installation on Deigo

```bash
APP=fasttree
VER=2.1.11
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR/$VER/bin
cd $APPDIR/$VER/bin
wget -O - http://www.microbesonline.org/fasttree/FastTreeMP > fasttree
chmod a+x fasttree
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
whatis("URL: ".."http://www.microbesonline.org/fasttree/")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."fasttree")
whatis("Description: ".."FastTree infers approximately-maximum-likelihood phylogenetic trees from alignments of nucleotide or protein sequences.")

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
```

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

## bcftools
- Home page: http://www.htslib.org
- Source code: https://github.com/samtools/bcftools/releases/download/1.15.1/bcftools-1.15.1.tar.bz2

### Installation on Deigo
```bash
APP=bcftools
VER=1.15.1
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/samtools/bcftools/releases/download/1.15.1/bcftools-1.15.1.tar.bz2 | tar xjvf -
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
whatis("Keywords: ".."bcftools")
whatis("Description: ".."contains all the vcf* commands which previously lived in the htslib repository (such as vcfcheck, vcfmerge, vcfisec, etc.) and the samtools BCF calling from bcftools subdirectory of samtools.")

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
```

## prokka
- Home page: https://github.com/tseemann/prokka
- Source code: https://hub.docker.com/r/staphb/prokka

### Installation on Deigo
```bash
module load singularity
APP=prokka
VER=1.14.5
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR
singularity build prokka.sif docker://staphb/prokka:${VER}
echo '#!/bin/sh' > prokka && echo "singularity exec $APPDIR/prokka.sif prokka \$*" >> prokka && chmod +x prokka
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
whatis("URL: ".."https://hub.docker.com/r/staphb/prokka")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."annotation")
whatis("Description: ".."rapid prokaryotic genome annotation")

-- Package settings
depends_on("singularity")
prepend_path("PATH", apphome)
__END__
```

## BEAST1
- Home page: https://beast.community/index.html
- Source code: https://github.com/beast-dev/beast-mcmc/releases/download/v1.10.4/BEASTv1.10.4.tgz

### Installation on Deigo
```bash
APP=BEAST
VER=1.10.4
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/beast-dev/beast-mcmc/releases/download/v1.10.4/BEASTv1.10.4.tgz | tar xzvf -
mv ${APP}v${VER} $VER
cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER
#%Module1.0##################################################################
set approot    [lrange [split [module-info name] {/}] 0 0]
set appname    [lrange [split [module-info name] {/}] 1 1]
set appversion [lrange [split [module-info name] {/}] 2 2]
set apphome    /bucket/BioinfoUgrp/$approot/$appname/$appversion

## URL of application homepage:
set appurl     https://beast.community

## Short description of package:
module-whatis  "BEAST is a cross-platform program for Bayesian analysis of molecular sequences using MCMC."

## Load any needed modules:
module load java-jdk/1.8.0_20
module load beagle/3.1.2

## Modify as needed, removing any variables not needed.
## Non-path variables can be set with "setenv VARIABLE value"
prepend-path    PATH            $apphome
prepend-path    PATH            $apphome/bin
setenv			JAVA_HOME		/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.252.b09-2.el8_1.x86_64
setenv			JRE_HOME		/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.252.b09-2.el8_1.x86_64/jre
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

## bioawk
- Home page: https://github.com/lh3/bioawk
- Source code: https://github.com/lh3/bioawk

### Installation on Deigo
```bash
APP=bioawk
VER=1.0
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/lh3/bioawk.git && mv $APP $VER && cd $VER
make
cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER
#%Module1.0##################################################################
set approot    [lrange [split [module-info name] {/}] 0 0]
set appname    [lrange [split [module-info name] {/}] 1 1]
set appversion [lrange [split [module-info name] {/}] 2 2]
set apphome    /bucket/BioinfoUgrp/$approot/$appname/$appversion

## URL of application homepage:
set appurl     https://github.com/lh3/bioawk

## Short description of package:
module-whatis  "Bioawk is an extension to Brian Kernighan's awk, adding the support of several common biological data formats, including optionally gzip'ed BED, GFF, SAM, VCF, FASTA/Q and TAB-delimited formats with column names."

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

## mugsy
- Home page: https://mugsy.sourceforge.net
- Source code: https://sourceforge.net/projects/mugsy/files/

### Installation on Deigo
```
APP=mugsy
VER=1r2.2
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://sourceforge.net/projects/mugsy/files/${APP}_x86-64-v${VER}.tgz | tar xzvf - && mv ${APP}_x86-64-v${VER} ${VER} && cd ${VER}
sed -i 's/export MUGSY_INSTALL/#export MUGSY_INSTALL/g' mugsyenv.sh
echo "export MUGSY_INSTALL=$PWD" >> mugsyenv.sh
cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER
#%Module1.0##################################################################
set approot    [lrange [split [module-info name] {/}] 0 0]
set appname    [lrange [split [module-info name] {/}] 1 1]
set appversion [lrange [split [module-info name] {/}] 2 2]
set apphome    /bucket/BioinfoUgrp/$approot/$appname/$appversion

## URL of application homepage:
set appurl     https://mugsy.sourceforge.net

## Short description of package:
module-whatis  "Mugsy is a multiple whole genome aligner."

## Load any needed modules:

## Modify as needed, removing any variables not needed.
## Non-path variables can be set with "setenv VARIABLE value"
prepend-path    PATH            $apphome
prepend-path    PATH            $apphome/MUMmer3.20
eval [exec /usr/bin/env -i /usr/share/Modules/bin/createmodule.sh $apphome/mugsyenv.sh]
__END__
```

## TCSF_IMRA
- Home page: https://github.com/Yukihirokinjo/TCSF_IMRA

### Installation on Deigo
```
APP=TCSF_IMRA
VER=2.7.3
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/Yukihirokinjo/TCSF_IMRA.git
mv $APP $VER && cd $VER
chmod u+x *.bash
chmod u+x *.R
echo '#!/bin/sh' > tcsf && echo "TCSF-$VER.bash \$*" >> tcsf && chmod +x tcsf
echo '#!/bin/sh' > imra && echo "IMRA-$VER.bash \$*" >> imra && chmod +x imra
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
whatis("URL: ".."https://github.com/Yukihirokinjo/TCSF_IMRA")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."TCSF_IMRA")
whatis("Description: ".."tools developed for improving de novo assembly of endosymbiont genomes")

-- Package settings
depends_on("seqtk/1.3", "R/4.2.1", "ncbi-blast/2.10.0+", "bowtie2/2.2.6", "samtools/1.12", "SPAdes/3.13.0", "idba/1.1.3-7")
prepend_path("PATH", apphome, apphome.."/Rlib")
setenv("TCSF_IMRA", apphome)
__END__
```

## InterProScan
- Home page: https://interproscan-docs.readthedocs.io/en/latest/index.html
- Source code: 

### Installation on Deigo
```bash
APP=interproscan
VER=5.73-104.0
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget https://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/${VER}/interproscan-${VER}-64-bit.tar.gz
wget https://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/${VER}/interproscan-${VER}-64-bit.tar.gz.md5
md5sum -c interproscan-${VER}-64-bit.tar.gz.md5
tar -pxvzf interproscan-${VER}-64-bit.tar.gz
chmod -R g+w interproscan-${VER}
mv interproscan-${VER} ${VER}
cd ${VER}
python3 setup.py -f interproscan.properties
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
whatis("URL: ".."https://interproscan-docs.readthedocs.io/en/latest/index.html")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."ASTER")
whatis("Description: ".." InterproScan to run the scanning algorithms from the InterPro database in an integrated way.")

-- Package settings
prepend_path("PATH", apphome)
if os.getenv("IPRDIR") then
    prepend_path("IPRDIR", apphome)
else
    setenv("IPRDIR", apphome)
end

-- Load dependencies
-- begin ChatGPT
-- Load dependencies (Ensure at least one version is loaded)
local python_versions = {"python/3.11.4", "python/3.10.2"}
local java_versions = {"java-jdk/21", "java-jdk/17", "java-jdk/14", "java-jdk/11"}

local function ensure_one_loaded(versions)
    for _, v in ipairs(versions) do
        if isloaded(v) then
            return  -- If one is already loaded, no need to load another
        end
    end
    depends_on(versions[1])  -- Load the first option if none are loaded
end

ensure_one_loaded(python_versions)
ensure_one_loaded(java_versions)
-- end ChatGPT

-- Display note when the module is loaded
if (mode() == "load") then
    LmodMessage([[
An environment variable "IPRDIR" has been set to the InterProScan directory.
InterProScan software has been installed.

USAGE EXAMPLE:
  ${IPRDIR}/interproscan.sh -i input.fasta --output-file-base IPRresult -cpu 4
]])
end
__END__
```

## RAxML NG (RAxML Next Generation MPI)
- Home page: https://github.com/amkozlov/raxml-ng/
- Source code: https://github.com/amkozlov/raxml-ng/releases/download/1.2.0/raxml-ng_v1.2.0_linux_x86_64_MPI.zip

### Installation on Deigo
```
APP=raxml-ng-mpi
VER=1.2.0
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
mkdir -p $APPDIR/$VER
cd $APPDIR/$VER
wget -O - https://github.com/amkozlov/raxml-ng/releases/download/1.2.0/raxml-ng_v1.2.0_linux_x86_64_MPI.zip > $APP-$VER.zip && unzip $APP-$VER.zip && rm $APP-$VER.zip
sh install.sh
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
whatis("URL: ".."https://github.com/amkozlov/raxml-ng")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."raxml-ng")
whatis("Description: ".."RAxML-NG is a phylogenetic tree inference tool which uses maximum-likelihood (ML) optimality criterion")

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
```

## PAML
- Home page: http://abacus.gene.ucl.ac.uk/software/#paml-for-unixlinux
- Source code: https://github.com/abacus-gene/paml

### Installation on Deigo
```
APP=paml
VER=4.10.6
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/abacus-gene/paml # this reads as version 4.9j on GitHub, which prints out as 4.10.6 when executed
mv $APP $VER && cd $VER/src
## allow higher number of taxa in some programs
sed -i "s/#define NS            500/#define NS            5000/g" mcmctree.c
sed -i "s/#define NS            1000/#define NS            5000/g" yn00.c
sed -i "s/#define NS          10/#define NS          5000/g" basemlg.c
## compile
make -f Makefile
rm *.o
mkdir ../bin
mv baseml basemlg chi2 codeml evolver infinitesites mcmctree pamp yn00 ../bin
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
whatis("URL: ".."https://github.com/abacus-gene/paml")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."PAML")
whatis("Description: ".."PAML is a program package for model fitting and phylogenetic tree reconstruction using DNA and protein sequence data. The programs are written in ANSI C")

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
```

## PHYLUCE
- Home page: https://phyluce.readthedocs.io/en/latest/
- Source code: https://phyluce.readthedocs.io/en/latest/installation.html
- - Note: switched to miniforge installation on 2024/12/11

### Installation on Deigo
```
APP=phyluce
VER=1.7.3
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b -p $APPDIR/$VER && rm Miniforge3-$(uname)-$(uname -m).sh && cd $VER
source ./bin/activate
./bin/mamba env create -p $MODROOT/$APP/$VER/envs/phyluce-1.7.3 --file=https://raw.githubusercontent.com/faircloth-lab/phyluce/v1.7.3/distrib/phyluce-1.7.3-py36-Linux-conda.yml
### modulefile
cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER
#%Module1.0##################################################################
set approot    [lrange [split [module-info name] {/}] 0 0]
set appname    [lrange [split [module-info name] {/}] 1 1]
set appversion [lrange [split [module-info name] {/}] 2 2]
set apphome    /bucket/BioinfoUgrp/$approot/$appname/$appversion

## URL of application homepage:
set appurl     https://phyluce.readthedocs.io/en/latest/index.html

## Short description of package:
module-whatis  "Phyluce installed using Miniforge3."

## Load any needed modules:

## Modify as needed, removing any variables not needed.
## Non-path variables can be set with "setenv VARIABLE value"
prepend-path    PATH            $apphome/bin
prepend-path    PATH            $apphome/envs/phyluce-1.7.3
prepend-path    PATH            $apphome/envs/phyluce-1.7.3/bin
prepend-path    PATH $apphome/lib
prepend-path    PYTHONPATH	$apphome/bin
__END__

```

## VeryFastTree
- Home page: https://github.com/citiususc/veryfasttree

### Installation on Deigo

```bash
APP=veryfasttree
VER=4.0.2
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR/ && cd $APPDIR/
git clone https://github.com/citiususc/veryfasttree
mv veryfasttree $VER && cd $VER/
cmake -DINSTALL_DIR:PATH=$APPDIR/$VER
make
chmod a+x VeryFastTree
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
whatis("URL: ".."https://github.com/citiususc/veryfasttree")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."veryfasttree")
whatis("Description: ".."VeryFastTree is a new tool designed for efficient phylogenetic tree inference, specifically tailored to handle massive taxonomic datasets.")

-- Package settings
prepend_path("PATH", apphome)
__END__
```
## phyloflash
- Home page: http://hrgv.github.io/phyloFlash/
- Note: switched to miniforge installation on 2024/12/12
### Installation on Deigo
```bash
APP=phyloflash
VER=3.4.2
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b -p $APPDIR/$VER && rm Miniforge3-$(uname)-$(uname -m).sh && cd $VER
source ./bin/activate
# add the channel to the configuration for the active environment
# https://stackoverflow.com/questions/40616381/can-i-add-a-channel-to-a-specific-conda-environment
./bin/conda config --env --add channels defaults
./bin/conda config --env --add channels bioconda
./bin/conda config --env --add channels conda-forge
# Create new environment named "pf" with phyloflash
#./bin/mamba env create -p $MODROOT/$APP/$VER/envs/pf $APP #### needs yml file
./bin/conda create -n pf $APP
# ./bin/conda activate $MODROOT/$APP/$VER/envs/pf #### CondaError: Run 'conda init' before 'conda activate'
# export PATH=$MODROOT/$APP/$VER/envs/pf/bin:$PATH
# ./envs/pf/bin/phyloFlash.pl -check_env
### modulefile
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
whatis("URL: ".."http://hrgv.github.io/phyloFlash/")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."rRNA, phylogeny, illumina, transcriptome")
whatis("Description: ".."phyloFlash is a pipeline to rapidly reconstruct the SSU rRNAs and explore phylogenetic composition of an Illumina (meta)genomic or transcriptomic dataset.")

-- Package settings
prepend_path("PATH", apphome)
prepend_path("PATH", apphome.."/envs/pf")
prepend_path("PATH", apphome.."/envs/pf/bin")
__END__
```


## QIIME2-amplicon
- Home page: https://github.com/qiime2/qiime2
- Installation: https://docs.qiime2.org/2024.5/install/native/#miniconda
- Note: switched to miniforge installation on 2024/12/12

### Installation on Deigo
```bash
APP=qiime2-amplicon
VER=2024.5
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b -p $APPDIR/$VER && rm Miniforge3-$(uname)-$(uname -m).sh && cd $VER
source ./bin/activate
./bin/mamba env create -p $MODROOT/$APP/$VER/envs/$APP-$VER --file=https://data.qiime2.org/distro/amplicon/qiime2-amplicon-2024.5-py39-linux-conda.yml
# conda activate /bucket/BioinfoUgrp/Other/qiime2-amplicon/2024.5/envs/qiime2-amplicon-2024.5
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
whatis("URL: ".."https://github.com/qiime2/qiime2")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."DNA, amplicon, metagenome")
whatis("Description: ".."QIIME 2 is a powerful, extensible, and decentralized microbiome bioinformatics platform that is free, open source, and community developed.")

-- Package settings
prepend_path("PATH", apphome)
prepend_path("PATH", apphome.."/envs/qiime2-amplicon-2024.5")
prepend_path("PATH", apphome.."/envs/qiime2-amplicon-2024.5/bin")
__END__
```

## BAMM
- Home page: https://github.com/macroevolution/bamm
- Installation: https://github.com/macroevolution/bamm

### Installation on Deigo
```bash
APP=bamm
VER=2.5
MODROOT=/bucket/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR/$VER
cd $APPDIR
git clone https://github.com/macroevolution/bamm
mv $APP $VER
cd $VER
# compile
mkdir build
cd build
cmake ..
make -j
cd $MODROOT/$APP/$VER
mkdir -p bin
cd bin
ln -s $MODROOT/$APP/$VER/build/bamm .
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
whatis("URL: ".."https://github.com/macroevolution/bamm")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."bamm")
whatis("Description: ".."A program for multimodel inference on speciation and trait evolution.")

-- Package settings
prepend_path("PATH", apphome.."/bin")
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
