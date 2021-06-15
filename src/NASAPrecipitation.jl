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
        IMERGFinalRaw, download

## Abstract types
"""
    NASAServer

Abstract supertype for NASA Precipitation datasets on NASA Servers.
"""
abstract type GPMDataset end

abstract type RawGPMDataset     <: GPMDataset end

abstract type MonthlyGPMDataset <: GPMDataset end

## Including Relevant Files

include("IMERGFinal.jl")
include("backend.jl")

end
