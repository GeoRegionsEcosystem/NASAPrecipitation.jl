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
    returnlsd :: Bool = true
)

	if geo.ID == "GLB"
		@info "$(modulelog()) - Global dataset request has been detected, switching to the Global (180 Grid) LandSea Mask GeoRegion"
		geo = GeoRegion("GLB180",path=geopath)
	else
		@info "$(modulelog()) - Checking to see if the specified GeoRegion \"$(geo.ID)\" is within the \"IMERG\" GeoRegion"
		in(geo,GeoRegion("GLB180",path=geopath),throw=true)
	end
	
	lsmfnc = joinpath(npd.maskpath,"imergmask-$(geo.ID).nc")

	if !isfile(lsmfnc)

		@info "$(modulelog()) - The IMERG Land-Sea mask dataset for the \"$(geo.ID)\" GeoRegion is not available, extracting from Global IMERG Land-Sea mask dataset ..."

		glbfnc = joinpath(npd.maskpath,"imergmask-GLB180.nc")
		if !isfile(glbfnc)
			@info "$(modulelog()) - The Global (180 Grid) IMERG Land-Sea mask dataset for the \"$(geo.ID)\" GeoRegion is not available, downloading from the NASA OPeNDAP servers ..."
			downloadLandSea(npd)
		end

		gds  = NCDataset(glbfnc)
		glon = gds["longitude"][:]
		glat = gds["latitude"][:]
		glsm = gds["lsm"][:,:]
		close(gds)

		ggrd = RegionGrid(geo,glon,glat)
		mask = ggrd.mask; mask[isnan.(mask)] .= 0

		@info "$(modulelog()) - Extracting regional IMERG Land-Sea mask for the \"$(geo.ID)\" GeoRegion from the Global (180 Grid) IMERG Land-Sea mask dataset ..."

		rlsm = extract(glsm,ggrd)

		saveLandSea(npd,geo,ggrd.lon,ggrd.lat,rlsm,Int16.(mask))

	end

	if returnlsd

		lds = NCDataset(lsmfnc)
		lon = nomissing(lds["longitude"][:],NaN)
		lat = nomissing(lds["latitude"][:],NaN)
		lsm = nomissing(lds["lsm"][:,:],NaN)
		close(lds)

		@info "$(modulelog()) - Retrieving the regional IMERG Land-Sea mask for the \"$(geo.ID)\" GeoRegion ..."

		return LandSeaFlat(lon,lat,lsm)

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

	saveLandSea(npd,GeoRegion("GLB180",path=geopath),lon,lat,var',mask)

end

function saveLandSea(
    npd  :: IMERGDataset,
    geo  :: GeoRegion,
    lon  :: Vector{<:Real},
    lat  :: Vector{<:Real},
    lsm  :: AbstractArray{<:Real,2},
    mask :: AbstractArray{Int16,2},
)

	fnc = joinpath(npd.maskpath,"imergmask-$(geo.ID).nc")
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