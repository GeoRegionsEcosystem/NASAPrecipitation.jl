struct IMERGMonthly{ST<:AbstractString, DT<:TimeType} <: IMERGDataset
	npdID :: ST
	lname :: ST
	doi   :: ST
    dtbeg :: DT
    dtend :: DT
    sroot :: ST
    hroot :: ST
    fpref :: ST
    fsuff :: ST
end

function IMERGMonthly(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString,
)

	@info "$(now()) - NASAPrecipitation.jl - Setting up data structure containing information on IMERG Monthly data to be downloaded"

    fol = joinpath(sroot,"imergfinalmo"); if !isdir(fol); mkpath(fol) end

	dtbeg = Date(year(dtbeg),1,1)
	dtend = Date(year(dtend),12,31)

    return IMERGFinalMO{ST,DT}(
		"imergfinalmo", "IMERG Monthly", "10.5067/GPM/IMERG/3B-MONTH/06",
        dtbeg, dtend,
		joinpath(sroot,"imergfinalmo"),
        "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGM.06",
        "3B-MO.MS.MRG.3IMERG", "V06B.HDF5",
    )

end

function download(
	npd :: IMERGMonthly{ST,DT},
	geo :: GeoRegion
) where {ST<:AbstractString, DT<:TimeType}

	@info "$(now()) - NASAPrecipitation.jl - Downloading $(npd.lname) data for the $(geo.name) GeoRegion from $(npd.dtbeg) to $(npd.dtend)"

	lon,lat = gpmlonlat(); nlon = length(lon); nlat = length(lat)
	ginfo = RegionGrid(geo,lon,lat)

	@info "$(now()) - NASAPrecipitation.jl - Preallocating temporary arrays for extraction of $(npd.lname) data for the $(geo.name) GeoRegion from the original gridded dataset"
	glon = ginfo.glon; nglon = length(glon); iglon = ginfo.ilon
	glat = ginfo.glat; nglat = length(glat); iglat = ginfo.ilat
	tmp  = zeros(Float32,nlat,nlon)
	var  = zeros(Float32,nglon,nglat,12)
	vint = zeros(Int16,nglon,nglat,12)
	isp  = zeros(Bool,nglon,nglat,12)

	for dt in npd.dtbeg : Year(1) : npd.dtend

		@info "$(now()) - NASAPrecipitation.jl - Downloading $(npd.lname) data for the $(geo.name) GeoRegion from the NASA Earthdata servers using OPeNDAP protocols for $(ymd2str(dt)) ..."

		npddir = joinpath(npd.hroot,"$(year(dt))")

		for mo in 1 : 12
			dtii   = Date(year(dt),mo,1)
			ymdfnc = "$(ymd2str(dtii))-S000000-E235959"
			npdfnc = "$(npd.fpref).$ymdfnc.$(@sprintf("%02d",mo)).$(npd.fsuff)"
			ds = NCDataset(joinpath(npddir,npdfnc))
			NCDatasets.load!(ds["precipitation"].var,tmp,:,:,1)
			close(ds)

			@debug "$(now()) - NASAPrecipitation.jl - Extraction of data from temporary array for the $(geo.name) GeoRegion"

			for ilat = 1 : nglat, ilon = 1 : nglon
				varii = tmp[iglat[ilat],iglon[ilon]]
				if varii != 9999.9 && !iszero(varii)
					  var[ilon,ilat,mo] = log2(varii/3600)
					  isp[ilon,ilat,mo] = 1
				elseif iszero(varii)
					  var[ilon,ilat,mo] = NaN32
					  isp[ilon,ilat,mo] = 1
				else; var[ilon,ilat,mo] = NaN32
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
	var   :: AbstractArray{Int16,3},
	isp   :: AbstractArray{Bool,3},
	dt    :: TimeType,
	npd   :: IMERGMonthly,
	geo   :: GeoRegion,
	ginfo :: RegionGrid,
	scale :: Vector{<:Real}
)

	@info "$(now()) - NASAPrecipitation.jl - Saving $(npd.lname) data in the $(geo.name) GeoRegion for $(Dates.format(dt,dateformat"yyyy-mm"))"

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

	ds.dim["longitude"] = length(ginfo.glon)
	ds.dim["latitude"]  = length(ginfo.glat)
	ds.dim["time"] 		= 12

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

	@info "$(now()) - NASAPrecipitation.jl - $(npd.lname) data in the $(geo.name) GeoRegion for $(Dates.format(dt,dateformat"yyyy-mm")) has been saved into $(fnc)"

end

function show(io::IO, npd::IMERGMonthly{ST,DT}) where {ST<:AbstractString, DT<:TimeType}
    print(
		io,
		"The NASA Precipitation Dataset {$ST,$DT} has the following properties:\n",
		"    Dataset ID      (npdID) : ", npd.npdID, '\n',
		"    Logging Name    (lname) : ", npd.lname, '\n',
		"    DOI URL          (doi)  : ", npd.doi,   '\n',
		"    Data Directory  (sroot) : ", npd.sroot, '\n',
		"    Date Begin      (dtbeg) : ", npd.dtbeg, '\n',
		"    Date End        (dtend) : ", npd.dtend, '\n',
		"    Timestep                : 1 Month\n",
        "    Data Resolution         : 0.1º\n",
        "    Data Server     (hroot) : ", npd.hroot, '\n',
	)
end
