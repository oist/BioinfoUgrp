# Nanopore sequencing

Modules for basecalling and processing Oxford Nanopore Technologies (ONT)
data.  Basecalling needs GPUs, so it runs on Saion.  If modules are new to
you, read the [main page](../README.md) first.  The examples use the long
`module` form, which works on Saion.

```bash
module load bioinfo-ugrp-modules
module avail                 # look for Dorado, pod5, modkit, …
```

The names in the table are those given at installation; check the exact
names and the versions with `module avail`.

| Module (🏠 homepage) | Purpose |
|---|---|
| `Dorado` [🏠](https://github.com/nanoporetech/dorado "Homepage") | ONT's current basecaller; loads `Dorado-models` |
| `Dorado-models` [🏠](https://github.com/nanoporetech/dorado "Homepage") | Dorado basecalling models; sets `DORADO_MODELS` to their directory |
| `pod5` [🏠](https://pypi.org/project/pod5/ "Homepage") | Tools for the POD5 raw data format |
| `modkit` [🏠](https://github.com/nanoporetech/modkit "Homepage") | Analysis of modified bases |
| `medaka` [🏠](https://github.com/nanoporetech/medaka "Homepage") | Consensus and variant calling (old version) |
| `ont_fast5_api` [🏠](https://github.com/nanoporetech/ont_fast5_api "Homepage") | Tools for the older FAST5 format |
| `Other/vbz_compression` [🏠](https://github.com/nanoporetech/vbz_compression "Homepage") | HDF5 plugin needed to read VBZ-compressed FAST5 files; sets `HDF5_PLUGIN_PATH` |
| `Guppy` [🏠](https://community.nanoporetech.com/protocols/Guppy-protocol "Homepage") | The previous basecaller; kept only to reproduce old analyses |
| `Rerio` [🏠](https://github.com/nanoporetech/rerio "Homepage") | Research models for Guppy; sets `RERIO_MODELS` |

Dorado, Guppy and Rerio are not free software: read their licences before
use.

## Basecalling with Dorado

Dorado does not work with the P100 GPUs, so use the V100 (or A100)
partitions.  These partitions require an application to SCDA; see
[the Saion system](https://scda-guide.oist.jp/saion-system.html).

```bash
module load bioinfo-ugrp-modules
module load Dorado
ls $DORADO_MODELS                                      # available models
srun -p gpu-v100 -t 0-01:00:00 dorado basecaller -h    # help
srun -p gpu-v100 --gres gpu:1 -c 8 --mem 20G -t 2-00:00:00 \
  dorado basecaller $DORADO_MODELS/<model> <directory of POD5 or FAST5 files> > calls.bam
```

For long runs, put these commands in a batch script that starts with
`#!/bin/bash -l` (see
[Using modules in Slurm jobs](../README.md#using-modules-in-slurm-jobs)).

## Guppy and Rerio (legacy)

Guppy was ONT's basecaller before Dorado and will not be updated.  We keep
the old versions so that past analyses can be reproduced.  Rerio provides
research models for Guppy and sets `RERIO_MODELS`.

```bash
module load bioinfo-ugrp-modules
module load Guppy Rerio
srun -p gpu-v100 --gres gpu:1 --mem 20G -t 2-00:00:00 \
  guppy_basecaller -i <FAST5 directory> --recursive -s <output directory> \
    -d $RERIO_MODELS -c res_dna_r941_min_crf_v031.cfg \
    --device auto --num_callers 16 --records_per_fastq 0 \
    --qscore_filtering --min_qscore 7 --calib_detect
```

Without Rerio, replace `-d … -c …` with the flow cell and kit, for instance
`--flowcell FLO-MIN106 --kit SQK-LSK109`.  For GPU acceleration, `srun` needs
`--gres gpu:1` and `guppy_basecaller` needs `--device auto`.

Installation recipes are in [dev/Nanopore.md](../dev/Nanopore.md).
