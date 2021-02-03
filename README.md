# BioinfoUgrp
OIST Bioinfo user group

## Finding modules
Search with a keyword, for instance `ml key clustal`.

## Loading installed modules
Execute `ml bioinfo-ugrp-modules` to make available the modules installed by the OIST Bioinfo user group. This line can be appended to your `~/.bashrc` to make them available by default.

## Debian Med modules
We autogenerate many modules from softwares packaged the Debian distribution. More information is available on the [DebianMedModules](DebianMedModules.md) page.

## Nextflow pipelines

We have prepared a [Nextflow](https://www.nextflow.io/) module (`ml Other/Nextflow`) and regisered [OIST's profile](https://github.com/nf-core/configs/blob/master/docs/oist.md) to the [nf-core](https://nf-co.re/) community so that you can run their pipelines with the `-profile oist` option on _Deigo_.

## Databases
Widely used databases were installed locally. Upon request by users, we plan on upgrading databases (not more than once a year). After upgrading a specific database, users will be asked if the older database should still remain available (completion of projects,...): it will be deleted after 30 days except if still required. At one time, a maximum of two versions of the same database will be available.
### Taxified NCBI NT & NR database release 238
The database was constructed using the module `ncbi-blast/2.10.0+` and can be loaded with `ml DB/blastDB/ncbi/238`. To be used with the arguments `nt` or `nr` supplied to `-db` in the commands of your scripts. Example script to get a taxified blast report:
```
module load ncbi-blast/2.10.0+
module load DB/blastDB/ncbi/238
WORKDIR="$PWD"
FASTA=FULL/PATH/TO/YOUR/FASTA/FILE
blastn -task megablast -db nt -query $FASTA -num_threads ${SLURM_CPUS_PER_TASK} -out ${WORKDIR}/megablastn.out \
	-outfmt '6 qseqid bitscore evalue length qlen qcovs pident sseqid sgi sacc staxid ssciname scomname stitle sseq' \
	-max_target_seqs 1
```
### Taxified DIAMOND databases
Databases were constructed using the module `Other/DIAMOND/2.0.4.142`. Diamond databases are available for:
- the NCBI-NR database (release 238): `ml DB/diamondDB/ncbi/238`
- Swiss-Prot (version XXX): `ml XXX`
- UniRef90 (version XXX): `ml XXX`

### Other databases
- InterProScan v5.46-81.0.  Use `ml XXX` to invoke it in your scripts.
- Pfam.  Use `ml XXX` to invoke it in your scripts.

## Communication channel
Prioritized communication channel is on Microsoft Teams: [BioinfoUgrp](https://teams.microsoft.com/l/team/19%3a3183bd7fe2844138a49996a2bd376873%40thread.tacv2/conversations?groupId=cc78e114-c544-43e2-b4b1-29c7428aa305&tenantId=d8c0fb8d-bb56-44bb-9f4a-c58e7465652e).
