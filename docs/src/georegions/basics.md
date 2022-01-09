# A Basic Primer to `GeoRegion`s

In essence, a `GeoRegion` is:
* a geographical region that can be either rectilinear region (`RectRegion`), or a polygonal shape within a specified rectilinear bound (`PolyRegion`).
* identified by a `regID`
* itself a subregion of a **parent** `GeoRegion` (identified by `parID`, which must itself be a valid `ID`)

!!! tip "Default GeoRegions"
    When using `GeoRegions.jl`, the default `GeoRegion` should generally be the global domain, specified by `GLB` and given by the `[N,S,E,W]` coordinates `[90,-90,360,0]`.  The Global GeoRegion `GLB` is considered to be a subset of itself.

See the [documentation for GeoRegions.jl](https://juliaclimate.github.io/GeoRegions.jl/dev/index.html) for more details on what `GeoRegion`s are, and the GeoRegions.jl package.

## NASAPrecipitation.jl reexports GeoRegion.jl

For ease of use, NASAPrecipitation.jl reexports all the functionality of GeoRegions.jl.

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
