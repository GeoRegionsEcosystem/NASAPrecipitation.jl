# The API for NASAPrecipitation.jl Downloads

In this page we go through downloading `NASAPrecipitationDataset`s and the Land-Sea Masks for both IMERG and TRMM data.

## Downloading `NASAPrecipitationDataset`s

Downloading datasets from NASA's EOSDIS OPeNDAP servers requires us to specify a `NASAPrecipitationDataset` `npd` to download, and a `GeoRegion` `geo` to specify the geographic area of interest.  This is passed to the download function `download(npd,geo)`

```@docs
NASAPrecipitation.download
```

For a basic introduction to the concept of a `GeoRegion`, you can refer to the next page *[A Basic Primer to `GeoRegion`s](../download/download.md)*.  Alternatively you can refer to the [GeoRegions.jl documentation](https://juliaclimate.github.io/GeoRegions.jl/dev/index.html) for a comprehensive tutorial.

## Downloading Land-Sea Masks

```@docs
NASAPrecipitation.getIMERGlsm
NASAPrecipitation.getTRMMlsm
```
