RStudio server
==============

_Coming soon_

RStudio desktop with X export is too slow, so let's use RStudio server in a browser.

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
    printf 'R_LIBS=~/R/library/RStudio-2022.12.0-353\n' | tee -a /etc/R/Renviron.site >/dev/null

    # Clean downoladed package cache.  Yes I know about /var/libs.
    apt clean
__SINGULARITY__
```

Then build the image:

    sudo singularity build RStudio_2022.12.0-353.sif RStudio_2022.12.0-353.def

Writable directories on _deigo_
-------------------------------

