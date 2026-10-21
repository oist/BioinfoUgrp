# Debian Med modules

The [Debian Med](https://www.debian.org/devel/debian-med/) project packages
bioinformatics and other medical software for the
[Debian](https://www.debian.org/intro/about) operating system.  We put several
hundred of these packages in a [Singularity](https://sylabs.io/) container
image and create one module per package on Deigo.  When you run a program
from one of these modules, it runs inside the container; this is transparent
for most uses.

If modules are new to you, read the [main page](README.md) first.

## Usage

The Debian Med modules are behind their own metamodule, `DebianMed`, inside
`bioinfo-ugrp-modules`:

```bash
ml bioinfo-ugrp-modules DebianMed
ml av                        # the Debian Med modules are now listed
ml bcftools                  # load one of them
bcftools --version
```

The modules are named after the Debian package, which is not always the name
of the program: for instance, a package can provide several programs.  Look
up a package on <https://packages.debian.org> (search the package contents)
or with `ml show <module>`.

The versions are those of the Debian release the image is built from; run
`ml av DebianMed` to see which releases are available.  Give the version of
the metamodule (for instance `ml bioinfo-ugrp-modules DebianMed/13.0-1`) if
you need the same software versions later.

R packages from Debian (`r-cran-*`, `r-bioc-*`) are not included.  For R, see
[RStudio/README.md](RStudio/README.md).

## Same program, several modules

Many programs exist both as a Debian Med module and as an `Other/` module or
an SCDA module, often in different versions.  After loading `DebianMed`, use
`ml spider <name>` to see all of them, load the one you want by its full
name, and check with `ml` and `<program> --version` which one you got.

## Syntax highlighting: `biosyntax-less`

The `biosyntax-less` module colours biological file formats in the `less`
pager.  It adds commands for each format, which read from a pipe:

```bash
ml bioinfo-ugrp-modules DebianMed biosyntax-less
samtools view -h aligned.bam | sam-less
```

Commands: `fa-less`, `fq-less`, `sam-less` (alias `bam-less`), `vcf-less`,
`bed-less`, `gtf-less`, `pdb-less`, `clustal-less`, `fai-less`,
`flagstat-less`.  The module also changes the `less` command itself, to show
line numbers and not wrap lines.

Maintenance notes are in [dev/DebianMed.md](dev/DebianMed.md).
