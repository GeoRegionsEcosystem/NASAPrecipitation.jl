<p align="center">
<img alt="NASAPrecipitation.jl Logo" src=https://raw.githubusercontent.com/natgeo-wong/NASAPrecipitation.jl/main/src/logosmall.png />
</p>

# **<div align="center">NASAPrecipitation.jl</div>**

<p align="center">
  <a href="https://www.repostatus.org/#active">
    <img alt="Repo Status" src="https://www.repostatus.org/badges/latest/active.svg?style=flat-square" />
  </a>
  <a href="https://github.com/GeoRegionsEcosystem/NASAPrecipitation.jl/actions/workflows/CI.yml">
    <img alt="GitHub Actions" src="https://github.com/GeoRegionsEcosystem/NASAPrecipitation.jl/actions/workflows/CI.yml/badge.svg?branch=main&style=flat-square">
  </a>
  <br>
  <a href="https://mit-license.org">
    <img alt="MIT License" src="https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square">
  </a>
	<img alt="MIT License" src="https://img.shields.io/github/v/release/natgeo-wong/NASAPrecipitation.jl.svg?style=flat-square">
  <a href="https://georegionsecosystem.github.io/NASAPrecipitation.jl/stable/">
    <img alt="Latest Documentation" src="https://img.shields.io/badge/docs-stable-blue.svg?style=flat-square">
  </a>
  <a href="https://georegionsecosystem.github.io/NASAPrecipitation.jl/dev/">
    <img alt="Latest Documentation" src="https://img.shields.io/badge/docs-latest-blue.svg?style=flat-square">
  </a>
</p>

**Created By:** Nathanael Wong (nathanaelwong@fas.harvard.edu)

## **Introduction**

`NASAPrecipitation.jl` is a Julia package that aims to streamline the following processes:
* downloads of NASA Precipitation Measurement Mission datasets
* basic analysis of said datasets
* perform all the above operations innately over a given [`GeoRegion`](https://github.com/JuliaClimate/GeoRegions.jl)

`NASAPrecipitation.jl` has been registered.  Install it via:
```
] add NASAPrecipitation
```

To get the most recent release on the `#main` branch, do
```
] add NASAPrecipitation#main
```

## **Required Installation**

In order to access NASA's EOSDIS OPeNDAP servers, you need to register an account with [Earthdata](https://www.earthdata.nasa.gov/) in order for [NCDatasets.jl](https://github.com/Alexander-Barth/NCDatasets.jl) to access the data.  Then, follow the steps desribed [here](https://natgeo-wong.github.io/NASAPrecipitation.jl/dev/using/download.html) in the documentation for your downloads to work.

## **Supported Datasets**

The following datasets are supported:
* **GPM IMERGv6**, 0.1º resolution, 60ºS to 60ºN
	* Final runs for Half-Hourly, Daily and Monthly Data
	* Early and Late runs of Half-Hourly and Daily Data
* **TRMM TMPAv7**, 0.25º resolution, 50ºS to 50ºN
	* Final runs for 3-Hourly, Daily and Monthly Data
	* Near Real-Time runs of 3-Hourly and Daily Data

Only the calibrated precipitation data is downloaded, with units of rate in mm/s.

If there is demand, I can easily add other datasets available on the `gpm1` and `disc2` NASA OPeNDAP servers to the mix as well. Please open an issue if you want me to do so.

## **Other Information**

*__Tip:__ The [GeoRegions.jl](https://github.com/JuliaClimate/GeoRegions.jl), [NCDatasets.jl](https://github.com/Alexander-Barth/NCDatasets.jl) and [Dates](https://docs.julialang.org/en/v1/stdlib/Dates) dependencies are reexported by `NASAPrecipitation.jl`, and therefore there is no need to call them separately when the `NASAPrecipitation.jl` package has been loaded.*
