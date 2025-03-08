# API for IMERG Datasets

```@docs
NASAPrecipitation.IMERGHalfHourly
NASAPrecipitation.IMERGDaily
NASAPrecipitation.IMERGMonthly{<:AbstractString,<:TimeType}
```

```@docs
NASAPrecipitation.IMERGEarlyHH
NASAPrecipitation.IMERGLateHH
NASAPrecipitation.IMERGFinalHH
NASAPrecipitation.IMERGEarlyDY
NASAPrecipitation.IMERGLateDY
NASAPrecipitation.IMERGFinalDY
NASAPrecipitation.IMERGMonthly(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString
)
```