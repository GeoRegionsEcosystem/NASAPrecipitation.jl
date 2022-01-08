"""
    download(
        npd :: NASAPrecipitationDataset,
        geo :: GeoRegion = GeoRegion("GLB"),
        dt  :: TimeType;
        lonlat :: Bool = false
    ) -> NCDataset

Reads a NASA Precipitation dataset specified by `npd` for a GeoRegion specified by `geo` at a date specified by `dt`.

Arguments
=========
- `npd` : a `NASAPrecipitationDataset` specifying the dataset details and date download range
- `geo` : a `GeoRegion` (see [GeoRegions.jl](https://github.com/JuliaClimate/GeoRegions.jl)) that sets the geographic bounds of the data array in lon-lat
- `dt`  : A specified date. The NCDataset retrieved may will contain data for the date, although it may also contain data for other dates depending on the `NASAPrecipitationDataset` specified by `npd`
"""
function read(
	npd :: IMERGHalfHourly{ST,DT},
	geo :: GeoRegion,
    dt  :: TimeType;
    lonlat :: Bool = false
) where {ST<:AbstractString, DT<:TimeType}

    pnc = npdfnc(npd,geo,dt)
    if !isfile(pnc)
        error("$(modulelog()) - The $(npd.lname) Dataset for the $(geo.regID) GeoRegion at Date $dt does not exist at $(pnc).  Check if files exist at $(npd.sroot) or download the files here")
    end
    @info "$(modulelog()) - Opening the $(npd.lname) NCDataset in the $(geo.regID) GeoRegion for $dt"
    pds = NCDataset(pnc)
    
    if !lonlat
          return pds
    else; return pds, pds["longitude"][:], pds["latitude"][:]
    end

end

function npdfnc(
    npd :: Union{IMERGHalfHourly{ST,DT},TRMM3Hourly{ST,DT}},
	geo :: GeoRegion,
    dt  :: TimeType
) where {ST<:AbstractString, DT<:TimeType}

    fol = joinpath(npd.sroot,geo.regID,"raw",yrmo2dir(dt))
    fnc = npd.npdID * "-" * geo.regID * "-" * ymd2str(dt) * ".nc"
    return joinpath(fol,fnc)

end

function npdfnc(
    npd :: Union{IMERGDaily{ST,DT},TRMMDaily{ST,DT}},
	geo :: GeoRegion,
    dt  :: TimeType
) where {ST<:AbstractString, DT<:TimeType}

    fol = joinpath(npd.sroot,geo.regID,"raw",yr2str(dt))
    fnc = npd.npdID * "-" * geo.regID * "-" * yrmo2str(dt) * ".nc"
    return joinpath(fol,fnc)

end

function npdfnc(
    npd :: Union{IMERGMonthly{ST,DT},TRMMMonthly{ST,DT}},
	geo :: GeoRegion,
    dt  :: TimeType
) where {ST<:AbstractString, DT<:TimeType}

    fol = joinpath(npd.sroot,geo.regID,"raw")
    fnc = npd.npdID * "-" * geo.regID * "-" * yr2str(dt) * ".nc"
    return joinpath(fol,fnc)

end