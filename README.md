# OIST's bioinformatics user group

## Communication channel
Prioritized communication channel is on Microsoft Teams: [BioinfoUgrp](https://teams.microsoft.com/l/team/19%3a3183bd7fe2844138a49996a2bd376873%40thread.tacv2/conversations?groupId=cc78e114-c544-43e2-b4b1-29c7428aa305&tenantId=d8c0fb8d-bb56-44bb-9f4a-c58e7465652e). Do not hesitate to use the ping function (putting `@` and then the name, like in other chat systems), because the discussions on the Team app are a bit easy to miss otherwise.
Please "Google" the issues prior to contacting us. Very often, the main issues will already be reported and the solution available on the reference webpage of the program: in the `Issues` tab of `GitHub` for some, in `GoogleGroups` for others (e.g. for [IQ-TREE](https://groups.google.com/g/iqtree)). Other great platforms are [StackOverflow](https://stackoverflow.com), or [Biostars](https://www.biostars.org).

## Finding modules
Search with a keyword, for instance `ml key clustal`.

## Loading installed modules
Execute `ml bioinfo-ugrp-modules` to make available the modules installed by the OIST Bioinfo user group. This line can be appended to your `~/.bashrc` to make them available by default.

### Debian Med modules
We autogenerate many modules from softwares packaged the Debian distribution.  To see them, execute `ml bioinfo-ugrp-modules DebianMed`.  More information is available on the [DebianMedModules](DebianMedModules.md) page.
To load a module in DebianMed (an example for loading bcftools):
```
# load DebianMed module first
ml bioinfo-ugrp-modules DebianMed

# now you can see the list of module installed in DebianMed.
ml avail

# load module
ml bcftools

# check the installation
bcftools --version
```

### Unix goodies

We provide some modules for Unix tools useful to everybody including bioinformaticians.

```
ml bioinfo-ugrp-modules UnixGoodies
ml av
```

Check [oist/BioinfoUgrp_UnixGoodies_Images](https://github.com/oist/BioinfoUgrp_UnixGoodies_Images) for details.

### Nextflow pipelines

We have prepared a [Nextflow](https://www.nextflow.io/) module (`ml bioinfo-ugrp-modules Nextflow2`) and registered [OIST's profile](https://github.com/nf-core/configs/blob/master/docs/oist.md) to the [nf-core](https://nf-co.re/) community so that you can run their pipelines with the `-profile oist` option on _Deigo_.  A _nf-core_ [module](https://github.com/nf-core/modules) is also available (`ml bioinfo-ugrp-modules nf-core`).

### Other tools

Under the `Other/` namespace, we also provide some general bioinformatics tools such as:

- DIAMOND (`ml Other/DIAMOND/2.0.4.142`)
- InterProScan and its database (`ml Other/interproscan/5.48-83.0`)
- … and more !

See [this page](Other.md) for the full list of modules and for more information.

## Databases
Widely used databases were installed locally. Upon request by users, we plan on upgrading databases (not more than once a year). After upgrading a specific database, users will be asked if the older database should still remain available (completion of projects,...): it will be deleted after 30 days except if still required. At one time, a maximum of two versions of the same database will be available.

### Taxified BLAST databases
The following databases were constructed using ncbi-blast v2.10.0+. The module `ncbi-blast/2.10.0+` has to be loaded in order to use these databases.
- NCBI NT and NR databases (release 238) : `ml DB/blastDB/ncbi/238`. To be used with the arguments `nt` or `nr` supplied to `-db` in the commands of your scripts. Example script to get a taxified blast report:
```
module load ncbi-blast/2.10.0+
module load DB/blastDB/ncbi/238
WORKDIR="$PWD"
FASTA=FULL/PATH/TO/YOUR/FASTA/FILE
blastn -task megablast -db nt -query $FASTA -num_threads ${SLURM_CPUS_PER_TASK} -out ${WORKDIR}/megablastn.out \
	-outfmt '6 qseqid bitscore evalue length qlen qcovs pident sseqid sgi sacc staxid ssciname scomname stitle sseq' \
	-max_target_seqs 1
```
- Swiss-Prot (version 2020_06): `ml DB/blastDB/sprot/2020_06`
- UniRef90 (version 2020_06): `ml DB/blastDB/uniref90/2020_06`

### Taxified DIAMOND databases
The following databases were constructed using DIAMOND v2.0.4.142. The module `Other/DIAMOND/2.0.4.142` has to be loaded in order to use them.
- the NCBI-NR database (release 238): `ml DB/diamondDB/ncbi/238`
- Swiss-Prot (version 2020_06): `ml DB/diamondDB/sprot/2020_06`
- UniRef90 (version 2020_06): `ml DB/diamondDB/uniref90/2020_06`

Unlike ncbi-blast, DIAMOND requires full path of the databases. The database module automatically create an environment variable "DIAMONDDB" which specifies full path to the DIAMOND database. So you need to prepend `${DIAMONDDB}` to the name of database. 
Example script to run diamond with the database module:
```
# load ncbi database for DIAMOND (proper version of DIAMOND is automatically loaded)
module load DB/diamondDB/ncbi/238

# check the loaded DIAMOND version and ${DIAMONDDB} variable
diamond --version
echo ${DIAMONDDB}

# run diamond search
WORKDIR="$PWD"
FASTA=FULL/PATH/TO/YOUR/FASTA/FILE
diamond blastp -db ${DIAMONDDB}/nr -q $FASTA -p ${SLURM_CPUS_PER_TASK} -out ${WORKDIR}/diamond.blastp.out -outfmt 6
```

### Pfam

Version 34.0:  Use `ml DB/Pfam/34.0` to invoke it in your scripts.

### Dfam

Version 3.9 downloaded from <https://www.dfam.org/releases/Dfam_3.9/families/> and <https://www.dfam.org/releases/Dfam_3.9/families/FamDB>.  HDF5 files were uncompressed after checking their MD5 sums.

The command `ml DB/Dfam/3.9` exposes two environment variables
 - `$BioinfoUgrp_Dfam` containing the path to the directory containing the HMM files, that can be passed to RepeatMasker through its `-libdir` argument.
 - `$BioinfoUgrp_FamDB` containing the path to the directory containing the HDF5 files, to be bind-mounted on `/opt/RepeatMasker/Libraries/famdb/` when using `TETools`.

### Dfam for RepeatMasker

The command `ml DB/Dfam_RepeatMasker/3.6__4.1.3` will set an environmental variable that changes the behaviour of the `repeatmodeler` module, so that it will use the full Dfam database provided by us instead of the “_curated only_” version provided by default.

#### Developer details

The RepeatMasker program does not follow symbolic links and the Dfam database is large (160 Gb), so I had to use hard links to the files of the `Dfam` module instead.  Also, the modulefile contains:

```
setenv("BioinfoUgrp_Dfam_Rmsk_4_1_3", apphome.."/RepeatMasker_4.1.3/Libraries")
setenv("SINGULARITY_BINDPATH", apphome.."/Libraries:/opt/RepeatMasker/Libraries")
```

## RStudio

[Here is how you can run RStudio](./RStudio) on a compute node.

## Modules on Saion

We have some modules on _Saion_ for GPU-accelerated computations such that can not be run on _Deigo_.  Please remember that the _modules_ system on _Saion_ is older, so the `ml` shortcuts will not work.  To list the available modules, do:

```
module load bioinfo-ugrp-modules
module available
```

### AlphaFold

We have a basic module for [AlphaFold 2.1.1](AlphaFold/AlphaFold2.md).  For a basic usage, you can do something similar to the example script in `/bucket/BioinfoUgrp/alphafold/2.1.1/bin/alphafold_example_script.sh`.

### Nanopore

We have modules for [basecalling Nanopore](NanoporeModules/README.md) data, in particular for _Guppy_ and _Rerio_.
