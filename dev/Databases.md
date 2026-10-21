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
