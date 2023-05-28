# Reading the Downloaded NASAPrecipitation Datasets

Once we have downloaded the data, the next step is of course to read and extract the downloaded data.  This is done by calling the function `read()` as follows:

```@docs
NASAPrecipitation.read
```

If for some reason, we need the path to the NetCDF file which contains the data, we can use the function `npdfnc()` as follows:

```@docs
NASAPrecipitation.npdfnc
```

```julia
using NASAPrecipitation
npd = IMERGMonthly(dtbeg=Date(2015,1,1),dtend=Date(2015,1,1)) # Downloads IMERG Monthly Data for the year 2015
geo = GeoRegion("AR6_SEA")
download(npd,geo)
read(npd,geo,Date(2015,1,1))
```