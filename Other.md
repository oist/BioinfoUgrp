# A collection of general bioinformatics modules

## TO DO
- Better to categorize modules into smaller subsets?

## Usage

```bash
module load bioinfo-ugrp-modules
ml av Other
module load Other/<your-favorite-module>
```

List of available modules:

```text
Other/3d-dna/180922
Other/arima_pipeline/2019.02.08
Other/assembly_stats/1.0.1
Other/asset/1.0.3
Other/BEAST/1.10.4
Other/bioawk/1.0
Other/BUSCO/5.1.3
Other/bwa/0.7.17
Other/cactus/2.4.0
Other/canu/2.1.1
Other/DAZZ_DB/2021.03.30
Other/deepvariant/1.1.0
Other/DIAMOND/2.0.4.142
Other/FASTK/2021.05.27
Other/fasttree/2.1.11
Other/genescope/2021.03.26
Other/genomescope/2.0
Other/gfatools/0.5
Other/hal/2.2
Other/hifiasm/0.15.4
Other/interproscan/5.48-83.0
Other/interproscan/5.60-92.0
Other/iqtree/2.2.0
Other/juicer/1.6
Other/k8/0.2.5
Other/KMC/genomescope
Other/make_telomere_bed/2021.05.20
Other/merqury/1.3
Other/meryl/1.3
Other/minimap2/2.20
Other/mosdepth/0.3.1
Other/mugsy/1r2.2
Other/Nextflow/20.10.0
Other/Nextflow/21.02.0-edge
Other/nf-core/1.12.1-0
Other/pairtools/0.3.0
Other/parallel/20210622
Other/pbgzip/2016.08.04
Other/pbipa/1.3.2
Other/peregrine/1.6.3
Other/preseq/3.1.2
Other/prokka/1.14.5
Other/purge_dups/1.2.5
Other/SALSA/2.3
Other/samblaster/0.1.26
Other/seqkit/2.0.0
Other/smudgeplot/0.2.3
Other/SPAdes/3.15.1
Other/trf/4.09.1
Other/winnowmap/2.03
```

# Installation

## assembly-stats

- Home page: https://github.com/sanger-pathogens/assembly-stats
- Source code: https://github.com/sanger-pathogens/assembly-stats
- 
### Installation on Deigo

```bash
APP=assembly-stats
VER=1.0.1
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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

## pbgzip

- Home page: https://github.com/nh13/pbgzip
- Source code: https://github.com/nh13/pbgzip
- 
### Installation on Deigo

```bash
APP=pbgzip
VER=20160804
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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


## pairtools

- Home page: https://pairtools.readthedocs.io/en/latest/
- Source code: https://github.com/open2c/pairtools

### Installation on Deigo

```bash
module load python/3.7.3
APP=pairtools
VER=0.3.0
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/shenwei356/seqkit/releases/download/v$VER/seqkit_linux_amd64.tar.gz | tar xzvf -
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
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR/$VER
cd $APPDIR
wget -O - https://ftp.gnu.org/gnu/parallel/parallel-$VER.tar.bz2 | tar xjvf -
cd $APP-$VER && ./configure --prefix=$APPDIR/$VER && make && make install && cd .. && rm -r $APP-$VER
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
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR
wget https://github.com/brentp/mosdepth/releases/download/v$VER/mosdepth && chmod +x mosdepth
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
VER=5.1.3
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR
singularity pull busco.sif docker://ezlabgva/busco:v${VER}_cv1
echo '#!/bin/sh' > busco && echo "singularity exec $APPDIR/busco.sif busco \$*" >> busco && chmod +x busco
echo '#!/bin/sh' > copy_augustus_config_dir && echo "singularity exec $APPDIR/busco.sif cp -r /augustus/config \$HOME/augustus_config" >> copy_augustus_config_dir && chmod +x copy_augustus_config_dir
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
whatis("URL: ".."https://busco.ezlab.org/")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."assembly")
whatis("Description: ".."Assessing genome assembly and annotation completeness with Benchmarking Universal Single-Copy Orthologs (BUSCO).")

-- Package settings
depends_on("singularity")
prepend_path("PATH", apphome)

execute {
    cmd = "if [ ! -d $HOME/augustus_config ]; then copy_augustus_config_dir; fi; export AUGUSTUS_CONFIG_PATH=\"$HOME/augustus_config\"",
    modeA = {"load"}
}
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
VER=0.15.4
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/chhylp123/hifiasm/archive/refs/tags/$VER.tar.gz | tar xzvf -
mv $APP-$VER $VER
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
whatis("Description: ".."Hifiasm: a haplotype-resolved assembler for accurate Hifi reads.")

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

## Canu (and HiCanu)

- Home page: https://github.com/marbl/canu
- Source code: https://github.com/marbl/canu/releases

### Installation on Deigo

```bash
APP=canu
VER=2.1.1
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/marbl/canu/releases/download/v$VER/$APP-$VER.Linux-amd64.tar.xz | tar Jxvf -
mv $APP-$VER $VER
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
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/marbl/meryl/releases/download/v$VER/meryl-$VER.Linux-amd64.tar.xz | tar Jxvf -
mv $APP-$VER $VER
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR
singularity pull $APP.sif docker://cschin/$APP:$VER
echo '#!/bin/sh' > $APP && echo "echo yes | singularity run $APPDIR/$APP.sif asm \$*" >> $APP && chmod +x $APP
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

### Installation on Deigo

```bash
APP=pbipa
VER=1.3.2
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh -b -p $APPDIR/$VER && rm Miniconda3-latest-Linux-x86_64.sh
cd $VER
./bin/conda config --add channels defaults
./bin/conda config --add channels conda-forge
./bin/conda config --add channels bioconda
./bin/conda install -y $APP=$VER
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
whatis("URL: ".."https://github.com/PacificBiosciences/pbipa")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."PacBio, HiFi, assembly")
whatis("Description: ".."Improved Phased Assembler.")

-- Package settings
prepend_path("PATH", apphome.."/bin")
__END__
```

### Example commands for running IPA on Deigo

```bash
module load Other/pbipa
srun -p compute -c 128 --mem 500G -t 24:00:00 --pty \
    ipa <arguments>
```

## DeepVariant

- Home page: https://github.com/google/deepvariant
- Source code: https://hub.docker.com/r/google/deepvariant/tags

### Installation on Deigo

```bash
module load singularity
APP=deepvariant
VER=1.1.0
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR
singularity pull $APP.sif docker://google/$APP:$VER
for CMD in run_deepvariant make_examples call_variants postprocess_variants; do echo '#!/bin/sh' > $CMD && echo "singularity exec $APPDIR/$APP.sif $CMD \$*" >> $CMD && chmod +x $CMD; done
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
wget -O - https://github.com/marbl/SALSA/archive/refs/tags/v$VER.tar.gz | tar xzvf -
mv $APP-$VER $VER && cd $VER && make
wget https://s3.amazonaws.com/hicfiles.tc4ga.com/public/juicer/juicer_tools_1.22.01.jar
cat <<'__END__' > convert.sh
#!/bin/bash
JUICER_JAR=/apps/unit/BioinfoUgrp/Other/SALSA/2.3/juicer_tools_1.22.01.jar
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/dfguan/purge_dups
mv purge_dups $VER && cd $VER/src && make
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
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/dfguan/asset
mv asset $VER && cd $VER/src && make
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
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR
wget https://github.com/Benson-Genomics-Lab/TRF/releases/download/v$VER/trf409.linux64 && mv trf409.linux64 $APP && chmod +x $APP
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/thegenemyers/DAZZ_DB
mv DAZZ_DB $VER && cd $VER && make
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
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/thegenemyers/FASTK
mv FASTK $VER && cd $VER && make
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR
git clone https://github.com/tbenavi1/KMC
mv KMC $VER && cd $VER && make
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR/$VER/bin
cd $APPDIR/$VER/bin
wget -O - http://www.microbesonline.org/fasttree/FastTreeMP > fasttree
chmod a+x fasttree
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
local modroot    = "/apps/unit/BioinfoUgrp"
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
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR
singularity build prokka.sif docker://staphb/prokka:${VER}
echo '#!/bin/sh' > prokka && echo "singularity exec $APPDIR/prokka.sif prokka \$*" >> prokka && chmod +x prokka
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
set apphome    /apps/unit/BioinfoUgrp/$approot/$appname/$appversion

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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
set apphome    /apps/unit/BioinfoUgrp/$approot/$appname/$appversion

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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
set apphome    /apps/unit/BioinfoUgrp/$approot/$appname/$appversion

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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
set apphome    /apps/unit/BioinfoUgrp/$approot/$appname/$appversion

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
- Home page: [https://github.com/lh3/bioawk](https://github.com/ComparativeGenomicsToolkit/cactus)
- Source code: quay.io/comparative-genomics-toolkit/cactus:v2.4.0

### Installation on Deigo
```
module load singularity
APP=cactus
VER=2.4.0
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR
singularity build $APP.sif docker:quay.io/comparative-genomics-toolkit/${APP}:v${VER}
echo '#!/bin/sh' > $APP && echo "singularity exec $APPDIR/$APP.sif $APP \$*" >> $APP && chmod +x $APP
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
MODROOT=/apps/unit/BioinfoUgrp/Other
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
set apphome    /apps/unit/BioinfoUgrp/$approot/$appname/$appversion

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

## InterProScan
- Home page: https://interproscan-docs.readthedocs.io/en/latest/index.html
- Source code: 

### Installation on Deigo
```bash
APP=interproscan
VER=5.60-92.0
MODROOT=/apps/unit/BioinfoUgrp/Other
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
# Index HMMs, see https://interproscan-docs.readthedocs.io/en/latest/HowToDownload.html#index-hmm-models
srun -pshort python3 setup.py interproscan.properties
# Fix prosite binaries, see https://interproscan-docs.readthedocs.io/en/latest/KnownIssues.html?highlight=prosite#prosite-pfsearchv3-errors
sed -i.bak -e '/binary.prosite.pfscanv3.path/s/pfscanV3$/altbin\/pfscanV3.noaf/' -e '/binary.prosite.pfsearchv3.path/s/pfsearchV3$/altbin\/pfsearchV3.noaf/' interproscan.properties
#################################### TO BE COMPLETED DURING NEXT UPDATE?
cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER
#%Module1.0
#
# InterProScan software and databases  
#

set approot    [lrange [split [module-info name] {/}] 0 0]
set appname    [lrange [split [module-info name] {/}] 1 1]
set appversion [lrange [split [module-info name] {/}] 2 2]
set apphome    /apps/unit/BioinfoUgrp/$approot/$appname/$appversion

## set/prepend environment valiable
if { [ info exist env(IPRDIR) ] } then {
  prepend-path  IPRDIR     $apphome
} else {
  setenv        IPRDIR     $apphome 
}

## URL of application homepage:
set appurl     "https://interproscan-docs.readthedocs.io/en/latest/index.html"

## Short description of package:
module-whatis  "InterproScan to run the scanning algorithms from the InterPro database in an integrated way."

## Load dependencies
module load python/3.7.3
module load java-jdk/14

## Note
if {[ module-info mode load ]} then {
  puts stderr {
  An environment variable "IPRDIR" has been set to InterProScan directory.
  InterProScan software has been installed.

  USAGE EXAMPLE:
    ${IPRDIR}/interproscan.sh -i input.fasta --output-file-base IPRresult -cpu 4

  }
}

## prepend pathes
#prepend-path    PATH            $apphome

#EOF
__END__
```

## OceanParcels

Module created for the mini course on Particle Tracking Simulation using Ocean Parcels (<https://groups.oist.jp/grad/mini-course-particle-tracking-simulation-using-ocean-parcels>)

```
APP=parcels
MODROOT=/apps/unit/BioinfoUgrp/Other
APPDIR=$MODROOT/$APP
VER=2.4.0
mkdir -p $APPDIR
cd $APPDIR
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh -b -p $APPDIR/$VER
cd $VER
./bin/conda create -n $APP
./bin/conda install --yes -n $APP -c conda-forge $APP
./bin/conda install --yes -n $APP jupyter
./bin/conda install --yes -n $APP cmocean
./bin/conda install --yes -n $APP cartopy
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
whatis("URL: ".."https://oceanparcels.org/")
whatis("Category: ".."Marine sciences")
whatis("Keywords: ".."Simulator")
whatis("Description: ".." Probably A Really Computationally Efficient Lagrangian Simulator.")

help([[OceanParcels installed with conda.

See https://oceanparcels.org/ for help.]])

-- Package settings
setenv("JUPYTER_CONFIG_DIR", "/apps/free81/python/3.7.3/share/jupyter")
prepend_path("PATH", apphome.."/envs/parcels/bin")
prepend_path("PYTHONPATH", apphome.."/envs/parcels/lib/python3.10/site-packages")
__END__
