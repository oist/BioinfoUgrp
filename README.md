# OIST's bioinformatics user group

## Communication channel
Prioritized communication channel is on Microsoft Teams: [BioinfoUgrp](https://teams.microsoft.com/l/team/19%3a3183bd7fe2844138a49996a2bd376873%40thread.tacv2/conversations?groupId=cc78e114-c544-43e2-b4b1-29c7428aa305&tenantId=d8c0fb8d-bb56-44bb-9f4a-c58e7465652e).

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

### Nextflow pipelines

We have prepared a [Nextflow](https://www.nextflow.io/) module (`ml bioinfo-ugrp-modules Nextflow`) and regisered [OIST's profile](https://github.com/nf-core/configs/blob/master/docs/oist.md) to the [nf-core](https://nf-co.re/) community so that you can run their pipelines with the `-profile oist` option on _Deigo_.  A _nf-core_ module is also available (`ml bioinfo-ugrp-modules nf-core`).

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

### Other databases
- Pfam (version 34.0):  Use `ml DB/Pfam/34.0` to invoke it in your scripts.

## Modules on Saion

We have some modules on _Saion_ for GPU-accelerated computations such that can not be run on _Deigo_.  Please remember that the _modules_ system on _Saion_ is older, so the `ml` shortcuts will not work.  To list the available modules, do:

```
module load bioinfo-ugrp-modules
module available
```

### Alpha Fold
We have a very basic implementation of Alpha fold 2.0 within the user group modules. You can find (in time) a verbose documentation [here](AlphaFold.md). However, for a basic usage, you can try to do something similar to the example script in: /apps/unit/BioinfoUgrp/alphafold/2.0.0/bin/alphafold_example_script.sh

### Nanopore

We have modules for [basecalling Nanopore](NanoporeModules.md) data, in particular for _Guppy_ and _Rerio_.
