"""
    npdfnc(
        npd :: NASAPrecipitationDataset,
        geo :: GeoRegion,
        dt  :: TimeType
    ) -> String

Returns of the path of the file for the NASA Precipitation dataset specified by `npd` for a GeoRegion specified by `geo` at a date specified by `dt`.

Arguments
=========
- `npd` : a `NASAPrecipitationDataset` specifying the dataset details and date download range
- `geo` : a `GeoRegion` (see [GeoRegions.jl](https://github.com/JuliaClimate/GeoRegions.jl)) that sets the geographic bounds of the data array in lon-lat
- `dt`  : A specified date. The NCDataset retrieved may will contain data for the date, although it may also contain data for other dates depending on the `NASAPrecipitationDataset` specified by `npd`
"""
function npdfnc(
    npd :: Union{IMERGHalfHourly{ST,DT},TRMM3Hourly{ST,DT}},
	geo :: GeoRegion,
    dt  :: TimeType
) where {ST<:AbstractString, DT<:TimeType}

    fol = joinpath(npd.datapath,geo.regID,yrmo2dir(dt))
    fnc = npd.npdID * "-" * geo.regID * "-" * ymd2str(dt) * ".nc"
    return joinpath(fol,fnc)

end

function npdfnc(
    npd :: Union{IMERGDaily{ST,DT},TRMMDaily{ST,DT}},
	geo :: GeoRegion,
    dt  :: TimeType
) where {ST<:AbstractString, DT<:TimeType}

    fol = joinpath(npd.datapath,geo.regID,yr2str(dt))
    fnc = npd.npdID * "-" * geo.regID * "-" * yrmo2str(dt) * ".nc"
    return joinpath(fol,fnc)

end

function npdfnc(
    npd :: Union{IMERGMonthly{ST,DT},TRMMMonthly{ST,DT}},
	geo :: GeoRegion,
    dt  :: TimeType
) where {ST<:AbstractString, DT<:TimeType}

    fol = joinpath(npd.datapath,geo.regID)
    fnc = npd.npdID * "-" * geo.regID * "-" * yr2str(dt) * ".nc"
    return joinpath(fol,fnc)

end

####

function npdanc(
    npd :: Union{IMERGHalfHourly{ST,DT},TRMM3Hourly{ST,DT},IMERGDaily{ST,DT},TRMMDaily{ST,DT}},
	geo :: GeoRegion,
    dt  :: TimeType
) where {ST<:AbstractString, DT<:TimeType}

    fol = joinpath(npd.datapath,geo.regID)
    fnc = npd.npdID * "-" * geo.regID * "-" * yr2str(dt) * ".nc"
    return joinpath(fol,fnc)

end