# RStudio server

Run [RStudio](https://posit.co/products/open-source/rstudio/) server on a
Deigo compute node, and use it from the web browser of your computer.  The
server runs from a Singularity image containing R, RStudio, the tidyverse,
and the libraries most often needed to install CRAN and Bioconductor
packages.

If modules are new to you, read the [main page](../README.md) first.

## Start the server

On Deigo, load the module and use `srun` to start an RStudio server on a
compute node.  Do not run it on a login node.

```bash
ml bioinfo-ugrp-modules Other/RStudio_server
# Adapt the time (-t), memory (--mem) and cores (-c) to your needs
srun -p compute -t 0-08:00:00 -c 2 --mem 10G RStudio_server
```

The server stops when the job reaches its time limit, or when you stop
`srun` with Ctrl-C.

The running server will output its URL and a password unique to the session such as:

```
RStudio URL:		http://deigo010902.oist.jp:54279/
RStudio Username:	charles-plessy
RStudio Password:	f0731f0e01d3b2f2
```

It also prints a command that opens an SSH tunnel from your computer to the
server, for use from outside OIST's network:

```
If you remote work, you can forward the server to port 1664 on your computer with:
ssh charles-plessy@deigo010902.oist.jp -J charles-plessy@login.oist.jp,charles-plessy@deigo.oist.jp -L 1664:localhost:54279
```

The server creates temporary files in your home directory, which you need
to delete when you have finished:

```
You will need to clean your temporary files by yourself:
RStudio temporary files:	/home/c/charles-plessy/tmp.zv3bC383g1
```

The R packages that you install from RStudio are stored in a separate
directory of your home directory, because they cannot be mixed with packages
built for other R installations on Deigo.  At the moment this directory is:

```
This image will build its packages in the following directory if it exists:
R_LIBS_USER="~/R/library/R_4.6_for_RStudio_Singularity"
```

Once a year, a new major release of R requires reinstalling your packages.
To keep using the same version, load the module with its version, for
instance `Other/RStudio_server/2026.08.2-200_R_4.6.1`; `ml av RStudio_server`
lists the versions.

## RStudio Desktop

The image also contains RStudio Desktop, which you can run on a Linux
computer with Singularity (or Apptainer) and a Wayland display, after
copying the image from `/bucket/BioinfoUgrp/Other/RStudio_server/<version>/`:

```
# On your own computer, not on Deigo:
singularity exec --bind $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/run/user/$(id -u)/$WAYLAND_DISPLAY  ./RStudio_2026.08.2-200_R_4.6.1.sif rstudio
# Or if you want to share your SSH agent:
singularity exec --bind $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/run/user/$(id -u)/$WAYLAND_DISPLAY --bind $SSH_AUTH_SOCK:/ssh-agent --env SSH_AUTH_SOCK=/ssh-agent ./RStudio_2026.08.2-200_R_4.6.1.sif rstudio
```

## Rscript

The module also provides `Rscript`, which runs R scripts with the R of the
image, for instance in batch jobs:

```bash
ml bioinfo-ugrp-modules Other/RStudio_server
Rscript myscript.R
```

Maintenance notes are in [dev/RStudio.md](../dev/RStudio.md).
