# Spatialtemporal Smoothing of NASAPrecipitation.jl Data

One of the drawbacks of retrieving data from the OPeNDAP server is that the connection is slower than using the direct-download method.  This cost can become especially noticeable when we are attempting to retrieve data for smaller regions of interest, where the lag caused by opening and closing remote datasets can add up and even take a longer time than doing a direct download.

Thus, drawing upon the functionality of `extractGrid()` in GeoRegions.jl, we have added in the ability to extract data for a smaller GeoRegion, provided that data for a larger GeoRegion has already been downloaded.

The extraction of data is as easy as

```
smoothing(
    <NASAPrecipitation Dataset>,
    <GeoRegion>,
    <smoothing options> ...,
)
```

### Setup
```@example smooth
using NASAPrecipitation
using CairoMakie
using DelimitedFiles

download("https://raw.githubusercontent.com/natgeo-wong/GeoPlottingData/main/coastline_resl.txt","coast.cst")
coast = readdlm("coast.cst",comments=true)
clon  = coast[:,1]
clat  = coast[:,2]
nothing
```

## An Example: Extracting Data for Southeast Asia from a larger Tropical Domain

Let's define a rectangular domain in Southeast Asia and download some NASAPrecipitation data for this region:

```@example smooth
npd = IMERGMonthly(start=Date(2015),stop=Date(2015,3))
geo = RectRegion("SEA","GLB","Southeast Asia",[15,-15,150,90],savegeo=false)
download(npd,geo)
lsd = getLandSea(npd,geo)
```

Now, let us proceed to perform a spatial smoothing of the data

```@example smooth
npd_smth = IMERGFinalDY(start=Date(2015,2),stop=Date(2015,2))
smoothing(npd_smth,geo,spatial=true,smoothlon=1,smoothlat=0.2)

ds_raw  = read(npd,geo,Date(2015,2))
ds_smth = read(npd,geo,Date(2015,2),smooth=true,smoothlon=1,smoothlat=0.2)

prcp_raw  = ds_raw["precipitation"][:,:,12]  * 86400
prcp_smth = ds_smth["precipitation"][:,:,12] * 86400

close(ds_raw)
close(ds_smth)

fig = Figure()
aspect = (maximum(lsd.lon)-minimum(lsd.lon)+10)/(maximum(lsd.lat)-minimum(lsd.lat)+10)

ax1 = Axis(
    fig[1,1],width=750,height=750/aspect,
    title="February 2015",xlabel="Longitude / º",ylabel="Latitude / º",
    limits=(minimum(slon)-5,maximum(slon)+5,minimum(slat)-5,maximum(slat)+5)
)
ax2 = Axis(
    fig[2,1],width=750,height=750/aspect,
    title="February 2015",xlabel="Longitude / º",ylabel="Latitude / º",
    limits=(minimum(slon)-5,maximum(slon)+5,minimum(slat)-5,maximum(slat)+5)
)
contourf!(
    ax1,lsd.lon,lsd.lat,prcp_raw,colormap=:Blues,
    levels=range(0,0.5,length=11),extendlow=:auto,extendhigh=:auto
)
contourf!(
    ax2,lsd.lon,lsd.lat,prcp_smth,colormap=:Blues,
    levels=range(0,0.5,length=11),extendlow=:auto,extendhigh=:auto
)
lines!(ax1,clon,clat,color=:black)
lines!(ax2,clon,clat,color=:black)

resize_to_layout!(fig)
fig
```

## API

```@docs
NASAPrecipitation.smoothing
```