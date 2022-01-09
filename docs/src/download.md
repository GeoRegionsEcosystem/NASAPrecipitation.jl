# The API for NASAPrecipitation.jl Downloads

In this page we go through downloading `NASAPrecipitationDataset`s and the Land-Sea Masks for both IMERG and TRMM data.

## Required dependencies

Since we are downloading from NASA's EOSDIS OPeNDAP servers, you need to do the following steps before NASAPrecipitation downloads will work:
* You need to register an account with Earthdata
* Create a `.netrc` file, and paste the following:
  * `machine urs.earthdata.nasa.gov login <your login> password <your password>`
* Create a `.dodsrc` file, and paste the following:
  * `HTTP.COOKIEJAR=/<home directory>/.urs_cookies`
  * `HTTP.NETRC=/<home directory>/.netrc`

## Downloading `NASAPrecipitationDataset`s

Downloading datasets from NASA's EOSDIS OPeNDAP servers requires us to specify a `NASAPrecipitationDataset` `npd` to download, and a `GeoRegion` `geo` to specify the geographic area of interest.  This is passed to the download function `download(npd,geo)`.

For a full example on downloading these datasets, look at the page *[Downloading IMERG Data](examples/download.md)*.

```@docs
NASAPrecipitation.download
```

For a basic introduction to the concept of a `GeoRegion`, you can refer to the page *[A Basic Primer to `GeoRegion`s](georegions/basics.md)*.  Alternatively you can refer to the [GeoRegions.jl documentation](https://juliaclimate.github.io/GeoRegions.jl/dev/index.html) for a comprehensive tutorial.

## Downloading Land-Sea Masks

We are also able to use NASAPrecipitation.jl to download Land-Sea Masks on the same grids as `IMERGDataset`s and `TRMMDataset`s.  This is of great help in allowing us to filter data based on whether it is over land or sea.

For a full example on how these land-sea masks can be used in dataset analysis, look at the page *[Land-Sea Mask Filtering](examples/landseamask.md)*.

```@docs
NASAPrecipitation.getIMERGlsm
NASAPrecipitation.getTRMMlsm
```
