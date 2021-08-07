# TRMM TMPA Datasets

TRMM TMPA Datasets are represented by the `TRMMDataset` AbstractType, which in itself is broken into the `TRMM3Hourly`, `TRMMDaily` and `TRMMMonthly` Types.  For 3-hourly and daily datsets, NASA provides not just the output from the final processing run, but also near real-time runs.

The Types that each dataset calls are listed below, along with their function calls.

|          |    `Type`     |   Near Real-Time   |      Final      |
| :------: | :-----------: | :----------------: | :-------------: |
|  3 Hour  | `TRMM3Hourly` | `TRMM3HourlyNRT()` | `TRMM3Hourly()` |
|   Daily  |  `TRMMDaily`  |  `TRMMDailyNRT()`  |  `TRMMDaily()`  |
|  Monthly | `TRMMMonthly` |                    | `TRMMMonthly()` |

So, for example, if we wanted to get the the Near Real-Time TRMM 3-Hourly dataset, we would call the function `TRMMMonthly()`, which would return a `TRMMMonthly` data structure (see example at the end of the page).

## `TRMMDataset` Types / Objects

There are three different Types of `TRMMDataset`:
* `TRMM3Hourly`, which is used to contain information on half-hourly TRMM TMPA datasets
* `TRMMDaily`, which is used to contain information on daily TRMM TMPA datasets
* `TRMMMonthly`, which is used to contain information on monthly TRMM TMPA datasets

```@docs
NASAPrecipitation.TRMM3Hourly{<:AbstractString,<:TimeType}
NASAPrecipitation.TRMMDaily{<:AbstractString,<:TimeType}
NASAPrecipitation.TRMMMonthly{<:AbstractString,<:TimeType}
```

## Creating a `TRMM3Hourly` dataset

The `TRMM3Hourly` dataset structure is used to contain information regarding 3-hourly TRMM datasets.  There are two functions that create `TRMM3Hourly` datasets
* `TRMM3HourlyNRT`, which is used to retrieve Near Real-Time runs
* `TRMM3Hourly`, which is used to retrieve the Final post-processing runs

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

## Creating a `TRMMDaily` dataset

The `TRMMDaily` dataset structure is used to contain information regarding Daily TRMM datasets.  There are two functions that create `TRMMDaily` datasets
* `TRMMDailyNRT`, which is used to retrieve Near Real-Time runs
* `TRMMDaily`, which is used to retrieve the Final post-processing runs

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

## Creating a `TRMMMonthly` dataset

The `TRMMMonthly` dataset structure is used to contain information regarding Monthly TRMM datasets.  There are two functions that create `TRMMMonthly` datasets
* `TRMMMonthlyNRT`, which is used to retrieve Near Real-Time runs
* `TRMMMonthly`, which is used to retrieve the Final post-processing runs

```@docs
NASAPrecipitation.TRMMMonthly(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString
)
```

## Example

```@repl
using NASAPrecipitation
npd = TRMMMonthly(dtbeg=Date(2017,2,1),dtend=Date(2017,2,1),sroot=pwd())
typeof(npd)
```
