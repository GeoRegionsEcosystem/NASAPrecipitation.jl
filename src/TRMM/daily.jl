struct TRMMDaily{ST<:AbstractString, DT<:TimeType} <: TRMMDataset
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

function TRMMDaily(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString,
)

	@info "$(now()) - NASAPrecipitation.jl - Setting up data structure containing information on Final TRMM Daily data to be downloaded"

    fol = joinpath(sroot,"trmmdaily"); if !isdir(fol); mkpath(fol) end

	dtbeg = Date(year(dtbeg),month(dtbeg),1)
	dtend = Date(year(dtend),month(dtend),daysinmonth(dtend))

    return TRMMDaily{ST,DT}(
		"trmmdaily", "Final TRMM Daily", "10.5067/TRMM/TMPA/DAY/7",
        dtbeg, dtend,
		joinpath(sroot,"trmmdaily"),
        "https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_L3/TRMM_3B42_Daily.7",
        "3B42_Daily", "7.nc4",
    )

end

function TRMMDailyNRT(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString,
)

	@info "$(now()) - NASAPrecipitation.jl - Setting up data structure containing information on Near Real-Time TRMM Daily data to be downloaded"

    fol = joinpath(sroot,"trmmdailynrt"); if !isdir(fol); mkpath(fol) end

	dtbeg = Date(year(dtbeg),month(dtbeg),1)
	dtend = Date(year(dtend),month(dtend),daysinmonth(dtend))

    return TRMMDaily{ST,DT}(
		"trmmdailynrt", "Near Real-Time TRMM Daily", "10.5067/TRMM/TMPA/DAY-E/7",
        dtbeg, dtend,
		joinpath(sroot,"trmmdailynrt"),
        "https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_RT/TRMM_3B42RT_Daily.7",
        "3B42RT_Daily", "7.nc4",
    )

end

function show(io::IO, npd::TRMMDaily{ST,DT}) where {ST<:AbstractString, DT<:TimeType}
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
        "    Data Resolution         : 0.25º\n",
        "    Data Server     (hroot) : ", npd.hroot, '\n',
	)
end
