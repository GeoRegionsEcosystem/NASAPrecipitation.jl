"""
    download(
        npd :: NASAPrecipitationDataset,
        geo :: GeoRegion = GeoRegion("GLB")
    ) -> nothing

Downloads a NASA Precipitation dataset specified by `npd` for a GeoRegion specified by `geo`

Arguments
=========
- `npd` : a `NASAPrecipitationDataset` specifying the dataset details and date download range
- `geo` : a `GeoRegion` (see [GeoRegions.jl](https://github.com/JuliaClimate/GeoRegions.jl)) that sets the geographic bounds of the data array in lon-lat
"""
function download(
	npd :: IMERGHalfHourly{ST,DT},
	geo :: GeoRegion = GeoRegion("GLB")
) where {ST<:AbstractString, DT<:TimeType}

	@info "$(now()) - NASAPrecipitation.jl - Downloading $(npd.lname) data for the $(geo.name) GeoRegion from $(npd.dtbeg) to $(npd.dtend)"

	if geo.regID == "GLB"
		@info "$(now()) - NASAPrecipitation.jl - Global dataset request has been detected, switching to the IMERG GeoRegion"
		addNPDGeoRegions(); geo = GeoRegion("IMERG")
	else
		isinGeoRegion(geo,GeoRegion("IMERG"))
	end

	fnc  = imergrawfiles()
	lon,lat = gpmlonlat(); nlon = length(lon); nlat = length(lat)
	ginfo = RegionGrid(geo,lon,lat)

	@info "$(now()) - NASAPrecipitation.jl - Preallocating temporary arrays for extraction of $(npd.lname) data for the $(geo.name) GeoRegion from the original gridded dataset"
	glon = ginfo.glon; nglon = length(glon); iglon = ginfo.ilon
	glat = ginfo.glat; nglat = length(glat); iglat = ginfo.ilat
	tmp0 = zeros(Float32,nglat,nglon)
	var  = zeros(Float32,nglon,nglat,48)

	if typeof(geo) <: PolyRegion
		  msk = ginfo.mask
	else; msk = ones(nglon,nglat)
	end

	if iglon[1] > iglon[end]
		shift == true
		iglon1 = iglon[1] : nlon; niglon1 = length(iglon1)
		iglon2 = 1 : iglon[end];  niglon2 = length(iglon2)
		tmp1 = @view tmp0[1:niglon1,:]
		tmp2 = @view tmp0[(niglon1+1):niglon2,:]
	else
		shift = false
		iglon = iglon[1] : iglon[end]
	end

	if iglat[1] > iglat[end]
		iglat = iglat[1] : -1 : iglat[end]
	else
		iglat = iglat[1] : iglat[end]
	end

	for dt in npd.dtbeg : Day(1) : npd.dtend

		@info "$(now()) - NASAPrecipitation.jl - Downloading $(npd.lname) data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(dt) ..."

		ymdfnc = Dates.format(dt,dateformat"yyyymmdd")
		npddir = joinpath(npd.hroot,"$(year(dt))",@sprintf("%03d",dayofyear(dt)))
		for it = 1 : 48

			@debug "$(now()) - NASAPrecipitation.jl - Loading data into temporary array for timestep $(fnc[it])"

			npdfnc = "$(npd.fpref).$ymdfnc-$(fnc[it]).$(npd.fsuff)"
			ds = NCDataset(joinpath(npddir,npdfnc))
			if !shift
				NCDatasets.load!(ds["precipitationCal"].var,tmp0,iglat,iglon,1)
			else
				NCDatasets.load!(ds["precipitationCal"].var,tmp1,iglat,iglon1,1)
				NCDatasets.load!(ds["precipitationCal"].var,tmp2,iglat,iglon2,1)
			end
			close(ds)

			@debug "$(now()) - NASAPrecipitation.jl - Extraction of data from temporary array for the $(geo.name) GeoRegion"
			for ilat = 1 : nglat, ilon = 1 : nglon
				varii = tmp0[ilat,ilon]
				mskii = msk[ilon,ilat]
				if (varii != -9999.9f0) && !isnan(mskii)
					  var[ilon,ilat,it] = varii / 3600
				else; var[ilon,ilat,it] = NaN32
				end
			end
		end

		save(var,dt,npd,geo,ginfo)

	end

end

function download(
	npd :: IMERGDaily{ST,DT},
	geo :: GeoRegion = GeoRegion("GLB")
) where {ST<:AbstractString, DT<:TimeType}

	@info "$(now()) - NASAPrecipitation.jl - Downloading $(npd.lname) data for the $(geo.name) GeoRegion from $(npd.dtbeg) to $(npd.dtend)"

	if geo.regID == "GLB"
		@info "$(now()) - NASAPrecipitation.jl - Global dataset request has been detected, switching to the IMERG GeoRegion"
		addNPDGeoRegions(); geo = GeoRegion("IMERG")
	else
		isinGeoRegion(geo,GeoRegion("IMERG"))
	end

	lon,lat = gpmlonlat(); nlon = length(lon); nlat = length(lat)
	ginfo = RegionGrid(geo,lon,lat)

	@info "$(now()) - NASAPrecipitation.jl - Preallocating temporary arrays for extraction of $(npd.lname) data for the $(geo.name) GeoRegion from the original gridded dataset"
	glon = ginfo.glon; nglon = length(glon); iglon = ginfo.ilon
	glat = ginfo.glat; nglat = length(glat); iglat = ginfo.ilat
	tmp0 = zeros(Float32,nglat,nglon)
	var  = zeros(Float32,nglon,nglat,31)

	if typeof(geo) <: PolyRegion
		  msk = ginfo.mask
	else; msk = ones(nglon,nglat)
	end

	if iglon[1] > iglon[end]
		shift == true
		iglon1 = iglon[1] : nlon; niglon1 = length(iglon1)
		iglon2 = 1 : iglon[end];  niglon2 = length(iglon2)
		tmp1 = @view tmp0[1:niglon1,:]
		tmp2 = @view tmp0[(niglon1+1):niglon2,:]
	else
		shift = false
		iglon = iglon[1] : iglon[end]
	end

	if iglat[1] > iglat[end]
		iglat = iglat[1] : -1 : iglat[end]
	else
		iglat = iglat[1] : iglat[end]
	end

	for dt in npd.dtbeg : Month(1) : npd.dtend

		@info "$(now()) - NASAPrecipitation.jl - Downloading $(npd.lname) data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(year(dt))-$(month(dt)) ..."

		npddir = joinpath(npd.hroot,"$(yrmo2dir(dt))")
		ndy = daysinmonth(dt)

		for dy in 1 : ndy
			dtii   = Date(year(dt),month(dt),dy)
			ymdfnc = "$(ymd2str(dtii))"
			npdfnc = "$(npd.fpref).$ymdfnc-$(npd.fsuff)"
			ds = NCDataset(joinpath(npddir,npdfnc))
			if !shift
				NCDatasets.load!(ds["precipitationCal"].var,tmp0,iglat,iglon,1)
			else
				NCDatasets.load!(ds["precipitationCal"].var,tmp1,iglat,iglon1,1)
				NCDatasets.load!(ds["precipitationCal"].var,tmp2,iglat,iglon2,1)
			end
			close(ds)

			@debug "$(now()) - NASAPrecipitation.jl - Extraction of data from temporary array for the $(geo.name) GeoRegion"

			for ilat = 1 : nglat, ilon = 1 : nglon
				varii = tmp0[ilat,ilon]
				mskii = msk[ilon,ilat]
				if (varii != -9999.9f0) && !isnan(mskii)
					  var[ilon,ilat,dy] = varii / 86400
				else; var[ilon,ilat,dy] = NaN32
				end
			end

		end

		save(view(var,:,:,1:ndy),dt,npd,geo,ginfo)

	end

end

function download(
	npd :: IMERGMonthly{ST,DT},
	geo :: GeoRegion = GeoRegion("GLB")
) where {ST<:AbstractString, DT<:TimeType}

	@info "$(now()) - NASAPrecipitation.jl - Downloading $(npd.lname) data for the $(geo.name) GeoRegion from $(npd.dtbeg) to $(npd.dtend)"

	if geo.regID == "GLB"
		@info "$(now()) - NASAPrecipitation.jl - Global dataset request has been detected, switching to the IMERG GeoRegion"
		addNPDGeoRegions(); geo = GeoRegion("IMERG")
	else
		isinGeoRegion(geo,GeoRegion("IMERG"))
	end

	lon,lat = gpmlonlat(); nlon = length(lon); nlat = length(lat)
	ginfo = RegionGrid(geo,lon,lat)

	@info "$(now()) - NASAPrecipitation.jl - Preallocating temporary arrays for extraction of $(npd.lname) data for the $(geo.name) GeoRegion from the original gridded dataset"
	glon = ginfo.glon; nglon = length(glon); iglon = ginfo.ilon
	glat = ginfo.glat; nglat = length(glat); iglat = ginfo.ilat
	tmp0 = zeros(Float32,nglat,nglon)
	var  = zeros(Float32,nglon,nglat,12)

	if typeof(geo) <: PolyRegion
		  msk = ginfo.mask
	else; msk = ones(nglon,nglat)
	end

	if iglon[1] > iglon[end]
		shift == true
		iglon1 = iglon[1] : nlon; niglon1 = length(iglon1)
		iglon2 = 1 : iglon[end];  niglon2 = length(iglon2)
		tmp1 = @view tmp0[1:niglon1,:]
		tmp2 = @view tmp0[(niglon1+1):niglon2,:]
	else
		shift = false
		iglon = iglon[1] : iglon[end]
	end

	if iglat[1] > iglat[end]
		iglat = iglat[1] : -1 : iglat[end]
	else
		iglat = iglat[1] : iglat[end]
	end

	for dt in npd.dtbeg : Year(1) : npd.dtend

		@info "$(now()) - NASAPrecipitation.jl - Downloading $(npd.lname) data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(year(dt)) ..."

		npddir = joinpath(npd.hroot,"$(year(dt))")

		for mo in 1 : 12
			dtii   = Date(year(dt),mo,1)
			ymdfnc = "$(ymd2str(dtii))-S000000-E235959"
			npdfnc = "$(npd.fpref).$ymdfnc.$(@sprintf("%02d",mo)).$(npd.fsuff)"
			ds = NCDataset(joinpath(npddir,npdfnc))
			if !shift
				NCDatasets.load!(ds["precipitationCal"].var,tmp0,iglat,iglon,1)
			else
				NCDatasets.load!(ds["precipitationCal"].var,tmp1,iglat,iglon1,1)
				NCDatasets.load!(ds["precipitationCal"].var,tmp2,iglat,iglon2,1)
			end
			close(ds)

			@debug "$(now()) - NASAPrecipitation.jl - Extraction of data from temporary array for the $(geo.name) GeoRegion"

			for ilat = 1 : nglat, ilon = 1 : nglon
				varii = tmp0[ilat,ilon]
				mskii = msk[ilon,ilat]
				if (varii != -9999.9f0) && !isnan(mskii)
					  var[ilon,ilat,mo] = varii / 3600
				else; var[ilon,ilat,mo] = NaN32
				end
			end

		end

		save(var,dt,npd,geo,ginfo)

	end

end

function download(
	npd :: TRMM3Hourly{ST,DT},
	geo :: GeoRegion = GeoRegion("GLB")
) where {ST<:AbstractString, DT<:TimeType}

	@info "$(now()) - NASAPrecipitation.jl - Downloading $(npd.lname) data for the $(geo.name) GeoRegion from $(npd.dtbeg) to $(npd.dtend)"

	if geo.regID == "GLB"
		@info "$(now()) - NASAPrecipitation.jl - Global dataset request has been detected, switching to the TRMM GeoRegion"
		addNPDGeoRegions(); geo = GeoRegion("TRMM")
	else
		isinGeoRegion(geo,GeoRegion("TRMM"))
	end

	lon,lat = trmmlonloat(); nlon = length(lon); nlat = length(lat)
	ginfo = RegionGrid(geo,lon,lat)

	@info "$(now()) - NASAPrecipitation.jl - Preallocating temporary arrays for extraction of $(npd.lname) data for the $(geo.name) GeoRegion from the original gridded dataset"
	glon = ginfo.glon; nglon = length(glon); iglon = ginfo.ilon
	glat = ginfo.glat; nglat = length(glat); iglat = ginfo.ilat
	tmp0 = zeros(Float32,nglat,nglon)
	var  = zeros(Float32,nglon,nglat,8)

	if typeof(geo) <: PolyRegion
		  msk = ginfo.mask
	else; msk = ones(nglon,nglat)
	end

	if iglon[1] > iglon[end]
		shift == true
		iglon1 = iglon[1] : nlon; niglon1 = length(iglon1)
		iglon2 = 1 : iglon[end];  niglon2 = length(iglon2)
		tmp1 = @view tmp0[1:niglon1,:]
		tmp2 = @view tmp0[(niglon1+1):niglon2,:]
	else
		shift = false
		iglon = iglon[1] : iglon[end]
	end

	if iglat[1] > iglat[end]
		iglat = iglat[1] : -1 : iglat[end]
	else
		iglat = iglat[1] : iglat[end]
	end

	for dt in npd.dtbeg : Day(1) : npd.dtend

		@info "$(now()) - NASAPrecipitation.jl - Downloading $(npd.lname) data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(dt) ..."

		ymdfnc = Dates.format(dt,dateformat"yyyymmdd")

		for it = 1 : 8

			@debug "$(now()) - NASAPrecipitation.jl - Loading data into temporary array for timestep $(fnc[it])"

			if isone(it); di = dt-Day(1)
				  npddir = joinpath(npd.hroot,"$(year(di))",@sprintf("%03d",dayofyear(di)))
			else; npddir = joinpath(npd.hroot,"$(year(dt))",@sprintf("%03d",dayofyear(dt)))
			end

			npdfnc = "$(npd.fpref).$ymdfnc.$((it-1)*3).$(npd.fsuff)"
			ds = NCDataset(joinpath(npddir,npdfnc))
			if !shift
				NCDatasets.load!(ds["precipitationCal"].var,tmp0,iglat,iglon,1)
			else
				NCDatasets.load!(ds["precipitationCal"].var,tmp1,iglat,iglon1,1)
				NCDatasets.load!(ds["precipitationCal"].var,tmp2,iglat,iglon2,1)
			end
			close(ds)

			@debug "$(now()) - NASAPrecipitation.jl - Extraction of data from temporary array for the $(geo.name) GeoRegion"
			for ilat = 1 : nglat, ilon = 1 : nglon
				varii = tmp0[ilat,ilon]
				mskii = msk[ilon,ilat]
				if (varii != -9999.9f0) && !isnan(mskii)
					  var[ilon,ilat,it] = varii / 3600
				else; var[ilon,ilat,it] = NaN32
				end
			end
		end

		save(var,dt,npd,geo,ginfo)

	end

end

function download(
	npd :: TRMMDaily{ST,DT},
	geo :: GeoRegion = GeoRegion("GLB")
) where {ST<:AbstractString, DT<:TimeType}

	@info "$(now()) - NASAPrecipitation.jl - Downloading $(npd.lname) data for the $(geo.name) GeoRegion from $(npd.dtbeg) to $(npd.dtend)"

	if geo.regID == "GLB"
		@info "$(now()) - NASAPrecipitation.jl - Global dataset request has been detected, switching to the TRMM GeoRegion"
		addNPDGeoRegions(); geo = GeoRegion("TRMM")
	else
		isinGeoRegion(geo,GeoRegion("TRMM"))
	end

	lon,lat = trmmlonlat(); nlon = length(lon); nlat = length(lat)
	ginfo = RegionGrid(geo,lon,lat)

	@info "$(now()) - NASAPrecipitation.jl - Preallocating temporary arrays for extraction of $(npd.lname) data for the $(geo.name) GeoRegion from the original gridded dataset"
	glon = ginfo.glon; nglon = length(glon); iglon = ginfo.ilon
	glat = ginfo.glat; nglat = length(glat); iglat = ginfo.ilat
	tmp0 = zeros(Float32,nglat,nglon)
	var  = zeros(Float32,nglon,nglat,31)

	if typeof(geo) <: PolyRegion
		  msk = ginfo.mask
	else; msk = ones(nglon,nglat)
	end

	if iglon[1] > iglon[end]
		shift == true
		iglon1 = iglon[1] : nlon; niglon1 = length(iglon1)
		iglon2 = 1 : iglon[end];  niglon2 = length(iglon2)
		tmp1 = @view tmp0[1:niglon1,:]
		tmp2 = @view tmp0[(niglon1+1):niglon2,:]
	else
		shift = false
		iglon = iglon[1] : iglon[end]
	end

	if iglat[1] > iglat[end]
		iglat = iglat[1] : -1 : iglat[end]
	else
		iglat = iglat[1] : iglat[end]
	end

	for dt in npd.dtbeg : Month(1) : npd.dtend

		@info "$(now()) - NASAPrecipitation.jl - Downloading $(npd.lname) data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(year(dt))-$(month(dt)) ..."

		npddir = joinpath(npd.hroot,"$(yrmo2dir(dt))")
		ndy = daysinmonth(dt)

		for dy in 1 : ndy
			dtii   = Date(year(dt),month(dt),dy)
			ymdfnc = "$(ymd2str(dtii))"
			npdfnc = "$(npd.fpref).$ymdfnc.$(npd.fsuff)"
			ds = NCDataset(joinpath(npddir,npdfnc))
			if !shift
				NCDatasets.load!(ds["precipitationCal"].var,tmp0,iglat,iglon,1)
			else
				NCDatasets.load!(ds["precipitationCal"].var,tmp1,iglat,iglon1,1)
				NCDatasets.load!(ds["precipitationCal"].var,tmp2,iglat,iglon2,1)
			end
			close(ds)

			@debug "$(now()) - NASAPrecipitation.jl - Extraction of data from temporary array for the $(geo.name) GeoRegion"

			for ilat = 1 : nglat, ilon = 1 : nglon
				varii = tmp0[ilat,ilon]
				mskii = msk[ilon,ilat]
				if (varii != -9999.9f0) && !isnan(mskii)
					  var[ilon,ilat,dy] = varii / 86400
				else; var[ilon,ilat,dy] = NaN32
				end
			end

		end

		save(view(var,:,:,1:ndy),dt,npd,geo,ginfo)

	end

end

function download(
	npd :: TRMMMonthly{ST,DT},
	geo :: GeoRegion = GeoRegion("GLB")
) where {ST<:AbstractString, DT<:TimeType}

	@info "$(now()) - NASAPrecipitation.jl - Downloading $(npd.lname) data for the $(geo.name) GeoRegion from $(npd.dtbeg) to $(npd.dtend)"

	if geo.regID == "GLB"
		@info "$(now()) - NASAPrecipitation.jl - Global dataset request has been detected, switching to the TRMM GeoRegion"
		addNPDGeoRegions(); geo = GeoRegion("TRMM")
	else
		isinGeoRegion(geo,GeoRegion("TRMM"))
	end

	lon,lat = trmmlonlat(); nlon = length(lon); nlat = length(lat)
	ginfo = RegionGrid(geo,lon,lat)

	@info "$(now()) - NASAPrecipitation.jl - Preallocating temporary arrays for extraction of $(npd.lname) data for the $(geo.name) GeoRegion from the original gridded dataset"
	glon = ginfo.glon; nglon = length(glon); iglon = ginfo.ilon
	glat = ginfo.glat; nglat = length(glat); iglat = ginfo.ilat
	tmp0 = zeros(Float32,nglat,nglon)
	var  = zeros(Float32,nglon,nglat,12)

	if typeof(geo) <: PolyRegion
		  msk = ginfo.mask
	else; msk = ones(nglon,nglat)
	end

	if iglon[1] > iglon[end]
		shift == true
		iglon1 = iglon[1] : nlon; niglon1 = length(iglon1)
		iglon2 = 1 : iglon[end];  niglon2 = length(iglon2)
		tmp1 = @view tmp0[1:niglon1,:]
		tmp2 = @view tmp0[(niglon1+1):niglon2,:]
	else
		shift = false
		iglon = iglon[1] : iglon[end]
	end

	if iglat[1] > iglat[end]
		iglat = iglat[1] : -1 : iglat[end]
	else
		iglat = iglat[1] : iglat[end]
	end

	for dt in npd.dtbeg : Year(1) : npd.dtend

		@info "$(now()) - NASAPrecipitation.jl - Downloading $(npd.lname) data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(year(dt)) ..."

		npddir = joinpath(npd.hroot,"$(year(dt))")

		for mo in 1 : 12
			dtii   = Date(year(dt),mo,1)
			ymdfnc = "$(ymd2str(dtii))"
			npdfnc = "$(npd.fpref).$ymdfnc.$(npd.fsuff)"
			ds = NCDataset(joinpath(npddir,npdfnc))
			if !shift
				NCDatasets.load!(ds["precipitationCal"].var,tmp0,iglat,iglon,1)
			else
				NCDatasets.load!(ds["precipitationCal"].var,tmp1,iglat,iglon1,1)
				NCDatasets.load!(ds["precipitationCal"].var,tmp2,iglat,iglon2,1)
			end
			close(ds)

			@debug "$(now()) - NASAPrecipitation.jl - Extraction of data from temporary array for the $(geo.name) GeoRegion"

			for ilat = 1 : nglat, ilon = 1 : nglon
				varii = tmp0[ilat,ilon]
				mskii = msk[ilon,ilat]
				if (varii != -9999.9f0) && !isnan(mskii)
					  var[ilon,ilat,mo] = varii / 3600
				else; var[ilon,ilat,mo] = NaN32
				end
			end

		end

		save(var,dt,npd,geo,ginfo)

	end

end
