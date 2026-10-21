# Bioinformatics software on Deigo and Saion

OIST's Bioinformatics User Group (BioinfoUgrp) installs bioinformatics
software and databases on OIST's two clusters: _Deigo_ (CPUs) and _Saion_
(GPUs).  This software comes as _environment modules_, which you load before
running a program.  This page explains how to use the modules and lists what
we provide.

The clusters are run by the Scientific Computing and Data Analysis section
(SCDA).  Their [guide](https://scda-guide.oist.jp) is the reference for
accounts, storage, Slurm and the module system.  Where this page and the SCDA
guide disagree, the SCDA guide is correct; please tell us so that we can fix
this page.

- [Quick start](#quick-start)
- [Environment modules: the basics](#environment-modules-the-basics)
- [Using modules in Slurm jobs](#using-modules-in-slurm-jobs)
- [What we provide](#what-we-provide)
- [Getting help](#getting-help)
- [Contributing](#contributing)


## Quick start

On a Deigo login node:

```bash
ml bioinfo-ugrp-modules      # make our modules visible
ml key minimap               # search the descriptions of all modules for a keyword
ml spider minimap2           # find a module and list its versions
ml Other/minimap2            # load it
minimap2 --version           # the program is now in your PATH
```

Do not run computations on the login nodes: once you have found the module
you need, use it in a Slurm job, as shown
[below](#using-modules-in-slurm-jobs).


## Environment modules: the basics

The clusters have hundreds of programs, often in several versions that
cannot be used at the same time.  To keep them apart, none of them is in your
`PATH` by default.  A _module_ is a small file that, when _loaded_, changes
your environment (mainly `PATH`, sometimes other variables) so that one
version of one program becomes usable.  _Unloading_ the module reverts the
change.  Modules do not install or copy anything; they only change variables
of your current shell.

SCDA's page [Use the module system](https://scda-guide.oist.jp/use-module-system.html)
describes the system in full; the module system is
[Lmod](https://lmod.readthedocs.io/en/latest/010_user.html).  The summary
below is limited to what you need for our modules.

### Commands

`module` is the command; on Deigo, `ml` is a shorter form of it.

| Task | Deigo (`ml` form) | Long form (Deigo and Saion) |
|---|---|---|
| List modules you can load | `ml av` | `module avail` |
| List modules whose name contains a word | `ml av samtools` | `module avail samtools` |
| Search names and descriptions | `ml key assembly` | `module key assembly` |
| Find a module anywhere, with its versions (Deigo only) | `ml spider hifiasm` | `module spider hifiasm` |
| Load the default version | `ml Other/hifiasm` | `module load Other/hifiasm` |
| Load a given version | `ml Other/hifiasm/0.25.0` | `module load Other/hifiasm/0.25.0` |
| List the modules you have loaded | `ml` | `module list` |
| Read a module's description and help | `ml whatis Other/hifiasm`, `ml help Other/hifiasm` | `module whatis …`, `module help …` |
| See what a module changes | `ml show Other/hifiasm` | `module show Other/hifiasm` |
| Unload one module | `ml -Other/hifiasm` | `module unload Other/hifiasm` |
| Unload all modules | `ml purge` | `module purge` |

When you do not give a version, the module system picks the default one,
which is usually the newest.  The default changes when we install a newer
version, so give the version explicitly when you need reproducible results,
and write it in your notes and methods sections.

### Our modules are behind a _metamodule_

Our modules are not visible until you load the metamodule
`bioinfo-ugrp-modules`.  Loading it adds our module directories to the list
where the module system searches (the `MODULEPATH` variable); it does not load
any program by itself.

```bash
ml bioinfo-ugrp-modules
ml av
```

SCDA use the same mechanism for other groups of modules: `ml av` lists
`bioinfo-ugrp-modules` among the metamodules, next to `amd-modules` and
`intel-modules`.  See their module page.  Inside our metamodule, some collections are again behind their own
metamodule, because they contain many modules (see
[What we provide](#what-we-provide)):

```bash
ml bioinfo-ugrp-modules DebianMed     # loads the two metamodules in turn
ml av
```

If you use our modules every day, you can add `ml bioinfo-ugrp-modules` to
your `~/.bashrc`.  This only makes the modules visible; it does not load any
program.

### Deigo and Saion differ

Our instructions for Saion use the long `module` form, because the `ml`
short form did not work there when they were written.  If an `ml` command
fails on Saion, use the long form:

```bash
module load bioinfo-ugrp-modules
module avail
```

The two clusters also do not have the same modules: most of ours are for
Deigo, and a few, which need GPUs, are for Saion.  Run `module avail` on the
cluster you use; a module seen on one cluster may be missing on the other or
be at a different version.

### When something goes wrong

- _Module not found_: load `bioinfo-ugrp-modules` first, then check the exact
  name and capitalisation with `ml spider <name>` (Deigo) or
  `module avail <name>`.
- _A module recently installed does not appear_: Lmod, the module system on
  Deigo, keeps a cache in your home directory.  Delete it with
  `rm -rf ~/.lmod.d/.cache` and try again.
- _Conflicting versions_: if a program behaves unexpectedly, run `ml purge`
  and load only the modules you need.


## Using modules in Slurm jobs

Load the modules inside the job script, not only in the shell from which you
submit it, as SCDA recommend: the script then records what the job needs.
Starting with `module purge` makes the job independent of what was loaded
when you submitted it.

A batch script for Deigo (submit with `sbatch myjob.sh`):

```bash
#!/bin/bash
#SBATCH --partition=compute
#SBATCH --time=0-04:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G

module purge
module load bioinfo-ugrp-modules
module load Other/minimap2/2.20

minimap2 -t "$SLURM_CPUS_PER_TASK" -a reference.fa reads.fq.gz > /flash/YourUnitU/aln.sam
```

An interactive session, for testing:

```bash
srun --partition=compute --time=0-02:00:00 --cpus-per-task=4 --mem=16G --pty bash
ml bioinfo-ugrp-modules Other/minimap2
```

Things to keep in mind (details in the SCDA guide):

- Always set the time (`-t`) and memory (`--mem`) of a job.  Ask for what the
  program needs, not the maximum: smaller jobs start sooner.  The `ruse`
  module measures what a program actually used.
- Submit jobs from your home directory: Slurm writes its output files in the
  directory you submit from, and a job submitted from `/bucket` fails.
- On compute nodes, `/bucket` is read-only.  Read your input from `/bucket`,
  write output to `/flash` (Deigo) or `/work` (Saion), and copy the results
  back to `/bucket` at the end.
- On Saion, start batch scripts with `#!/bin/bash -l` and interactive jobs
  with `bash -l`, otherwise the module system is not set up.  GPU jobs need a
  GPU partition and `--gres`.

SCDA pages: [Use Slurm](https://scda-guide.oist.jp/use-slurm),
[Deigo](https://scda-guide.oist.jp/deigo.html),
[the Saion system](https://scda-guide.oist.jp/saion-system.html),
[resource limits](https://scda-guide.oist.jp/resource-limits.html),
[rules and guidelines](https://scda-guide.oist.jp/support-services.html).


## What we provide

| Collection | How to see it | Cluster | Documentation |
|---|---|---|---|
| General bioinformatics tools (aligners, assemblers, phylogeny, Hi-C, repeats, …) | `ml bioinfo-ugrp-modules`, then `ml av Other` | Deigo | [Other/README.md](Other/README.md) |
| Hundreds of tools packaged by Debian Med, one module each | `ml bioinfo-ugrp-modules DebianMed`, then `ml av` | Deigo | [DebianMedModules.md](DebianMedModules.md) |
| Unix command-line utilities | `ml bioinfo-ugrp-modules UnixGoodies`, then `ml av` | Deigo | [oist/BioinfoUgrp_UnixGoodies_Images](https://github.com/oist/BioinfoUgrp_UnixGoodies_Images) |
| Nextflow, nf-core tools, nf-test, and the `-profile oist` for nf-core pipelines | `ml bioinfo-ugrp-modules Nextflow3` | Deigo | [Nextflow.md](Nextflow.md) |
| Databases: BLAST, DIAMOND, GTDB, Pfam, Dfam | `ml bioinfo-ugrp-modules`, then `ml av DB` | Deigo | [DataBases.md](DataBases.md) |
| RStudio server on a compute node, and `Rscript` | `ml bioinfo-ugrp-modules Other/RStudio_server` | Deigo | [RStudio/README.md](RStudio/README.md) |
| Nanopore basecalling (Dorado) and related tools | `module load bioinfo-ugrp-modules`, then `module avail` | Saion (Deigo for CPU-only tools) | [NanoporeModules/README.md](NanoporeModules/README.md) |
| AlphaFold 2 protein structure prediction | `module load bioinfo-ugrp-modules`, then `module avail` | Saion | [AlphaFold/README.md](AlphaFold/README.md) |

The same program can exist in several collections, and in SCDA's own
modules.  They can differ in version and in the way they were built; use
`ml spider <name>` to see them all, and load the one you want by its full
name.

### Requests

To ask for new software, a new version, or a database update, write on the
Teams channel (see below) or open an
[issue on GitHub](https://github.com/oist/BioinfoUgrp/issues).  If you open
an issue, also post its link on the Teams channel to notify us.  We update
databases at most once a year.  After an update, we ask whether the previous
version is still needed; if nobody needs it, we delete it after 30 days.  At
most two versions of a database are kept at the same time.


## Getting help

Our main channel is the
[BioinfoUgrp team on Microsoft Teams](https://teams.microsoft.com/l/team/19%3a3183bd7fe2844138a49996a2bd376873%40thread.tacv2/conversations?groupId=cc78e114-c544-43e2-b4b1-29c7428aa305&tenantId=d8c0fb8d-bb56-44bb-9f4a-c58e7465652e)
(OIST login needed).  Messages there are easy to miss, so mention the people
you address with `@` followed by their name.

Before asking, search the web for the error message: many problems are
already reported, with a solution, in the program's own issue tracker (for
instance the `Issues` tab of its GitHub repository) or forum (for instance
[IQ-TREE's Google group](https://groups.google.com/g/iqtree)), or on
[Biostars](https://www.biostars.org) and
[Stack Overflow](https://stackoverflow.com).

SCDA also offer
[Bioinformatics Open Hours](https://scda-answers.oist.jp/books/scda-open-hours/page/bioinformatics-open-hours)
for one-on-one consultation.  For problems with the clusters themselves
(accounts, storage, Slurm, SCDA's own modules), contact SCDA:
`ask-scda@oist.jp`.


## Contributing

The installation recipes and maintenance notes are separate from the user
documentation: see [CONTRIBUTING.md](CONTRIBUTING.md).
