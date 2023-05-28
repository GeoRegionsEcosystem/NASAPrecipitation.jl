# Integrating GeoRegions.jl with NASAPrecipitation.jl

When downloading and analysing the NASA Precipitation data, we are often not interested in global data.  Instead, we are interest in the statistics and trends, etc., in a specific geographic region.  We use the functionality of GeoRegions.jl, and the exported `GeoRegion` and `RegionGrid` Types to manipulate and extract out data from our region of interest from the datasets provided.

For ease of use, NASAPrecipitation.jl reexports all the functionality of GeoRegions.jl.

!!! tip "Reexporting GeoRegions.jl"
    For ease of use, NASAPrecipitation.jl reexports all the functionality of GeoRegions.jl., so all the functions that support the creation and retrieval of `GeoRegion` information, and the extraction and manipulation of data using `RegionGrid`s, can be used by calling `using NASAPrecipitation`

Below, we give a brief rundown of the functionality of GeoRegions.jl, but for a full description and tutorial of how to use this package, please refer to the [documentation](https://juliaclimate.github.io/GeoRegions.jl)

## What is a `GeoRegion`?

In essence, a `GeoRegion` is:
* a geographical region that can be either rectilinear region (`RectRegion`), or a polygonal shape within a specified rectilinear bound (`PolyRegion`).
* identified by a `regID`
* itself a subregion of a **parent** `GeoRegion` (identified by `parID`, which must itself be a valid `ID`)

!!! tip "Default GeoRegions"
    When using `GeoRegions.jl`, the default `GeoRegion` should generally be the global domain, specified by `GLB` and given by the `[N,S,E,W]` coordinates `[90,-90,360,0]`.  The Global GeoRegion `GLB` is considered to be a subset of itself.

## An Example of a `GeoRegion`

Let us plot an example `GeoRegion`. When a `GeoRegion` is called, NASAPrecipitation.jl will create a grid that spans the bounds of the `GeoRegion` (red dots), but will only download valid data in the **shape** of the `GeoRegion` (blue dots).

![regiongrid](regiongrid.png)

## Predefined `GeoRegion`s in NASAPrecipitation.jl

By default, NASAPrecipitation.jl will download all available data.  This means
* For `IMERGDataset`s, the data spans 89.95ºS to 89.95ºN
* For `TRMMDataset`s, the data spans 49.875ºS to 49.875ºN
* For the TRMM Land-Sea Mask, the data spans 89.875ºS to 89.875ºN

In NASAPrecipitation.jl, we therefore define the `GeoRegion`s `GPM`, `TRMM` and `TRMMLSM` in order to ensure that bounds of the GeoRegion we request do not go out of bounds of what is available.  Upon loading NASAPrecipitation.jl for the first time during any Julia session, NASAPrecipitation.jl will check if these three `GeoRegion`s exist.  However, one can check if they exist at any point (and recreate them if they don't) using the function `addNPDGeoRegions()`

```@repl
using NASAPrecipitation
resetGeoRegions()  # Clear custom GeoRegions
addNPDGeoRegions() # Checking to see if NASAPrecipitation.jl GeoRegions exists
GeoRegion("IMERG")
```

```@docs
NASAPrecipitation.addNPDGeoRegions()
```
