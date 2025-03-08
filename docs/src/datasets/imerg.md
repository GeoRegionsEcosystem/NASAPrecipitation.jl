# GPM IMERG Datasets

GPM IMERG Datasets are represented by the `IMERGDataset` AbstractType, which in itself is broken into the `IMERGHalfHourly`, `IMERGDaily` and `IMERGMonthly` Types.  For half-hourly and daily datsets, NASA provides not just the output from the final processing run, but also early and late near real-time runs.

The Types that each dataset calls are listed below, along with their function calls.

|           |       `Type`      |    Early NRT     |    Late NRT     |    Final NRT     |
| :-------: | :---------------: | :--------------: | :-------------: | :--------------: |
|  30 Mins  | `IMERGHalfHourly` | `IMERGEarlyHH()` | `IMERGLateHH()` | `IMERGFinalHH()` |
|   Daily   |    `IMERGDaily`   | `IMERGEarlyDY()` | `IMERGLateDY()` | `IMERGFinalDY()` |
|  Monthly  |   `IMERGMonthly`  |                  |                 | `IMERGMonthly()` |

So, for example, if we wanted to get the the Early Near Real-Time IMERG Half-Hourly dataset, we would call the function `IMERGEarlyHH`, which would return a `IMERGHalfHourly` data structure (see example at the end of the page).

### Setup
```@example imerg
using NASAPrecipitation
```

## `IMERGDataset` Types / Objects

There are three different Types of `IMERGDataset`:
* `IMERGHalfHourly`, which is used to contain information on half-hourly GPM IMERG datasets
* `IMERGDaily`, which is used to contain information on daily GPM IMERG datasets
* `IMERGMonthly`, which is used to contain information on monthly GPM IMERG datasets

## Creating an `IMERGHalfHourly` dataset

The `IMERGHalfHourly` dataset structure is used to contain information regarding half-hourly IMERG datasets.  There are three functions that create `IMERGHalfHourly` datasets
* `IMERGEarlyHH`, which is used to retrieve Near Real-Time Early runs
* `IMERGLateHH`, which is used to retrieve Near Real-Time Late runs
* `IMERGFinalHH`, which is used to retrieve the Final post-processing runs

First, let's define an "Early" dataset:

```@example imerg
npd = IMERGEarlyHH(start=DateTime(2017,2,1,15,30,0),stop=Date(2017,2,4))
```
```@example imerg
typeof(npd)
```

Now let's define a "Late" dataset:

```@example imerg
npd = IMERGLateHH(start=Date(2017,2,1),stop=Date(2017,2,3))
```
```@example imerg
typeof(npd)
```

By comparing the two, we see as above that whether a dataset is "Early", "Late" or "Final" doesn't matter, it will return the same subtype of the NASAPrecipitationDataset. What changes will be the values in the fields, not the dataset structure or type itself.

!!! warning
    `IMERGHalfHourly` datasets are designed to select data by entire days, and so here `npd.start` and `npd.stop` are defined by the entire days for which data is downloaded.

## Creating an `IMERGDaily` dataset

The `IMERGDaily` dataset structure is used to contain information regarding daily IMERG datasets.  There are three functions that create `IMERGDaily` datasets
* `IMERGEarlyDY`, which is used to retrieve Near Real-Time Early runs
* `IMERGLateDY`, which is used to retrieve Near Real-Time Late runs
* `IMERGFinalDY`, which is used to retrieve the Final post-processing runs

```@example imerg
npd = IMERGFinalDY(start=Date(2017,2,5),stop=Date(2017,2,9))
```
```@example imerg
typeof(npd)
```

!!! warning
    `IMERGDaily` datasets are designed to select data by entire months, and so here `npd.start` and `npd.stop` define the whole month of Feb 2017.

## Creating an `IMERGMonthly` dataset

The `IMERGMonthly` dataset structure is used to contain information monthly daily IMERG datasets.  There is only one functions that creates `IMERGMonthly` datasets
* `IMERGMonthly`, which is used to retrieve the Final post-processing runs

```@example imerg
npd = IMERGMonthly(start=Date(2017,6,1),stop=Date(2017,8,15))
```
```@example imerg
typeof(npd)
```

!!! warning
    `IMERGMonthly` datasets are designed to select data by entire years, and so here `npd.start` and `npd.stop` define the whole year of 2017.
