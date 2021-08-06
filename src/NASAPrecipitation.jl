module NASAPrecipitation

## Modules Used
using Dates
using GeoRegions
using Logging
using NCDatasets
using Printf
using Statistics

import Base: download, show

## Exporting the following functions:
export
        IMERGFinalHH, IMERGLateHH, IMERGEarlyHH,
        IMERGFinalDY, IMERGLateDY, IMERGEarlyDY,
        IMERGMonthly,

        TRMM3Hourly, TRMM3HourlyNRT,
        TRMMDaily,   TRMMDailyNRT,
        TRMMMonthly,

        getIMERGlsm, getTRMMlsm,
        download

## Abstract types
"""
    NASAPrecipitationDataset

Abstract supertype for NASA Precipitation datasets on NASA OPeNDAP Servers.
"""
abstract type NASAPrecipitationDataset end

"""
    IMERGDataset <: NASAPrecipitationDataset

Abstract supertype for GPM IMERG datasets on NASA OPeNDAP Servers, a subType of NASAPrecipitationDataset.
"""
abstract type IMERGDataset <: NASAPrecipitationDataset end

"""
    TRMMDataset <: NASAPrecipitationDataset

Abstract supertype for TRMM TMPA datasets on NASA OPeNDAP Servers, a subType of NASAPrecipitationDataset.
"""
abstract type TRMMDataset  <: NASAPrecipitationDataset end

## Including Relevant Files

include("IMERG/halfhourly.jl")
include("IMERG/daily.jl")
include("IMERG/monthly.jl")
include("IMERG/landseamask.jl")

include("TRMM/3hourly.jl")
include("TRMM/daily.jl")
include("TRMM/monthly.jl")
include("TRMM/landseamask.jl")

include("downloads.jl")
include("save.jl")
include("backend.jl")

end
