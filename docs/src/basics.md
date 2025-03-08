# The Basics of NASAPrecipitation.jl

There are two essential components in NASAPrecipitation.jl

* A NASA precipitation dataset of interest (i.e., a NASAPrecipitationDataset `npd`)
* A geographic region of interest (i.e., a GeoRegion `geo`)

With these two components, you can perform the following actions:

* Download data of interest using `download(npd,geo)`
* Perform basic analysis on the data using `analysis(npd,geo)`
* Manipulate the data (e.g., spatiotemporal smoothing using `smooth(npd,geo,...)`)

## The `NASAPrecipitationDataset` Type

All `NASAPrecipitationDataset` types _(except for the Dummy types)_ contain the following information:
* `start` - The beginning of the date-range of our data of interest
* `stop` - The end of the date-range of our data of interest
* `path` - The data directory in which our dataset is saved into

```@docs
NASAPrecipitation.NASAPrecipitationDataset
```

## The `AbstractGeoRegion` Type

A `GeoRegion` defines the geometry/geometries of geograhical region(s) of interest. See the [documentation of GeoRegions.jl](https://georegionsecosystem.github.io/GeoRegions.jl/dev/georegions) for more information.

```@docs
GeoRegions.AbstractGeoRegion
```