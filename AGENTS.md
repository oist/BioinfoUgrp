# AGENTS.md

Instructions for coding agents working in this repository.

## What this repository is

Documentation and installation recipes for the environment modules of OIST's
bioinformatics user group, installed under `/bucket/BioinfoUgrp` on the Deigo
and Saion clusters.  Most files are Markdown pages containing shell snippets
and Lmod modulefiles.

## Conventions

- Recipes set `APP`, `VER` and `MODROOT`, install into `$MODROOT/$APP/$VER`,
  and write a Lua modulefile based on the template used throughout
  `Other/*.md`.
- Keep recipes runnable as written, by copy and paste, on a Deigo login node.

## Working rules

- Do not push or open pull requests unless asked.
