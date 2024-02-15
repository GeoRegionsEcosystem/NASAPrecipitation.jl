# Downloading and Reading NASA Precipitation Datasets

In this page we show how you can download data for a given `NASAPrecipitation` dataset.


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

## Required dependencies

Since we are downloading from NASA's EOSDIS OPeNDAP servers, you are required to perform the following:
1. You need to register an account with Earthdata and allow access to the NASA EOSDISC on it.
2. Create a `.netrc` file with the following information: `machine urs.earthdata.nasa.gov login <your login> password <your password>`
3. Create a `.dodsrc` file with the following lines: (1) `HTTP.COOKIEJAR=/<home directory>/.urs_cookies` and (2) `HTTP.NETRC=/<home directory>/.netrc`

If this sounds complicated however, fear not! You need only perform the first step yourself (i.e. create your own account), for NASAPrecipitation.jl will automatically set up the `.dodsrc` file (if you don't already have one), and once you have your `<login>` and `<password>`, you can use the function `setup()` to set up your `.netrc` file.

```
setup(
    login = <username>
    password = <password>
)
```

## Downloading `NASAPrecipitationDataset`s

Downloading NASA Precipitation data is as simple as
```julia
npd = NASAPrecipitationDataset(args...)
geo = GeoRegion(args...)
download(npd,geo)
```

Let us download the `IMERGMonthly` Dataset for 2020 over the Caribbean (as defined by the AR6 IPCC), for example

```@example download
npd = IMERGMonthly(start=Date(2020),stop=Date(2020))
geo = GeoRegion("AR6_CAR")
lsd = getLandSea(npd,geo)
download(npd,geo)
```

## Reading data for a downloaded `NASAPrecipitationDataset`

And now that you have downloaded the data, you can use the function `read()` to call the `NCDataset` that points towards the downloaded data.

```@example download
ds = read(npd,geo,Date(2020))
```

As shown in the printout of the `NCDataset`, the precipitation data is saved under the field name `precipitation`, and is in units of `kg m**-2 s**-1`, or alternatively `mm s**-1`.

```@example download
prcp = ds["precipitation"][:,:,:] * 3600
close(ds)

fig = Figure()
_,_,slon,slat = coordGeoRegion(geo)
aspect = (maximum(slon)-minimum(slon))/(maximum(slat)-minimum(slat))

ax = Axis(
    fig[1,1],width=350,height=350/aspect,
    title="February 2020",xlabel="Longitude / º",ylabel="Latitude / º",
    limits=(minimum(slon)-2,maximum(slon)+2,minimum(slat)-2,maximum(slat)+2)
)
contourf!(
    ax,lsd.lon,lsd.lat,prcp[:,:,2],colormap=:Blues,
    levels=range(0,0.5,length=11),extendlow=:auto,extendhigh=:auto
)
lines!(ax,clon,clat,color=:black)
lines!(ax,slon,slat,color=:red,linewidth=5)

ax = Axis(
    fig[1,2],width=350,height=350/aspect,
    title="August 2020",xlabel="Longitude / º",
    limits=(minimum(slon)-2,maximum(slon)+2,minimum(slat)-2,maximum(slat)+2)
)
contourf!(
    ax,lsd.lon,lsd.lat,prcp[:,:,8],colormap=:Blues,
    levels=range(0,0.5,length=11),extendlow=:auto,extendhigh=:auto
)
lines!(ax,clon,clat,color=:black)
lines!(ax,slon,slat,color=:red,linewidth=5)

hideydecorations!(ax, ticks = false,grid=false)

resize_to_layout!(fig)
fig
```

## Where is the data saved to?

You can check where the data is saved to for a given dataset, georegion and datetime by using the function `npdfnc()`

```@example download
fnc = npdfnc(npd,geo,Date(2020))
```

## API

```@docs
NASAPrecipitation.setup
NASAPrecipitation.download
NASAPrecipitation.read
NASAPrecipitation.npdfnc
```