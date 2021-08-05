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
        IMERGFinalMO
        download

## Abstract types
"""
    NASAServer

Abstract supertype for NASA Precipitation datasets on NASA Servers.
"""
abstract type GPMDataset end

abstract type RawGPMDataset     <: GPMDataset end

abstract type MonthlyGPMDataset <: GPMDataset end

## Including Relevant Files

include("IMERGFinalHH.jl")
include("IMERGLateHH.jl")
include("IMERGEarlyHH.jl")
include("IMERGFinalDY.jl")
include("IMERGLateDY.jl")
include("IMERGEarlyDY.jl")
include("IMERGFinalMO.jl")
include("LandSeaMask.jl")
include("backend.jl")

end
