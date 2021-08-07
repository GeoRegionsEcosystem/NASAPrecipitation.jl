# TRMM TMPA Datasets

TRMM TMPA Datasets are represented by the `TRMMDataset` AbstractType, which in itself is broken into the `TRMM3Hourly`, `TRMMDaily` and `TRMMMonthly` Types.  For 3-hourly and daily datsets, NASA provides not just the output from the final processing run, but also near real-time runs.

The Types that each dataset calls are listed below, along with their function calls.

|          |    `Type`     |   Near Real-Time   |      Final      |
| :------: | :-----------: | :----------------: | :-------------: |
|  3 Hour  | `TRMM3Hourly` | `TRMM3HourlyNRT()` | `TRMM3Hourly()` |
|   Daily  |  `TRMMDaily`  |  `TRMMDailyNRT()`  |  `TRMMDaily()`  |
|  Monthly | `TRMMMonthly` |                    | `TRMMMonthly()` |

So, for example, if we wanted to get the the Near Real-Time TRMM 3-Hourly dataset, we would call the function `TRMM3HourlyNRT`, which would return a `TRMM3Hourly` data structure (see example at the end of the page).
