# General bioinformatics modules (`Other/`)

These modules are installed by the Bioinformatics User Group under
`/bucket/BioinfoUgrp/Other`.  Their names start with `Other/`.  If modules
are new to you, read the [main page](../README.md) first.

```bash
ml bioinfo-ugrp-modules       # make our modules visible
ml av Other                   # list the Other/ modules and their versions
ml whatis Other/seqkit        # one-line description
ml Other/seqkit               # load the default version
```

The tables below list the modules by topic, with no version numbers because
these change; `ml av Other` shows the versions installed.  Unless stated
otherwise, a module puts the program of the same name in your `PATH`, and
runs on Deigo.  🏠 links to the program's homepage; on Deigo,
`ml whatis <module>` also shows the homepage recorded in the module, as
`URL`.  The
[usage notes](#usage-notes) after the tables describe the modules that work
differently.

To run a program, load its module in a Slurm job; see
[Using modules in Slurm jobs](../README.md#using-modules-in-slurm-jobs).


## Alignment and mapping

| Module | Purpose | Notes |
|---|---|---|
| `Other/bwa` [🏠](https://github.com/lh3/bwa "Homepage") | Short-read mapping to a reference genome | |
| `Other/minimap2` [🏠](https://github.com/lh3/minimap2 "Homepage") | Pairwise alignment of long reads, assemblies and spliced sequences | also `paftools.js` ([notes](#minimap2)) |
| `Other/k8` [🏠](https://github.com/attractivechaos/k8 "Homepage") | JavaScript shell | needed by `paftools.js`; loaded by `Other/minimap2` |
| `Other/winnowmap` [🏠](https://github.com/marbl/Winnowmap "Homepage") | Long-read and genome alignment, for repetitive regions | |
| `Other/samblaster` [🏠](https://github.com/GregoryFaust/samblaster "Homepage") | Marks duplicates in read-id grouped paired-end SAM files | |
| `Other/DIAMOND` [🏠](https://github.com/bbuchfink/diamond "Homepage") | Protein and translated DNA search | databases in [DataBases.md](../DataBases.md) |
| `Other/cactus` [🏠](https://github.com/ComparativeGenomicsToolkit/cactus "Homepage") | Reference-free whole-genome alignment | `cactus`, `cactus-pangenome` |
| `Other/hal` [🏠](https://github.com/ComparativeGenomicsToolkit/hal "Homepage") | Tools for HAL alignment files (made by Cactus) | |
| `Other/mugsy` [🏠](https://mugsy.sourceforge.net "Homepage") | Multiple whole-genome alignment | |


## SAM, BAM, VCF and sequence files

| Module | Purpose | Notes |
|---|---|---|
| `Other/samtools` [🏠](http://www.htslib.org "Homepage") | SAM/BAM/CRAM manipulation | |
| `Other/bcftools` [🏠](http://www.htslib.org "Homepage") | VCF/BCF manipulation and variant calling | |
| `Other/mosdepth` [🏠](https://github.com/brentp/mosdepth "Homepage") | Sequencing depth from BAM/CRAM | |
| `Other/preseq` [🏠](http://smithlabresearch.org/software/preseq/ "Homepage") | Estimates library complexity | |
| `Other/pbgzip` [🏠](https://github.com/nh13/pbgzip "Homepage") | Parallel block gzip | |
| `Other/seqkit` [🏠](https://bioinf.shenwei.me/seqkit/ "Homepage") | FASTA/FASTQ manipulation | |
| `Other/DAZZ_DB` [🏠](https://github.com/thegenemyers/DAZZ_DB "Homepage") | Dazzler database for long reads | [several commands](#packages-with-several-commands) |
| `Other/ncbi-datasets-cli` [🏠](https://www.ncbi.nlm.nih.gov/datasets/docs/v2/command-line-tools/ "Homepage") | Downloads genomes and annotations from NCBI | `datasets`, `dataformat` |


## k-mers and genome profiling

| Module | Purpose | Notes |
|---|---|---|
| `Other/FASTK` [🏠](https://github.com/thegenemyers/FASTK "Homepage") | k-mer counter for high-fidelity reads | [several commands](#packages-with-several-commands) |
| `Other/meryl` [🏠](https://github.com/marbl/meryl "Homepage") | k-mer counter | |
| `Other/merqury` [🏠](https://github.com/marbl/merqury "Homepage") | k-mer based assembly evaluation | `merqury.sh` |
| `Other/KMC/genomescope` [🏠](https://github.com/tbenavi1/KMC "Homepage") | k-mer counter, version modified for GenomeScope 2.0 and Smudgeplot | `kmc`, `kmc_dump`, `kmc_tools`, `smudge_pairs` |
| `Other/genomescope` [🏠](https://github.com/tbenavi1/genomescope2.0 "Homepage") | Genome size, heterozygosity and ploidy from k-mer spectra | `genomescope.R` |
| `Other/genescope` [🏠](https://github.com/thegenemyers/GENESCOPE.FK "Homepage") | GenomeScope for FASTK output | `GeneScopeFK.R` |
| `Other/smudgeplot` [🏠](https://github.com/KamilSJaron/smudgeplot "Homepage") | Ploidy and heterozygosity structure | `smudgeplot.py` |


## Genome assembly

| Module | Purpose | Notes |
|---|---|---|
| `Other/hifiasm` [🏠](https://github.com/chhylp123/hifiasm "Homepage") | Assembler for PacBio HiFi (and ONT) reads | |
| `Other/canu` [🏠](https://github.com/marbl/canu "Homepage") | Long-read assembler (Canu and HiCanu) | |
| `Other/Flye` [🏠](https://github.com/mikolmogorov/Flye "Homepage") | Long-read assembler | |
| `Other/SPAdes` [🏠](https://github.com/ablab/spades "Homepage") | Short-read assembly toolkit | |
| `Other/SMARTdenovo` [🏠](https://github.com/ruanjue/smartdenovo "Homepage") | Long-read assembler | |
| `Other/peregrine` [🏠](https://github.com/cschin/Peregrine "Homepage") | Assembler for HiFi reads | [notes](#peregrine-and-deepvariant) |
| `Other/TCSF_IMRA` [🏠](https://github.com/Yukihirokinjo/TCSF_IMRA "Homepage") | Improves de novo assemblies of endosymbiont genomes | `tcsf`, `imra` |

IPA (PacBio's Improved Phased Assembler) is no longer available, because it
was installed with Anaconda.  Tell us if you need it.


## Assembly evaluation and curation

| Module | Purpose | Notes |
|---|---|---|
| `Other/assembly-stats` [🏠](https://github.com/sanger-pathogens/assembly-stats "Homepage") | Assembly statistics (N50, …) | |
| `Other/BUSCO` [🏠](https://busco.ezlab.org/ "Homepage") | Completeness of assemblies and annotations | [notes](#busco) |
| `Other/gfatools` [🏠](https://github.com/lh3/gfatools "Homepage") | Manipulation of GFA assembly graphs | |
| `Other/BandageNG` [🏠](https://github.com/asl/BandageNG "Homepage") | Visualisation of assembly graphs | the graphical interface needs a display (X11 forwarding or remote desktop) |
| `Other/purge_dups` [🏠](https://github.com/dfguan/purge_dups "Homepage") | Removes haplotypic duplications | [several commands](#packages-with-several-commands); no runner script, no k-mer plot |
| `Other/asset` [🏠](https://github.com/dfguan/asset "Homepage") | Assembly evaluation | [several commands](#packages-with-several-commands); no runner script |
| `Other/make_telomere_bed` [🏠](https://github.com/yoshihikosuzuki/make_telomere_bed "Homepage") | BED file of telomeric repeats in contigs | |


## Hi-C and scaffolding

| Module | Purpose | Notes |
|---|---|---|
| `Other/arima_pipeline` [🏠](https://github.com/ArimaGenomics/mapping_pipeline "Homepage") | Arima Genomics Hi-C mapping scripts | [several commands](#packages-with-several-commands) |
| `Other/SALSA` [🏠](https://github.com/marbl/SALSA "Homepage") | Scaffolding with Hi-C | [notes](#salsa) |
| `Other/juicer` [🏠](https://github.com/aidenlab/juicer "Homepage") | Hi-C analysis (CPU version only) | [notes](#juicer) |
| `Other/3d-dna` [🏠](https://github.com/aidenlab/3d-dna "Homepage") | Hi-C scaffolding (normal mode only) | [notes](#3d-dna) |
| `Other/hic2cool` [🏠](https://github.com/4dn-dcic/hic2cool "Homepage") | Converts `.hic` to `.cool` | |
| `Other/pairtools` [🏠](https://pairtools.readthedocs.io/ "Homepage") | Processing of Hi-C read pairs | |


## Variants

| Module | Purpose | Notes |
|---|---|---|
| `Other/deepvariant` [🏠](https://github.com/google/deepvariant "Homepage") | Variant calling with a neural network | [notes](#peregrine-and-deepvariant) |

See also `Other/bcftools` above.


## Annotation and protein function

| Module | Purpose | Notes |
|---|---|---|
| `Other/eggnog-mapper` [🏠](http://eggnog-mapper.embl.de "Homepage") | Functional annotation by orthology (eggNOG) | [notes](#eggnog-mapper); loads its database |
| `Other/interproscan` [🏠](https://interproscan-docs.readthedocs.io/en/v5/ "Homepage") | Protein domain and family annotation | [notes](#interproscan) |
| `Other/prokka` [🏠](https://github.com/tseemann/prokka "Homepage") | Prokaryotic genome annotation | |
| `Other/defense_predictor` [🏠](https://pypi.org/project/defense-predictor/ "Homepage") | Predicts antiphage defence systems | needs a GPU: use on Saion |
| `Other/Boltz` [🏠](https://github.com/jwohlwend/boltz "Homepage") | Biomolecular structure and interaction prediction | needs a GPU: use on Saion; model weights are pre-installed |

For AlphaFold, see [AlphaFold/README.md](../AlphaFold/README.md).


## Repeats and transposable elements

| Module | Purpose | Notes |
|---|---|---|
| `Other/TETools` [🏠](https://github.com/Dfam-consortium/TETools "Homepage") | RepeatMasker, RepeatModeler and related tools | [notes](#tetools) |
| `Other/DfamTEBrowser` [🏠](https://github.com/Dfam-consortium/DfamTEBrowser "Homepage") | Genome browser for transposable element families | loads `Other/TETools` and `Other/ULTRA` |
| `Other/trf` [🏠](https://github.com/Benson-Genomics-Lab/TRF "Homepage") | Tandem Repeats Finder | |
| `Other/ULTRA` [🏠](https://github.com/TravisWheelerLab/ULTRA "Homepage") | Tandem repeat detection | |

The Dfam database is in [DataBases.md](../DataBases.md#dfam).


## Phylogeny and evolution

| Module | Purpose | Notes |
|---|---|---|
| `Other/iqtree` [🏠](http://www.iqtree.org "Homepage") | Maximum-likelihood phylogeny, IQ-TREE 2 | `iqtree2`, `iqtree` |
| `Other/iqtree3` [🏠](http://www.iqtree.org "Homepage") | Maximum-likelihood phylogeny, IQ-TREE 3 | `iqtree3` |
| `Other/raxml-ng-mpi` [🏠](https://github.com/amkozlov/raxml-ng "Homepage") | Maximum-likelihood phylogeny, MPI version | |
| `Other/fasttree` [🏠](http://www.microbesonline.org/fasttree/ "Homepage") | Approximately-maximum-likelihood phylogeny | |
| `Other/veryfasttree` [🏠](https://github.com/citiususc/veryfasttree "Homepage") | FastTree reimplementation for large datasets | |
| `Other/astral` [🏠](https://github.com/smirarab/ASTRAL "Homepage") | Species tree from gene trees | Java program: `java -jar $ASTRAL …` |
| `Other/aster` [🏠](https://github.com/chaoszhang/ASTER "Homepage") | Species tree estimation (ASTRAL family, CASTER) | |
| `Other/BEAST` [🏠](https://beast.community/ "Homepage") | Bayesian phylogenetics (BEAST 1) | |
| `Other/paml` [🏠](https://github.com/abacus-gene/paml "Homepage") | Phylogenetic analysis by maximum likelihood (codeml, …) | |
| `Other/bamm` [🏠](https://github.com/macroevolution/bamm "Homepage") | Speciation and trait evolution rates | |
| `Other/phyluce` [🏠](https://phyluce.readthedocs.io/ "Homepage") | Phylogenomics with ultraconserved elements | |


## Microbial ecology

| Module | Purpose | Notes |
|---|---|---|
| `Other/phyloflash` [🏠](http://hrgv.github.io/phyloFlash/ "Homepage") | SSU rRNA reconstruction from (meta)genomes or transcriptomes | |
| `Other/qiime2-amplicon` [🏠](https://qiime2.org/ "Homepage") | Amplicon (microbiome) analysis with QIIME 2 | |

For databases such as GTDB, see [DataBases.md](../DataBases.md).


## Visualisation servers

These start a web server on a compute node, which you open in your web
browser.

| Module | Purpose | Notes |
|---|---|---|
| `Other/jbrowse2` [🏠](https://jbrowse.org/jb2/ "Homepage") | JBrowse 2 genome browser | [notes](#web-servers-jbrowse2-and-cellxgene-vip) |
| `Other/cellxgene-vip` [🏠](https://github.com/interactivereport/cellxgene_VIP "Homepage") | Single-cell data explorer (cellxgene with VIP plugin) | [notes](#web-servers-jbrowse2-and-cellxgene-vip) |

For RStudio, see [RStudio/README.md](../RStudio/README.md).


## Utilities

| Module | Purpose | Notes |
|---|---|---|
| `Other/parallel` [🏠](https://www.gnu.org/software/parallel "Homepage") | GNU parallel: runs commands in parallel | |
| `Other/BFG` [🏠](https://rtyley.github.io/bfg-repo-cleaner/ "Homepage") | Removes large files from Git history | |
| `Other/prek` [🏠](https://github.com/j178/prek "Homepage") | Runs pre-commit hooks | used by nf-core tools |

For Nextflow, nf-core and nf-test, see [Nextflow.md](../Nextflow.md).


## Usage notes

### Packages with several commands

Some modules provide several programs, none of which has the module's name.
List them with `ml show <module>` (look at the directories added to `PATH`),
and read the program's own documentation.

- `Other/DAZZ_DB`: `fasta2DB`, `DB2fasta`, `DBsplit`, `DBdust`, `DBstats`,
  `DBshow`, `DBdump`, `DBrm`, `DBmv`, `DBtrim`, `DBwipe`, `Catrack`,
  `fasta2DAM`, `DAM2fasta`, `quiva2DB`, `DB2quiva`, `arrow2DB`, `DB2arrow`,
  `DBa2b`, `DBb2a`, `rangen`, `simulator`.
- `Other/FASTK`: `FastK`, `Fastcp`, `Fastmv`, `Fastrm`, `Haplex`, `Histex`,
  `Homex`, `Logex`, `Profex`, `Symmex`, `Tabex`, `Vennex`.
- `Other/purge_dups`: `purge_dups`, `pbcstat`, `ngscstat`, `calcuts`,
  `get_seqs`, `split_fa`.
- `Other/asset`: `ast_pb`, `ast_10x`, `ast_bion`, `ast_bion_bnx`, `ast_hic`,
  `ast_hic2`, `acc`, `detgaps`, `pchlst`, `pchlst0`, `col_conts`, `split_fa`,
  `union`, `union_brks`, `10x`.  The
  [VGP workflow](https://github.com/VGP/vgp-assembly/tree/master/pipeline/asset)
  shows how to combine them.
- `Other/arima_pipeline`: `filter_five_end.pl`, `two_read_bam_combiner.pl`,
  `get_stats.pl`.  The developers'
  [01_mapping_arima.sh](https://github.com/ArimaGenomics/mapping_pipeline/blob/master/01_mapping_arima.sh)
  shows how to use them.

### minimap2

The module also provides `paftools.js`, which runs with the `k8` JavaScript
shell (module `Other/k8`).

### BUSCO

BUSCO runs from a read-only Singularity image; the `busco` command calls it
for you.  If you need to change the AUGUSTUS configuration, the module
prints, when loaded, the commands to copy it to `$HOME/augustus_config` and
to point `AUGUSTUS_CONFIG_PATH` to that copy.

### Peregrine and DeepVariant

Both run from a Singularity image.  `peregrine <arguments>` runs the
assembler (`asm`) and answers its interactive prompt for you.
`Other/deepvariant` provides `run_deepvariant` and its steps,
`make_examples`, `call_variants` and `postprocess_variants`.

### SALSA

The main program is `run_pipeline.py`.  The module also provides
`convert.sh`, modified to work on Deigo; see SALSA's README for what it
does.

### Juicer

Juicer expects its scripts in a directory next to your data; read the
[Juicer wiki](https://github.com/aidenlab/juicer/wiki/Installation) first.
Only the CPU version is installed.

```bash
ml bioinfo-ugrp-modules Other/juicer
juicer_copy_scripts_dir   # creates a link named "scripts" in the current directory
./scripts/juicer.sh <arguments>
```

`scripts/common/juicer_tools.jar` is already in place.  The default of the
`-D` option is the current directory (`.`) instead of `/opt/juicer`.

### 3D-DNA

Read the [3D-DNA manual](http://aidenlab.org/assembly/manual_180322.pdf)
first.  Only the normal mode is supported (not the diploid or phasing
modes).  The module provides:

- `run-asm-pipeline.sh`, also available as `3d-dna`;
- `run-asm-pipeline-post-review.sh`, also as `3d-dna-post-review`;
- `run-assembly-visualizer.sh`, also as `3d-dna-run-assembly-visualizer`;
- `3d-dna-fasta2assembly`, which runs the developers'
  `generate-assembly-file-from-fasta.awk`:
  `3d-dna-fasta2assembly genome.fasta > genome.assembly`.

### eggnog-mapper

The module also loads `DB/eggnog-mapper/5.0.2`, which sets `EGGNOG_DATA_DIR`,
so `emapper.py` finds the eggNOG database without options.  The Pfam,
MMseqs2 and novel-families databases are installed; the per-taxon HMMER
databases are not (ask us if you need one).

```bash
ml bioinfo-ugrp-modules Other/eggnog-mapper
mkdir -p /flash/YourUnitU/emapper
emapper.py -i proteins.faa -o myrun --output_dir /flash/YourUnitU/emapper \
  --temp_dir /flash/YourUnitU/emapper --cpu "$SLURM_CPUS_PER_TASK"
```

Give `--cpu` explicitly: by default `emapper.py` uses one core, whatever the
job requested.  Give `--temp_dir` too: by default DIAMOND writes its temporary
files in the current directory, which is often your slow and small home
directory.  Reading the 8.7 GB DIAMOND database takes several minutes even
for a few proteins (7 minutes for 8 proteins on one core, in our test).

eggnog-mapper comes with its own DIAMOND, MMseqs2, HMMER and Prodigal, but
uses the ones first in your `PATH` if other modules provide them.  Load only
this module to use the bundled versions.

### InterProScan

The module sets `IPRDIR` to the installation directory and loads Python and
Java if needed.

```bash
${IPRDIR}/interproscan.sh -i input.fasta --output-file-base IPRresult -cpu 4
```

### TETools

The module provides `RepeatMasker`, `RepeatModeler`, `BuildDatabase`,
`famdb.py`, `calcDivergenceFromAlign.pl`, `createRepeatLandscape.pl`,
`generateSeedAlignments.pl`, `rmblastn`, `makeblastdb` and `blastx`, each
running from the Dfam TETools Singularity image.  To use the full Dfam
database instead of the curated part bundled with the image, load one of the
Dfam modules described in [DataBases.md](../DataBases.md#dfam).

### Web servers: jbrowse2 and cellxgene-vip

Start the server inside a Slurm job, from a directory where it can write,
such as `/flash/YourUnitU/<your user name>`: `/bucket` is read-only on compute nodes.

```bash
srun -p compute -t 2:00:00 -c 4 --mem 8G --pty bash
ml bioinfo-ugrp-modules Other/jbrowse2
cd /flash/YourUnitU/$USER
launch_jbrowse2 --fasta /path/to/genome.fa       # the .fai index must exist
```

`launch_jbrowse2 --help` lists the options.  The module also provides
`jbrowse2`, the JBrowse command-line tool.  With `Other/cellxgene-vip`, the
command is `cellxgene-vip file.h5ad`.

Both commands print the address of the server and an `ssh -L` command to
reach it from outside OIST's network.  **The servers have no password:
anyone on OIST's network who finds the address can see your data, and
JBrowse's admin server also lets them edit it.**  Do not leave them running,
and delete the files they created on `/flash` when you are done.
