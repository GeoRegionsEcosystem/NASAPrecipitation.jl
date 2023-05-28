# Dummy Datasets

Dummy datasets are meant to specify the paths to the NASAPrecipitation root directory, and LandSea Dataset directory, without needing inputs for date.

```@docs
NASAPrecipitation.IMERGDummy
NASAPrecipitation.TRMMDummy
```

```@repl
using NASAPrecipitation
npd = IMERGDummy(path=homedir())
npd = TRMMDummy(path=homedir())
isdir(npd.maskpath)
```

## API

```@docs
IMERGDummy(
    ST = String;
    path  :: AbstractString = homedir(),
)
TRMMDummy(
    ST = String;
    path  :: AbstractString = homedir(),
)
```