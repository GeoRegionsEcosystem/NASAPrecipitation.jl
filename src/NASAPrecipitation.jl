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
        getIMERGlsm, getTRMMlsm,
        download

## Abstract types
"""
    IMERGDataset

Abstract supertype for GPM IMERG datasets on NASA OPeNDAP Servers.
"""
abstract type IMERGDataset end


## Including Relevant Files

include("IMERGHalfHourly.jl")
include("IMERGDaily.jl")
include("IMERGMonthly.jl")
include("IMERGLandSeaMask.jl")
include("TRMMLandSeaMask.jl")
include("backend.jl")

end
