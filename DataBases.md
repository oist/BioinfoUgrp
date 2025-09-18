# Databases

## Taxified BLAST databases
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

## Taxified DIAMOND databases
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

## Pfam

Version 34.0:  Use `ml DB/Pfam/34.0` to invoke it in your scripts.

## Dfam

Version 3.9 downloaded from <https://www.dfam.org/releases/Dfam_3.9/families/> and <https://www.dfam.org/releases/Dfam_3.9/families/FamDB>.  HDF5 files were uncompressed after checking their MD5 sums.

The command `ml DB/Dfam/3.9` exposes two environment variables
 - `$BioinfoUgrp_Dfam` containing the path to the directory containing the HMM files, that can be passed to RepeatMasker through its `-libdir` argument.
 - `$BioinfoUgrp_FamDB` containing the path to the directory containing the HDF5 files, to be bind-mounted on `/opt/RepeatMasker/Libraries/famdb/` when using `TETools`.

## Dfam for RepeatMasker

The command `ml DB/Dfam_RepeatMasker/3.6__4.1.3` will set an environmental variable that changes the behaviour of the `repeatmodeler` module, so that it will use the full Dfam database provided by us instead of the “_curated only_” version provided by default.

### Developer details

The RepeatMasker program does not follow symbolic links and the Dfam database is large (160 Gb), so I had to use hard links to the files of the `Dfam` module instead.  Also, the modulefile contains:

```
setenv("BioinfoUgrp_Dfam_Rmsk_4_1_3", apphome.."/RepeatMasker_4.1.3/Libraries")
setenv("SINGULARITY_BINDPATH", apphome.."/Libraries:/opt/RepeatMasker/Libraries")
```
