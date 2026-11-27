# AGENTS.md

Instructions for coding agents working in this repository.

## What this repository is

Documentation and installation recipes for the environment modules of OIST's
bioinformatics user group, installed under `/bucket/BioinfoUgrp` on the Deigo
and Saion clusters.

## Layout

- User pages (`README.md`, `Other/README.md`, `DataBases.md`,
  `DebianMedModules.md`, `Nextflow.md`, `NanoporeModules/README.md`,
  `RStudio/README.md`, `AlphaFold/`) explain usage only, with no
  installation commands.
- Developer pages are `CONTRIBUTING.md` and the files in `dev/`: recipes and
  maintenance notes.
- Support scripts (`Other/launch_jbrowse2`, `Other/cellxgene-vip`,
  `RStudio/*.sh`, …) must not be moved: installed modules fetch some of them
  by URL.

Read `CONTRIBUTING.md` for the conventions.

## Design decisions

Decided with the maintainers in October 2026, when the documentation was
split by audience.

Audience and placement:

- The most visible part of the repository (the top-level `README.md` and the
  `README.md` of each directory) is for users.  Developer material goes in
  `CONTRIBUTING.md` and `dev/`, never in user pages.
- User pages keep their historical paths, because other sites link to them.
  Recipe files may move within `dev/`.

Users and the SCDA guide:

- Assume users understand the module system only superficially.  Restate the
  basics (what a module is, `ml`/`module` commands, metamodules, use in Slurm
  jobs) in `README.md`, and keep other user pages short by linking there.
- Stay compatible with the SCDA guide (<https://scda-guide.oist.jp>), which
  is the reference for the clusters.  Use its command forms (for instance
  `module key`, as in its summary table) and naming conventions (unit
  directories such as `/flash/YourUnitU`), restate only what users of our
  modules need, and link to the relevant SCDA page for the rest.  Where this
  repository and the SCDA guide disagree, the SCDA guide wins.  The guide is
  reachable from the cloud environment; check statements against it.
- Examples for Saion use the long `module` form.

Module listings:

- The `Other/` catalogue is grouped by topic, without version numbers (users
  run `ml av`).  One general Slurm example in `README.md` replaces per-tool
  `srun` examples; usage notes exist only for modules that do not simply put
  a program of the same name in `PATH`.
- Every entry of a module or database listing shows its homepage as a 🏠
  link with the title "Homepage", placed right after the module name:
  ``| `Other/bwa` [🏠](https://github.com/lh3/bwa "Homepage") | … |``.
  Take the URL from the modulefile's `whatis("URL: …")` in this repository
  when it is correct.
- Mark non-free software and restrictive licences on the user page.

Recipes:

- New Python programs from PyPI go in a virtual environment per module,
  with the version pinned and a `requirements.lock`; the modulefile adds
  only `bin/` to `PATH` (see `CONTRIBUTING.md`).  eggnog-mapper (2026-10) was
  the first module installed this way.
- Databases are separate `DB/` modules, loaded by the program's module with
  `depends_on()`, not stored inside the program's installation.

Communication:

- Users request software on the Teams channel or in GitHub issues; when they
  open an issue, they also post its link on Teams.

Accuracy:

- Do not state as fact what was not checked (module names, versions,
  behaviour on Saion).  Say how users can check it (`ml av`, `ml spider`,
  `module avail`), or flag it to the maintainers.

## Working rules

- When a recipe changes, update the user catalogue if usage changes.
- Keep recipes runnable as written, by copy and paste.  Downloads run on a
  Deigo login node; compiled software follows SCDA's rule to build on an AMD
  compute node (see `CONTRIBUTING.md`).
- Do not push or open pull requests unless asked.
