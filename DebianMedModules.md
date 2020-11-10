Debian Med modules
==================

The [Debian Med](https://www.debian.org/devel/debian-med/) project packages
bioinformatics and other medically relevant software for the
[Debian](https://www.debian.org/intro/about) operating system.  We collect
many of them in a [Singularity](https://sylabs.io/) container and create one
module per package on Deigo.

For users
---------


For developers
--------------

### Creation of a new Singularity image

This has to be run on a machine where one has administrator priviledges.
(That is: not Deigo)

```
DEBVERSION=10.6
# Select Debian version and installed packages
cat > DebianMed_$DEBVERSION.def << __EOF__
Bootstrap: docker
From: debian:$DEBVERSION

%post
    apt -y update
    apt -y install locales # Multilingual support
    apt -y install med-cloud bioperl python-biopython # Bioinfo packages
    apt -y install rsync ncftp lftp # Small utilities
    apt -y install perl-doc man-db # Documentation
__EOF__

# Build the image
sudo singularity build DebianMed_$DEBVERSION.sif DebianMed_$DEBVERSION.def

# Transfer it on Deigo
scp deigo mkdir -p /apps/unit/BioinfoUgrp/DebianMed_$DEBVERSION
scp DebianMed_$DEBVERSION.def DebianMed_$DEBVERSION.sif deigo:/apps/unit/BioinfoUgrp/DebianMed_$DEBVERSION
```

### Misc commands

To list all the packages in the `med-bio` metapackage:

```
./debmed.sif apt show med-cloud | grep Recommends | cut -d' ' -f2-
```

Command to generate all the modules:

```
for package in $(./debmed.sif apt show med-cloud | grep Recommends | cut -d' ' -f2- | sed 's/,//g')
do
  ../BioinfoUgrp/mkDebMedModule.sh $package
  done
```

Make sure the module and modulefiles created are writable for the group:

```
umask 002
```

Or if you did not use `umask`, add the write permissions after:

```
chmod g+w file_name
```

After creating a new module, if it is not seen by `ml av`, delete the cache:

```
rm -rf ~/.lmod.d/.cache
```

## TODO

 - Parse description from Debian package
 - Export man pages and add MANPATH to the Lua module.
 - Blacklist R package or handle them separately.
