# Spatialtemporal Smoothing of Data

There are options in NASAPrecipitation.jl to spatialtemporally smooth data.

```
smoothing(
    <NASAPrecipitation Dataset>,
    <GeoRegion>,
    <smoothing options> ...,
)
```

It is important to see the documentation and see which options are available for each type of dataset, but we summarize it in the table below:

|       `Type`      | Spatial |       Temporal      |
| :---------------: | :-----: | :-----------------: |
| `IMERGHalfHourly` |   Yes   | Yes (specify hours) |
|    `IMERGDaily`   |   Yes   | Yes (specify days)  |
|   `IMERGMonthly`  |   Yes   |         No          |
|   `TRMM3Hourly`   |   Yes   | Yes (specify hours) |
|    `TRMMDaily`    |   Yes   | Yes (specify days)  |
|   `TRMMMonthly`   |   Yes   |         No          |

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

## Spatial Smoothing Example

Let's define a rectangular domain in Southeast Asia and download some NASAPrecipitation data for this region:

```@example smooth
npd = IMERGMonthly(start=Date(2015),stop=Date(2015,3))
geo = RectRegion("TMP","GLB","Southeast Asia",[15,-15,125,95],savegeo=false)
download(npd,geo)
lsd = getLandSea(npd,geo)
```

We then proceed to perform a spatial smoothing (1.0º longitude, 0.2º latitude) of the data.

```@example smooth
npd_smth = IMERGMonthly(start=Date(2015,2),stop=Date(2015,2))
smoothing(npd_smth,geo,smoothlon=1,smoothlat=0.2)
```

Now let us compare the difference between the raw and smoothed data.

```@example smooth
ds_raw  = read(npd_smth,geo,Date(2015))
ds_smth = read(npd_smth,geo,Date(2015),smooth=true,smoothlon=1,smoothlat=0.2)

prcp_raw  = ds_raw["precipitation"][:,:,11]  * 86400
prcp_smth = ds_smth["precipitation"][:,:,11] * 86400

close(ds_raw)
close(ds_smth)

fig = Figure()
aspect = (maximum(lsd.lon)-minimum(lsd.lon)+2)/(maximum(lsd.lat)-minimum(lsd.lat)+2)

ax1 = Axis(
    fig[1,1],width=350,height=350/aspect,
    title="November 2015 (Raw)",xlabel="Longitude / º",ylabel="Latitude / º",
    limits=(minimum(lsd.lon)-1,maximum(lsd.lon)+1,minimum(lsd.lat)-1,maximum(lsd.lat)+1)
)
ax2 = Axis(
    fig[1,2],width=350,height=350/aspect,
    title="November 2015 (Smoothed 1.0ºx0.2º)",xlabel="Longitude / º",
    limits=(minimum(lsd.lon)-1,maximum(lsd.lon)+1,minimum(lsd.lat)-1,maximum(lsd.lat)+1)
)
contourf!(
    ax1,lsd.lon,lsd.lat,prcp_raw,colormap=:Blues,
    levels=range(0,20,length=11),extendlow=:auto,extendhigh=:auto
)
contourf!(
    ax2,lsd.lon,lsd.lat,prcp_smth,colormap=:Blues,
    levels=range(0,20,length=11),extendlow=:auto,extendhigh=:auto
)
lines!(ax1,clon,clat,color=:black)
lines!(ax2,clon,clat,color=:black)

resize_to_layout!(fig)
fig
```

And we see that the data is smoothed in the longitude-direction. Because they are not smoothed equally in both longitude and latitude, the fields look stretched in the longitude direction.

## API

```@docs
NASAPrecipitation.smoothing
```