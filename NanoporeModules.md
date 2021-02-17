Modules related to Nanopore sequencing
======================================

Guppy
-----

 - Homepage: https://community.nanoporetech.com/protocols/Guppy-protocol
 - Source code: Proprietary.


### Example module update on Saion

```
VER=4.4.2
cd /apps/unit/BioinfoUgrp/Guppy/
wget https://mirror.oxfordnanoportal.com/software/analysis/ont-guppy-${VER}-1.el7.x86_64.rpm
rpm2cpio ont-guppy-${VER}-1.el7.x86_64.rpm | cpio -idmv
mkdir $VER
mv opt $VER
cd /apps/.bioinfo-ugrp-modulefiles/Guppy
cp 2.3.5 $VER
```

### Example commands for running Guppy on Saion

Take home message: `srun` needs `-pgpu --gres gpu:1` and `guppy_basecaller` needs `--device auto`.

```
module load bioinfo-ugrp-modules
module load Guppy
srun --time 2-0 --mem 20G -pgpu --gres gpu:1 --pty guppy_basecaller \
   -i <where FAST5 files are> \
   --recursive \
   --flowcell FLO-MIN106 --kit SQK-LSK109 \
   --num_callers 16 --device auto \
   --records_per_fastq 0 --qscore_filtering --min_qscore 7 --calib_detect \
   -s <where to write the output>
```
