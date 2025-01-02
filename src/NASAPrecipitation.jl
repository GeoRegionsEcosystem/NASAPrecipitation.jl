module NASAPrecipitation

## Modules Used
using Logging
using NetRC
using Printf
using Statistics
using RegionGrids

import Base: download, show, read
import LandSea: getLandSea

## Reexporting exported functions within these modules
using Reexport
@reexport using Dates
@reexport using GeoRegions
@reexport using LandSea
@reexport using NCDatasets

## Exporting the following functions:
export
        IMERGFinalHH, IMERGLateHH, IMERGEarlyHH,
        IMERGFinalDY, IMERGLateDY, IMERGEarlyDY,
        IMERGMonthly,

        TRMM3Hourly, TRMM3HourlyNRT,
        TRMMDaily,   TRMMDailyNRT,
        TRMMMonthly,

        IMERGDummy, TRMMDummy,

        getLandSea, addNPDGeoRegions,

        download, read, npdfnc, setup, extract, smoothing

## Abstract types
"""
    NASAPrecipitationDataset{ST<:AbstractString, DT<:TimeType}
        ID    :: ST
        name  :: ST
        doi   :: ST
        start :: DT
        stop  :: DT
        datapath :: ST
        maskpath :: ST
        hroot :: ST
        fpref :: ST
        fsuff :: ST
    end

Abstract supertype for NASA Precipitation datasets on NASA OPeNDAP Servers.

Fields:
* `ID`    : ID for the `NASAPrecipitationDataset`, used in determining containing folders and filenames of the NetCDF
* `name`  : The name describing the `NASAPrecipitationDataset`, used mostly in Logging
* `doi`   : The DOI identifier, to be saved into the NetCDF
* `start` : The start date (Y,M,D) of our download / analysis
* `stop`  : The end date (Y,M,D) of our download / analysis
* `datapath` : The directory in which to save our downloads and analysis files to
* `maskpath` : The directory in which to save our corresponding landsea mask datasets
* `hroot` : The URL of the NASA's EOSDIS OPeNDAP server for which this dataset is stored
* `fpref` : The prefix component of the NetCDF files to be downloaded
* `fsuff` : The suffix component of the NetCDF files to be downloaded

Of these fields, only `start`, `stop`, `datapath` and `maskpath` are user-defined.  All other fields are predetermined depending on the type of NASA Precipitation Dataset called.
"""
abstract type NASAPrecipitationDataset end

"""
    IMERGDataset <: NASAPrecipitationDataset

Abstract supertype for GPM IMERG datasets on NASA OPeNDAP Servers, a subType of `NASAPrecipitationDataset`.
"""
abstract type IMERGDataset <: NASAPrecipitationDataset end

"""
    TRMMDataset <: NASAPrecipitationDataset

Abstract supertype for TRMM TMPA datasets on NASA OPeNDAP Servers, a subType of `NASAPrecipitationDataset`.
"""
abstract type TRMMDataset  <: NASAPrecipitationDataset end

modulelog() = "$(now()) - NASAPrecipitation.jl"
npddir = joinpath(@__DIR__,"files")

function __init__()
    setup()
end

## Including Relevant Files

include("setup.jl")

include("datasets/imerghh.jl")
include("datasets/imergdy.jl")
include("datasets/imergmo.jl")
include("datasets/trmm3hr.jl")
include("datasets/trmmdy.jl")
include("datasets/trmmmo.jl")
include("datasets/dummy.jl")

include("landsea/imerg.jl")
include("landsea/trmm.jl")

include("downloads.jl")
include("save.jl")
include("read.jl")
include("extract.jl")
include("smoothing.jl")
include("filesystem.jl")
include("backend.jl")

end
