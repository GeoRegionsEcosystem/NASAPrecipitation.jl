"""
    read(
        npd :: NASAPrecipitationDataset,
        geo :: GeoRegion,
        dt  :: TimeType;
        lonlat :: Bool = false
    ) -> NCDataset           (if lonlat = false)
      -> lon, lat, NCDataset (if lonlat = true)

Reads a NASA Precipitation dataset specified by `npd` for a GeoRegion specified by `geo` at a date specified by `dt`.

Arguments
=========
- `npd` : a `NASAPrecipitationDataset` specifying the dataset details and date download range
- `geo` : a `GeoRegion` (see [GeoRegions.jl](https://github.com/JuliaClimate/GeoRegions.jl)) that sets the geographic bounds of the data array in lon-lat
- `dt`  : A specified date. The NCDataset retrieved may will contain data for the date, although it may also contain data for other dates depending on the `NASAPrecipitationDataset` specified by `npd`

Keyword Arguments
=================
- `lonlat` : if `true`, then return the longitude and latitude vectors for the dataset. Otherwise only the NCDataset type will be returned.
"""
function read(
	npd :: NASAPrecipitationDataset,
	geo :: GeoRegion,
    dt  :: TimeType;
    lonlat :: Bool = false
)

    pnc = npdfnc(npd,geo,dt)
    if !isfile(pnc)
        error("$(modulelog()) - The $(npd.lname) Dataset for the $(geo.regID) GeoRegion at Date $dt does not exist at $(pnc).  Check if files exist at $(npd.datapath) or download the files here")
    end
    @info "$(modulelog()) - Opening the $(npd.lname) NCDataset in the $(geo.regID) GeoRegion for $dt"
    pds = NCDataset(pnc)
    
    if !lonlat
          return pds
    else; return pds, pds["longitude"][:], pds["latitude"][:]
    end

end