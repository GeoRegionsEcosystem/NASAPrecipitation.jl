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
        IMERGFinalMO,
        getimerglsm, gettrmmlsm,
        download

## Abstract types
"""
    NASAServer

Abstract supertype for NASA Precipitation datasets on NASA Servers.
"""
abstract type IMERGDataset end
abstract type IMERGHalfHour <: IMERGDataset end
abstract type IMERGDaily    <: IMERGDataset end
abstract type IMERGMonthly  <: IMERGDataset end


## Including Relevant Files

include("IMERGFinalHH.jl")
include("IMERGLateHH.jl")
include("IMERGEarlyHH.jl")
include("IMERGFinalDY.jl")
include("IMERGLateDY.jl")
include("IMERGEarlyDY.jl")
include("IMERGFinalMO.jl")
include("IMERGLandSeaMask.jl")
include("TRMMLandSeaMask.jl")
include("backend.jl")

end
