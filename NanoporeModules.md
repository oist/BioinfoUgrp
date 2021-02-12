Modules related to Nanopore sequencing
======================================

Guppy
-----

 - Homepage: https://community.nanoporetech.com/protocols/Guppy-protocol
 - Source code: Proprietary.


### Example module update on Saion

 - `cd /apps/unit/BioinfoUgrp/Guppy/`
 - Downloaded the RPM package `wget https://mirror.oxfordnanoportal.com/software/analysis/ont-guppy-4.4.0-1.el7.x86_64.rpm` (MD5 sum 07a74b887429769c3e511b8025c1c5d8) from the [Software Downloads](https://community.nanoporetech.com/downloads) page on the ONT website.
 - Unpacked it with `rpm2cpio ont-guppy-4.4.0-1.el7.x86_64.rpm | cpio -idmv`
 - Move the contents into `4.4.0`.
 - `cd /apps/.bioinfo-ugrp-modulefiles/Guppy`
 - Copied a previous [module file](https://groups.oist.jp/scs/install-software-your-unit) for this version.

### Example commands for running Guppy on Saion

Take home message: `srun` needs `-pgpu --gres gpu:1` and `guppy_basecaller` needs `--device auto`.

```
module use /apps/.bioinfo-ugrp-modulefiles/
module load Guppy
srun --time 2-0 --mem 20G -pgpu --gres gpu:1 --pty guppy_basecaller \
   -i <where FAST5 files are> \
   --recursive \
   --flowcell FLO-MIN106 --kit SQK-LSK109 \
   --num_callers 16 --device auto \
   --records_per_fastq 0 --qscore_filtering --min_qscore 7 --calib_detect \
   -s <where to write the output>
```
