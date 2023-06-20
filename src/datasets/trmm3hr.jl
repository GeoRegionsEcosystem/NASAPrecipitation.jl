"""
    TRMM3Hourly{ST<:AbstractString, DT<:TimeType} <: TRMMDataset

Object containing information on 3-Hourly TRMM datasets to be downloaded
"""
struct TRMM3Hourly{ST<:AbstractString, DT<:TimeType} <: TRMMDataset
	ID    :: ST
	name  :: ST
	doi   :: ST
    start :: DT
    stop  :: DT
    datapath :: ST
    maskpath :: ST
    hroot :: ST
    fpref :: ST
    fsuff :: ST
end

"""
    TRMM3Hourly(
        ST = String,
        DT = Date;
        start :: TimeType,
        stop  :: TimeType,
        path  :: AbstractString = homedir(),
    ) -> npd :: TRMM3Hourly{ST,DT}

Creates a `TRMM3Hourly` dataset `npd` to retrieve datasets from the Final post-processing runs for 3-Hourly output

Keyword Arguments
=================
- `start` : Date at which download / analysis of the dataset begins
- `stop` : Date at which download / analysis of the dataset ends
- `path` : The directory in which the folder `trmm3hourly` will be created for data downloads, storage and analysis, default is the home directoy called by `homedir()`

The following fields in `npd` will be fixed as below:
- `ID` : trmm3hourly
- `name` : Final TRMM 3-Hourly
- `doi` : 10.5067/TRMM/TMPA/3H/7
- `hroot` : https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_L3/TRMM_3B42.7
- `fpref` : 3B42
- `fsuff` : 7.HDF
"""
function TRMM3Hourly(
    ST = String,
    DT = Date;
    start :: TimeType,
    stop  :: TimeType,
    path  :: AbstractString = homedir(),
)

	@info "$(modulelog()) - Setting up data structure containing information on Final TRMM 3-Hourly data to be downloaded"

    fol = joinpath(path,"trmm3hourly"); if !isdir(fol); mkpath(fol) end
    fol = joinpath(path,"trmmmask");    if !isdir(fol); mkpath(fol) end
    trmmcheckdates(start,stop)

    return TRMM3Hourly{ST,DT}(
		"trmm3hourly", "Final TRMM 3-Hourly", "10.5067/TRMM/TMPA/3H/7",
        start, stop,
		joinpath(path,"trmm3hourly"),
		joinpath(path,"trmmmask"),
        "https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_L3/TRMM_3B42.7",
        "3B42", "7A.HDF",
    )

end

"""
    TRMM3HourlyNRT(
        ST = String,
        DT = Date;
        start :: TimeType,
        stop  :: TimeType,
        path  :: AbstractString = homedir(),
    ) -> npd :: TRMM3Hourly{ST,DT}

Creates a `TRMM3Hourly` dataset `npd` to retrieve datasets from the Near Real-Time runs for 3-Hourly output

Keyword Arguments
=================
- `start` : Date at which download / analysis of the dataset begins
- `stop` : Date at which download / analysis of the dataset ends
- `path` : The directory in which the folder `trmm3hourlynrt` will be created for data downloads, storage and analysis, default is the home directoy called by `homedir()`

The following fields in `npd` will be fixed as below:
- `ID` : trmm3hourlynrt
- `name` : Near Real-Time TRMM 3-Hourly
- `doi`   : 10.5067/TRMM/TMPA/3H-E/7
- `hroot` : https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_RT/TRMM_3B42RT.7
- `fpref` : 3B42RT
- `fsuff` : 7R2.nc4
"""
function TRMM3HourlyNRT(
    ST = String,
    DT = Date;
    start :: TimeType = Date(1998,1,1),
    stop  :: TimeType = Date(2019,12,31),
    path  :: AbstractString = homedir(),
)

	@info "$(modulelog()) - Setting up data structure containing information on Near Real-Time TRMM 3-Hourly data to be downloaded"

    fol = joinpath(path,"trmm3hourlynrt"); if !isdir(fol); mkpath(fol) end
    fol = joinpath(path,"trmmmask");       if !isdir(fol); mkpath(fol) end
    trmmcheckdates(start,stop)

    return TRMM3Hourly{ST,DT}(
		"trmm3hourlynrt", "Near Real-Time TRMM 3-Hourly", "10.5067/TRMM/TMPA/3H-E/7",
        start, stop,
		joinpath(path,"trmm3hourlynrt"),
		joinpath(path,"trmmmask"),
        "https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_RT/TRMM_3B42RT.7",
        "3B42RT", "7R2.nc4",
    )

end

function show(io::IO, npd::TRMM3Hourly{ST,DT}) where {ST<:AbstractString, DT<:TimeType}
    print(
		io,
		"The NASA Precipitation Dataset {$ST,$DT} has the following properties:\n",
		"    Dataset ID         (ID) : ", npd.ID, '\n',
		"    Logging Name       (name) : ", npd.name, '\n',
		"    DOI URL              (doi) : ", npd.doi,   '\n',
		"    Data Directory  (datapath) : ", npd.datapath, '\n',
		"    Mask Directory  (maskpath) : ", npd.maskpath, '\n',
		"    Date Begin         (start) : ", npd.start, '\n',
		"    Date End            (stop) : ", npd.stop, '\n',
		"    Timestep                   : 3 Hourly\n",
        "    Data Resolution            : 0.25º\n",
        "    Data Server        (hroot) : ", npd.hroot, '\n',
	)
end
