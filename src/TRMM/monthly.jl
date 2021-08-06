struct TRMMMonthly{ST<:AbstractString, DT<:TimeType} <: TRMMDataset
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

function TRMMMonthly(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString,
)

	@info "$(now()) - NASAPrecipitation.jl - Setting up data structure containing information on TRMM Monthly data to be downloaded"

    fol = joinpath(sroot,"trmmmonthly"); if !isdir(fol); mkpath(fol) end

	dtbeg = Date(year(dtbeg),1,1)
	dtend = Date(year(dtend),12,31)

    return trmmfinalmo{ST,DT}(
		"trmmmonthly", "TRMM Monthly (TMPA 3B43)", "10.5067/TRMM/TMPA/MONTH/7",
        dtbeg, dtend,
		joinpath(sroot,"trmmmonthly"),
        "https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_L3/TRMM_3B43.7",
        "3B43", "7.HDF",
    )

end

function show(io::IO, npd::TRMMMonthly{ST,DT}) where {ST<:AbstractString, DT<:TimeType}
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
        "    Data Resolution         : 0.25º\n",
        "    Data Server     (hroot) : ", npd.hroot, '\n',
	)
end
