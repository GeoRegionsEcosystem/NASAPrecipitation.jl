# TRMM TMPA Datasets

TRMM TMPA Datasets are represented by the `TRMMDataset` AbstractType, which in itself is broken into the `TRMM3Hourly`, `TRMMDaily` and `TRMMMonthly` Types.  For 3-hourly and daily datsets, NASA provides not just the output from the final processing run, but also near real-time runs.

The Types that each dataset calls are listed below, along with their function calls.

|          |    `Type`     |   Near Real-Time   |      Final      |
| :------: | :-----------: | :----------------: | :-------------: |
|  3 Hour  | `TRMM3Hourly` | `TRMM3HourlyNRT()` | `TRMM3Hourly()` |
|   Daily  |  `TRMMDaily`  |  `TRMMDailyNRT()`  |  `TRMMDaily()`  |
|  Monthly | `TRMMMonthly` |                    | `TRMMMonthly()` |

So, for example, if we wanted to get the the Near Real-Time TRMM 3-Hourly dataset, we would call the function `TRMMMonthly()`, which would return a `TRMMMonthly` data structure (see example at the end of the page).

### Setup
```@example trmm
using NASAPrecipitation
```

## `TRMMDataset` Types / Objects

There are three different Types of `TRMMDataset`:
* `TRMM3Hourly`, which is used to contain information on half-hourly TRMM TMPA datasets
* `TRMMDaily`, which is used to contain information on daily TRMM TMPA datasets
* `TRMMMonthly`, which is used to contain information on monthly TRMM TMPA datasets

## Creating a `TRMM3Hourly` dataset

The `TRMM3Hourly` dataset structure is used to contain information regarding 3-hourly TRMM datasets.  There are two functions that create `TRMM3Hourly` datasets
* `TRMM3HourlyNRT`, which is used to retrieve Near Real-Time runs
* `TRMM3Hourly`, which is used to retrieve the Final post-processing runs

```@example trmm
npd = TRMM3HourlyNRT(start=Date(2017,2,1),stop=Date(2017,2,1))
```
```@example trmm
typeof(npd)
```

```@example trmm
npd = TRMM3Hourly(start=Date(2017,2,1),stop=Date(2017,2,1))
```
```@example trmm
typeof(npd)
```

We see as above that whether a dataset is `EarlyNRT` or `LateNRT` or `Final` doesn't matter, it will return the same dataset type.  What changes will be the values in the fields, not the dataset structure or type itself.

## Creating a `TRMMDaily` dataset

The `TRMMDaily` dataset structure is used to contain information regarding Daily TRMM datasets.  There are two functions that create `TRMMDaily` datasets
* `TRMMDailyNRT`, which is used to retrieve Near Real-Time runs
* `TRMMDaily`, which is used to retrieve the Final post-processing runs

```@example trmm
npd = TRMMDailyNRT(start=Date(2017,2,5),stop=Date(2017,2,5))
```
```@example trmm
typeof(npd)
```

!!! info
    Notice here, that `npd.start` and `npd.stop` define the whole month of Feb 2017, as, for efficiency purposes, `TRMMDaily` datasets are designed to select data by entire months.

## Creating a `TRMMMonthly` dataset

The `TRMMMonthly` dataset structure is used to contain information regarding Monthly TRMM datasets.  The function used to create `TRMMMonthly` datasets is
* `TRMMMonthly`, which is used to retrieve the Final post-processing runs

```@example trmm
npd = TRMMMonthly(start=Date(2017,6,1),stop=Date(2017,8,15))
```
```@example trmm
typeof(npd)
```

!!! info
    Notice here, that `npd.start` and `npd.stop` define the whole year of 2017, as, for efficiency purposes, `TRMMMonthly` datasets are designed to select data by entire years.