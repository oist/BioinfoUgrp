To list all the packages in the `med-bio` metapackage:

```
./debmed.sif apt show med-cloud | grep Recommends | cut -d' ' -f2-
```

Make sure the module and modulefiles created are writable for the group:

```
umask 002
```

Or if you did not use `umask`, add the write permissions after:

```
chmod g+w file_name
```
