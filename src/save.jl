function save(
	var  :: AbstractArray{Float32,3},
	dt   :: TimeType,
	npd  :: NASAPrecipitationDataset,
	geo  :: GeoRegion,
	ggrd :: RegionGrid;
    smooth  :: Bool = false,
    smoothlon  :: Real = 0,
    smoothlat  :: Real = 0,
    smoothtime :: Int = 0,
)

	@info "$(modulelog()) - Saving $(npd.name) data in the $(geo.name) GeoRegion for $(dt)"

	fnc = npdfnc(npd,geo,dt)
	if smooth
        fnc = npdsmth(npd,geo,dt,smoothlon,smoothlat,smoothtime)
    end
	if !isdir(dirname(fnc)); mkpath(dirname(fnc)) end
	if isfile(fnc)
		@info "$(modulelog()) - Overwrite stale NetCDF file $(fnc) ..."
        rm(fnc)
	end
	@info "$(modulelog()) - Creating NetCDF file $(fnc) ..."
	pds = makenpdnc(npd,fnc)

	pds.dim["longitude"] = length(ggrd.lon)
	pds.dim["latitude"]  = length(ggrd.lat)
	pds.dim["time"]      = size(var,3)

	nclon = defVar(pds,"longitude",Float32,("longitude",),attrib = Dict(
	    "units"     => "degrees_east",
	    "long_name" => "longitude",
	))

	nclat = defVar(pds,"latitude",Float32,("latitude",),attrib = Dict(
	    "units"     => "degrees_north",
	    "long_name" => "latitude",
	))

	ncvar = defVar(pds,"precipitation",Float32,("longitude","latitude","time"),attrib = Dict(
	    "units"     => "kg m**-2 s**-1",
	    "long_name" => "precipitation_rate",
		"full_name" => "Precipitation Rate",
	))

	nclon[:] = ggrd.lon
	nclat[:] = ggrd.lat
	ncvar[:,:,:] = var

	close(pds)

	@info "$(modulelog()) - $(npd.name) data in the $(geo.name) GeoRegion for $(dt) has been saved into $(fnc)"

end

function save(
	var :: AbstractArray{Float32,3},
	dt  :: TimeType,
	npd :: NASAPrecipitationDataset,
	geo :: GeoRegion,
	lsd :: LandSeaData;
    smooth  :: Bool = false,
    smoothlon  :: Real = 0,
    smoothlat  :: Real = 0,
    smoothtime :: Int = 0,
)

	@info "$(modulelog()) - Saving $(npd.name) data in the $(geo.name) GeoRegion for $(dt)"

	fnc = npdfnc(npd,geo,dt)
	if smooth
        fnc = npdsmth(npd,geo,dt,smoothlon,smoothlat,smoothtime)
    end
	if !isdir(dirname(fnc)); mkpath(dirname(fnc)) end
	if isfile(fnc)
		@info "$(modulelog()) - Overwrite stale NetCDF file $(fnc) ..."
        rm(fnc)
	end
	@info "$(modulelog()) - Creating NetCDF file $(fnc) ..."
	pds = makenpdnc(npd,fnc)

	pds.dim["longitude"] = length(lsd.lon)
	pds.dim["latitude"]  = length(lsd.lat)
	pds.dim["time"]      = size(var,3)

	nclon = defVar(pds,"longitude",Float32,("longitude",),attrib = Dict(
	    "units"     => "degrees_east",
	    "long_name" => "longitude",
	))

	nclat = defVar(pds,"latitude",Float32,("latitude",),attrib = Dict(
	    "units"     => "degrees_north",
	    "long_name" => "latitude",
	))

	ncvar = defVar(pds,"precipitation",Float32,("longitude","latitude","time"),attrib = Dict(
	    "units"     => "kg m**-2 s**-1",
	    "long_name" => "precipitation_rate",
		"full_name" => "Precipitation Rate",
	))

	nclon[:] = lsd.lon
	nclat[:] = lsd.lat
	ncvar[:,:,:] = var

	close(pds)

	@info "$(modulelog()) - $(npd.name) data in the $(geo.name) GeoRegion for $(dt) has been saved into $(fnc)"

end

function makenpdnc(
	npd :: IMERGHalfHourly,
	fnc :: AbstractString
)

	return NCDataset(fnc,"c",attrib = Dict(
		"doi"              => npd.doi,
		"AlgorithmID"      => "3IMERGHH",
		"AlgorithmVersion" => "3IMERGH_6.3"
	))

end

function makenpdnc(
	npd :: IMERGDaily,
	fnc :: AbstractString
)

	return NCDataset(fnc,"c",attrib = Dict(
		"doi"         => npd.doi,
		"AlgorithmID" => "3IMERGD",
	))

end

function makenpdnc(
	npd :: IMERGMonthly,
	fnc :: AbstractString
)

	return NCDataset(fnc,"c",attrib = Dict(
		"doi"              => npd.doi,
		"AlgorithmID"      => "3IMERGM",
		"AlgorithmVersion" => "3IMERGM_6.3",
	))

end

function makenpdnc(
	npd :: TRMM3Hourly,
	fnc :: AbstractString
)

	return NCDataset(fnc,"c",attrib = Dict(
		"doi"              => npd.doi,
		"AlgorithmID"      => "3B42",
		"AlgorithmVersion" => "3B42_7.0"
	))

end

function makenpdnc(
	npd :: TRMMDaily,
	fnc :: AbstractString
)

	return NCDataset(fnc,"c",attrib = Dict("doi"=>npd.doi))

end

function makenpdnc(
	npd :: TRMMMonthly,
	fnc :: AbstractString
)

	return NCDataset(fnc,"c",attrib = Dict(
		"doi"              => npd.doi,
		"AlgorithmID"      => "3B43",
		"AlgorithmVersion" => "3B43_7.0",
	))

end
