# An Overview of the NASA Precipitation Datasets

A NASA Precipitation Dataset is defined to be a dataset from the NASA Global Precipitation Measurement (GPM) Mission.  As of now, this package supports the following **Level 3** products:
* **GPM IMERGv6**, 0.1º resolution, 60ºS to 60ºN
  * Final runs for Half-Hourly, Daily and Monthly Data
  * Early and Late runs of Half-Hourly and Daily Data
* **TRMM TMPAv7**, 0.25º resolution, 50ºS to 50ºN
  * Final runs for 3-Hourly, Daily and Monthly Data
  * Near Real-Time runs of 3-Hourly and Daily Data

The `NASAPrecipitationDataset` AbstractType is meant as an overarching type container for information that identifies various NASA Precipitation Datasets.  The `NASAPrecipitationDataset` Type has two sub-Types:
* The `IMERGDataset` for the GPM IMERG Dataset
* The `TRMMDataset` for the TRMM TMPA Dataset

Each of these Abstract superTypes has its own set of Types.  See the summary table below for an overview, and the respective pages for [GPM IMERG](imerg.md) and [TRMM TMPA](trmm.md) for more information.

```@docs
NASAPrecipitation.NASAPrecipitationDataset
NASAPrecipitation.IMERGDataset
NASAPrecipitation.TRMMDataset
```

All subTypes of the `NASAPrecipitationDataset` have the same basic fields and structure.

## Summary Table

|                 |  `SuperType`   |       `Type`      |    Early NRT     |     (Late) NRT     |    Final NRT     |
| :-------------: | :------------: | :---------------: | :--------------: | :----------------: | :--------------: |
|  IMERG 30 Mins  | `IMERGDataset` | `IMERGHalfHourly` | `IMERGEarlyHH()` |  `IMERGLateHH()`   | `IMERGFinalHH()` |
|   IMERG Daily   | `IMERGDataset` |    `IMERGDaily`   | `IMERGEarlyDY()` |  `IMERGLateDY()`   | `IMERGFinalDY()` |
|  IMERG Monthly  | `IMERGDataset` |   `IMERGMonthly`  |                  |                    | `IMERGMonthly()` |
|   TRMM 3 Hour   | `TRMMDataset`  |   `TRMM3Hourly`   |                  | `TRMM3HourlyNRT()` |  `TRMM3Hourly()` |
|   TRMM Daily    | `TRMMDataset`  |    `TRMMDaily`    |                  |  `TRMMDailyNRT()`  |   `TRMMDaily()`  |
|  TRMM Monthly   | `TRMMDataset`  |   `TRMMMonthly`   |                  |                    |  `TRMMMonthly()` |