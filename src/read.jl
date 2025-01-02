"""
    read(
        npd :: NASAPrecipitationDataset,
        geo :: GeoRegion,
        dt  :: TimeType;
        smooth   :: Bool = false,
        smoothlon  :: Real = 0,
        smoothlat  :: Real = 0,
        smoothtime :: Real = 0,
        quiet  :: Bool = false
    ) -> NCDataset

Reads a NASA Precipitation dataset specified by `npd` for a GeoRegion specified by `geo` at a date specified by `dt`.

Arguments
=========
- `npd` : a `NASAPrecipitationDataset` specifying the dataset details and date download range
- `geo` : a `GeoRegion` (see [GeoRegions.jl](https://github.com/GeoRegionsEcosystem/GeoRegions.jl)) that sets the geographic bounds of the data array in lon-lat
- `dt`  : A specified date. The NCDataset retrieved may will contain data for the date, although it may also contain data for other dates depending on the `NASAPrecipitationDataset` specified by `npd`

Keyword Arguments
=================
- `smooth` :
- `smoothlon` :
- `smoothlat` :
- `smoothtime` :
- `quiet` : 
"""
function read(
	npd :: NASAPrecipitationDataset,
	geo :: GeoRegion,
    dt  :: TimeType;
    smooth   :: Bool = false,
    smoothlon  :: Real = 0,
    smoothlat  :: Real = 0,
    smoothtime :: Real = 0,
    quiet  :: Bool = false
)

    pnc = npdfnc(npd,geo,dt)

    raw = true
    if smooth
        if iszero(smoothlon) && iszero(smoothlat) && iszero(smoothtime)
            error("$(modulelog()) - Incomplete specification of smoothing parameters in either the longitude or latitude directions")
        end
        pnc = npdsmth(npd,geo,dt,smoothlon,smoothlat,smoothtime)
        raw = false
    end

    if quiet
        disable_logging(Logging.Warn)
    end

    if raw
        if !isfile(pnc)
            error("$(modulelog()) - The $(npd.name) Dataset for the $(geo.ID) GeoRegion at Date $dt does not exist at $(pnc).  Check if files exist at $(npd.datapath) or download the files here")
        end
        @info "$(modulelog()) - Opening the $(npd.name) NCDataset in the $(geo.ID) GeoRegion for $dt"
    end
    if smooth
        if !isfile(pnc)
            error("$(modulelog()) - The spatially smoothed ($(@sprintf("%.2f",smoothlon))x$(@sprintf("%.2f",smoothlat))) $(npd.name) Dataset for $(geo.ID) GeoRegion at Date $dt does not exist at $(pnc).  Check if files exist at $(npd.datapath) or download the files here")
        end
        @info "$(modulelog()) - Opening the spatialtemporally smoothed ($(@sprintf("%.2f",smoothlon))ºx$(@sprintf("%.2f",smoothlat))º, $(@sprintf("%02d",smoothtime)) timesteps) $(npd.name) NCDataset in the $(geo.ID) GeoRegion for $dt"
    end

    if quiet
        disable_logging(Logging.Debug)
    end

    flush(stderr)
    
    return NCDataset(pnc)

end