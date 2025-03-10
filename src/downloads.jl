"""
    download(
        npd :: NASAPrecipitationDataset,
        geo :: GeoRegion = GeoRegion("GLB");
	    overwrite :: Bool = false
    ) -> nothing

Downloads a NASA Precipitation dataset specified by `npd` for a GeoRegion specified by `geo`

Arguments
=========
- `npd` : a `NASAPrecipitationDataset` specifying the dataset details and date download range
- `geo` : a `GeoRegion` (see [GeoRegions.jl](https://github.com/GeoRegionsEcosystem/GeoRegions.jl)) that sets the geographic bounds of the data array in lon-lat

Keyword Arguments
=================
- `overwrite` : If `true`, overwrite any existing files
"""
function download(
	npd :: IMERGHalfHourly{ST,DT},
	geo :: GeoRegion = GeoRegion("GLB");
	overwrite :: Bool = false
) where {ST<:AbstractString, DT<:TimeType}

	@info "$(modulelog()) - Downloading $(npd.name) data for the $(geo.name) GeoRegion from $(npd.start) to $(npd.stop)"

	if geo.ID == "GLB"
		geo = GeoRegion("GLB180",path=geopath)
	else
		in(geo,GeoRegion("GLB180",path=geopath))
	end

	dyfnc = imergrawfiles()
	lon,lat = gpmlonlat(); nlon = length(lon)
	ggrd = RegionGrid(geo,lon,lat)

	@info "$(modulelog()) - Preallocating temporary arrays for extraction of $(npd.name) data for the $(geo.name) GeoRegion from the original gridded dataset"
	glon = ggrd.lon; nglon = length(glon); iglon = ggrd.ilon
	glat = ggrd.lat; nglat = length(glat); iglat = ggrd.ilat
	mask = ggrd.mask
	var  = zeros(Float32,nglon,nglat,48)
	tmp0 = zeros(Float32,nglat,nglon)

	if iglon[1] > iglon[end]
		shift = true
		iglon1 = iglon[1] : nlon; niglon1 = length(iglon1)
		iglon2 = 1 : iglon[end];  niglon2 = length(iglon2)
		tmp1 = @view tmp0[:,1:niglon1]
		tmp2 = @view tmp0[:,niglon1.+(1:niglon2)]
		@info "Temporary array sizes: $(size(tmp1)), $(size(tmp2))"
	else
		shift = false
		iglon = iglon[1] : iglon[end]
	end

	if iglat[1] > iglat[end]
		iglat = iglat[1] : -1 : iglat[end]
	else
		iglat = iglat[1] : iglat[end]
	end

	if npd.v6; varID = "precipitationCal"; else; varID = "precipitation" end

	for dt in npd.start : Day(1) : npd.stop

		fnc = npdfnc(npd,geo,dt)
		if overwrite || !isfile(fnc)

			@info "$(modulelog()) - Downloading $(npd.name) data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(dt) ..."

			ymdfnc = Dates.format(dt,dateformat"yyyymmdd")
			npddir = joinpath(npd.hroot,"$(year(dt))",@sprintf("%03d",dayofyear(dt)))
			
			for it = 1 : 48

				@debug "$(modulelog()) - Loading data into temporary array for timestep $(dyfnc[it])"

				npdfnc = "$(npd.fpref).$ymdfnc-$(dyfnc[it]).$(npd.fsuff)"

				tryretrieve = 0
				ds = 0
				while !(typeof(ds) <: NCDataset) && (tryretrieve < 20)
					if tryretrieve > 0
						@info "$(modulelog()) - Attempting to request data from NASA OPeNDAP servers on Attempt $(tryretrieve+1) of 20"
					end
					ds = NCDataset(joinpath(npddir,npdfnc))
					tryretrieve += 1
				end
				
				if !shift
					NCDatasets.load!(ds[varID].var,tmp0,iglat,iglon,1)
				else
					NCDatasets.load!(ds[varID].var,tmp1,iglat,iglon1,1)
					NCDatasets.load!(ds[varID].var,tmp2,iglat,iglon2,1)
				end
				close(ds)

				@debug "$(modulelog()) - Extraction of data from temporary array for the $(geo.name) GeoRegion"
				for ilat = 1 : nglat, ilon = 1 : nglon
					varii = tmp0[ilat,ilon]
					mskii = mask[ilon,ilat]
					if (varii != -9999.9f0) && !isnan(mskii)
						var[ilon,ilat,it] = varii / 3600
					else; var[ilon,ilat,it] = NaN32
					end
				end
			end

			save(var,dt,npd,geo,ggrd)

		else

			@info "$(modulelog()) - $(npd.name) data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(dt) exists in $(fnc), and we are not overwriting, skipping to next timestep ..."

		end

		flush(stderr)

	end

end

function download(
	npd :: IMERGDaily{ST,DT},
	geo :: GeoRegion = GeoRegion("GLB");
	overwrite :: Bool = false
) where {ST<:AbstractString, DT<:TimeType}

	@info "$(modulelog()) - Downloading $(npd.name) data for the $(geo.name) GeoRegion from $(npd.start) to $(npd.stop)"

	if geo.ID == "GLB"
		geo = GeoRegion("GLB180",path=geopath)
	else
		in(geo,GeoRegion("GLB180",path=geopath))
	end

	lon,lat = gpmlonlat(); nlon = length(lon)
	ggrd = RegionGrid(geo,lon,lat)

	@info "$(modulelog()) - Preallocating temporary arrays for extraction of $(npd.name) data for the $(geo.name) GeoRegion from the original gridded dataset"
	glon = ggrd.lon; nglon = length(glon); iglon = ggrd.ilon
	glat = ggrd.lat; nglat = length(glat); iglat = ggrd.ilat
	mask = ggrd.mask
	var  = zeros(Float32,nglon,nglat,31)
	tmp0 = zeros(Float32,nglat,nglon)

	if iglon[1] > iglon[end]
		shift = true
		iglon1 = iglon[1] : nlon; niglon1 = length(iglon1)
		iglon2 = 1 : iglon[end];  niglon2 = length(iglon2)
		tmp1 = @view tmp0[:,1:niglon1]
		tmp2 = @view tmp0[:,niglon1.+(1:niglon2)]
	else
		shift = false
		iglon = iglon[1] : iglon[end]
	end

	if iglat[1] > iglat[end]
		iglat = iglat[1] : -1 : iglat[end]
	else
		iglat = iglat[1] : iglat[end]
	end

	if npd.v6; varID = "precipitationCal"; else; varID = "precipitation" end

	for dt in npd.start : Month(1) : npd.stop

		fnc = npdfnc(npd,geo,dt)
		if overwrite || !isfile(fnc)

			@info "$(modulelog()) - Downloading $(npd.name) data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(year(dt))-$(month(dt)) ..."

			npddir = joinpath(npd.hroot,"$(yrmo2dir(dt))")
			ndy = daysinmonth(dt)

			for dy in 1 : ndy
				dtii   = Date(year(dt),month(dt),dy)
				ymdfnc = "$(ymd2str(dtii))"
				npdfnc = "$(npd.fpref).$ymdfnc-$(npd.fsuff)"
				ds = NCDataset(joinpath(npddir,npdfnc))
				if !shift
					NCDatasets.load!(ds[varID].var,tmp0,iglat,iglon,1)
				else
					NCDatasets.load!(ds[varID].var,tmp1,iglat,iglon1,1)
					NCDatasets.load!(ds[varID].var,tmp2,iglat,iglon2,1)
				end
				close(ds)

				@debug "$(modulelog()) - Extraction of data from temporary array for the $(geo.name) GeoRegion"

				for ilat = 1 : nglat, ilon = 1 : nglon
					varii = tmp0[ilat,ilon]
					mskii = mask[ilon,ilat]
					if (varii != -9999.9f0) && !isnan(mskii)
						var[ilon,ilat,dy] = varii / 86400
					else; var[ilon,ilat,dy] = NaN32
					end
				end

			end

			save(view(var,:,:,1:ndy),dt,npd,geo,ggrd)

		else

			@info "$(modulelog()) - $(npd.name) data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(dt) exists in $(fnc), and we are not overwriting, skipping to next timestep ..."

		end

        flush(stderr)

	end

end

function download(
	npd :: IMERGMonthly{ST,DT},
	geo :: GeoRegion = GeoRegion("GLB");
	overwrite :: Bool = false
) where {ST<:AbstractString, DT<:TimeType}

	@info "$(modulelog()) - Downloading $(npd.name) data for the $(geo.name) GeoRegion from $(npd.start) to $(npd.stop)"

	if geo.ID == "GLB"
		geo = GeoRegion("GLB180",path=geopath)
	else
		in(geo,GeoRegion("GLB180",path=geopath))
	end

	lon,lat = gpmlonlat(); nlon = length(lon)
	ggrd = RegionGrid(geo,lon,lat)

	@info "$(modulelog()) - Preallocating temporary arrays for extraction of $(npd.name) data for the $(geo.name) GeoRegion from the original gridded dataset"
	glon = ggrd.lon; nglon = length(glon); iglon = ggrd.ilon
	glat = ggrd.lat; nglat = length(glat); iglat = ggrd.ilat
	mask = ggrd.mask
	var  = zeros(Float32,nglon,nglat,12)
	tmp0 = zeros(Float32,nglat,nglon)

	if iglon[1] > iglon[end]
		shift = true
		iglon1 = iglon[1] : nlon; niglon1 = length(iglon1)
		iglon2 = 1 : iglon[end];  niglon2 = length(iglon2)
		tmp1 = @view tmp0[:,1:niglon1]
		tmp2 = @view tmp0[:,niglon1.+(1:niglon2)]
	else
		shift = false
		iglon = iglon[1] : iglon[end]
	end

	if iglat[1] > iglat[end]
		iglat = iglat[1] : -1 : iglat[end]
	else
		iglat = iglat[1] : iglat[end]
	end

	for dt in npd.start : Year(1) : npd.stop

		fnc = npdfnc(npd,geo,dt)
		if overwrite || !isfile(fnc)

			@info "$(modulelog()) - Downloading $(npd.name) data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(year(dt)) ..."

			npddir = joinpath(npd.hroot,"$(year(dt))")

			for mo in 1 : 12
				dtii   = Date(year(dt),mo,1)
				ymdfnc = "$(ymd2str(dtii))-S000000-E235959"
				npdfnc = "$(npd.fpref).$ymdfnc.$(@sprintf("%02d",mo)).$(npd.fsuff)"
				ds = NCDataset(joinpath(npddir,npdfnc))
				if !shift
					NCDatasets.load!(ds["precipitation"].var,tmp0,iglat,iglon,1)
				else
					NCDatasets.load!(ds["precipitation"].var,tmp1,iglat,iglon1,1)
					NCDatasets.load!(ds["precipitation"].var,tmp2,iglat,iglon2,1)
				end
				close(ds)

				@debug "$(modulelog()) - Extraction of data from temporary array for the $(geo.name) GeoRegion"

				for ilat = 1 : nglat, ilon = 1 : nglon
					varii = tmp0[ilat,ilon]
					mskii = mask[ilon,ilat]
					if (varii != -9999.9f0) && !isnan(mskii)
						var[ilon,ilat,mo] = varii / 3600
					else; var[ilon,ilat,mo] = NaN32
					end
				end

			end

			save(var,dt,npd,geo,ggrd)

		else

			@info "$(modulelog()) - $(npd.name) data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(dt) exists in $(fnc), and we are not overwriting, skipping to next timestep ..."

		end

        flush(stderr)

	end

end

function download(
	npd :: TRMM3Hourly{ST,DT},
	geo :: GeoRegion = GeoRegion("GLB");
	overwrite :: Bool = false
) where {ST<:AbstractString, DT<:TimeType}

	@info "$(modulelog()) - Downloading $(npd.name) data for the $(geo.name) GeoRegion from $(npd.start) to $(npd.stop)"

	if geo.ID == "GLB"
		geo = GeoRegion("GLB180",path=geopath)
	else
		in(geo,GeoRegion("GLB180",path=geopath))
	end

	lon,lat = trmmlonlat(); nlon = length(lon)
	ggrd = RegionGrid(geo,lon,lat)

	@info "$(modulelog()) - Preallocating temporary arrays for extraction of $(npd.name) data for the $(geo.name) GeoRegion from the original gridded dataset"
	glon = ggrd.lon; nglon = length(glon); iglon = ggrd.ilon
	glat = ggrd.lat; nglat = length(glat); iglat = ggrd.ilat
	mask = ggrd.mask
	var  = zeros(Float32,nglon,nglat,8)
	tmp0 = zeros(Float32,nglat,nglon)

	if iglon[1] > iglon[end]
		shift = true
		iglon1 = iglon[1] : nlon; niglon1 = length(iglon1)
		iglon2 = 1 : iglon[end];  niglon2 = length(iglon2)
		tmp1 = @view tmp0[:,1:niglon1]
		tmp2 = @view tmp0[:,niglon1.+(1:niglon2)]
	else
		shift = false
		iglon = iglon[1] : iglon[end]
	end

	if iglat[1] > iglat[end]
		iglat = iglat[1] : -1 : iglat[end]
	else
		iglat = iglat[1] : iglat[end]
	end

	for dt in npd.start : Day(1) : npd.stop

		fnc = npdfnc(npd,geo,dt)
		if overwrite || !isfile(fnc)

			@info "$(modulelog()) - Downloading $(npd.name) data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(dt) ..."

			ymdfnc = Dates.format(dt,dateformat"yyyymmdd")

			for it = 1 : 8

				@debug "$(modulelog()) - Loading data into temporary array for timestep $(@sprintf("%02d",(it-1)*3))00-$(@sprintf("%02d",(it)*3-2))59"

				if isone(it); di = dt-Day(1)
					npddir = joinpath(npd.hroot,"$(year(di))",@sprintf("%03d",dayofyear(di)))
				else; npddir = joinpath(npd.hroot,"$(year(dt))",@sprintf("%03d",dayofyear(dt)))
				end

				npdfnc = "$(npd.fpref).$ymdfnc.$(@sprintf("%02d",(it-1)*3)).$(npd.fsuff)"
				ds = NCDataset(joinpath(npddir,npdfnc))
				if !shift
					NCDatasets.load!(ds["precipitation"].var,tmp0,iglat,iglon,1)
				else
					NCDatasets.load!(ds["precipitation"].var,tmp1,iglat,iglon1,1)
					NCDatasets.load!(ds["precipitation"].var,tmp2,iglat,iglon2,1)
				end
				close(ds)

				@debug "$(modulelog()) - Extraction of data from temporary array for the $(geo.name) GeoRegion"
				for ilat = 1 : nglat, ilon = 1 : nglon
					varii = tmp0[ilat,ilon]
					mskii = mask[ilon,ilat]
					if (varii != -9999.9f0) && !isnan(mskii)
						var[ilon,ilat,it] = varii / 3600
					else; var[ilon,ilat,it] = NaN32
					end
				end
			end

			save(var,dt,npd,geo,ggrd)

		else

			@info "$(modulelog()) - $(npd.name) data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(dt) exists in $(fnc), and we are not overwriting, skipping to next timestep ..."

		end

        flush(stderr)

	end

end

function download(
	npd :: TRMMDaily{ST,DT},
	geo :: GeoRegion = GeoRegion("GLB");
	overwrite :: Bool = false
) where {ST<:AbstractString, DT<:TimeType}

	@info "$(modulelog()) - Downloading $(npd.name) data for the $(geo.name) GeoRegion from $(npd.start) to $(npd.stop)"

	if geo.ID == "GLB"
		geo = GeoRegion("GLB180",path=geopath)
	else
		in(geo,GeoRegion("GLB180",path=geopath))
	end

	lon,lat = trmmlonlat(); nlon = length(lon)
	ggrd = RegionGrid(geo,lon,lat)

	@info "$(modulelog()) - Preallocating temporary arrays for extraction of $(npd.name) data for the $(geo.name) GeoRegion from the original gridded dataset"
	glon = ggrd.lon; nglon = length(glon); iglon = ggrd.ilon
	glat = ggrd.lat; nglat = length(glat); iglat = ggrd.ilat
	mask = ggrd.mask
	var  = zeros(Float32,nglon,nglat,31)
	tmp0 = zeros(Float32,nglat,nglon)

	if iglon[1] > iglon[end]
		shift = true
		iglon1 = iglon[1] : nlon; niglon1 = length(iglon1)
		iglon2 = 1 : iglon[end];  niglon2 = length(iglon2)
		tmp1 = @view tmp0[:,1:niglon1]
		tmp2 = @view tmp0[:,niglon1.+(1:niglon2)]
	else
		shift = false
		iglon = iglon[1] : iglon[end]
	end

	if iglat[1] > iglat[end]
		iglat = iglat[1] : -1 : iglat[end]
	else
		iglat = iglat[1] : iglat[end]
	end

	for dt in npd.start : Month(1) : npd.stop

		fnc = npdfnc(npd,geo,dt)
		if overwrite || !isfile(fnc)

			@info "$(modulelog()) - Downloading $(npd.name) data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(year(dt))-$(month(dt)) ..."

			npddir = joinpath(npd.hroot,"$(yrmo2dir(dt))")
			ndy = daysinmonth(dt)

			for dy in 1 : ndy
				dtii   = Date(year(dt),month(dt),dy)
				ymdfnc = "$(ymd2str(dtii))"
				npdfnc = "$(npd.fpref).$ymdfnc.$(npd.fsuff)"
				ds = NCDataset(joinpath(npddir,npdfnc))
				if !shift
					NCDatasets.load!(ds["precipitation"].var,tmp0,iglat,iglon,1)
				else
					NCDatasets.load!(ds["precipitation"].var,tmp1,iglat,iglon1,1)
					NCDatasets.load!(ds["precipitation"].var,tmp2,iglat,iglon2,1)
				end
				close(ds)

				@debug "$(modulelog()) - Extraction of data from temporary array for the $(geo.name) GeoRegion"

				for ilat = 1 : nglat, ilon = 1 : nglon
					varii = tmp0[ilat,ilon]
					mskii = mask[ilon,ilat]
					if (varii != -9999.9f0) && !isnan(mskii)
						var[ilon,ilat,dy] = varii / 86400
					else; var[ilon,ilat,dy] = NaN32
					end
				end

			end

			save(view(var,:,:,1:ndy),dt,npd,geo,ggrd)

		else

			@info "$(modulelog()) - $(npd.name) data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(dt) exists in $(fnc), and we are not overwriting, skipping to next timestep ..."

		end

        flush(stderr)

	end

end

function download(
	npd :: TRMMMonthly{ST,DT},
	geo :: GeoRegion = GeoRegion("GLB");
	overwrite :: Bool = false
) where {ST<:AbstractString, DT<:TimeType}

	@info "$(modulelog()) - Downloading $(npd.name) data for the $(geo.name) GeoRegion from $(npd.start) to $(npd.stop)"

	if geo.ID == "GLB"
		geo = GeoRegion("GLB180",path=geopath)
	else
		in(geo,GeoRegion("GLB180",path=geopath))
	end

	lon,lat = trmmlonlat(); nlon = length(lon)
	ggrd = RegionGrid(geo,lon,lat)

	@info "$(modulelog()) - Preallocating temporary arrays for extraction of $(npd.name) data for the $(geo.name) GeoRegion from the original gridded dataset"
	glon = ggrd.lon; nglon = length(glon); iglon = ggrd.ilon
	glat = ggrd.lat; nglat = length(glat); iglat = ggrd.ilat
	mask = ggrd.mask
	var  = zeros(Float32,nglon,nglat,12)
	tmp0 = zeros(Float32,nglat,nglon)

	if iglon[1] > iglon[end]
		shift = true
		iglon1 = iglon[1] : nlon; niglon1 = length(iglon1)
		iglon2 = 1 : iglon[end];  niglon2 = length(iglon2)
		tmp1 = @view tmp0[:,1:niglon1]
		tmp2 = @view tmp0[:,niglon1.+(1:niglon2)]
	else
		shift = false
		iglon = iglon[1] : iglon[end]
	end

	if iglat[1] > iglat[end]
		iglat = iglat[1] : -1 : iglat[end]
	else
		iglat = iglat[1] : iglat[end]
	end

	for dt in npd.start : Year(1) : npd.stop

		fnc = npdfnc(npd,geo,dt)
		if overwrite || !isfile(fnc)

			@info "$(modulelog()) - Downloading $(npd.name) data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(year(dt)) ..."

			npddir = joinpath(npd.hroot,"$(year(dt))")

			for mo in 1 : 12
				dtii   = Date(year(dt),mo,1)
				ymdfnc = "$(ymd2str(dtii))"
				npdfnc = "$(npd.fpref).$ymdfnc.$(npd.fsuff)"
				ds = NCDataset(joinpath(npddir,npdfnc))
				if !shift
					NCDatasets.load!(ds["precipitation"].var,tmp0,iglat,iglon,1)
				else
					NCDatasets.load!(ds["precipitation"].var,tmp1,iglat,iglon1,1)
					NCDatasets.load!(ds["precipitation"].var,tmp2,iglat,iglon2,1)
				end
				close(ds)

				@debug "$(modulelog()) - Extraction of data from temporary array for the $(geo.name) GeoRegion"

				for ilat = 1 : nglat, ilon = 1 : nglon
					varii = tmp0[ilat,ilon]
					mskii = mask[ilon,ilat]
					if (varii != -9999.9f0) && !isnan(mskii)
						var[ilon,ilat,mo] = varii / 3600
					else; var[ilon,ilat,mo] = NaN32
					end
				end

			end

			save(var,dt,npd,geo,ggrd)

		else

			@info "$(modulelog()) - $(npd.name) data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(dt) exists in $(fnc), and we are not overwriting, skipping to next timestep ..."

		end

        flush(stderr)

	end

end
