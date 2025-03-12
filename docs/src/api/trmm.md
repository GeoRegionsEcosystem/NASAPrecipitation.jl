# API for TRMM Datasets

## Types of TRMM Datasets

```@docs
NASAPrecipitation.TRMM3Hourly{<:AbstractString,<:TimeType}
NASAPrecipitation.TRMMDaily{<:AbstractString,<:TimeType}
NASAPrecipitation.TRMMMonthly{<:AbstractString,<:TimeType}
```

## Creating TRMM Sub-Daily Datasets

```@docs
NASAPrecipitation.TRMM3HourlyNRT
NASAPrecipitation.TRMM3Hourly(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString
)
```

## Creating TRMM Daily Datasets

```@docs
NASAPrecipitation.TRMMDailyNRT
NASAPrecipitation.TRMMDaily(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString
)
```

## Creating TRMM Monthly Datasets

```@docs
NASAPrecipitation.TRMMMonthly(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString
)
```