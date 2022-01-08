function save(
	var   :: AbstractArray{Float32,3},
	dt    :: TimeType,
	npd   :: NASAPrecipitationDataset,
	geo   :: GeoRegion,
	ginfo :: RegionGrid,
)

	@info "$(modulelog()) - Saving $(npd.lname) data in the $(geo.name) GeoRegion for $(dt)"

	ds,fnc = makenpdnc(npd,geo,dt)

	ds.dim["longitude"] = length(ginfo.glon)
	ds.dim["latitude"]  = length(ginfo.glat)
	ds.dim["time"] 		= size(var,3)

	nclon = defVar(ds,"longitude",Float32,("longitude",),attrib = Dict(
	    "units"     => "degrees_east",
	    "long_name" => "longitude",
	))

	nclat = defVar(ds,"latitude",Float32,("latitude",),attrib = Dict(
	    "units"     => "degrees_north",
	    "long_name" => "latitude",
	))

	ncvar = defVar(ds,"prcp_rate",Float32,("longitude","latitude","time"),attrib = Dict(
	    "units"         => "kg m**-2 s**-1",
	    "long_name"     => "precipitation_rate",
		"full_name"     => "Precipitation Rate",
	))

	nclon[:] = ginfo.glon
	nclat[:] = ginfo.glat
	ncvar[:] = var

	close(ds)

	@info "$(modulelog()) - $(npd.lname) data in the $(geo.name) GeoRegion for $(dt) has been saved into $(fnc)"

end

function makenpdnc(
	npd :: IMERGHalfHourly,
	geo :: GeoRegion,
	dt  :: TimeType,
)

	fol = joinpath(npd.sroot,geo.regID,"raw",yrmo2dir(dt))
	if !isdir(fol); mkpath(fol) end
	fnc = joinpath(fol,"$(npd.npdID)-$(geo.regID)-$(ymd2str(dt)).nc")
	if isfile(fnc)
		@info "$(modulelog()) - Overwrite stale NetCDF file $(fnc) ..."
        rm(fnc);
	end

	@info "$(modulelog()) - Creating NetCDF file $(fnc) ..."
	ds = NCDataset(fnc,"c",attrib = Dict(
		"doi"				=> npd.doi,
		"AlgorithmID"		=> "3IMERGHH",
		"AlgorithmVersion"	=> "3IMERGH_6.3"
	))

	return ds,fnc

end

function makenpdnc(
	npd :: IMERGDaily,
	geo :: GeoRegion,
	dt  :: TimeType,
)

	fol = joinpath(npd.sroot,geo.regID,"raw","$(year(dt))")
	if !isdir(fol); mkpath(fol) end
	fnc = joinpath(fol,"$(npd.npdID)-$(geo.regID)-$(yrmo2str(dt)).nc")
	if isfile(fnc)
		@info "$(modulelog()) - Overwrite stale NetCDF file $(fnc) ..."
		rm(fnc);
	end

	@info "$(modulelog()) - Creating NetCDF file $(fnc) ..."
	ds = NCDataset(fnc,"c",attrib = Dict(
		"doi"				=> npd.doi,
		"AlgorithmID"		=> "3IMERGD",
	))

	return ds,fnc

end

function makenpdnc(
	npd :: IMERGMonthly,
	geo :: GeoRegion,
	dt  :: TimeType,
)

	fol = joinpath(npd.sroot,geo.regID,"raw")
	if !isdir(fol); mkpath(fol) end
	fnc = joinpath(fol,"$(npd.npdID)-$(geo.regID)-$(year(dt)).nc")
	if isfile(fnc)
		@info "$(modulelog()) - Overwrite stale NetCDF file $(fnc) ..."
		rm(fnc);
	end

	@info "$(modulelog()) - Creating NetCDF file $(fnc) ..."
	ds = NCDataset(fnc,"c",attrib = Dict(
		"doi"				=> npd.doi,
		"AlgorithmID"		=> "3IMERGM",
		"AlgorithmVersion"	=> "3IMERGM_6.3",
	))

	return ds,fnc

end

function makenpdnc(
	npd :: TRMM3Hourly,
	geo :: GeoRegion,
	dt  :: TimeType,
)

	fol = joinpath(npd.sroot,geo.regID,"raw",yrmo2dir(dt))
	if !isdir(fol); mkpath(fol) end
	fnc = joinpath(fol,"$(npd.npdID)-$(geo.regID)-$(ymd2str(dt)).nc")
	if isfile(fnc)
		@info "$(modulelog()) - Overwrite stale NetCDF file $(fnc) ..."
        rm(fnc);
	end

	@info "$(modulelog()) - Creating NetCDF file $(fnc) ..."
	ds = NCDataset(fnc,"c",attrib = Dict(
		"doi"				=> npd.doi,
		"AlgorithmID"		=> "3B42",
		"AlgorithmVersion"	=> "3B42_7.0"
	))

	return ds,fnc

end

function makenpdnc(
	npd :: TRMMDaily,
	geo :: GeoRegion,
	dt  :: TimeType,
)

	fol = joinpath(npd.sroot,geo.regID,"raw","$(year(dt))")
	if !isdir(fol); mkpath(fol) end
	fnc = joinpath(fol,"$(npd.npdID)-$(geo.regID)-$(yrmo2str(dt)).nc")
	if isfile(fnc)
		@info "$(modulelog()) - Overwrite stale NetCDF file $(fnc) ..."
		rm(fnc);
	end

	@info "$(modulelog()) - Creating NetCDF file $(fnc) ..."
	ds = NCDataset(fnc,"c",attrib = Dict(
		"doi"				=> npd.doi,
	))

	return ds,fnc

end

function makenpdnc(
	npd :: TRMMMonthly,
	geo :: GeoRegion,
	dt  :: TimeType,
)

	fol = joinpath(npd.sroot,geo.regID,"raw")
	if !isdir(fol); mkpath(fol) end
	fnc = joinpath(fol,"$(npd.npdID)-$(geo.regID)-$(year(dt)).nc")
	if isfile(fnc)
		@info "$(modulelog()) - Overwrite stale NetCDF file $(fnc) ..."
		rm(fnc);
	end

	@info "$(modulelog()) - Creating NetCDF file $(fnc) ..."
	ds = NCDataset(fnc,"c",attrib = Dict(
		"doi"				=> npd.doi,
		"AlgorithmID"		=> "3B43",
		"AlgorithmVersion"	=> "3B43_7.0",
	))

	return ds,fnc

end
