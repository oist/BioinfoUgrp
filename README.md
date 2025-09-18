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

Check [DataBases](DataBases.md) for details.

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
