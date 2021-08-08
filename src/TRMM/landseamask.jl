"""
    getTRMMlsm(
        geo :: GeoRegion = GeoRegion("GLB");
	    sroot :: AbstractString = pwd()
    ) -> nothing

Downloads the TRMM-TMPA Land-Sea Mask for a GeoRegion specified by `geo` and saves it into `sroot`

Arguments
=========
- `geo` : a `GeoRegion` (see [GeoRegions.jl](https://github.com/JuliaClimate/GeoRegions.jl)) that sets the geographic bounds of the data array in lon-lat

Keyword Arguments
=================
- `sroot` : the directory to save the TRMM-TMPA Land-Sea Mask
"""
function getTRMMlsm(
	geo   :: GeoRegion = GeoRegion("GLB");
    sroot :: AbstractString = pwd(),
)

    @info "$(now()) - NASAPrecipitation.jl - Retrieving Land-Sea Mask for the TRMM-TMPA dataset"

	if geo.regID == "GLB"
		@info "$(now()) - NASAPrecipitation.jl - Global dataset request has been detected, switching to the TRMM LandSea Mask GeoRegion"
		addNPDGeoRegions(); geo = GeoRegion("TRMMLSM")
	else
		isinGeoRegion(geo,GeoRegion("TRMMLSM"))
	end

    lon,lat = trmmlonlat(full=true); nlon = length(lon); nlat = length(lat)
	ginfo = RegionGrid(geo,lon,lat)

	@info "$(now()) - NASAPrecipitation.jl - Preallocating temporary array for extraction of TRMM-TMPA Land-Sea Mask data for the $(geo.name) GeoRegion from the original global gridded dataset"
	glon = ginfo.glon; nglon = length(glon); iglon = ginfo.ilon
	glat = ginfo.glat; nglat = length(glat); iglat = ginfo.ilat
	tmp  = zeros(Float32,nlat,nlon)
	var  = zeros(Float32,nglon,nglat)

	@info "$(now()) - NASAPrecipitation.jl - Retrieving the original TRMM-TMPA Land-Sea Mask data from NASA's EOSDIS OPeNDAP servers"
	hroot = "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/AUXILIARY"
    npdnc = "TRMM_TMPA_LandSeaMask.2/TRMM_TMPA_LandSeaMask.2.nc4"
    npdds = NCDataset(joinpath(hroot,npdnc))
	NCDatasets.load!(npdds["landseamask"].var,tmp,:,:)
	close(npdds)

	@debug "$(now()) - NASAPrecipitation.jl - Extraction of data from temporary array for the $(geo.name) GeoRegion"

	extractregionlsm!(var,tmp,ginfo)

	saveTRMMlsm(var,geo,ginfo,sroot)

end

function saveTRMMlsm(
	lsm   :: AbstractArray{<:Real,2},
	geo   :: GeoRegion,
	ginfo :: RegionGrid,
	sroot :: AbstractString
)

	@info "$(now()) - NASAPrecipitation.jl - Saving TRMM-TMPA Land-Sea Mask data in the $(geo.name) GeoRegion"

	if !isdir(sroot); mkpath(sroot) end
	fnc = joinpath(sroot,"trmmlsm-$(geo.regID).nc")
	if isfile(fnc)
		@info "$(now()) - NASAPrecipitation.jl - Overwrite stale NetCDF file $(fnc) ..."
		rm(fnc);
	end

	@info "$(now()) - NASAPrecipitation.jl - Creating NetCDF file $(fnc) ..."
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

	ds.dim["longitude"] = length(ginfo.glon)
	ds.dim["latitude"]  = length(ginfo.glat)

	nclon = defVar(ds,"longitude",Float32,("longitude",),attrib = Dict(
	    "units"     => "degrees_east",
	    "long_name" => "longitude",
	))

	nclat = defVar(ds,"latitude",Float32,("latitude",),attrib = Dict(
	    "units"     => "degrees_north",
	    "long_name" => "latitude",
	))

	nclsm = defVar(ds,"lsm",Float32,("longitude","latitude",),attrib = Dict(
	    "units"         => "0-1",
	    "long_name"     => "land_sea_mask",
		"full_name"     => "Land-Sea Mask",
	))

	nclon[:] = ginfo.glon
	nclat[:] = ginfo.glat
	nclsm[:] = 1 .- lsm/100

	close(ds)

	@info "$(now()) - NASAPrecipitation.jl - TRMM-TMPA Land-Sea Mask data in the $(geo.name) GeoRegion has been saved into $(fnc)"

end
