"""
    TRMM3Hourly{ST<:AbstractString, DT<:TimeType} <: TRMMDataset

Object containing information on 3-Hourly TRMM datasets to be downloaded
"""
struct TRMM3Hourly{ST<:AbstractString, DT<:TimeType} <: TRMMDataset
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
    TRMM3Hourly(
        ST = String,
        DT = Date;
        dtbeg :: TimeType,
        dtend :: TimeType,
        sroot :: AbstractString,
    ) -> npd :: TRMM3Hourly{ST,DT}

Creates a `TRMM3Hourly` dataset `npd` to retrieve datasets from the Final post-processing runs for 3-Hourly output

Keyword Arguments
=================
- `dtbeg` : Date at which download / analysis of the dataset begins
- `dtend` : Date at which download / analysis of the dataset ends
- `sroot` : The directory in which the folder `trmm3hourly` will be created for data downloads, storage and analysis

The following fields in `npd` will be fixed as below:
- `npdID` : trmm3hourly
- `lname` : Final TRMM 3-Hourly
- `doi`   : 10.5067/TRMM/TMPA/3H/7
- `hroot` : https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_L3/TRMM_3B42.7
- `fpref` : 3B42
- `fsuff` : 7.HDF
"""
function TRMM3Hourly(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString,
)

	@info "$(now()) - NASAPrecipitation.jl - Setting up data structure containing information on Final TRMM 3-Hourly data to be downloaded"

    fol = joinpath(sroot,"trmm3hourly"); if !isdir(fol); mkpath(fol) end

	dtbeg = Date(year(dtbeg),month(dtbeg),1)
	dtend = Date(year(dtend),month(dtend),daysinmonth(dtend))

    return TRMM3Hourly{ST,DT}(
		"trmm3hourly", "Final TRMM 3-Hourly", "10.5067/TRMM/TMPA/3H/7",
        dtbeg, dtend,
		joinpath(sroot,"trmm3hourly"),
        "https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_L3/TRMM_3B42.7",
        "3B42", "7.HDF",
    )

end

"""
    TRMM3HourlyNRT(
        ST = String,
        DT = Date;
        dtbeg :: TimeType,
        dtend :: TimeType,
        sroot :: AbstractString,
    ) -> npd :: TRMM3Hourly{ST,DT}

Creates a `TRMM3Hourly` dataset `npd` to retrieve datasets from the Near Real-Time runs for 3-Hourly output

Keyword Arguments
=================
- `dtbeg` : Date at which download / analysis of the dataset begins
- `dtend` : Date at which download / analysis of the dataset ends
- `sroot` : The directory in which the folder `trmm3hourlynrt` will be created for data downloads, storage and analysis

The following fields in `npd` will be fixed as below:
- `npdID` : trmm3hourlynrt
- `lname` : Near Real-Time TRMM 3-Hourly
- `doi`   : 10.5067/TRMM/TMPA/3H-E/7
- `hroot` : https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_RT/TRMM_3B42RT.7
- `fpref` : 3B42RT
- `fsuff` : 7R2.nc4
"""
function TRMM3HourlyNRT(
    ST = String,
    DT = Date;
    dtbeg :: TimeType,
    dtend :: TimeType,
    sroot :: AbstractString,
)

	@info "$(now()) - NASAPrecipitation.jl - Setting up data structure containing information on Near Real-Time TRMM 3-Hourly data to be downloaded"

    fol = joinpath(sroot,"trmm3hourlynrt"); if !isdir(fol); mkpath(fol) end

	dtbeg = Date(year(dtbeg),month(dtbeg),1)
	dtend = Date(year(dtend),month(dtend),daysinmonth(dtend))

    return TRMM3Hourly{ST,DT}(
		"trmm3hourlynrt", "Near Real-Time TRMM 3-Hourly", "10.5067/TRMM/TMPA/3H-E/7",
        dtbeg, dtend,
		joinpath(sroot,"trmm3hourlynrt"),
        "https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_RT/TRMM_3B42RT.7",
        "3B42RT", "7R2.nc4",
    )

end

function show(io::IO, npd::TRMM3Hourly{ST,DT}) where {ST<:AbstractString, DT<:TimeType}
    print(
		io,
		"The NASA Precipitation Dataset {$ST,$DT} has the following properties:\n",
		"    Dataset ID      (npdID) : ", npd.npdID, '\n',
		"    Logging Name    (lname) : ", npd.lname, '\n',
		"    DOI URL          (doi)  : ", npd.doi,   '\n',
		"    Data Directory  (sroot) : ", npd.sroot, '\n',
		"    Date Begin      (dtbeg) : ", npd.dtbeg, '\n',
		"    Date End        (dtend) : ", npd.dtend, '\n',
		"    Timestep                : 3 Hourly\n",
        "    Data Resolution         : 0.25º\n",
        "    Data Server     (hroot) : ", npd.hroot, '\n',
	)
end
