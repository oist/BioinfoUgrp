# Databases

Large reference databases installed on Deigo by the Bioinformatics User
Group, so that you do not need to download your own copy.  Each database is
a module whose name starts with `DB/`.  Loading it sets environment variables
pointing to the files; it does not copy anything.

```bash
ml bioinfo-ugrp-modules
ml av DB
```

If modules are new to you, read the [main page](README.md) first.  For update
requests and the policy on old versions, see
[Requests](README.md#requests).

| Database | Module | Version | For |
|---|---|---|---|
| NCBI nt and nr | `DB/blastDB/ncbi/238` | release 238 | BLAST |
| Swiss-Prot | `DB/blastDB/sprot/2020_06` | 2020_06 | BLAST |
| UniRef90 | `DB/blastDB/uniref90/2020_06` | 2020_06 | BLAST |
| NCBI nr | `DB/diamondDB/ncbi/238` | release 238 | DIAMOND |
| Swiss-Prot | `DB/diamondDB/sprot/2020_06` | 2020_06 | DIAMOND |
| UniRef90 | `DB/diamondDB/uniref90/2020_06` | 2020_06 | DIAMOND |
| GTDB | `DB/diamondDB/GTDB/r226` | r226 | DIAMOND |
| GTDB-Tk reference data | `DB/GTDBTK/ref_data/226.0` | r226 | GTDB-Tk, nf-core pipelines |
| Pfam | `DB/Pfam/34.0` | 34.0 | HMMER and similar |
| Dfam | `DB/Dfam/4.0` | 4.0 | RepeatMasker |
| Dfam for RepeatMasker | `DB/Dfam_RepeatMasker/3.6__4.1.3` | see module name | RepeatMasker in TETools |

The BLAST, DIAMOND (except GTDB) and Pfam databases date from 2020.


## BLAST databases

The databases were built with BLAST+ 2.10.0 and include taxonomy
information.  Load the `ncbi-blast/2.10.0+` module with them.  Give the
database name (`nt`, `nr`, …) to the `-db` option.

```bash
module load ncbi-blast/2.10.0+
module load bioinfo-ugrp-modules
module load DB/blastDB/ncbi/238

blastn -task megablast -db nt -query /path/to/query.fasta \
  -num_threads "$SLURM_CPUS_PER_TASK" -max_target_seqs 1 \
  -outfmt '6 qseqid bitscore evalue length qlen qcovs pident sseqid sgi sacc staxid ssciname scomname stitle sseq' \
  -out megablastn.out
```


## DIAMOND databases

The NCBI, Swiss-Prot and UniRef90 databases were built with DIAMOND
2.0.4.142, and their modules load that version of `Other/DIAMOND`.  The GTDB
database was built with DIAMOND 2.1.11.

DIAMOND needs the full path of the database.  The modules set the variable
`DIAMONDDB` to the directory that contains it.

```bash
module load bioinfo-ugrp-modules
module load DB/diamondDB/ncbi/238
diamond --version           # check which DIAMOND is loaded
echo "$DIAMONDDB"

diamond blastp -d "$DIAMONDDB/nr" -q /path/to/query.fasta \
  -p "$SLURM_CPUS_PER_TASK" -f 6 -o diamond.blastp.tsv
```

For GTDB, the database file is `$DIAMONDDB/gtdb.dmnd`:

```bash
module load bioinfo-ugrp-modules
module load DB/diamondDB/GTDB/r226
diamond blastp -d "$DIAMONDDB/gtdb.dmnd" -q /path/to/query.fasta \
  -p "$SLURM_CPUS_PER_TASK" -o gtdb.blastp.tsv
```


## GTDB-Tk reference data (r226)

The reference data needed by GTDB-Tk for the taxonomic classification of
bacterial and archaeal genomes.  This module contains **only the data**:
GTDB-Tk itself is not installed as a module, but nf-core pipelines bring it
in their own containers.

The module sets two variables:

- `GTDBTK_DATA_PATH`: the uncompressed data;
- `GTDBTK_DATA_ARCHIVED`: the compressed archive.

Example with [nf-core/mag](https://nf-co.re/mag), which then does not need
to download the database (about 100 GB); see [Nextflow.md](Nextflow.md) for
how to run nf-core pipelines:

```bash
module load bioinfo-ugrp-modules
module load Nextflow3
module load DB/GTDBTK/ref_data/226.0

nextflow run nf-core/mag \
  -profile oist \
  --input samplesheet.csv \
  --outdir /flash/<YourUnit>/mag_results \
  --gtdb_db "$GTDBTK_DATA_ARCHIVED"
```

Use `$GTDBTK_DATA_PATH` instead if the pipeline expects the uncompressed
data.


## Pfam

Version 34.0: `ml DB/Pfam/34.0`.  Run `ml show DB/Pfam/34.0` to see the
variables it sets.


## Dfam

`DB/Dfam/4.0` contains Dfam 4.0, downloaded from
<https://www.dfam.org/releases/Dfam_4.0/families/>, with the HDF5 files
uncompressed after checking their MD5 sums.  It sets:

- `BioinfoUgrp_Dfam`: the directory of the HMM files, to pass to RepeatMasker
  with its `-libdir` option;
- `BioinfoUgrp_FamDB`: the directory of the HDF5 (FamDB) files;
- `SINGULARITY_BINDPATH`: makes the Singularity containers of `Other/TETools`
  see this full copy of Dfam in place of the partial one they contain.

`DB/Dfam_RepeatMasker/3.6__4.1.3` changes the behaviour of the RepeatMasker
and RepeatModeler commands of `Other/TETools` so that they use the full
Dfam database instead of the "curated only" version bundled in the
container.

Load only one of the two Dfam modules at a time: both set
`SINGULARITY_BINDPATH`, so the second replaces the value set by the first.
This also replaces any value you set yourself.
