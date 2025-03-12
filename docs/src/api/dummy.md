# API for Dummy Datasets

## Types of Dummy Datasets

```@docs
NASAPrecipitation.IMERGDummy
NASAPrecipitation.TRMMDummy
```

## Creating a Dummy Dataset

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