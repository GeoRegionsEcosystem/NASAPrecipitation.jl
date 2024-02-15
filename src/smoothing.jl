function calculatebufferweights(shiftsteps)

    buffer = Int(ceil((shiftsteps-1)/2))
    weights = ones(buffer*2+1)
    if buffer >= (shiftsteps/2)
        weights[1] = 0.5
        weights[end] = 0.5
    end
    weights /= shiftsteps
    return buffer,weights

end

function smoothing(
    npd :: IMERGHalfHourly,
	geo :: GeoRegion;
    spatial  :: Bool = false,
    temporal :: Bool = false,
    hours :: Int = 0,
    smoothlon :: Real = 0,
    smoothlat :: Real = 0,
    verbose :: Bool = false
)

    if !spatial && !temporal
        error("$(modulelog()) - You need to specify at least one of the `spatial` and `temporal` keyword arguments as true")
    end

    if !spatial  && !iszero(smoothlon); smoothlon = 0 end
    if !spatial  && !iszero(smoothlat); smoothlat = 0 end
    if !temporal && !iszero(hours);     hours     = 0 end

    if spatial && (iszero(smoothlon) && iszero(smoothlat))
        error("$(modulelog()) - Incomplete specification of smoothing parameters in either the longitude or latitude directions")
    end

    if temporal && iszero(hours)
        error("$(modulelog()) - Incomplete specification of temporal smoothing parameters")
    end

    hours *= 2

    if !isinteger(hours)
        error("$(modulelog()) - For temporal smoothing, we need to specify the time in half-hourly increments")
    end

    if hours > 48
        error("$(modulelog()) - Setting a hard cap to the maximum number of days that can be included in the timeaveraging to 24 hours. This may expand in the future.")
    end

    shiftlon = smoothlon/0.1; if !isinteger(shiftlon)
        error("$(modulelog()) - The variable `smoothlon` should be a integer multiple of 0.1")
    end
    shiftlat = smoothlat/0.1; if !isinteger(shiftlat)
        error("$(modulelog()) - The variable `smoothlat` should be a integer multiple of 0.1")
    end

    buffer_lon, weights_lon  = calculatebufferweights(shiftlon)
    buffer_lat, weights_lat  = calculatebufferweights(shiftlat)
    buffer_time,weights_time = calculatebufferweights(hours)

    lsd  = getLandSea(npd,geo)
    nlon = length(lsd.lon)
    nlat = length(lsd.lat)
    nhr  = 48

    @info "$(modulelog()) - Preallocating data arrays for the analysis of data in the $(geo.name) Region ..."

    tmpdata  = zeros(Float32,nlon,nlat,48+buffer_time*2)
    shftlon  = zeros(Float32,nlon,nlat,(2*buffer_lon+1))
    shftlat  = zeros(Float32,nlon,nlat,(2*buffer_lat+1))
    smthdata = zeros(Float32,nlon,nlat,48)
    nanlat   = zeros(Bool,(2*buffer_lat+1))
    nanlon   = zeros(Bool,(2*buffer_lon+1))
    smthii   = zeros(Float32,1+buffer_time*2)

    flush(stderr)

    for dt in npd.start : Month(1) : npd.stop

        ds  = read(npd,geo,dt)
        NCDatasets.load!(
            ds["precipitation"].var,
            view(tmpdata,:,:,(1:nhr).+buffer_time),
            :,:,:
        )
        close(ds)

        if temporal

            ds  = read(npd,geo,dt-Day(1))
            NCDatasets.load!(
                ds["precipitation"].var,
                view(tmpdata,:,:,(1:buffer_time)),
                :,:,:
            )
            close(ds)

            flush(stderr)

            ds  = read(npd,geo,dt+Day(1))
            NCDatasets.load!(
                ds["precipitation"].var,
                view(tmpdata,:,:,(1:buffer_time).+(nhr+buffer_time)),
                :,:,:
            )
            close(ds)

            flush(stderr)

            @info "$(modulelog()) - Performing $hours-hour temporal smoothing on $(npd.name) Precipitation Rate data in $(geo.name) during $(dt) ..."
            for ihr = 1 : nhr, ilat = 1 : nlat, ilon = 1 : nlon
                for ii = 0 : (buffer_time*2)
                    smthii[ii+1] = tmpdata[ilon,ilat,ihr+ii] * weights_time[ii+1]
                end
                smthdata[ilon,ilat,ihr] = sum(smthii)
            end

            flush(stderr)

        else

            for ihr = 1 : nhr, ilat = 1 : nlat, ilon = 1 : nlon
                smthdata[ilon,ilat,ihr] = tmpdata[ilon,ilat,ihr]
            end

            flush(stderr)

        end

        if spatial
            @info "$(modulelog()) - Performing spatial smoothing ($(@sprintf("%.2f",smoothlon))x$(@sprintf("%.2f",smoothlat))) on $(npd.name) Precipitation Rate data in $(geo.name) during $(dt) ..."
            for ihr = 1 : nhr

                if !iszero(buffer_lat)
                    ishift = 0
                    for ilat = -buffer_lat : buffer_lat
                        ishift += 1
                        circshift!(
                            view(shftlat,:,:,ishift),view(smthdata,:,:,ihr),
                            (0,ilat)
                        )
                    end
                    for ilat = 1 : nlat, ilon = 1 : nlon
                        if !isnan(tmpdata[ilon,ilat,ihr])
                            smthdata[ilon,ilat,ihr] = nanmean(
                                view(shftlat,ilon,ilat,:),nanlat,weights_lat
                            )
                        else; smthdata[ilon,ilat,ihr] = NaN32
                        end
                    end
                end

                if !iszero(buffer_lon)
                    ishift = 0
                    for ilon = -buffer_lon : buffer_lon
                        ishift += 1
                        circshift!(
                            view(shftlon,:,:,ishift),view(smthdata,:,:,ihr),
                            (ilon,0)
                        )
                    end
                    for ilat = 1 : nlat, ilon = 1 : nlon
                        if !isnan(tmpdata[ilon,ilat,ihr])
                            smthdata[ilon,ilat,ihr] = nanmean(
                                view(shftlon,ilon,ilat,:),nanlon,weights_lon
                            )
                        else; smthdata[ilon,ilat,ihr] = NaN32
                        end
                    end
                end
            end

            flush(stderr)

            if verbose
                @info "$(modulelog()) - Setting edges to NaN32 because we used cyclical circshift to do spatial smoothing, which doesn't make sense if boundaries are not periodic ..."
            end
            if !iszero(buffer_lon) && !geo.is360
                for ihr = 1 : nhr, ilat = 1 : nlat, ilon = 1 : buffer_lon
                    smthdata[ilon,ilat,ihr] = NaN32
                end
                for ihr = 1 : nhr, ilat = 1 : nlat, ilon = (nlon-buffer_lon+1) : nlon
                    smthdata[ilon,ilat,ihr] = NaN32
                end
            end
            if !iszero(buffer_lat)
                for ihr = 1 : nhr, ilat = 1 : buffer_lat, ilon = 1 : nlon
                    smthdata[ilon,ilat,ihr] = NaN32
                end
                for ihr = 1 : nhr, ilat = (nlat-buffer_lat+1) : nlat, ilon = 1 : nlon
                    smthdata[ilon,ilat,ihr] = NaN32
                end
            end

        end

        save(
            smthdata, dt, npd, geo, lsd,
            smooth=true, smoothlon=smoothlon, smoothlat=smoothlat, smoothtime=hours
        )

        flush(stderr)

    end

end

function smoothing(
    npd :: Union{IMERGDaily,TRMMDaily},
    geo :: GeoRegion;
    spatial  :: Bool = false,
    temporal :: Bool = false,
    days :: Int = 0,
    smoothlon :: Real = 0,
    smoothlat :: Real = 0,
    verbose :: Bool = false
)

    if !spatial && !temporal
        error("$(modulelog()) - You need to specify at least one of the `spatial` and `temporal` keyword arguments as true")
    end

    if !spatial  && !iszero(smoothlon); smoothlon = 0 end
    if !spatial  && !iszero(smoothlat); smoothlat = 0 end
    if !temporal && !iszero(days);      days     = 0 end

    if spatial && (iszero(smoothlon) && iszero(smoothlat))
        error("$(modulelog()) - Incomplete specification of smoothing parameters in either the longitude or latitude directions")
    end

    if temporal && iszero(days)
        error("$(modulelog()) - Incomplete specification of temporal smoothing parameters")
    end

    if days > 28
        error("$(modulelog()) - Setting a hard cap to the maximum number of days that can be included in the timeaveraging to 28 days. This may expand in the future.")
    end

    shiftlon = smoothlon/0.1; if !isinteger(shiftlon)
        error("$(modulelog()) - The variable `smoothlon` should be a integer multiple of 0.1")
    end
    shiftlat = smoothlat/0.1; if !isinteger(shiftlat)
        error("$(modulelog()) - The variable `smoothlat` should be a integer multiple of 0.1")
    end

    buffer_lon, weights_lon  = calculatebufferweights(shiftlon)
    buffer_lat, weights_lat  = calculatebufferweights(shiftlat)
    buffer_time,weights_time = calculatebufferweights(days)

    lsd  = getLandSea(npd,geo)
    nlon = length(lsd.lon)
    nlat = length(lsd.lat)

    @info "$(modulelog()) - Preallocating data arrays for the analysis of data in the $(geo.name) Region ..."

    tmpdata  = zeros(nlon,nlat,31+buffer_time*2)
    shftlon  = zeros(nlon,nlat,(2*buffer_lon+1))
    shftlat  = zeros(nlon,nlat,(2*buffer_lat+1))
    smthdata = zeros(nlon,nlat,31)
    nanlat   = zeros(Bool,(2*buffer_lat+1))
    nanlon   = zeros(Bool,(2*buffer_lon+1))
    smthii   = zeros(1+buffer_time*2)

    flush(stderr)

    for dt in npd.start : Month(1) : npd.stop

        ndy = daysinmonth(dt)
        ds  = read(npd,geo,dt+Month(1))
        NCDatasets.load!(
            ds["precipitation"].var,
            view(tmpdata,:,:,(1:ndy).+buffer_time),
            :,:,:
        )
        close(ds)

        flush(stderr)

        if temporal
            
            ds  = read(npd,geo,dt-Month(1))
            NCDatasets.load!(
                ds["precipitation"].var,
                view(tmpdata,:,:,(1:buffer_time)),
                :,:,:
            )
            close(ds)

            flush(stderr)

            ds  = read(npd,geo,dt+Month(1))
            NCDatasets.load!(
                ds["precipitation"].var,
                view(tmpdata,:,:,(1:buffer_time).+(ndy+buffer_time)),
                :,:,:
            )
            close(ds)

            flush(stderr)

            @info "$(modulelog()) - Performing $days-day temporal smoothing on $(npd.name) Precipitation Rate data in $(geo.name) during $(year(dt)) $(monthname(dt)) ..."
            for idy = 1 : ndy, ilat = 1 : nlat, ilon = 1 : nlon
                for ii = 0 : (buffer_time*2)
                    smthii[ii+1] = tmpdata[ilon,ilat,idy+ii] * weights_time[ii+1]
                end
                smthdata[ilon,ilat,idy] = sum(smthii)
            end

            flush(stderr)
        else
            for idy = 1 : ndy, ilat = 1 : nlat, ilon = 1 : nlon
                smthdata[ilon,ilat,idy] = tmpdata[ilon,ilat,idy]
            end

            flush(stderr)
        end

        if spatial
            @info "$(modulelog()) - Performing spatial smoothing ($(@sprintf("%.2f",smoothlon))x$(@sprintf("%.2f",smoothlat))) on $(npd.name) Precipitation Rate data in $(geo.name) during $(year(dt)) $(monthname(dt)) ..."
            for idy = 1 : ndy

                if !iszero(buffer_lat)
                    ishift = 0
                    for ilat = -buffer_lat : buffer_lat
                        ishift += 1
                        circshift!(
                            view(shftlat,:,:,ishift),view(smthdata,:,:,idy),
                            (0,ilat)
                        )
                    end
                    for ilat = 1 : nlat, ilon = 1 : nlon
                        if !isnan(tmpdata[ilon,ilat,idy])
                            smthdata[ilon,ilat,idy] = nanmean(
                                view(shftlat,ilon,ilat,:),nanlat,weights_lat
                            )
                        else; smthdata[ilon,ilat,idy] = NaN32
                        end
                    end
                end

                if !iszero(buffer_lon)
                    ishift = 0
                    for ilon = -buffer_lon : buffer_lon
                        ishift += 1
                        circshift!(
                            view(shftlon,:,:,ishift),view(smthdata,:,:,idy),
                            (ilon,0)
                        )
                    end
                    for ilat = 1 : nlat, ilon = 1 : nlon
                        if !isnan(tmpdata[ilon,ilat,idy])
                            smthdata[ilon,ilat,idy] = nanmean(
                                view(shftlon,ilon,ilat,:),nanlon,weights_lon
                            )
                        else; smthdata[ilon,ilat,idy] = NaN32
                        end
                    end
                end
                
            end

            flush(stderr)

            if verbose
                @info "$(modulelog()) - Setting edges to NaN32 because we used cyclical circshift to do spatial smoothing, which doesn't make sense if boundaries are not periodic ..."
            end
            if !iszero(buffer_lon) && !geo.is360
                for idy = 1 : ndy, ilat = 1 : nlat, ilon = 1 : buffer_lon
                    smthdata[ilon,ilat,idy] = NaN32
                end
                for idy = 1 : ndy, ilat = 1 : nlat, ilon = (nlon-buffer_lon+1) : nlon
                    smthdata[ilon,ilat,idy] = NaN32
                end
            end
            if !iszero(buffer_lat)
                for idy = 1 : ndy, ilat = 1 : buffer_lat, ilon = 1 : nlon
                    smthdata[ilon,ilat,idy] = NaN32
                end
                for idy = 1 : ndy, ilat = (nlat-buffer_lat+1) : nlat, ilon = 1 : nlon
                    smthdata[ilon,ilat,idy] = NaN32
                end
            end

        end

        save(
            view(smthdata,:,:,1:ndy), dt, npd, geo, lsd,
            smooth=true, smoothlon=smoothlon, smoothlat=smoothlat, smoothtime=days
        )

        flush(stderr)

    end

end

function smoothing(
    npd :: Union{IMERGMonthly,TRMMMonthly},
    geo :: GeoRegion;
    smoothlon :: Real = 0,
    smoothlat :: Real = 0,
    verbose :: Bool = false
)

    if iszero(smoothlon) && iszero(smoothlat)
        error("$(modulelog()) - Incomplete specification of smoothing parameters in either the longitude or latitude directions")
    end

    shiftlon = smoothlon/0.1; if !isinteger(shiftlon)
        error("$(modulelog()) - The variable `smoothlon` should be a integer multiple of 0.1")
    end
    shiftlat = smoothlat/0.1; if !isinteger(shiftlat)
        error("$(modulelog()) - The variable `smoothlat` should be a integer multiple of 0.1")
    end

    buffer_lon, weights_lon  = calculatebufferweights(shiftlon)
    buffer_lat, weights_lat  = calculatebufferweights(shiftlat)

    lsd  = getLandSea(npd,geo)
    nlon = length(lsd.lon)
    nlat = length(lsd.lat)

    @info "$(modulelog()) - Preallocating data arrays for the analysis of data in the $(geo.name) Region ..."

    ndt = ntimesteps(npd)
    smthdata = zeros(Float32,nlon,nlat,ndt)
    shftlon  = zeros(Float32,nlon,nlat,(2*buffer_lon+1))
    shftlat  = zeros(Float32,nlon,nlat,(2*buffer_lat+1))
    nanlat   = zeros(Bool,(2*buffer_lat+1))
    nanlon   = zeros(Bool,(2*buffer_lon+1))

    flush(stderr)

    for dt in npd.start : Month(1) : npd.stop

        ds  = read(npd,geo,dt)
        sc  = ds["precipitation"].attrib["scale_factor"]
        of  = ds["precipitation"].attrib["add_offset"]
        mv  = ds["precipitation"].attrib["missing_value"]
        fv  = ds["precipitation"].attrib["_FillValue"]
        NCDatasets.load!(ds["precipitation"].var,tmpload,:,:,:)
        int2real!(smthdata,tmpload,scale=sc,offset=of,mvalue=mv,fvalue=fv)
        close(ds)

        flush(stderr)

        @info "$(modulelog()) - Performing spatial smoothing ($(@sprintf("%.2f",smoothlon))x$(@sprintf("%.2f",smoothlat))) on $(npd.name) Precipitation Rate data in $(geo.name) during $(year(dt)) $(monthname(dt)) ..."
        for idt = 1 : ndt

            if !iszero(buffer_lat)
                ishift = 0
                for ilat = -buffer_lat : buffer_lat
                    ishift += 1
                    circshift!(
                        view(shftlat,:,:,ishift),view(smthdata,:,:,idt),
                        (0,ilat)
                    )
                end
                for ilat = 1 : nlat, ilon = 1 : nlon
                    if !isnan(tmpdata[ilon,ilat,idt])
                        smthdata[ilon,ilat,idt] = nanmean(
                            view(shftlat,ilon,ilat,:),nanlat,weights_lat
                        )
                    else; smthdata[ilon,ilat,idt] = NaN32
                    end
                end
            end

            if !iszero(buffer_lon)
                ishift = 0
                for ilon = -buffer_lon : buffer_lon
                    ishift += 1
                    circshift!(
                        view(shftlon,:,:,ishift),view(smthdata,:,:,idt),
                        (ilon,0)
                    )
                end
                for ilat = 1 : nlat, ilon = 1 : nlon
                    if !isnan(tmpdata[ilon,ilat,idt])
                        smthdata[ilon,ilat,idt] = nanmean(
                            view(shftlat,ilon,ilat,:),nanlon,weights_lon
                        )
                    else; smthdata[ilon,ilat,idt] = NaN32
                    end
                end
            end

        end

        flush(stderr)

        if verbose
            @info "$(modulelog()) - Setting edges to NaN32 because we used cyclical circshift to do spatial smoothing, which doesn't make sense if boundaries are not periodic ..."
        end
        if !iszero(buffer_lon) && !geo.is360
            for idt = 1 : ndt, ilat = 1 : nlat, ilon = 1 : buffer_lon
                smthdata[ilon,ilat,idt] = NaN32
            end
            for idt = 1 : ndt, ilat = 1 : nlat, ilon = (nlon-buffer_lon+1) : nlon
                smthdata[ilon,ilat,idt] = NaN32
            end
        end
        if !iszero(buffer_lat)
            for idt = 1 : ndt, ilat = 1 : buffer_lat, ilon = 1 : nlon
                smthdata[ilon,ilat,idt] = NaN32
            end
            for idt = 1 : ndt, ilat = (nlat-buffer_lat+1) : nlat, ilon = 1 : nlon
                smthdata[ilon,ilat,idt] = NaN32
            end
        end

        save(
            smthdata, dt, npd, geo, lsd,
            smooth=true, smoothlon=smoothlon, smoothlat=smoothlat
        )

        flush(stderr)

    end

end