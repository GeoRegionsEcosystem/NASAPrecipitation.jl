function extract(
    npd :: NASAPrecipitationDataset,
	geo :: GeoRegion,
)

    @info "$(modulelog()) - Retrieving GeoRegion and LandSea Dataset information for the parent GeoRegion of \"$(geo.regID)\", \"$(geo.parID)\""
    pgeo = GeoRegion(geo.parID)
    plsd = getLandSea(npd,pgeo)
    rlsd = getLandSea(npd,geo)
    plon = plsd.lon
    plat = plsd.lat

    @info "$(modulelog()) - Creating RegionGrid for \"$(geo.regID)\" based on the longitude and latitude vectors of the parent GeoRegion \"$(ereg.geo.parID)\""

    rinfo = RegionGrid(geo,plon,plat)
    ilon  = rinfo.ilon; nlon = length(ilon)
    ilat  = rinfo.ilat; nlat = length(ilat)
    if typeof(rinfo) <: PolyGrid
          mask = rinfo.mask
    else; mask = ones(nlon,nlat)
    end
    
    if typeof(npd) <: IMERGHalfHourly
        rmat = zeros(Float32,nlon,nlat,48)
    elseif typeof(npd) <: TRMM3Hourly
        rmat = zeros(Float32,nlon,nlat,8)
    elseif typeof(npd) <: Union{IMERGDaily,TRMMDaily}
        rmat = zeros(Float32,nlon,nlat,31)
    else
        rmat = zeros(Float32,nlon,nlat,12)
    end

    for dt in extract_time(npd)

        pds  = read(npd,pgeo,dt)
        pmat = nomissing(pds["prcp_rate"][:],NaN)
        nt   = size(pmat,3)

        @info "$(modulelog()) - Extracting the $(npd.lname) precipitation data in $(geo.name) GeoRegion from the $(pgeo.name) GeoRegion for $(year(dt)) $(Dates.monthname(dt))"

        for it = 1 : nt, i_ilat = 1 : nlat, i_ilon = 1 : nlon

            if isone(mask[i_ilon,i_ilat])
                  rmat[i_ilon,i_ilat,it] = pmat[ilon[i_ilon],ilat[i_ilat],it]
            else; rmat[i_ilon,i_ilat,it] = NaN32
            end

        end

        close(pds)

        save(view(rmat,:,:,1:nt),dt,npd,geo,rlsd)

    end

end

extract_time(npd::Union{IMERGHalfHourly,TRMM3Hourly}) = npd.dtbeg :  Day(1)  : npd.dtend
extract_time(npd::Union{IMERGDaily,TRMMDaily})        = npd.dtbeg : Month(1) : npd.dtend
extract_time(npd::Union{IMERGMonthly,TRMMMonthly})    = npd.dtbeg : Year(1)  : npd.dtend