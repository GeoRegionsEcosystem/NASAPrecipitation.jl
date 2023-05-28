# Loading and Saving Land-Sea Mask Datasets

The Land-Sea Dataset can be obtained using the function `getLandSea()`.  See end of the page for the API

### Setup

````@example landseamask
using NASAPrecipitation
using DelimitedFiles
using CairoMakie

download("https://raw.githubusercontent.com/natgeo-wong/GeoPlottingData/main/coastline_resl.txt","coast.cst")
coast = readdlm("coast.cst",comments=true)
clon  = coast[:,1]
clat  = coast[:,2]
nothing
````

## Retrieving IMERG and TRMM Land-Sea Mask over Java

First, we must define the `NASAPrecipitation` datasets, and the GeoRegion of interest.
````@example landseamask
npd_imerg = IMERGDummy(path=pwd())
npd_trmm  = TRMMDummy(path=pwd())
geo  = RectRegion("JAV","GLB","Java",[-5.5,-9,115,105],savegeo=false)
````

Then, we retrieve the IMERG LandSea Dataset
````@example landseamask
lsd_imerg = getLandSea(npd_imerg,geo)
````

And then the TRMM LandSea Dataset
````@example landseamask
lsd_trmm  = getLandSea(npd_trmm ,geo)
````

And we plot them below for comparison:

````@example landseamask
fig = Figure()
slon,slat = coordGeoRegion(geo)
aspect = (maximum(slon)-minimum(slon))/(maximum(slat)-minimum(slat))

ax1 = Axis(
    fig[1,1],width=750,height=750/aspect,
    title="IMERG Land-Sea Mask",ylabel="Latitude / º",
    limits=(minimum(slon)-0.5,maximum(slon)+0.5,minimum(slat)-0.5,maximum(slat)+0.5)
)
contourf!(
    ax1,lsd_imerg.lon,lsd_imerg.lat,lsd_imerg.lsm,colormap=:delta,
    levels=range(0.05,0.95,length=19),extendlow=:auto,extendhigh=:auto
)
lines!(ax1,slon,slat,linewidth=5)

ax2 = Axis(
    fig[2,1],width=750,height=750/aspect,
    title="TRMM Land-Sea Mask",xlabel="Longitude / º",ylabel="Latitude / º",
    limits=(minimum(slon)-0.5,maximum(slon)+0.5,minimum(slat)-0.5,maximum(slat)+0.5)
)
contourf!(
    ax2,lsd_trmm.lon,lsd_trmm.lat,lsd_trmm.lsm,colormap=:delta,
    levels=range(0.05,0.95,length=19),extendlow=:auto,extendhigh=:auto
)
lines!(ax2,slon,slat,linewidth=5)

resize_to_layout!(fig)
fig
````

We see that, as expected, the IMERG `LandSea` dataset is of a higher resolution than that of TRMM, which also explains the gap between the border of the GeoRegion and the data, because in GPM IMERG and TRMM TMPA datasets, the grid *edges* start at [ N,S,E,W ] = [ 90,-90,360,0 ], not the grid centers.

## API

```@docs
getLandSea
```