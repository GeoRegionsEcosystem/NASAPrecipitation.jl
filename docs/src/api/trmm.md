# API for TRMM Datasets

```@docs
NASAPrecipitation.TRMM3Hourly{<:AbstractString,<:TimeType}
NASAPrecipitation.TRMMDaily{<:AbstractString,<:TimeType}
NASAPrecipitation.TRMMMonthly{<:AbstractString,<:TimeType}
```

```@docs
NASAPrecipitation.TRMM3HourlyNRT
NASAPrecipitation.TRMM3Hourly(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString
)
NASAPrecipitation.TRMMDailyNRT
NASAPrecipitation.TRMMDaily(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString
)
NASAPrecipitation.TRMMMonthly(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString
)
```