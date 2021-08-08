"""
    TRMMDaily{ST<:AbstractString, DT<:TimeType} <: TRMMDataset

Object containing information on Daily TRMM datasets to be downloaded
"""
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

"""
    TRMMDaily(
        ST = String,
        DT = Date;
        dtbeg :: TimeType,
        dtend :: TimeType,
        sroot :: AbstractString = homedir(),
    ) -> npd :: TRMMDaily{ST,DT}

Creates a `TRMMDaily` dataset `npd` to retrieve datasets from the Final post-processing runs for Daily output

Keyword Arguments
=================
- `dtbeg` : Date at which download / analysis of the dataset begins
- `dtend` : Date at which download / analysis of the dataset ends
- `sroot` : The directory in which the folder `trmmdaily` will be created for data downloads, storage and analysis, default is the home directoy called by `homedir()`

The following fields in `npd` will be fixed as below:
- `npdID` : trmmdaily
- `lname` : Final TRMM Daily
- `doi`   : 10.5067/TRMM/TMPA/DAY/7
- `hroot` : https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_L3/TRMM_3B42_Daily.7
- `fpref` : 3B42_Daily
- `fsuff` : 7.nc4
"""
function TRMMDaily(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString = homedir(),
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

"""
    TRMMDailyNRT(
        ST = String,
        DT = Date;
        dtbeg :: TimeType,
        dtend :: TimeType,
        sroot :: AbstractString = homedir(),
    ) -> npd :: TRMMDaily{ST,DT}

Creates a `TRMMDaily` dataset `npd` to retrieve datasets from the Near Real-Time processing runs for Daily output

Keyword Arguments
=================
- `dtbeg` : Date at which download / analysis of the dataset begins
- `dtend` : Date at which download / analysis of the dataset ends
- `sroot` : The directory in which the folder `trmmdailynrt` will be created for data downloads, storage and analysis, default is the home directoy called by `homedir()`

The following fields in `npd` will be fixed as below:
- `npdID` : trmmdailynrt
- `lname` : Near Real-Time TRMM Daily
- `doi`   : 10.5067/TRMM/TMPA/DAY-E/7
- `hroot` : https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_RT/TRMM_3B42RT_Daily.7
- `fpref` : 3B42RT_Daily
- `fsuff` : 7.nc4
"""
function TRMMDailyNRT(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString = homedir(),
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
