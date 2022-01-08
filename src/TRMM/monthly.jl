"""
    TRMMMonthly{ST<:AbstractString, DT<:TimeType} <: TRMMDataset

Object containing information on Monthly TRMM datasets to be downloaded
"""
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

"""
    TRMMMonthly(
        ST = String,
        DT = Date;
        dtbeg :: TimeType,
        dtend :: TimeType,
        sroot :: AbstractString = homedir(),
    ) -> npd :: TRMMMonthly{ST,DT}

Creates a `TRMMMonthly` dataset `npd` to retrieve datasets from the Final post-processing runs for Monthly output

Keyword Arguments
=================
- `dtbeg` : Date at which download / analysis of the dataset begins
- `dtend` : Date at which download / analysis of the dataset ends
- `sroot` : The directory in which the folder `trmmmonthly` will be created for data downloads, storage and analysis, default is the home directoy called by `homedir()`

The following fields in `npd` will be fixed as below:
- `npdID` : trmmmonthly
- `lname` : TRMM Monthly (TMPA 3B43)
- `doi`   : 10.5067/TRMM/TMPA/MONTH/7
- `hroot` : https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_L3/TRMM_3B43.7
- `fpref` : 3B43
- `fsuff` : 7.HDF
"""
function TRMMMonthly(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString = homedir(),
)

	@info "$(modulelog()) - Setting up data structure containing information on TRMM Monthly data to be downloaded"

    fol = joinpath(sroot,"trmmmonthly"); if !isdir(fol); mkpath(fol) end

	dtbeg = Date(year(dtbeg),1,1)
	dtend = Date(year(dtend),12,31)

    return TRMMMonthly{ST,DT}(
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
