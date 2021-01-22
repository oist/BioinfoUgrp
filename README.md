# BioinfoUgrp
OIST Bioinfo user group

## Finding modules
Search with a keyword, for instance `ml key clustal`.

## Loading installed modules
Execute `ml bioinfo-ugrp-modules` to make available the modules installed by the OIST Bioinfo user group. This line can be appended to your `~/.bashrc` to make them available by default.

## Debian Med modules
We autogenerate many modules from softwares packaged the Debian distribution. More information is available on the [DebianMedModules](DebianMedModules.md) page.

## Databases
Widely used databases were installed locally. Upon request by users, we plan on upgrading databases (not more than once a year). After upgrading a specific database, users will be asked if the older database should still remain available (completion of projects,...): it will be deleted after 30 days except if still required. At one time, a maximum of two versions of the same database will be available.
### Taxified NCBI NT & NR database release 238
The database was constructed using the module `ncbi-blast/2.10.0+`. Use `ml XXX`, and `nt` or `nr` in the commands of your scripts.
### Taxified DIAMOND databases
Databases were constructed using `DIAMOND/2.0.4.142`. Diamond databases are available for the NCBI-NR database (release 238), Swiss-Prot (version XXX), and gtdb (version XXX). Use `ml XXX` to invoke it in your scripts.

- UniRef
- InterProScan v5.46-81.0
- Pfam

## Communication channel
Prioritized communication channel is on Microsoft Teams: [BioinfoUgrp](https://teams.microsoft.com/l/team/19%3a3183bd7fe2844138a49996a2bd376873%40thread.tacv2/conversations?groupId=cc78e114-c544-43e2-b4b1-29c7428aa305&tenantId=d8c0fb8d-bb56-44bb-9f4a-c58e7465652e).
