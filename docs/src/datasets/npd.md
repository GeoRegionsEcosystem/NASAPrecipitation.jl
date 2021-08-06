# NASA Precipitation Datasets

The precipitation datasets that NASAPrecipitation.jl v0.1 currently supports are retrieved from NASA's EOSDIS OPeNDAP servers.  They are considered to be a `NASAPrecipitationDataset` type.

## `NASAPrecipitationDataset`

The `NASAPrecipitationDataset` AbstractType is meant as an overarching type container for information that identifies various NASA Precipitation Datasets.

```@docs
NASAPrecipitation.NASAPrecipitationDataset
```

All subTypes of the `NASAPrecipitationDataset` have the same basic fields and structure.
```@repl
using NASAPrecipitation
npd = IMERGFinalHH(dtbeg=Date(2017,2,1),dtend=Date(2017,2,1),sroot=pwd())
npd.dtbeg
npd.sroot
npd.fpref
typeof(npd)
typeof(npd) <: NASAPrecipitation.NASAPrecipitationDataset
```

## Supported NASA Datasets

The following datasets are supported in v0.1:
* **GPM IMERGv6**, 0.1º resolution, 60ºS to 60ºN, represented by the `IMERGDataset` Type
  * Final runs for Half-Hourly, Daily and Monthly Data
  * Early and Late runs of Half-Hourly and Daily Data
* **TRMM TMPAv7**, 0.25º resolution, 50ºS to 50ºN, represented by the `TRMMataset` Type
  * Final runs for 3-Hourly, Daily and Monthly Data
  * Near Real-Time runs of 3-Hourly and Daily Data

```@docs
NASAPrecipitation.IMERGDataset
NASAPrecipitation.TRMMDataset
```

Each of these Abstract superTypes has its own set of Types.  See the respective pages for [GPM IMERG](imerg.md) and [TRMM TMPA](trmm.md) for more information.
