struct IMERGFinalRaw{ST<:AbstractString, DT<:TimeType} <: RawGPMDataset
	npdID :: ST
    dtbeg :: DT
    dtend :: DT
    sroot :: ST
    hroot :: ST
    fpref :: ST
    fsuff :: ST
end


function IMERGFinalRaw(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString,
)

    fol = joinpath(sroot,"imergfinal"); if !isdir(fol); mkpath(fol) end

    return IMERGFinalRaw{ST,DT}(
		"imergfinal",
        dtbeg,dtend,joinpath(sroot,"imergfinal"),
        "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGHH.06",
        "3B-HHR.MS.MRG.3IMERG",
        "V06B.HDF5",
    )

end

function download(
	npd :: IMERGFinalRaw{ST,DT},
	geo :: GeoRegion
) where {ST<:AbstractString, DT<:TimeType}

	fnc  = imergrawfiles()
	lon,lat = gpmlonlat(); nlon = length(lon); nlat = length(lat)
	ginfo = GeoRegionInfo(geo,lon,lat)
	glon = ginfo.glon; nglon = length(glon); iglon = ginfo.ilon
	glat = ginfo.glat; nglat = length(glat); iglat = ginfo.ilat
	tmp  = zeros(Float32,nlat,nlon)
	var  = zeros(Float32,nglon,nglat,48)
	vint = zeros(Int16,nglon,nglat,48)
	isp  = zeros(Bool,nglon,nglat,48)

	for dt in npd.dtbeg : Day(1) : npd.dtend
		ymdfnc = Dates.format(dt,dateformat"yyyymmdd")
		npddir = joinpath(npd.hroot,"$(year(dt))",@sprintf("%03d",dayofyear(dt)))
		for it = 1 : 48
			npdfnc = "$(npd.fpref).$ymdfnc-$(fnc[it]).$(npd.fsuff)"
			ds = NCDataset(joinpath(npddir,npdfnc))
			NCDatasets.load!(ds["precipitationCal"].var,tmp,:,:,1)
			close(ds)
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
		save(var,isp,dt,npd,geo,ginfo,vint)
	end

end

function save(
	var   :: Array{Float32,3},
	isp   :: Array{Bool,3},
	dt    :: TimeType,
	npd   :: IMERGFinalRaw,
	geo   :: GeoRegion,
	ginfo :: RegionInfo,
	vint  :: Array{Int16,3},
)

	fol = joinpath(npd.sroot,geo.regID,"raw",yrmo2dir(dt))
	if !isdir(fol); mkpath(fol) end
	fnc = joinpath(fol,"$(npd.npdID)-$(ymd2str(dt)).nc")
	if isfile(fnc)
		@info "$(now()) - Stale NetCDF file $(fnc) detected.  Overwriting ..."
        rm(fnc);
	end

	scale,offset = ncoffsetscale(var)
	real2int16!(vint,var,scale,offset)

	ds = NCDataset(fnc,"c",attrib = Dict(
		"doi"				=> "10.5067/GPM/IMERG/3B-HH/0",
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
        "scale_factor"  => scale,
        "add_offset"    => offset,
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
	ncvar.var[:] = vint

	close(ds)

end

function show(io::IO, npd::IMERGFinalRaw{ST,DT}) where {ST<:AbstractString, DT<:TimeType}
    print(
		io,
		"The NASA Precipitation Dataset {$ST,$DT} is IMERG Final Raw (Half-Hourly):\n",
		"    Data Directory  : ", npd.sroot, '\n',
		"    Date Begin      : ", npd.dtbeg, '\n',
		"    Date End        : ", npd.dtend, '\n',
		"    Timestep        : 30 minutes\n",
        "    Data Resolution : 0.1º\n",
        "    Data Server     : ", npd.hroot, '\n',
	)
end
