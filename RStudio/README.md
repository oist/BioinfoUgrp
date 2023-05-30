RStudio server
==============

_Coming soon_

RStudio desktop with X export is too slow, so let's use RStudio server in a browser.


CAUTION
-------

If you run RStudio server as indicated here, and somebody finds your session,
they can steal your SSH key, mine bitcoins on _Saion_, and pretend it is
your fault.

Singularity image
-----------------

Our [singularity image](./Singularity.def) contains the latest RStudio server
on a Debian unstable (Sid) base, which we know contains the latest `R` stable
release.

We also install some development libraries that are likely to be needed
to compile some CRAN or bioconductor packages, as well as packages
needed by RMarkdown and `R CMD check`.

Lastly, let's install the latest tidyverse, as everybody wants it.

Then build the image:

    singularity build --fakeroot RStudio_2023.03.1-446.sif Singularity.def

Write access on _deigo_
-----------------------

The _RStudio_ server needs to write in three different places,
each configured by a different command line argument.

 - `--server-working-dir`: _“The default working directory of the rserver process.”_
 - `--server-data-dir`: _“Path to the data directory where RStudio Server will write run-time state.”_
 - `--database-config-file`: Overrides the default path to the SQLite database that RStudio server needs, which by default is in the Singularity image, therefore non-writable.

At the moment I found no problem to make `--server-working-dir` and
`--server-data-dir` point to the same directory in `$HOME`, but it needs
to be furthe tested.

The SQLite database itself can be in the server working dir.  For instance
on _deigo_ with the `charles-plessy` user, the database configuration file
can be like:

    provider=sqlite
    directory=/home/c/charles-plessy/myRstudioServerDir/myRstudioDatabase.sqlite3

Other configuration arguments
-----------------------------

The server needs to run under your user name.  For instance you can pass `--server-user=$(whoami)`.

You need to pick a port number that is a) higher than 1024 and
b) not used by somebody else on the same node.  Pass it to `rserver` with the
`--www-port` option.

Example command
---------------

Run for the home directory.

    ./RStudio_2022.12.0-353.sif /usr/lib/rstudio-server/bin/rserver --server-working-dir $(pwd)/deletemRstudi --server-data-dir $(pwd)/deletemRstudi --database-config-file $(pwd)/rsdb.conf --server-user=$(whoami) --www-port=9797
