# API for IMERG Datasets

## Types of IMERG Datasets

```@docs
NASAPrecipitation.IMERGHalfHourly
NASAPrecipitation.IMERGDaily
NASAPrecipitation.IMERGMonthly{<:AbstractString,<:TimeType}
```

## Creating IMERG Half-Hourly Datasets

```@docs
NASAPrecipitation.IMERGEarlyHH
NASAPrecipitation.IMERGLateHH
NASAPrecipitation.IMERGFinalHH
```

## Creating IMERG Daily Datasets

```@docs
NASAPrecipitation.IMERGEarlyDY
NASAPrecipitation.IMERGLateDY
NASAPrecipitation.IMERGFinalDY
```

## Creating IMERG Monthly Datasets

```@docs
NASAPrecipitation.IMERGMonthly(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString
)
```