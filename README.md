# OIST's bioinformatics user group

## Finding modules
Search with a keyword, for instance `ml key clustal`.

## Loading installed modules
Execute `ml bioinfo-ugrp-modules` to make available the modules installed by the OIST Bioinfo user group. This line can be appended to your `~/.bashrc` to make them available by default.

### Debian Med modules
We autogenerate many modules from softwares packaged the Debian distribution.  To see them, execute `ml bioinfo-ugrp-modules DebianMed`.  More information is available on the [DebianMedModules](DebianMedModules.md) page.
To load a module in DebianMed (an example for loading bcftools):
```
# load DebianMed module first
module load DebianMed

# now you can see the list of module installed in DebianMed.
module avail

# load module
module load bcftools

# check the installation
bcftools --version

```

### Nextflow pipelines

We have prepared a [Nextflow](https://www.nextflow.io/) module (`ml Other/Nextflow`) and regisered [OIST's profile](https://github.com/nf-core/configs/blob/master/docs/oist.md) to the [nf-core](https://nf-co.re/) community so that you can run their pipelines with the `-profile oist` option on _Deigo_.

### Other tools

Under the `Other/` namespace, we also provide some general bioinformatics tools such as:

- DIAMOND (`ml Other/DIAMOND/2.0.4.142`)
- InterProScan and its database (`ml Other/interproscan/5.48-83.0`)

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

## Modules on Saion.

We have some modules on _Saion_ for GPU-accelerated computations such as [basecalling Nanopore](NanoporeModules.md) data, that can not be run on _Deigo_.  Please remember that the _modules_ system on _Saion_ is older, so the `ml` shortcuts will not work.  To list the available modules, do:

```
module load bioinfo-ugrp-modules
module available
```

## Communication channel
Prioritized communication channel is on Microsoft Teams: [BioinfoUgrp](https://teams.microsoft.com/l/team/19%3a3183bd7fe2844138a49996a2bd376873%40thread.tacv2/conversations?groupId=cc78e114-c544-43e2-b4b1-29c7428aa305&tenantId=d8c0fb8d-bb56-44bb-9f4a-c58e7465652e).
