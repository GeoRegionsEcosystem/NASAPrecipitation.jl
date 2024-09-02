"""
    getLandSea(
        npd :: NASAPrecipitationDataset,
	    geo :: GeoRegion = GeoRegion("GLB");
	    returnlsd = true,
	    FT = Float32
    ) -> LandSea

Retrieve the Land-Sea Mask data for the `NASAPrecipitationDataset` specified.

Arguments
=========
- `npd` : The `NASAPrecipitationDataset` specified, can be either IMERG or TRMM, the function will download the relevant Land-Sea mask without needing further specification.
- `geo` : The GeoRegion of interest

Keyword Arguments
=================
- `returnlsd` : If `true` return the data as a `LandSea` dataset. Otherwise, the data is simply saved into the npd.maskpath directory.
"""
function getLandSea(
	npd :: IMERGDataset,
	geo :: GeoRegion = GeoRegion("GLB");
    returnlsd :: Bool = true,
    smooth    :: Bool = false,
    σlon :: Int = 0,
    σlat :: Int = 0,
    iterations :: Int = 100,
    FT = Float32
)

	if geo.ID == "GLB"
		@info "$(modulelog()) - Global dataset request has been detected, switching to the IMERG LandSea Mask GeoRegion"
		addNPDGeoRegions(); geo = GeoRegion("IMERG")
	else
		@info "$(modulelog()) - Checking to see if the specified GeoRegion \"$(geo.ID)\" is within the \"IMERG\" GeoRegion"
		isinGeoRegion(geo,GeoRegion("IMERG"))
	end
	
	if !smooth
        lsmfnc = joinpath(npd.maskpath,"imergmask-$(geo.ID).nc")
    else
        lsmfnc = joinpath(npd.maskpath,"imergmask-$(geo.ID)-smooth_$(σlon)x$(σlat).nc")
    end

	if !isfile(lsmfnc)

		@info "$(modulelog()) - The IMERG Land-Sea mask dataset for the \"$(geo.ID)\" GeoRegion is not available, extracting from Global IMERG Land-Sea mask dataset ..."

		glbfnc = joinpath(npd.maskpath,"imergmask-IMERG.nc")
		if !isfile(glbfnc)
			@info "$(modulelog()) - The Global IMERG Land-Sea mask dataset for the \"$(geo.ID)\" GeoRegion is not available, downloading from the NASA OPeNDAP servers ..."
			downloadLandSea(npd)
		end

		gds  = NCDataset(glbfnc)
		glon = gds["longitude"][:]
		glat = gds["latitude"][:]
		glsm = gds["lsm"][:,:]
		close(gds)

        if smooth
            smooth!(glsm,σlon=σlon,σlat=σlat,iterations=iterations)
        end

		ggrd = RegionGrid(geo,glon,glat)
		ilon  = ggrd.ilon; nlon = length(ggrd.ilon)
		ilat  = ggrd.ilat; nlat = length(ggrd.ilat)
		rlsm  = zeros(nlon,nlat)
		
		if typeof(ggrd) <: RectGrid
			  mask = ones(Int16,nlon,nlat)
		else; mask = ggrd.mask; mask[isnan.(mask)] .= 0
		end

		@info "$(modulelog()) - Extracting regional IMERG Land-Sea mask for the \"$(geo.ID)\" GeoRegion from the Global IMERG Land-Sea mask dataset ..."

		for iglat = 1 : nlat, iglon = 1 : nlon
			if isone(mask[iglon,iglat])
				rlsm[iglon,iglat] = glsm[ilon[iglon],ilat[iglat]]
			else
				rlsm[iglon,iglat] = NaN
			end
		end

		saveLandSea(npd,geo,ggrd.lon,ggrd.lat,rlsm,Int16.(mask),smooth,σlon,σlat)

	end

	if returnlsd

		lds = NCDataset(lsmfnc)
		lon = lds["longitude"][:]
		lat = lds["latitude"][:]
		lsm = lds["lsm"][:,:]
		msk = lds["mask"][:,:]
		close(lds)

		@info "$(modulelog()) - Retrieving the regional IMERG Land-Sea mask for the \"$(geo.ID)\" GeoRegion ..."

		return LandSea{FT}(lon,lat,lsm,msk)

	else

		return nothing

	end

end

function downloadLandSea(
	npd :: IMERGDataset
)

	lon,lat = gpmlonlat()
	nlon = length(lon)
	nlat = length(lat)
	var  = zeros(Float32,nlat,nlon)
	mask = ones(Int16,nlon,nlat)

	@info "$(modulelog()) - Retrieving the original IMERG Land-Sea Mask data from NASA's EOSDIS OPeNDAP servers"
	hroot = "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/AUXILIARY"
    npdnc = "GPM_IMERG_LandSeaMask.2/GPM_IMERG_LandSeaMask.2.nc4"
    npdds = NCDataset(joinpath(hroot,npdnc),"r")
	NCDatasets.load!(npdds["landseamask"].var,var,:,:)
	close(npdds)

	for ilon = 1 : nlon, ilat = 1 : nlat
		var[ilat,ilon] = 1 - var[ilat,ilon] / 100
	end

	saveLandSea(npd,GeoRegion("IMERG"),lon,lat,var',mask)

end

function saveLandSea(
    npd  :: IMERGDataset,
    geo  :: GeoRegion,
    lon  :: Vector{<:Real},
    lat  :: Vector{<:Real},
    lsm  :: AbstractArray{<:Real,2},
    mask :: AbstractArray{Int16,2},
    smooth :: Bool = false,
    σlon :: Int = 0,
    σlat :: Int = 0,
)

	if !smooth
		fnc = joinpath(npd.maskpath,"imergmask-$(geo.ID).nc")
	else
		fnc = joinpath(npd.maskpath,"imergmask-$(geo.ID)-smooth_$(σlon)x$(σlat).nc")
	end
    if isfile(fnc)
        rm(fnc,force=true)
    end

    ds = NCDataset(fnc,"c",attrib = Dict(
		"Conventions" => "CF-1.4",
		"NCO"         => "4.5.1",
		"Authors"     => "Bill Olson, Dave Bolvin, George Huffman",
		"Description" => "This IMERG land sea mask contains values ranging from 0% to 100% with 0% representing all land and 100% representing all ocean",
		"Title"       => "Land/Sea static mask relevant to IMERG precipitation 0.1x0.1 degree",
		"Version"     => "2",
		"History"     => "This land sea mask originated from the NOAA group at SSEC in the 1980s. It was originally produced at 1/6 deg resolution, and then regridded for the purposes of GPCP, TMPA, and IMERG precipitation products. NASA code 610.2, Global Change Data Center, restructured this IMERG land sea mask to match the IMERG grid, and converted the file to CF-compliant netCDF4. Version 2 was created in May, 2019 to resolve detected inaccuracies in coastal regions.",
		"DOI"         => "10.5067/6P5EM1HPR3VD",
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
	nclsm[:,:] = lsm
    ncmsk[:,:] = mask

    close(ds)

end