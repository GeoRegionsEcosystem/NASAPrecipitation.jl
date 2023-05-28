# Defining NASA Precipitation Datasets

Defining a `NASAPrecipitationDataset` is easy, all you have to define are two things:
1. Date range, ranging from `start` to `stop`
2. Data path, i.e. where you want to save the NASA Precipitation Data

```
DatasetFunction(
    start = Date(),
    stop  = Date(),
    path  = ...
)
```

## Examples

See below for an example of defining an `IMERGDataset`
```@repl
using NASAPrecipitation
npd = IMERGFinalHH(start=Date(2017,2,1),stop=Date(2017,2,1),path=homedir())
npd.start
npd.datapath
npd.fpref
typeof(npd)
typeof(npd) <: NASAPrecipitation.NASAPrecipitationDataset
```

And below for an example of defining a `TRMMDataset`
```@repl
using NASAPrecipitation
npd = TRMMMonthly(start=Date(2017,2,1),stop=Date(2017,2,1),path=homedir())
npd.start
npd.datapath
npd.fpref
typeof(npd)
typeof(npd) <: NASAPrecipitation.NASAPrecipitationDataset
```

We see that the input arguments, and the fields of the resulting dataset, are the same despite the different dataset Types.