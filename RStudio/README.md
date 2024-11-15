RStudio server
==============

How to use
----------

### Start the server

On _deigo_, load the `singularity` module, and use `srun` to start a _RStudio sever_ instance on a _compute_ node.
Do not run it on a _login_ node.

```
ml bioinfo-ugrp-modules Other/RStudio_server
# Change --mem and add -c according to your needs
srun -pcompute --mem 10G RStudio_server
```

The running server will output its URL and a password unique to the session such as:

```
RStudio URL:		http://deigo010902.oist.jp:54279/
RStudio Username:	charles-plessy
RStudio Password:	f0731f0e01d3b2f2
```

If applicable, it will also give an example command on how to run a SSH tunnel,
for people who remote work outside our network.

```
If you remote work, you can forward the server to port 1664 on your computer with:
ssh charles-plessy@deigo010902.oist.jp -J charles-plessy@login.oist.jp,charles-plessy@deigo.oist.jp -L 1664:localhost:54279
```

The server creates temporary files:

```
You will need to clean your temporary files by yourself:
RStudio temporary files:	/home/c/charles-plessy/tmp.zv3bC383g1
```

The _R_ packages that you will install from RStudio will be stored in a
specific location in your home directory, because they can not be mixed with
the packages built directly on _deigo_ or in other images.  At the moment this
directory is:

```
This image will build its packages in the following directory if it exists:
R_LIBS_USER="~/R/library/R_4.4_for_RStudio_Singularity"
```

**Note that once a year, there is a major release of R that requires rebuild of
the installed packages.  To stick the same version and ignore updates, load the
module with the version name like in
`Other/RStudio_server/2024.09.1-394_R_4.4.2` for instance.**

### RStudio Desktop

The image also contains RStudio Desktop in case you need it.

```
# On your desktop PC, not deigo:
xhost +
singularity exec ./RStudio_2024.09.1-394_R_4.4.2.sif rstudio
```

How to build a Singularity image
--------------------------------

Our [singularity image](./Singularity.def) contains the latest RStudio server
on a Debian unstable (Sid) base, which we know contains the latest `R` stable
release.

We also install some development libraries that are likely to be needed
to compile some CRAN or bioconductor packages, as well as packages
needed by RMarkdown and `R CMD check`.

Lastly, let's install the latest tidyverse, as everybody wants it.

Then build the image:

    singularity build --fakeroot RStudio_2024.09.1-394_R_4.4.2.sif Singularity.def

Technical details
-----------------

Inspired by https://gitlab.oit.duke.edu/chsi-informatics/containers/singularity-rstudio-base and a couple of other repositories.

The _RStudio_ server needs to write in three different places,
each configured by a different command line argument.

 - `--server-working-dir`: _“The default working directory of the rserver process.”_
 - `--server-data-dir`: _“Path to the data directory where RStudio Server will write run-time state.”_
 - `--database-config-file`: Overrides the default path to the SQLite database that RStudio server needs, which by default is in the Singularity image, therefore non-writable.

At the moment I found no problem to make `--server-working-dir` and
`--server-data-dir` point to the same directory in `$HOME`, but it was not tested extensively.

The SQLite database itself can be in the server working dir.  Its configuration
file is generated on the fly for each run.  For instance its contents look like:

    provider=sqlite
    directory=/home/c/charles-plessy/tmp.J7UkdHFppy/db.sqlite3

The server needs to run under your user name `--server-user=$USER`.

An available port number is picked randomly between 50000 and 65535 and passed
to `rserver` with the `--www-port` option.

### Lmod modulefile

```
-- Default settings
local modroot    = "/bucket/BioinfoUgrp"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package information
whatis("Name: "..appname)
whatis("Version: "..appversion)
whatis("URL: ".."https://github.com/oist/BioinfoUgrp/tree/master/RStudio")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."R, RStudio, server")
whatis("Description: ".."Singularity image to run RStudio server on a compute node and access from your web browser.")

-- Package settings
depends_on("singularity")
prepend_path("PATH", apphome.."/")
```
