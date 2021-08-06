struct IMERGEarlyDY{ST<:AbstractString, DT<:TimeType} <: GPMDaily
	npdID :: ST
    dtbeg :: DT
    dtend :: DT
    sroot :: ST
    hroot :: ST
    fpref :: ST
    fsuff :: ST
end


function IMERGEarlyDY(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString,
)

	@info "$(now()) - NASAPrecipitation.jl - Setting up data structure containing information on Early IMERG Daily data to be downloaded"

    fol = joinpath(sroot,"imergearlydy"); if !isdir(fol); mkpath(fol) end

	dtbeg = Date(year(dtbeg),month(dtbeg),1)
	dtend = Date(year(dtend),month(dtend),daysinmonth(dtend))

    return IMERGEarlyDY{ST,DT}(
		"imergearlydy",
        dtbeg,dtend,joinpath(sroot,"imergearlydy"),
        "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGDE.06",
        "3B-DAY-E.MS.MRG.3IMERG",
        "S000000-E235959.V06.nc4",
    )

end

function download(
	npd :: IMERGEarlyDY{ST,DT},
	geo :: GeoRegion
) where {ST<:AbstractString, DT<:TimeType}

	@info "$(now()) - NASAPrecipitation.jl - Downloading Early IMERG Daily data for the $(geo.name) GeoRegion from $(npd.dtbeg) to $(npd.dtend)"

	fnc  = imergrawfiles()
	lon,lat = gpmlonlat(); nlon = length(lon); nlat = length(lat)
	ginfo = RegionGrid(geo,lon,lat)

	@info "$(now()) - NASAPrecipitation.jl - Preallocating temporary arrays for extraction of Early IMERG Daily data for the $(geo.name) GeoRegion from the original gridded dataset"
	glon = ginfo.glon; nglon = length(glon); iglon = ginfo.ilon
	glat = ginfo.glat; nglat = length(glat); iglat = ginfo.ilat
	tmp  = zeros(Float32,nlat,nlon)
	var  = zeros(Float32,nglon,nglat,31)
	vint = zeros(Int16,nglon,nglat,31)
	isp  = zeros(Bool,nglon,nglat,31)

	for dt in npd.dtbeg : Month(1) : npd.dtend

		@info "$(now()) - NASAPrecipitation.jl - Downloading Early IMERG Daily data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(ymd2str(dt)) ..."

		npddir = joinpath(npd.hroot,"$(yrmo2dir(dt))")
		ndy = daysinmonth(dt)

		for dy in 1 : ndy
			dtii   = Date(year(dt),month(dt),dy)
			ymdfnc = "$(ymd2str(dtii))"
			npdfnc = "$(npd.fpref).$ymdfnc-$(npd.fsuff)"
			ds = NCDataset(joinpath(npddir,npdfnc))
			NCDatasets.load!(ds["precipitationCal"].var,tmp,:,:,1)
			close(ds)

			@debug "$(now()) - NASAPrecipitation.jl - Extraction of data from temporary array for the $(geo.name) GeoRegion"

			for ilat = 1 : nglat, ilon = 1 : nglon
				varii = tmp[iglat[ilat],iglon[ilon]]
				if varii != 9999.9 && !iszero(varii)
					  var[ilon,ilat,dy] = log2(varii/86400)
					  isp[ilon,ilat,dy] = 1
				elseif iszero(varii)
					  var[ilon,ilat,dy] = NaN32
					  isp[ilon,ilat,dy] = 1
				else; var[ilon,ilat,dy] = NaN32
				end
			end

		end

		@debug "$(now()) - NASAPrecipitation.jl - Converting data from Float32 format to Int16 format in order to save space ..."
		scale,offset = ncoffsetscale(view(var,:,:,1:ndy))
		real2int16!(vint,view(var,:,:,1:ndy),scale,offset)

		save(view(vint,:,:,1:ndy),view(isp,:,:,1:ndy),dt,npd,geo,ginfo,[scale,offset])
	end

end

function save(
	var   :: AbstractArray{Int16,3},
	isp   :: AbstractArray{Bool,3},
	dt    :: TimeType,
	npd   :: IMERGEarlyDY,
	geo   :: GeoRegion,
	ginfo :: RegionGrid,
	scale :: Vector{<:Real}
)

	@info "$(now()) - NASAPrecipitation.jl - Saving Early IMERG Daily data in the $(geo.name) GeoRegion for $(Dates.format(dt,dateformat"yyyy-mm"))"

	fol = joinpath(npd.sroot,geo.regID,"raw","$(year(dt))")
	if !isdir(fol); mkpath(fol) end
	fnc = joinpath(fol,"$(npd.npdID)-$(geo.regID)-$(yrmo2str(dt)).nc")
	if isfile(fnc)
		@info "$(now()) - NASAPrecipitation.jl - Overwrite stale NetCDF file $(fnc) ..."
        rm(fnc);
	end

	@info "$(now()) - NASAPrecipitation.jl - Creating NetCDF file $(fnc) ..."
	ds = NCDataset(fnc,"c",attrib = Dict(
		"doi"				=> "10.5067/GPM/IMERGDE/DAY/06",
		"AlgorithmID"		=> "3IMERGD",
	))

	ndy = daysinmonth(dt)
	ds.dim["longitude"] = length(ginfo.glon)
	ds.dim["latitude"]  = length(ginfo.glat)
	ds.dim["time"] 		= ndy

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

	@info "$(now()) - NASAPrecipitation.jl - Early IMERG Daily data in the $(geo.name) GeoRegion for $(Dates.format(dt,dateformat"yyyy-mm")) has been saved into $(fnc)"

end

function show(io::IO, npd::IMERGEarlyDY{ST,DT}) where {ST<:AbstractString, DT<:TimeType}
    print(
		io,
		"The NASA Precipitation Dataset {$ST,$DT} is Early IMERG (Daily):\n",
		"    Data Directory  : ", npd.sroot, '\n',
		"    Date Begin      : ", npd.dtbeg, '\n',
		"    Date End        : ", npd.dtend, '\n',
		"    Timestep        : 1 Day\n",
        "    Data Resolution : 0.1º\n",
        "    Data Server     : ", npd.hroot, '\n',
	)
end
