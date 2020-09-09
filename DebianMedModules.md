To list all the packages in the `med-bio` metapackage:

```
./debmed.sif apt show med-cloud | grep Recommends | cut -d' ' -f2-
```
