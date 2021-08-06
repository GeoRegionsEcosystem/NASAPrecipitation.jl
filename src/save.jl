function save(
	var   :: Array{Int16,3},
	isp   :: Array{Bool,3},
	dt    :: TimeType,
	npd   :: NASAPrecipitationDataset,
	geo   :: GeoRegion,
	ginfo :: RegionGrid,
	scale :: Vector{<:Real}
)

	@info "$(now()) - NASAPrecipitation.jl - Saving $(npd.lname) data in the $(geo.name) GeoRegion for $(dt)"

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

	ncvar = defVar(ds,"precipitationrate",Int16,("longitude","latitude","time"),attrib = Dict(
	    "units"         => "kg m**-2 s**-1",
	    "long_name"     => "log2_of_precipitation_rate",
		"full_name"     => "log2 of Precipitation Rate",
        "scale_factor"  => scale[1],
        "add_offset"    => scale[2],
        "_FillValue"    => Int16(-32767),
        "missing_value" => Int16(-32767),
	))

	ncisp = defVar(ds,"valid",Int8,("longitude","latitude","time"),attrib = Dict(
	    "units"         => "0-1",
	    "long_name"     => "valid_precipitation_measurement",
		"full_name"     => "Mask of Valid Precipitation Measurement",
	))

	nclon[:] = ginfo.glon
	nclat[:] = ginfo.glat
	ncisp[:] = isp
	ncvar.var[:] = var

	close(ds)

	@info "$(now()) - NASAPrecipitation.jl - $(npd.lname) data in the $(geo.name) GeoRegion for $(dt) has been saved into $(fnc)"

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
		@info "$(now()) - NASAPrecipitation.jl - Overwrite stale NetCDF file $(fnc) ..."
        rm(fnc);
	end

	@info "$(now()) - NASAPrecipitation.jl - Creating NetCDF file $(fnc) ..."
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
		@info "$(now()) - NASAPrecipitation.jl - Overwrite stale NetCDF file $(fnc) ..."
		rm(fnc);
	end

	@info "$(now()) - NASAPrecipitation.jl - Creating NetCDF file $(fnc) ..."
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
		@info "$(now()) - NASAPrecipitation.jl - Overwrite stale NetCDF file $(fnc) ..."
		rm(fnc);
	end

	@info "$(now()) - NASAPrecipitation.jl - Creating NetCDF file $(fnc) ..."
	ds = NCDataset(fnc,"c",attrib = Dict(
		"doi"				=> npd.doi,
		"AlgorithmID"		=> "3IMERGM",
		"AlgorithmVersion"	=> "3IMERGM_6.3",
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
		@info "$(now()) - NASAPrecipitation.jl - Overwrite stale NetCDF file $(fnc) ..."
		rm(fnc);
	end

	@info "$(now()) - NASAPrecipitation.jl - Creating NetCDF file $(fnc) ..."
	ds = NCDataset(fnc,"c",attrib = Dict(
		"doi"				=> npd.doi,
		"AlgorithmID"		=> "3B43",
		"AlgorithmVersion"	=> "3B43_7.0",
	))

	return ds,fnc

end
