```@raw html
---
layout: home

hero:
  name: "NASAPrecipitation.jl"
  text: "Handling NASA's Precipitation Datasets"
  tagline: Download, extract and manipulate NASA's Precipitation Datasets in Julia.
  image:
    src: /logo.png
    alt: NASAPrecipitation
  actions:
    - theme: brand
      text: Getting Started
      link: /basics
    - theme: alt
      text: Datasets
      link: /datasets/intro
    - theme: alt
      text: Tutorials
      link: /tutorials
    - theme: alt
      text: View on Github
      link: https://github.com/GeoRegionsEcosystem/NASAPrecipitation.jl

features:
  - title: 🔍 Simple and Intuitive
    details: NASAPrecipitation aims to be simple and intuitive to the user, with basic functions like `download()` and `read()`.
  - title: 🌍 Region of Interest
    details: You don't have to download the global dataset, only for your (Geo)Region of interest, saving you time and disk space for small domains.
  - title: 🏔️ Comprehensive
    details: NASAPrecipitation.jl aims to easily download all IMERG Level 3 products, and eventually even Level 2 products as well.
---
```

## Introduction

NASAPrecipitation.jl builds upon the [GeoRegions Ecosystem](https://github.com/GeoRegionsEcosystem) to streamline the following processes:
* downloads of NASA Precipitation Measurement Mission datasets (e.g., TRMM 3B42, IMERGv7)
* basic analysis of said datasets
* perform all the above operations innately over a given geographical region using the [GeoRegions.jl](https://github.com/GeoRegionsEcosystem/GeoRegions.jl) package

## Installation Instructions

The latest version of ETOPO can be installed using the Julia package manager (accessed by pressing `]` in the Julia command prompt)
```julia-repl
julia> ]
(@v1.10) pkg> add NASAPrecipitation
```

You can update `NASAPrecipitation.jl` to the latest version using
```julia-repl
(@v1.10) pkg> update NASAPrecipitation
```

And if you want to get the latest release without waiting for me to update the Julia Registry (although this generally isn't necessary since I make a point to release patch versions as soon as I find bugs or add new working features), you may fix the version to the `main` branch of the GitHub repository:
```julia-repl
(@v1.10) pkg> add NASAPrecipitation#main
```

## Getting help
If you are interested in using `NASAPrecipitation.jl` or are trying to figure out how to use it, please feel free to ask me questions and get in touch!  Please feel free to [open an issue](https://github.com/GeoRegionsEcosystem/NASAPrecipitation.jl/issues/new) if you have any questions, comments, suggestions, etc!
