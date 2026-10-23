# Maintenance notes: databases

User documentation: [DataBases.md](../DataBases.md).  General conventions:
[CONTRIBUTING.md](../CONTRIBUTING.md).

Database modules live under `/bucket/BioinfoUgrp/DB` and their names start
with `DB/`.

Update policy announced to users: databases are updated on request, at most
once a year; after an update, users are asked whether the previous version is
still needed, and it is deleted after 30 days otherwise; at most two versions
of a database are kept at the same time.

## Dfam

Downloaded from <https://www.dfam.org/releases/Dfam_4.0/families/> and
<https://www.dfam.org/releases/Dfam_4.0/families/FamDB>.  The HDF5 files were
uncompressed after checking their MD5 sums.

The `DB/Dfam/4.0` modulefile:

```
-- Default settings
local modroot    = "/bucket/BioinfoUgrp"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package information
whatis("Name: "..appname)
whatis("Version: "..appversion)
whatis("URL: ".."https://dfam.org")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."annotation, transposon, repeat")
whatis("Description: ".."The Dfam open collection of Transposable Element DNA sequence alignments")

-- Package settings
LmodMessage("You can find the Dfam database HMMs in the directory pointed to\nby the environment variable $BioinfoUgrp_Dfam, and the\nHDF5 files in $BioinfoUgrp_FamDB.")
setenv("BioinfoUgrp_Dfam", apphome)
setenv("BioinfoUgrp_FamDB", apphome .. "/FamDB")
setenv("SINGULARITY_BINDPATH", apphome.."/FamDB:/opt/RepeatMasker/Libraries/famdb")
```

## Dfam for RepeatMasker (`DB/Dfam_RepeatMasker/3.6__4.1.3`)


The RepeatMasker program does not follow symbolic links and the Dfam database is large (160 Gb), so I had to use hard links to the files of the `Dfam` module instead.  Also, the modulefile contains:

```
setenv("BioinfoUgrp_Dfam_Rmsk_4_1_3", apphome.."/RepeatMasker_4.1.3/Libraries")
setenv("SINGULARITY_BINDPATH", apphome.."/Libraries:/opt/RepeatMasker/Libraries")
```

## eggnog-mapper

eggNOG 5.0.2 for `Other/eggnog-mapper` (2.1.x expects this version), in
`/bucket/BioinfoUgrp/DB/eggnog-mapper/5.0.2` (49 GB, 2026-10).  Downloaded
with eggnog-mapper's own script, after the `sed` fix described in the
eggnog-mapper recipe in [dev/Other.md](Other.md#eggnog-mapper).  The script
prints "Finished." even when downloads fail: read the log for `wget` errors.

Run from the home directory (the `datacp` partition can write to `/bucket`):

```bash
mkdir -p /bucket/BioinfoUgrp/DB/eggnog-mapper/5.0.2
sbatch -p datacp -c 1 --mem 4G -t 2-00:00:00 -J eggnogdb --wrap '
umask 002
module purge
module load python/3.11.4
/bucket/BioinfoUgrp/Other/eggnog-mapper/2.1.13/bin/download_eggnog_data.py -y -F -P -M \
  --data_dir /bucket/BioinfoUgrp/DB/eggnog-mapper/5.0.2'
```

`-F`: novel families; `-P`: Pfam; `-M`: MMseqs2.  The per-taxon HMMER
databases (`-H -d <taxid>`) are not installed.

The archives keep their stored permissions, which `umask` does not change.
Afterwards, make everything group-writable:

```bash
cd /bucket/BioinfoUgrp/DB/eggnog-mapper/5.0.2
find . ! -perm -g+w -exec chmod g+w {} +
```

Modulefile `/bucket/BioinfoUgrp/DB/modulefiles/eggnog-mapper/5.0.2.lua`:

```
-- Default settings
local modroot    = "/bucket/BioinfoUgrp"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package information
whatis("Name: "..appname)
whatis("Version: "..appversion)
whatis("URL: ".."http://eggnog5.embl.de")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."annotation, orthology, database")
whatis("Description: ".."eggNOG database for eggnog-mapper")

-- Package settings
setenv("EGGNOG_DATA_DIR", apphome)
```
