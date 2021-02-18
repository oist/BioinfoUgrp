Modules related to Nanopore sequencing
======================================

Usage
-----

```
module load bioinfo-ugrp-modules
module load Guppy
# If needed:
module load Rerio
```

Note that for GPU acceleration on _Saion_, `srun` needs `-pgpu --gres gpu:1` and `guppy_basecaller` needs `--device auto`.

Please ask further questions on the _BioinfoUgrp_ group on [Teams](https://teams.microsoft.com/l/team/19%3a3183bd7fe2844138a49996a2bd376873%40thread.tacv2/conversations?groupId=cc78e114-c544-43e2-b4b1-29c7428aa305&tenantId=d8c0fb8d-bb56-44bb-9f4a-c58e7465652e) (OIST login needed).

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
