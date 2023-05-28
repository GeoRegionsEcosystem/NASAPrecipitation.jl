# Extracting data from existing data into a subGeoRegion

One of the drawbacks of retrieving data from the OPeNDAP server is that the connection is slower than doing a direct download from the https url.  This cost can become especially noticeable when we are attempting to retrieve data for smaller regions of interest, where the lag caused by opening and closing remote datasets can add up and even take a longer time than doing a direct download.

Thus, drawing upon the functionality of `extractGrid()` in GeoRegions.jl, we have added in the ability to extract data for a smaller GeoRegion, provided that data for a larger GeoRegion has already been downloaded.

The extraction of data is as easy as

```
extract(
    <NASAPrecipitation Dataset>,
    <subGeoRegion>,
    <parentGeoRegion>,
)
```

### Setup
```@example download
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

Let's define the Tropical Domain and download some NASAPrecipitation data for this region:

```@example download
npd = TRMMMonthly(start=Date(2015),stop=Date(2015))
pgeo = RectRegion("TRP","GLB","Tropics",[30,-30,360,0],savegeo=false)
download(npd,pgeo)
```

We then proceed to define a subGeoRegion, and then extract the data
```@example download
sgeo = GeoRegion("AR6_SEA")
extract(npd,sgeo,pgeo)
```

Now, let us proceed to compare and contrast the two Regions

```@example download
ds = read(npd,pgeo,Date(2015))
prcp_pgeo = ds["precipitation"][:] * 3600
lsd_pgeo  = getLandSea(npd,pgeo)
close(ds)
ds = read(npd,sgeo,Date(2015))
prcp_sgeo = ds["precipitation"][:] * 3600
lsd_sgeo  = getLandSea(npd,sgeo)
close(ds)

fig = Figure()
_,_,slon,slat = coordGeoRegion(sgeo)
aspect = (maximum(slon)-minimum(slon)+90)/(maximum(slat)-minimum(slat)+30)

ax = Axis(
    fig[1,1],width=750,height=750/aspect,
    title="February 2015",xlabel="Longitude / º",ylabel="Latitude / º",
    limits=(minimum(slon)-45,maximum(slon)+45,minimum(slat)-15,maximum(slat)+15)
)
contourf!(
    ax,lsd_pgeo.lon,lsd_pgeo.lat,prcp_pgeo[:,:,2],colormap=:Greens,
    levels=range(0,0.5,length=11),extendlow=:auto,extendhigh=:auto
)
contourf!(
    ax,lsd_sgeo.lon,lsd_sgeo.lat,prcp_sgeo[:,:,2],colormap=:Blues,
    levels=range(0,0.5,length=11),extendlow=:auto,extendhigh=:auto
)
lines!(ax,clon,clat,color=:black)
lines!(ax,slon,slat,color=:red,linewidth=5)

resize_to_layout!(fig)
fig
```

## API

```@docs
NASAPrecipitation.extract
```