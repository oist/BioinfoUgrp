# Nextflow and nf-core

[Nextflow](https://www.nextflow.io/) runs computational pipelines, and
[nf-core](https://nf-co.re/) is a community collection of Nextflow
pipelines.  On Deigo we provide Nextflow, the nf-core helper tools and the
nf-test framework as modules.  We also maintain the
[OIST configuration profile](https://github.com/nf-core/configs/blob/master/docs/oist.md)
in nf-core, so that nf-core pipelines run on Deigo with the option
`-profile oist`.

If modules are new to you, read the [main page](README.md) first.

## Which Nextflow module?

Nextflow has twice changed in ways that break older pipelines, so there are
three modules:

| Module | Nextflow versions | Use for |
|---|---|---|
| `Nextflow3` | 2026 and later, with the _strict syntax_ | current pipelines |
| `Nextflow2` | DSL2, before the strict syntax | pipelines not yet compatible with the strict syntax |
| `Nextflow` | 21.10.6 only | old _DSL1_ pipelines |

DSL1 pipelines can also run with `Nextflow2` if you pass `-dsl1` to
`nextflow`.  Load only one of the three at a time.

```bash
ml bioinfo-ugrp-modules
ml av Nextflow               # list the modules and versions
ml Nextflow3
nextflow -version
```

`Nextflow2` and `Nextflow3` limit the memory of the `nextflow` program itself
(not of the pipeline's jobs) by setting `NXF_OPTS` to `-Xms500M -Xmx2G`.  If a
large pipeline needs more, tell us, or set `NXF_OPTS` yourself after loading
the module.

## Running an nf-core pipeline

```bash
ml bioinfo-ugrp-modules Nextflow3
nextflow run nf-core/<pipeline> -r <version> -profile oist \
  --input samplesheet.csv --outdir /flash/<YourUnit>/results
```

The `oist` profile sends each step of the pipeline to Slurm as a separate job
and runs the software in Singularity containers.  Read
[its documentation](https://github.com/nf-core/configs/blob/master/docs/oist.md)
for what it sets and how to change it, and the pipeline's page on
<https://nf-co.re> for its parameters.  Give `-r` a release number, so that
you can rerun the same version later.

Note the single dash in `-profile`: options with one dash are for Nextflow,
options with two dashes are parameters of the pipeline.

Some reference data that pipelines would otherwise download are already on
Deigo; see [DataBases.md](DataBases.md).

## nf-core tools and nf-test

These are mostly useful if you write or modify pipelines.

| Module | Provides |
|---|---|
| `nf-core` | the [`nf-core` command](https://nf-co.re/docs/nf-core-tools) (list, download, create and lint pipelines); loads `Nextflow2` unless `Nextflow2` or `Nextflow3` is already loaded, and also loads `Other/nf-test` and `Other/prek` |
| `Other/nf-test` | [nf-test](https://www.nf-test.com/), a testing framework for Nextflow pipelines |

To use the nf-core tools with `Nextflow3`, load `Nextflow3` first:

```bash
ml bioinfo-ugrp-modules Nextflow3 nf-core
ml                           # check which modules are loaded
```

Known problem: the `Other/nf-test` module loads `Nextflow2` even when
`Nextflow3` is loaded, so you may end up with both.  If `ml` lists both, run
`ml -Nextflow2` and check `nextflow -version`.

Installation recipes are in [dev/Nextflow.md](dev/Nextflow.md).
