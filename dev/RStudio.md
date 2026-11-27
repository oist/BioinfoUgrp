# Maintenance notes: RStudio server image

User documentation: [RStudio/README.md](../RStudio/README.md).  General
conventions: [CONTRIBUTING.md](../CONTRIBUTING.md).  The files used here are
in the [RStudio](../RStudio) directory: `Singularity.def`,
`launch_rserver.sh` and `rstudio_auth.sh`.

## How to build a Singularity image

Our [singularity image](../RStudio/Singularity.def) contains the latest RStudio server
on a Debian unstable (Sid) base, which we know contains the latest `R` stable
release.

We also install some development libraries that are likely to be needed
to compile some CRAN or bioconductor packages, as well as packages
needed by RMarkdown and `R CMD check`.

Lastly, let's install the latest tidyverse, as everybody wants it.

Then build the image:

    singularity build --fakeroot RStudio_2026.08.2-200_R_4.6.1.sif Singularity.def

## Technical details

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

### Generate scripts

```
VERSION=2026.08.2-200_R_4.6.1
BASE=/bucket/BioinfoUgrp/Other/RStudio_server/$VERSION
IMAGE=$BASE/RStudio_${VERSION}.sif

cat > RStudio_server <<EOF
#!/bin/bash
set -e

VERSION="$VERSION"
BASE="/bucket/BioinfoUgrp/Other/RStudio_server/\$VERSION"
IMAGE="\$BASE/RStudio_\${VERSION}.sif"

KEYDIR="\$HOME/.local/share/rstudio-server"

mkdir -p "\$KEYDIR"
chmod 700 "\$KEYDIR"

for key in secure-cookie-key session-rpc-key
do
    if [ ! -s "\$KEYDIR/\$key" ]; then
        openssl rand -hex 32 > "\$KEYDIR/\$key"
        chmod 600 "\$KEYDIR/\$key"
    fi
done

exec singularity exec \\
    --bind "\$KEYDIR:/var/lib/rstudio-server" \\
    "\$IMAGE" \\
    launch_rserver "\$@"
EOF

chmod +x RStudio_server

cat > Rscript <<EOF
#!/bin/bash
set -e

VERSION="$VERSION"
BASE="/bucket/BioinfoUgrp/Other/RStudio_server/\$VERSION"
IMAGE="\$BASE/RStudio_\${VERSION}.sif"

exec singularity exec "\$IMAGE" Rscript "\$@"
EOF

chmod +x Rscript
```
