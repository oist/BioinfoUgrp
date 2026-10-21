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

## Working rules

- When a recipe changes, update the user catalogue if usage changes.
- Keep recipes runnable as written, by copy and paste, on a Deigo login node.
- Do not push or open pull requests unless asked.
