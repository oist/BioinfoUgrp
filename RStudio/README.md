RStudio server
==============

How to use
----------

On _deigo_, load the `singularity` module, and use `srun` to start a _RStudio sever_ instance on a compute node.

```
ml singularity
srun -pcompute --mem 10G RStudio_server_2023.03.1-446.sif # Change according to your needs
```

The running server will output its URL and a password unique to the session such as:

```
RStudio URL:		http://deigo011232.oist.jp:63597/
RStudio Username:	charles-plessy
RStudio Password:	55eef325d064b7ba
RStudio temporary files:	/home/c/charles-plessy/tmp.J7UkdHFppy
```

At the moment you need to clean the temporary files by yourself after the session is over.

The _R_ packages that you will install from RStudio will be stored in a specific location in your home directory, because they can not be mixed with the packages built directly on _deigo_ or in other images.  At the moment this directory is:

```
~/R/library/RStudio-2023.03.1-446
```

TODO: also output it together with the URL and password. 

**You may need to create the directory first if it does not exist yet**

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

    singularity build --fakeroot RStudio_2023.03.1-446.sif Singularity.def

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
