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

Let's install the latest RStudio server on a Debian unstable
(Sid) base, which we know contains the latest `R` stable release.

We also install some development libraries that are likely to be needed
to compile some CRAN or bioconductor packages, as well as packages
needed by RMarkdown and `R CMD check`.

Lastly, let's install the latest tidyverse, as everybody wants it.

```sh
cat <<__SINGULARITY__ > RStudio_2022.12.0-353.def
Bootstrap: docker
From: debian:sid

%post
    # Update the image
    apt update
    apt upgrade -y
    
    # Add a package needed to suppress some error messages
    apt install -y whiptail
    
    # Build the American and British English locales
    apt install -y locales
    sed -i /etc/locale.gen -e '/en_[UG].*.UTF-8/s/# //'
    locale-gen
    
    # Install the latest R
    apt install -y r-base
    
    # Install development packages
    apt install -y r-base-dev git libssl-dev libclang-dev libxml2-dev \
      libcurl4-openssl-dev libssl-dev libfftw3-dev libtiff-dev libgsl-dev\
      libfontconfig1-dev libharfbuzz-dev libfribidi-dev
    apt install -y libproj-dev # For proj4, for ggmsa
    apt install -y libboost-all-dev # For GenomicBreaks and other packages
    apt install -y cmake
    apt install -y libv8-dev libudunits2-dev libgdal-dev # in case one wants to install concaveman for ggforce
    
    # Install software needed for vignette building and package checks
    apt install -y pandoc qpdf texlive
    
    # Small utilities usefult for command line and troubleshooting
        apt install -y bash-completion file sudo wget htop strace
        
    # Packages wanted by RStudio
    apt install -y psmisc procps systemctl sudo lsb-release libgl1 libnss3 libasound2 libxdamage1
    
    # Install RStudio server
    wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2022.12.0-353-amd64.deb
    apt --fix-broken -y install ./rstudio-server-2022.12.0-353-amd64.deb
    rm rstudio-*-amd64.deb
    
    # Install R packages of general intetest
    R -e 'install.packages("BiocManager")'
    R -e 'install.packages("tidyverse")'
    R -e 'install.packages("devtools")' 
    R -e 'install.packages("remotes")'
    R -e 'install.packages("rmarkdown")'

    # Use home directory outside image to install more packages
    printf 'R_LIBS_SITE="/usr/local/lib/R/site-library:/usr/lib/R/library"\n' | tee -a /etc/R/Renviron.site >/dev/null
    printf 'R_LIBS_USER="~/R/library/RStudio-2022.12.0-353"\n'                | tee -a /etc/R/Renviron.site >/dev/null

    # Clean downoladed package cache.  Yes I know about /var/libs.
    apt clean
__SINGULARITY__
```

Then build the image:

    sudo singularity build RStudio_2022.12.0-353.sif RStudio_2022.12.0-353.def

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
