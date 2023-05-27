function getLandSea(
	npd :: TRMMDataset,
	geo :: GeoRegion = GeoRegion("GLB");
    returnlsd = true,
    FT = Float32
)

	if geo.ID == "GLB"
		@info "$(modulelog()) - Global dataset request has been detected, switching to the TRMM LandSea Mask GeoRegion"
		addNPDGeoRegions(); geo = GeoRegion("TRMMLSM")
	else
		@info "$(modulelog()) - Checking to see if the specified GeoRegion \"$(geo.ID)\" is within the \"TRMMLSM\" GeoRegion"
		isinGeoRegion(geo,GeoRegion("TRMMLSM"))
	end
	lsmfnc = joinpath(npd.maskpath,"trmmmask-$(geo.ID).nc")

	if !isfile(lsmfnc)

		@info "$(modulelog()) - The TRMM Land-Sea mask dataset for the \"$(geo.ID)\" GeoRegion is not available, extracting from Global TRMM Land-Sea mask dataset ..."

		glbfnc = joinpath(npd.maskpath,"trmmmask-TRMMLSM.nc")
		if !isfile(glbfnc)
			@info "$(modulelog()) - The Global TRMM Land-Sea mask dataset for the \"$(geo.ID)\" GeoRegion is not available, downloading from the Climate Data Store ..."
			downloadLandSea(npd)
		end

		gds  = NCDataset(glbfnc)
		glon = gds["longitude"][:]
		glat = gds["latitude"][:]
		glsm = gds["lsm"][:]
		close(gds)

		rinfo = RegionGrid(geo,glon,glat)
		ilon  = rinfo.ilon; nlon = length(rinfo.ilon)
		ilat  = rinfo.ilat; nlat = length(rinfo.ilat)
		rlsm  = zeros(nlon,nlat)
		
		if typeof(rinfo) <: PolyGrid
			  mask = rinfo.mask; mask[isnan.(mask)] .= 0
		else; mask = ones(Int16,nlon,nlat)
		end

		@info "$(modulelog()) - Extracting regional TRMM Land-Sea mask for the \"$(geo.ID)\" GeoRegion from the Global TRMM Land-Sea mask dataset ..."

		for iglat = 1 : nlat, iglon = 1 : nlon
			if isone(mask[iglon,iglat])
				rlsm[iglon,iglat] = glsm[ilon[iglon],ilat[iglat]]
			else
				rlsm[iglon,iglat] = NaN
			end
		end

		saveLandSea(npd,geo,rinfo.lon,rinfo.lat,rlsm,Int16.(mask))

	end

	if returnlsd

		lds = NCDataset(lsmfnc)
		lon = lds["longitude"][:]
		lat = lds["latitude"][:]
		lsm = lds["lsm"][:]
		msk = lds["mask"][:]
		close(lds)

		@info "$(modulelog()) - Retrieving the regional TRMM Land-Sea mask for the \"$(geo.ID)\" GeoRegion ..."

		return LandSea{FT}(lon,lat,lsm,msk)

	else

		return nothing

	end

end

function downloadLandSea(
	npd :: TRMMDataset
)

	lon,lat = trmmlonlat(full=true)
	nlon = length(lon)
	nlat = length(lat)
	var  = zeros(Float32,nlat,nlon)
	mask = ones(Int16,nlon,nlat)

	@info "$(modulelog()) - Retrieving the original TRMM-TMPA Land-Sea Mask data from NASA's EOSDIS OPeNDAP servers"
	hroot = "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/AUXILIARY"
    npdnc = "TRMM_TMPA_LandSeaMask.2/TRMM_TMPA_LandSeaMask.2.nc4"
    npdds = NCDataset(joinpath(hroot,npdnc))
	NCDatasets.load!(npdds["landseamask"].var,var,:,:)
	close(npdds)

	saveLandSea(npd,GeoRegion("TRMMLSM"),lon,lat,var',mask)

end

function saveLandSea(
    npd  :: TRMMDataset,
    geo  :: GeoRegion,
    lon  :: Vector{<:Real},
    lat  :: Vector{<:Real},
    lsm  :: AbstractArray{<:Real,2},
    mask :: AbstractArray{Int16,2},
)

    fnc = joinpath(npd.maskpath,"trmmmask-$(geo.ID).nc")
    if isfile(fnc)
        rm(fnc,force=true)
    end

    ds = NCDataset(fnc,"c",attrib = Dict(
		"Conventions" => "CF-1.4",
		"NCO"         => "4.5.1",
		"Authors"     => "Bill Olson, Dave Bolvin, George Huffman",
		"Description" => "This TMPA land sea mask contains values ranging from 0% to 100% with 0% representing all land and 100% representing all ocean",
		"Title"       => "Land/Sea static mask relevant to TMPA precipitation 0.25x0.25 degree",
		"Version"     => "2",
		"History"     => "This land sea mask originated from the NOAA group at SSEC in the 1980s. It was originally produced at 1/6 deg resolution, and then regridded for the purposes of GPCP, TMPA, and IMERG precipitation products. NASA code 610.2, Global Change Data Center, restructured this TMPA land sea mask to match the TMPA grid, and converted the file to CF-compliant netCDF4. Version 2 was created in May, 2019 to resolve detected inaccuracies in coastal regions.",
		"DOI"         => "10.5067/K1VR7BN7YDWN",
	))

    ds.dim["longitude"] = length(lon)
    ds.dim["latitude"]  = length(lat)

    nclon = defVar(ds,"longitude",Float32,("longitude",),attrib = Dict(
        "units"     => "degrees_east",
        "long_name" => "longitude",
    ))

    nclat = defVar(ds,"latitude",Float32,("latitude",),attrib = Dict(
        "units"     => "degrees_north",
        "long_name" => "latitude",
    ))

    nclsm = defVar(ds,"lsm",Float32,("longitude","latitude",),attrib = Dict(
        "long_name"     => "land_sea_mask",
        "full_name"     => "Land-Sea Mask",
        "units"         => "0-1",
    ))

    ncmsk = defVar(ds,"mask",Int16,("longitude","latitude",),attrib = Dict(
        "long_name"     => "georegion_mask",
        "full_name"     => "GeoRegion Mask",
        "units"         => "0-1",
    ))

    nclon[:] = lon
    nclat[:] = lat
	nclsm[:] = lsm
    ncmsk[:] = mask

    close(ds)

end

##############################################################################

function getTRMMlsd(
	geo  :: GeoRegion = GeoRegion("GLB");
	path :: AbstractString,
    returnlsd = true,
    FT = Float32
)

	if geo.ID == "GLB"
		@info "$(modulelog()) - Global dataset request has been detected, switching to the TRMM LandSea Mask GeoRegion"
		addNPDGeoRegions(); geo = GeoRegion("TRMMLSM")
	else
		@info "$(modulelog()) - Checking to see if the specified GeoRegion \"$(geo.ID)\" is within the \"TRMMLSM\" GeoRegion"
		isinGeoRegion(geo,GeoRegion("TRMMLSM"))
	end
	lsmfnc = joinpath(path,"trmmmask-$(geo.ID).nc")

	if !isfile(lsmfnc)

		@info "$(modulelog()) - The TRMM Land-Sea mask dataset for the \"$(geo.ID)\" GeoRegion is not available, extracting from Global TRMM Land-Sea mask dataset ..."

		glbfnc = joinpath(path,"trmmmask-TRMMLSM.nc")
		if !isfile(glbfnc)
			@info "$(modulelog()) - The Global TRMM Land-Sea mask dataset for the \"$(geo.ID)\" GeoRegion is not available, downloading from the Climate Data Store ..."
			downloadTRMMlsd(path)
		end

		gds  = NCDataset(glbfnc)
		glon = gds["longitude"][:]
		glat = gds["latitude"][:]
		glsm = gds["lsm"][:]
		close(gds)

		rinfo = RegionGrid(geo,glon,glat)
		ilon  = rinfo.ilon; nlon = length(rinfo.ilon)
		ilat  = rinfo.ilat; nlat = length(rinfo.ilat)
		rlsm  = zeros(nlon,nlat)
		
		if typeof(rinfo) <: PolyGrid
			  mask = rinfo.mask; mask[isnan.(mask)] .= 0
		else; mask = ones(Int16,nlon,nlat)
		end

		@info "$(modulelog()) - Extracting regional TRMM Land-Sea mask for the \"$(geo.ID)\" GeoRegion from the Global TRMM Land-Sea mask dataset ..."

		for iglat = 1 : nlat, iglon = 1 : nlon
			if isone(mask[iglon,iglat])
				rlsm[iglon,iglat] = glsm[ilon[iglon],ilat[iglat]]
			else
				rlsm[iglon,iglat] = NaN
			end
		end

		saveTRMMlsd(geo,rinfo.lon,rinfo.lat,rlsm,Int16.(mask),path)

	end

	if returnlsd

		lds = NCDataset(lsmfnc)
		lon = lds["longitude"][:]
		lat = lds["latitude"][:]
		lsm = lds["lsm"][:]
		msk = lds["mask"][:]
		close(lds)

		@info "$(modulelog()) - Retrieving the regional TRMM Land-Sea mask for the \"$(geo.ID)\" GeoRegion ..."

		return LandSea{FT}(lon,lat,lsm,msk)

	else

		return nothing

	end

end

function downloadTRMMlsd(
	path :: AbstractString
)

	lon,lat = trmmlonlat(full=true)
	nlon = length(lon)
	nlat = length(lat)
	var  = zeros(Float32,nlat,nlon)
	mask = ones(Int16,nlon,nlat)

	@info "$(modulelog()) - Retrieving the original TRMM-TMPA Land-Sea Mask data from NASA's EOSDIS OPeNDAP servers"
	hroot = "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/AUXILIARY"
    npdnc = "TRMM_TMPA_LandSeaMask.2/TRMM_TMPA_LandSeaMask.2.nc4"
    npdds = NCDataset(joinpath(hroot,npdnc))
	NCDatasets.load!(npdds["landseamask"].var,var,:,:)
	close(npdds)

	saveTRMMlsd(GeoRegion("TRMMLSM"),lon,lat,var',mask,path)

end

function saveTRMMlsd(
    geo  :: GeoRegion,
    lon  :: Vector{<:Real},
    lat  :: Vector{<:Real},
    lsm  :: AbstractArray{<:Real,2},
    mask :: AbstractArray{Int16,2},
	path :: AbstractString
)

    fnc = joinpath(path,"trmmmask-$(geo.ID).nc")
    if isfile(fnc)
        rm(fnc,force=true)
    end

    ds = NCDataset(fnc,"c",attrib = Dict(
		"Conventions" => "CF-1.4",
		"NCO"         => "4.5.1",
		"Authors"     => "Bill Olson, Dave Bolvin, George Huffman",
		"Description" => "This TMPA land sea mask contains values ranging from 0% to 100% with 0% representing all land and 100% representing all ocean",
		"Title"       => "Land/Sea static mask relevant to TMPA precipitation 0.25x0.25 degree",
		"Version"     => "2",
		"History"     => "This land sea mask originated from the NOAA group at SSEC in the 1980s. It was originally produced at 1/6 deg resolution, and then regridded for the purposes of GPCP, TMPA, and IMERG precipitation products. NASA code 610.2, Global Change Data Center, restructured this TMPA land sea mask to match the TMPA grid, and converted the file to CF-compliant netCDF4. Version 2 was created in May, 2019 to resolve detected inaccuracies in coastal regions.",
		"DOI"         => "10.5067/K1VR7BN7YDWN",
	))

    ds.dim["longitude"] = length(lon)
    ds.dim["latitude"]  = length(lat)

    nclon = defVar(ds,"longitude",Float32,("longitude",),attrib = Dict(
        "units"     => "degrees_east",
        "long_name" => "longitude",
    ))

    nclat = defVar(ds,"latitude",Float32,("latitude",),attrib = Dict(
        "units"     => "degrees_north",
        "long_name" => "latitude",
    ))

    nclsm = defVar(ds,"lsm",Float32,("longitude","latitude",),attrib = Dict(
        "long_name"     => "land_sea_mask",
        "full_name"     => "Land-Sea Mask",
        "units"         => "0-1",
    ))

    ncmsk = defVar(ds,"mask",Int16,("longitude","latitude",),attrib = Dict(
        "long_name"     => "georegion_mask",
        "full_name"     => "GeoRegion Mask",
        "units"         => "0-1",
    ))

    nclon[:] = lon
    nclat[:] = lat
	nclsm[:] = lsm
    ncmsk[:] = mask

    close(ds)

end