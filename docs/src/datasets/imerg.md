# GPM IMERG Datasets

GPM IMERG Datasets are represented by the `IMERGDataset` AbstractType, which in itself is broken into the `IMERGHalfHourly`, `IMERGDaily` and `IMERGMonthly` Types.  For half-hourly and daily datsets, NASA provides not just the output from the final processing run, but also early and late near real-time runs.

The Types that each dataset calls are listed below, along with their function calls.

|           |       `Type`      |    Early NRT     |    Late NRT     |    Final NRT     |
| :-------: | :---------------: | :--------------: | :-------------: | :--------------: |
|  30 Mins  | `IMERGHalfHourly` | `IMERGEarlyHH()` | `IMERGLateHH()` | `IMERGFinalHH()` |
|   Daily   |    `IMERGDaily`   | `IMERGEarlyDY()` | `IMERGLateDY()` | `IMERGFinalDY()` |
|  Monthly  |   `IMERGMonthly`  |                  |                 | `IMERGMonthly()` |

So, for example, if we wanted to get the the Early Near Real-Time IMERG Half-Hourly dataset, we would call the function `IMERGEarlyHH`, which would return a `IMERGHalfHourly` data structure (see example at the end of the page).

## `IMERGDataset` Types / Objects

There are three different Types of `IMERGDataset`:
* `IMERGHalfHourly`, which is used to contain information on half-hourly GPM IMERG datasets
* `IMERGDaily`, which is used to contain information on daily GPM IMERG datasets
* `IMERGMonthly`, which is used to contain information on monthly GPM IMERG datasets

```@docs
NASAPrecipitation.IMERGHalfHourly
NASAPrecipitation.IMERGDaily
NASAPrecipitation.IMERGMonthly{<:AbstractString,<:TimeType}
```

## Creating an `IMERGHalfHourly` dataset

The `IMERGHalfHourly` dataset structure is used to contain information regarding half-hourly IMERG datasets.  There are three functions that create `IMERGHalfHourly` datasets
* `IMERGEarlyHH`, which is used to retrieve Near Real-Time Early runs
* `IMERGLateHH`, which is used to retrieve Near Real-Time Late runs
* `IMERGFinalHH`, which is used to retrieve the Final post-processing runs

```@docs
NASAPrecipitation.IMERGEarlyHH
NASAPrecipitation.IMERGLateHH
NASAPrecipitation.IMERGFinalHH
```

## Creating an `IMERGDaily` dataset

The `IMERGDaily` dataset structure is used to contain information regarding daily IMERG datasets.  There are three functions that create `IMERGDaily` datasets
* `IMERGEarlyDY`, which is used to retrieve Near Real-Time Early runs
* `IMERGLateDY`, which is used to retrieve Near Real-Time Late runs
* `IMERGFinalDY`, which is used to retrieve the Final post-processing runs

```@docs
NASAPrecipitation.IMERGEarlyDY
NASAPrecipitation.IMERGLateDY
NASAPrecipitation.IMERGFinalDY
```

## Creating an `IMERGMonthly` dataset

The `IMERGMonthly` dataset structure is used to contain information monthly daily IMERG datasets.  There is only one functions that creates `IMERGMonthly` datasets
* `IMERGMonthly`, which is used to retrieve the Final post-processing runs

```@docs
NASAPrecipitation.IMERGMonthly(
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
npd = IMERGEarlyHH(dtbeg=Date(2017,2,1),dtend=Date(2017,2,1),sroot=pwd())
typeof(npd)
```
