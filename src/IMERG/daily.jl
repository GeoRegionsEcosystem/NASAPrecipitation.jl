struct IMERGDaily{ST<:AbstractString, DT<:TimeType} <: IMERGDataset
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

    return IMERGDaily{ST,DT}(
		"imergearlydy", "Early IMERG Daily", "10.5067/GPM/IMERGDE/DAY/06",
        dtbeg, dtend,
		joinpath(sroot,"imergearlydy"),
        "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGDE.06",
        "3B-DAY-E.MS.MRG.3IMERG", "S000000-E235959.V06.nc4",
    )

end

function IMERGLateDY(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString,
)

	@info "$(now()) - NASAPrecipitation.jl - Setting up data structure containing information on Late IMERG Daily data to be downloaded"

    fol = joinpath(sroot,"imerglatedy"); if !isdir(fol); mkpath(fol) end

	dtbeg = Date(year(dtbeg),month(dtbeg),1)
	dtend = Date(year(dtend),month(dtend),daysinmonth(dtend))

    return IMERGDaily{ST,DT}(
		"imerglatedy", "Late IMERG Daily", "10.5067/GPM/IMERGDL/DAY/06",
        dtbeg, dtend,
		joinpath(sroot,"imerglatedy"),
        "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGDL.06",
        "3B-DAY-L.MS.MRG.3IMERG", "S000000-E235959.V06.nc4",
    )

end

function IMERGFinalDY(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString,
)

	@info "$(now()) - NASAPrecipitation.jl - Setting up data structure containing information on Final IMERG Daily data to be downloaded"

    fol = joinpath(sroot,"imergfinaldy"); if !isdir(fol); mkpath(fol) end

	dtbeg = Date(year(dtbeg),month(dtbeg),1)
	dtend = Date(year(dtend),month(dtend),daysinmonth(dtend))

    return IMERGDaily{ST,DT}(
		"imergfinaldy", "Final IMERG Daily", "10.5067/GPM/IMERGDF/DAY/06",
        dtbeg, dtend,
		joinpath(sroot,"imergfinaldy"),
        "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGDF.06",
        "3B-DAY.MS.MRG.3IMERG", "S000000-E235959.V06.nc4",
    )

end

function show(io::IO, npd::IMERGDaily{ST,DT}) where {ST<:AbstractString, DT<:TimeType}
    print(
		io,
		"The NASA Precipitation Dataset {$ST,$DT} has the following properties:\n",
		"    Dataset ID      (npdID) : ", npd.npdID, '\n',
		"    Logging Name    (lname) : ", npd.lname, '\n',
		"    DOI URL          (doi)  : ", npd.doi,   '\n',
		"    Data Directory  (sroot) : ", npd.sroot, '\n',
		"    Date Begin      (dtbeg) : ", npd.dtbeg, '\n',
		"    Date End        (dtend) : ", npd.dtend, '\n',
		"    Timestep                : 1 Day\n",
        "    Data Resolution         : 0.1º\n",
        "    Data Server     (hroot) : ", npd.hroot, '\n',
	)
end
