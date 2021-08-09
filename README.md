<p align="center">
<img alt="NASAPrecipitation.jl Logo" src=https://raw.githubusercontent.com/natgeo-wong/NASAPrecipitation.jl/main/src/logosmall.png />
</p>

# **<div align="center">NASAPrecipitation.jl</div>**

<p align="center">
  <a href="https://www.repostatus.org/#active">
    <img alt="Repo Status" src="https://www.repostatus.org/badges/latest/active.svg?style=flat-square" />
  </a>
  <a href="https://github.com/natgeo-wong/NASAPrecipitation.jl/actions/workflows/CI.yml">
    <img alt="GitHub Actions" src="https://github.com/natgeo-wong/NASAPrecipitation.jl/actions/workflows/CI.yml/badge.svg?branch=main&style=flat-square">
  </a>
  <br>
  <a href="https://mit-license.org">
    <img alt="MIT License" src="https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square">
  </a>
	<img alt="MIT License" src="https://img.shields.io/github/v/release/natgeo-wong/NASAPrecipitation.jl.svg?style=flat-square">
  <a href="https://natgeo-wong.github.io/NASAPrecipitation.jl/stable/">
    <img alt="Latest Documentation" src="https://img.shields.io/badge/docs-stable-blue.svg?style=flat-square">
  </a>
  <a href="https://natgeo-wong.github.io/NASAPrecipitation.jl/dev/">
    <img alt="Latest Documentation" src="https://img.shields.io/badge/docs-latest-blue.svg?style=flat-square">
  </a>
</p>

**Created By:** Nathanael Wong (nathanaelwong@fas.harvard.edu)

## **Introduction**

`NASAPrecipitation.jl` is a Julia package that aims to streamline the following processes:
* downloads of NASA Precipitation Measurement Mission datasets
* basic analysis of said datasets
* perform all the above operations innately over a given [`GeoRegion`](https://github.com/JuliaClimate/GeoRegions.jl)

`NASAPrecipitation.jl` is not yet registered.  Therefore, it can only be installed via
```
] add https://github.com/natgeo-wong/NASAPrecipitation.jl.git
```

## **Required Installation**

In order to access NASA's EOSDIS OPeNDAP servers, the following steps are required for [NCDatasets.jl](https://github.com/Alexander-Barth/NCDatasets.jl) to access the data:
* You need to register an account with Earthdata
* Create a `.netrc` file, and paste the following:
  * `machine urs.earthdata.nasa.gov login <your login> password <your password>`
* Create a `.dodsrc` file, and paste the following:
  * `HTTP.COOKIEJAR=/<home directory>/.urs_cookies`
  * `HTTP.NETRC=/<home directory>/.netrc`

## **Usage**

Please refer to the [documentation](https://natgeo-wong.github.io/NASAPrecipitation.jl/dev/) for instructions and examples.  A working knowledge of the `GeoRegion` and `RegionInfo` supertypes used in [`GeoRegions.jl`](https://github.com/JuliaClimate/GeoRegions.jl) v2 is also needed.

*__Tip:__ Both the `GeoRegions.jl` and `Dates` dependencies are reexported by `NASAPrecipitation.jl`, and therefore there is no need to call either `GeoRegions.jl` or `Dates` separately when using the `NASAPrecipitation.jl` package.*

## **Supported Datasets**

The following datasets are supported:
* **GPM IMERGv6**, 0.1º resolution, 60ºS to 60ºN
	* Final runs for Half-Hourly, Daily and Monthly Data
	* Early and Late runs of Half-Hourly and Daily Data
* **TRMM TMPAv7**, 0.25º resolution, 50ºS to 50ºN
	* Final runs for 3-Hourly, Daily and Monthly Data
	* Near Real-Time runs of 3-Hourly and Daily Data

Only the calibrated precipitation data is downloaded, with units of rate in log2(mm/s).

If there is demand, I can easily add other datasets available on the `gpm1` and `disc2` NASA OPeNDAP servers to the mix as well. Please open an issue if you want me to do so.
