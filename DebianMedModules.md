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
