### mhmVis
`mhmVis` is an R package to visualise mHM input and output files.
The main focus is to read, process and plot `netcdf` and `asc` files.
`mhmVis` tries to facilitate automated saving of publication-ready grahics.
E.g. from netcdf files, `vis_nc_film` creates an animated time series movie on a projected map.

This is work-in-heavy-progress and still subject to API changes.
It is planned to be linked with [mHMr](https://github.com/JBrenn/mHMr) one day.
Bug reports and feature requests are welcome as an 
[issue](https://github.com/brry/mhmVis/issues) or via email at <berry-b@gmx.de>.

### installation

Install dependencies ([instructions](https://github.com/brry/OSMscale#intro) 
in case `OSMscale` does not install out of the box):
```R
install.packages("berryFunctions")
install.packages("OSMscale")
library(OSMscale)
```

Update dependencies and install `mhmVis` itself:
```R
berryFunctions::instGit("brry/berryFunctions")
berryFunctions::instGit("brry/OSMscale")
berryFunctions::instGit("brry/mhmVis")
```

### usage

Examples to be added
