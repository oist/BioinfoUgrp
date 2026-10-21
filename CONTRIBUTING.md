# Maintaining the BioinfoUgrp modules and documentation

This guide is for the members of the Bioinformatics User Group who install
software, databases and modules under `/bucket/BioinfoUgrp`, and who edit
this repository.  Users do not need it; their entry point is
[README.md](README.md).


## How the documentation is organised

The documentation is split by audience.

- **User pages** explain what is installed and how to use it.  They contain
  no installation commands.
  - [README.md](README.md): module basics, Slurm usage, overview of the
    collections, help.
  - [Other/README.md](Other/README.md): catalogue of the `Other/` modules.
  - [DataBases.md](DataBases.md), [DebianMedModules.md](DebianMedModules.md),
    [Nextflow.md](Nextflow.md), [NanoporeModules/README.md](NanoporeModules/README.md),
    [RStudio/README.md](RStudio/README.md), [AlphaFold/](AlphaFold/README.md).
- **Developer pages**, in [dev/](dev), hold the installation recipes and
  maintenance notes.
  - [dev/Alignment.md](dev/Alignment.md), [dev/Assembly.md](dev/Assembly.md),
    [dev/Repeats.md](dev/Repeats.md), [dev/Other.md](dev/Other.md): recipes
    for the `Other/` modules.
  - [dev/Databases.md](dev/Databases.md), [dev/DebianMed.md](dev/DebianMed.md),
    [dev/Nextflow.md](dev/Nextflow.md), [dev/Nanopore.md](dev/Nanopore.md),
    [dev/RStudio.md](dev/RStudio.md).
  - [dev/REVIEW-2026-10-21.md](dev/REVIEW-2026-10-21.md): known problems in
    the recipes, with line numbers of an older revision.
- **Support files** stay where they are, because some are downloaded by URL
  from the installed modules: `Other/launch_jbrowse2`, `Other/cellxgene-vip`,
  `RStudio/*.sh`, `RStudio/Singularity.def`, `NanoporeModules/*.tcl`,
  `NanoporeModules/Singularity.def`, `mkDebMedModule.sh`.

When you add or update a module:

1. Add or update the recipe in the relevant `dev/` page.
2. Add or update the module's row in the user catalogue, with a one-line
   description, and a usage note if the module does not simply put a program
   of the same name in `PATH` (wrappers, several commands, environment
   variables, GPU needs, known limitations).
3. Do not put versions in the user catalogue unless users need them; they
   become outdated.

User pages restate only the basics of the clusters (modules, Slurm, storage)
and link to the [SCDA guide](https://scda-guide.oist.jp) for the rest.  Keep
them compatible with it, and prefer a link to a copy.


## Installation layout

| Path | Contents |
|---|---|
| `/bucket/BioinfoUgrp/Other/<app>/<version>` | the `Other/` modules |
| `/bucket/BioinfoUgrp/Other/modulefiles/<app>/<version>.lua` | their modulefiles |
| `/bucket/BioinfoUgrp/DB/…` | databases (`DB/` modules) |
| `/bucket/BioinfoUgrp/DebianMed/<Debian version>/` | Debian Med image, wrappers and modulefiles |
| `/bucket/BioinfoUgrp/Nanopore/`, `/bucket/BioinfoUgrp/<app>/` | Nanopore and older modules |
| `/apps/.bioinfo-ugrp-modulefiles81/` | on Deigo, the module directory that `bioinfo-ugrp-modules` adds to `MODULEPATH` (SCDA's module page shows the `DB/` and `Other/` modules listed from it); also holds metamodules such as `DebianMed/<version>.lua` |
| `/apps/.bioinfo-ugrp-modulefiles/` | older modulefiles (Tcl), such as Guppy and Rerio |

The recipes are the record of how each module was made; the installed tree
is not under version control.


## Recipe conventions

- Set `APP`, `VER` and `MODROOT`, and install into `$MODROOT/$APP/$VER`.
- Download a release that matches `VER` (a tag, a versioned archive, or
  `pip install "$APP==$VER"`), not "latest" or a branch, so that the module
  version is true.
- Recipes must run as written, by copy and paste, on a Deigo login node.
- Write Lua modulefiles, following the template used in
  [dev/Alignment.md](dev/Alignment.md): `whatis` lines for name, version,
  URL, category, keywords and description, then the package settings.  The
  description is what users see with `ml whatis` and `ml key`, so make it
  informative.
- Use `depends_on()` for required modules.  For variables that hold lists,
  such as `PATH` or `SINGULARITY_BINDPATH`, use `prepend_path()` (with the
  right delimiter) rather than `setenv()`, so as not to erase values set by
  users or other modules.
- Wrapper scripts must pass their arguments with `"$@"`, not `$*`, so that
  arguments containing spaces survive.
- Add a `help([[…]])` text when the module does more than adding a program
  to `PATH`.

### Permissions

Members of the group must be able to update each other's installations:
run `umask 002` before installing, and check that files and directories are
group-writable.

### Where to build

SCDA's page
[Install software for your unit](https://scda-guide.oist.jp/install-software-your-unit.html)
says to build software on a compute node: an AMD node on Deigo for general
software, because code compiled on an Intel node might not work properly on
the AMD nodes, and a GPU node on Saion for GPU-accelerated software.  Their
example:

```bash
srun -t 0-2 -p compute -C epyc -c 16 --mem=8G --pty bash
```

`/bucket` is read-only on compute nodes, and writable on the login nodes and
through the `datacp` partition
([research storage](https://scda-guide.oist.jp/research-storage.html)).  So
compile and test in a directory on `/flash`, then copy the result to
`/bucket` from a login node.  Downloading and unpacking prebuilt binaries or
containers can be done from a login node.  Many existing recipes run `make`
on a login node; follow SCDA's rule when you update them.

The same page explains how to write modulefiles.  Lmod reads modulefiles in
Lua (used for new modules here) and in Tcl (older modules here, and SCDA's
examples).

GPU software for Saion is installed from Deigo when it needs a Python
module that Saion's login nodes lack (see the Boltz recipe in
[dev/Other.md](dev/Other.md)).

### conda

Anaconda is prohibited on OIST systems since 2025-04-01, for licensing
reasons ([SCDA page](https://scda-guide.oist.jp/anaconda-oist)); this covers
Miniconda too.  Use conda from conda-forge (Miniforge), with the conda-forge
and bioconda channels only; do not add Anaconda's `defaults` channel.  Pin
the Miniforge version.

### Licences

State in the user page when a program or its data is not free software, or
restricts the use of its results (examples: Dorado, Guppy, AlphaFold 3).


## Testing a new module

Lmod caches the list of modules, so a new modulefile may not be visible at
once:

```bash
rm -rf ~/.lmod.d/.cache
ml bioinfo-ugrp-modules
module --ignore_cache load Other/<app>/<version>
```

Then run the program on a compute node, not only `--version` on the login
node.


## Communication

Discuss changes on the Teams channel (see [README.md](README.md#getting-help))
or in [GitHub issues](https://github.com/oist/BioinfoUgrp/issues).
