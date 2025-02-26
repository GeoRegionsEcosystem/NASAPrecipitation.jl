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
- `geo` : a `GeoRegion` (see [GeoRegions.jl](https://github.com/GeoRegionsEcosystem/GeoRegions.jl)) that sets the geographic bounds of the data array in lon-lat
- `dt`  : A specified date. The NCDataset retrieved may will contain data for the date, although it may also contain data for other dates depending on the `NASAPrecipitationDataset` specified by `npd`
"""
function npdfnc(
    npd :: Union{IMERGHalfHourly{ST,DT},TRMM3Hourly{ST,DT}},
	geo :: GeoRegion,
    dt  :: TimeType
) where {ST<:AbstractString, DT<:TimeType}

    fol = joinpath(npd.datapath,geo.ID,yrmo2dir(dt))
    fnc = npd.ID * "-" * geo.ID * "-" * ymd2str(dt) * ".nc"
    return joinpath(fol,fnc)

end

function npdfnc(
    npd :: Union{IMERGDaily{ST,DT},TRMMDaily{ST,DT}},
	geo :: GeoRegion,
    dt  :: TimeType
) where {ST<:AbstractString, DT<:TimeType}

    fol = joinpath(npd.datapath,geo.ID,yr2str(dt))
    fnc = npd.ID * "-" * geo.ID * "-" * yrmo2str(dt) * ".nc"
    return joinpath(fol,fnc)

end

function npdfnc(
    npd :: Union{IMERGMonthly{ST,DT},TRMMMonthly{ST,DT}},
	geo :: GeoRegion,
    dt  :: TimeType
) where {ST<:AbstractString, DT<:TimeType}

    fol = joinpath(npd.datapath,geo.ID)
    fnc = npd.ID * "-" * geo.ID * "-" * yr2str(dt) * ".nc"
    return joinpath(fol,fnc)

end

####

function npdanc(
    npd :: Union{IMERGHalfHourly{ST,DT},TRMM3Hourly{ST,DT},IMERGDaily{ST,DT},TRMMDaily{ST,DT}},
	geo :: GeoRegion,
    dt  :: TimeType
) where {ST<:AbstractString, DT<:TimeType}

    fol = joinpath(npd.datapath,geo.ID)
    fnc = npd.ID * "-" * geo.ID * "-" * yr2str(dt) * ".nc"
    return joinpath(fol,fnc)

end

####

function npdsmth(
    npd :: Union{IMERGHalfHourly{ST,DT},TRMM3Hourly{ST,DT}},
	geo :: GeoRegion,
    dt  :: TimeType,
    smoothlon  :: Real,
    smoothlat  :: Real,
    smoothtime :: Int
) where {ST<:AbstractString, DT<:TimeType}

    fol = joinpath(npd.datapath,geo.ID,yrmo2dir(dt))
    fnc = npd.ID * "-" * geo.ID * "-" * "smooth" * "_" *
          @sprintf("%.2f",smoothlon) * "x" * @sprintf("%.2f",smoothlat) *
          "_" * @sprintf("%02d",smoothtime) * "steps" *
          "-" * ymd2str(dt) * ".nc"
    return joinpath(fol,fnc)

end

function npdsmth(
    npd :: Union{IMERGDaily{ST,DT},TRMMDaily{ST,DT}},
	geo :: GeoRegion,
    dt  :: TimeType,
    smoothlon  :: Real,
    smoothlat  :: Real,
    smoothtime :: Int
) where {ST<:AbstractString, DT<:TimeType}

    fol = joinpath(npd.datapath,geo.ID,yr2str(dt))
    fnc = npd.ID * "-" * geo.ID * "-" * "smooth" * "_" *
          @sprintf("%.2f",smoothlon) * "x" * @sprintf("%.2f",smoothlat) *
          "_" * @sprintf("%02d",smoothtime) * "steps" *
          "-" * yrmo2str(dt) * ".nc"
    return joinpath(fol,fnc)

end

function npdsmth(
    npd :: Union{IMERGMonthly{ST,DT},TRMMMonthly{ST,DT}},
	geo :: GeoRegion,
    dt  :: TimeType,
    smoothlon  :: Real,
    smoothlat  :: Real,
    smoothtime :: Int
) where {ST<:AbstractString, DT<:TimeType}

    fol = joinpath(npd.datapath,geo.ID)
    fnc = npd.ID * "-" * geo.ID * "-" * "smooth" * "_" *
          @sprintf("%.2f",smoothlon) * "x" * @sprintf("%.2f",smoothlat) *
          "_" * @sprintf("%02d",smoothtime) * "steps" *
          "-" * yr2str(dt) * ".nc"
    return joinpath(fol,fnc)

end