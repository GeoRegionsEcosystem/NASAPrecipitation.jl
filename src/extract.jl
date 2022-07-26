function extract(
    npd :: NASAPrecipitationDataset,
	geo :: GeoRegion,
)

    @info "$(modulelog()) - Retrieving GeoRegion and LandSea Dataset information for the parent GeoRegion of \"$(geo.regID)\", \"$(geo.parID)\""
    pgeo = GeoRegion(geo.parID)
    plsd = extract_LandSea(pgeo,npd)
    plon = plsd.lon
    plat = plsd.lat

    @info "$(modulelog()) - Creating RegionGrid for \"$(geo.regID)\" based on the longitude and latitude vectors of the parent GeoRegion \"$(geo.parID)\""

    rinfo = RegionGrid(geo,plon,plat)
    ilon  = rinfo.ilon; nlon = length(ilon)
    ilat  = rinfo.ilat; nlat = length(ilat)
    if typeof(rinfo) <: PolyGrid
          mask = rinfo.mask
    else; mask = ones(nlon,nlat)
    end
    
    rmat,pmat = extract_mat(nlon,nlat,length(plon),length(plat),npd)

    for dt in extract_time(npd)

        pds  = read(npd,pgeo,dt)
        nt   = pds.dim["time"]
        tmat = @view pmat[:,:,1:nt]
        NCDatasets.load!(pds["precipitation"].var,tmat,:,:,1:nt)

        @info "$(modulelog()) - Extracting the $(npd.lname) precipitation data in $(geo.name) GeoRegion from the $(pgeo.name) GeoRegion for $(year(dt)) $(Dates.monthname(dt))"

        for it = 1 : nt, i_ilat = 1 : nlat, i_ilon = 1 : nlon

            if isone(mask[i_ilon,i_ilat])
                  rmat[i_ilon,i_ilat,it] = tmat[ilon[i_ilon],ilat[i_ilat],it]
            else; rmat[i_ilon,i_ilat,it] = NaN32
            end

        end

        close(pds)

        save(view(rmat,:,:,1:nt),dt,npd,geo,rinfo)

    end

end

extract_time(npd::Union{IMERGHalfHourly,TRMM3Hourly}) = npd.start :  Day(1)  : npd.stop
extract_time(npd::Union{IMERGDaily,TRMMDaily})        = npd.start : Month(1) : npd.stop
extract_time(npd::Union{IMERGMonthly,TRMMMonthly})    = npd.start : Year(1)  : npd.stop

function extract_mat(
    nlon :: Int, nlat :: Int, nplon :: Int, nplat :: Int,
    ::IMERGHalfHourly
)

    return zeros(Float32,nlon,nlat,48), zeros(Float32,nplon,nplat,48)

end

function extract_mat(
    nlon :: Int, nlat :: Int, nplon :: Int, nplat :: Int,
    ::TRMM3Hourly
)

    return zeros(Float32,nlon,nlat,8), zeros(Float32,nplon,nplat,8)

end

function extract_mat(
    nlon :: Int, nlat :: Int, nplon :: Int, nplat :: Int,
    ::Union{IMERGDaily,TRMMDaily}
)

    return zeros(Float32,nlon,nlat,31), zeros(Float32,nplon,nplat,31)

end

function extract_mat(
    nlon :: Int, nlat :: Int, nplon :: Int, nplat :: Int,
    ::Union{IMERGMonthly,TRMMMonthly}
)

    return zeros(Float32,nlon,nlat,12), zeros(Float32,nplon,nplat,12)

end

extract_LandSea(geo::GeoRegion, npd::IMERGDataset) = getIMERGlsd(geo,path=npd.maskpath)
extract_LandSea(geo::GeoRegion, npd::TRMMDataset)  = getTRMMlsd( geo,path=npd.maskpath)