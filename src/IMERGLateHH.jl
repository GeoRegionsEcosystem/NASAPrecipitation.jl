struct IMERGLateHH{ST<:AbstractString, DT<:TimeType} <: RawGPMDataset
	npdID :: ST
    dtbeg :: DT
    dtend :: DT
    sroot :: ST
    hroot :: ST
    fpref :: ST
    fsuff :: ST
end


function IMERGLateHH(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString,
)

	@info "$(now()) - NASAPrecipitation.jl - Setting up data structure containing information on Late IMERG Half-Hourly data to be downloaded"

    fol = joinpath(sroot,"imerglatehh"); if !isdir(fol); mkpath(fol) end

    return IMERGLateHH{ST,DT}(
		"imerglatehh",
        dtbeg,dtend,joinpath(sroot,"imerglatehh"),
        "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGHHL.06",
        "3B-HHR-L.MS.MRG.3IMERG",
        "V06B.HDF5",
    )

end

function download(
	npd :: IMERGLateHH{ST,DT},
	geo :: GeoRegion
) where {ST<:AbstractString, DT<:TimeType}

	@info "$(now()) - NASAPrecipitation.jl - Downloading Late IMERG Half-Hourly data for the $(geo.name) GeoRegion from $(npd.dtbeg) to $(npd.dtend)"

	fnc  = imergrawfiles()
	lon,lat = gpmlonlat(); nlon = length(lon); nlat = length(lat)
	ginfo = RegionGrid(geo,lon,lat)

	@info "$(now()) - NASAPrecipitation.jl - Preallocating temporary arrays for extraction of Late IMERG Half-Hourly data for the $(geo.name) GeoRegion from the original gridded dataset"
	glon = ginfo.glon; nglon = length(glon); iglon = ginfo.ilon
	glat = ginfo.glat; nglat = length(glat); iglat = ginfo.ilat
	tmp  = zeros(Float32,nlat,nlon)
	var  = zeros(Float32,nglon,nglat,48)
	vint = zeros(Int16,nglon,nglat,48)
	isp  = zeros(Bool,nglon,nglat,48)

	for dt in npd.dtbeg : Day(1) : npd.dtend

		@info "$(now()) - NASAPrecipitation.jl - Downloading Late IMERG Half-Hourly data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(dt) ..."

		ymdfnc = Dates.format(dt,dateformat"yyyymmdd")
		npddir = joinpath(npd.hroot,"$(year(dt))",@sprintf("%03d",dayofyear(dt)))
		for it = 1 : 48

			@debug "$(now()) - NASAPrecipitation.jl - Loading data into temporary array for timestep $(fnc[it])"

			npdfnc = "$(npd.fpref).$ymdfnc-$(fnc[it]).$(npd.fsuff)"
			ds = NCDataset(joinpath(npddir,npdfnc))
			NCDatasets.load!(ds["precipitationCal"].var,tmp,:,:,1)
			close(ds)

			@debug "$(now()) - NASAPrecipitation.jl - Extraction of data from temporary array for the $(geo.name) GeoRegion"
			for ilat = 1 : nglat, ilon = 1 : nglon
				varii = tmp[iglat[ilat],iglon[ilon]]
				if varii != 9999.9 && !iszero(varii)
					  var[ilon,ilat,it] = log2(varii/3600)
  					  isp[ilon,ilat,it] = 1
				elseif iszero(varii)
					  var[ilon,ilat,it] = NaN32
					  isp[ilon,ilat,it] = 1
				else; var[ilon,ilat,it] = NaN32
				end
			end
		end

		@debug "$(now()) - NASAPrecipitation.jl - Converting data from Float32 format to Int16 format in order to save space ..."
		scale,offset = ncoffsetscale(var)
		real2int16!(vint,var,scale,offset)

		save(vint,isp,dt,npd,geo,ginfo,[scale,offset])
	end

end

function save(
	var   :: Array{Int16,3},
	isp   :: Array{Bool,3},
	dt    :: TimeType,
	npd   :: IMERGLateHH,
	geo   :: GeoRegion,
	ginfo :: RegionGrid,
	scale :: Vector{<:Real}
)

	@info "$(now()) - NASAPrecipitation.jl - Saving Late IMERG raw Half-Hourly data in the $(geo.name) GeoRegion for $(dt)"

	fol = joinpath(npd.sroot,geo.regID,"raw",yrmo2dir(dt))
	if !isdir(fol); mkpath(fol) end
	fnc = joinpath(fol,"$(npd.npdID)-$(geo.regID)-$(ymd2str(dt)).nc")
	if isfile(fnc)
		@info "$(now()) - NASAPrecipitation.jl - Overwrite stale NetCDF file $(fnc) ..."
        rm(fnc);
	end

	@info "$(now()) - NASAPrecipitation.jl - Creating NetCDF file $(fnc) ..."
	ds = NCDataset(fnc,"c",attrib = Dict(
		"doi"				=> "10.5067/GPM/IMERG/3B-HH-L/06",
		"AlgorithmID"		=> "3IMERGHH",
		"AlgorithmVersion"	=> "3IMERGH_6.3"
	))

	ds.dim["longitude"] = length(ginfo.glon)
	ds.dim["latitude"]  = length(ginfo.glat)
	ds.dim["time"] = 48

	nclon = defVar(ds,"longitude",Float32,("longitude",),attrib = Dict(
	    "units"     => "degrees_east",
	    "long_name" => "longitude",
	))

	nclat = defVar(ds,"latitude",Float32,("latitude",),attrib = Dict(
	    "units"     => "degrees_north",
	    "long_name" => "latitude",
	))

	ncvar = defVar(ds,"prcp_tot",Int16,("longitude","latitude","time"),attrib = Dict(
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

	@info "$(now()) - NASAPrecipitation.jl - Late IMERG Half-Hourly data in the $(geo.name) GeoRegion for $(dt) has been saved into $(fnc)"

end

function show(io::IO, npd::IMERGLateHH{ST,DT}) where {ST<:AbstractString, DT<:TimeType}
    print(
		io,
		"The NASA Precipitation Dataset {$ST,$DT} is Late IMERG (Half-Hourly):\n",
		"    Data Directory  : ", npd.sroot, '\n',
		"    Date Begin      : ", npd.dtbeg, '\n',
		"    Date End        : ", npd.dtend, '\n',
		"    Timestep        : 30 minutes\n",
        "    Data Resolution : 0.1º\n",
        "    Data Server     : ", npd.hroot, '\n',
	)
end
