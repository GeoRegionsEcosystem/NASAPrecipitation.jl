"""
    TRMMDaily{ST<:AbstractString, DT<:TimeType} <: TRMMDataset

Object containing information on Daily TRMM datasets to be downloaded
"""
struct TRMMDaily{ST<:AbstractString, DT<:TimeType} <: TRMMDataset
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
    TRMMDaily(
        ST = String,
        DT = Date;
        start :: TimeType,
        stop  :: TimeType,
        path  :: AbstractString = homedir(),
    ) -> npd :: TRMMDaily{ST,DT}

Creates a `TRMMDaily` dataset `npd` to retrieve datasets from the Final post-processing runs for Daily output

Keyword Arguments
=================
- `start` : Date at which download / analysis of the dataset begins
- `stop` : Date at which download / analysis of the dataset ends
- `path` : The directory in which the folder `trmmdaily` will be created for data downloads, storage and analysis, default is the home directoy called by `homedir()`

The following fields in `npd` will be fixed as below:
- `ID` : trmmdaily
- `name` : Final TRMM Daily
- `doi` : 10.5067/TRMM/TMPA/DAY/7
- `hroot` : https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_L3/TRMM_3B42_Daily.7
- `fpref` : 3B42_Daily
- `fsuff` : 7.nc4
"""
function TRMMDaily(
    ST = String,
    DT = Date;
    start :: TimeType = Date(1998,1),
    stop  :: TimeType = Date(2019,12),
    path  :: AbstractString = homedir(),
)

	@info "$(modulelog()) - Setting up data structure containing information on Final TRMM Daily data to be downloaded"

    fol = joinpath(path,"trmmdaily"); if !isdir(fol); mkpath(fol) end
    fol = joinpath(path,"trmmmask");  if !isdir(fol); mkpath(fol) end

	start = Date(year(start),month(start),1)
	stop = Date(year(stop),month(stop),daysinmonth(stop))
    trmmcheckdates(start,stop)

    return TRMMDaily{ST,DT}(
		"trmmdaily", "Final TRMM Daily", "10.5067/TRMM/TMPA/DAY/7",
        start, stop,
		joinpath(path,"trmmdaily"),
		joinpath(path,"trmmmask"),
        "https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_L3/TRMM_3B42_Daily.7",
        "3B42_Daily", "7.nc4",
    )

end

"""
    TRMMDailyNRT(
        ST = String,
        DT = Date;
        start :: TimeType,
        stop  :: TimeType,
        path  :: AbstractString = homedir(),
    ) -> npd :: TRMMDaily{ST,DT}

Creates a `TRMMDaily` dataset `npd` to retrieve datasets from the Near Real-Time processing runs for Daily output

Keyword Arguments
=================
- `start` : Date at which download / analysis of the dataset begins
- `stop` : Date at which download / analysis of the dataset ends
- `path` : The directory in which the folder `trmmdailynrt` will be created for data downloads, storage and analysis, default is the home directoy called by `homedir()`

The following fields in `npd` will be fixed as below:
- `ID` : trmmdailynrt
- `name` : Near Real-Time TRMM Daily
- `doi`   : 10.5067/TRMM/TMPA/DAY-E/7
- `hroot` : https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_RT/TRMM_3B42RT_Daily.7
- `fpref` : 3B42RT_Daily
- `fsuff` : 7.nc4
"""
function TRMMDailyNRT(
    ST = String,
    DT = Date;
    start :: TimeType = Date(1998,1),
    stop  :: TimeType = Date(2019,12),
    path  :: AbstractString = homedir(),
)

	@info "$(modulelog()) - Setting up data structure containing information on Near Real-Time TRMM Daily data to be downloaded"

    fol = joinpath(path,"trmmdailynrt"); if !isdir(fol); mkpath(fol) end
    fol = joinpath(path,"trmmmask");     if !isdir(fol); mkpath(fol) end

	start = Date(year(start),month(start),1)
	stop = Date(year(stop),month(stop),daysinmonth(stop))
    trmmcheckdates(start,stop)

    return TRMMDaily{ST,DT}(
		"trmmdailynrt", "Near Real-Time TRMM Daily", "10.5067/TRMM/TMPA/DAY-E/7",
        start, stop,
		joinpath(path,"trmmdailynrt"),
		joinpath(path,"trmmmask"),
        "https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_RT/TRMM_3B42RT_Daily.7",
        "3B42RT_Daily", "7.nc4",
    )

end

function show(io::IO, npd::TRMMDaily{ST,DT}) where {ST<:AbstractString, DT<:TimeType}
    print(
		io,
		"The NASA Precipitation Dataset {$ST,$DT} has the following properties:\n",
		"    Dataset ID         (ID) : ", npd.ID, '\n',
		"    Logging Name        (name): ", npd.name, '\n',
		"    DOI URL              (doi) : ", npd.doi,   '\n',
		"    Data Directory  (datapath) : ", npd.datapath, '\n',
		"    Mask Directory  (maskpath) : ", npd.maskpath, '\n',
		"    Date Begin         (start) : ", npd.start, '\n',
		"    Date End            (stop) : ", npd.stop, '\n',
		"    Timestep                   : 1 Day\n",
        "    Data Resolution            : 0.25º\n",
        "    Data Server        (hroot) : ", npd.hroot, '\n',
	)
end
