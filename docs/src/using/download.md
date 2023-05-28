# Downloading and Saving NASA Precipitation Datasets

In this page we go through downloading `NASAPrecipitationDataset`s and the Land-Sea Masks for both IMERG and TRMM data.

## Required dependencies

Since we are downloading from NASA's EOSDIS OPeNDAP servers, you are required to perform the following:
1. You need to register an account with Earthdata
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

Downloading datasets from NASA's EOSDIS OPeNDAP servers requires us to specify a `NASAPrecipitationDataset` `npd` to download, and a `GeoRegion` `geo` to specify the geographic area of interest.  This is passed to the download function `download(npd,geo)`.

For a full example on downloading these datasets, look at the page *[Downloading IMERG Data](examples/download.md)*.

## API

```@docs
NASAPrecipitation.setup
NASAPrecipitation.download
```