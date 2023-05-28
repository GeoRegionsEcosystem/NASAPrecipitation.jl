"""
    TRMMMonthly{ST<:AbstractString, DT<:TimeType} <: TRMMDataset

Object containing information on Monthly TRMM datasets to be downloaded
"""
struct TRMMMonthly{ST<:AbstractString, DT<:TimeType} <: TRMMDataset
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
    TRMMMonthly(
        ST = String,
        DT = Date;
        start :: TimeType,
        stop  :: TimeType,
        path  :: AbstractString = homedir(),
    ) -> npd :: TRMMMonthly{ST,DT}

Creates a `TRMMMonthly` dataset `npd` to retrieve datasets from the Final post-processing runs for Monthly output

Keyword Arguments
=================
- `start` : Date at which download / analysis of the dataset begins
- `stop` : Date at which download / analysis of the dataset ends
- `path` : The directory in which the folder `trmmmonthly` will be created for data downloads, storage and analysis, default is the home directoy called by `homedir()`

The following fields in `npd` will be fixed as below:
- `ID` : trmmmonthly
- `name` : TRMM Monthly (TMPA 3B43)
- `doi` : 10.5067/TRMM/TMPA/MONTH/7
- `hroot` : https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_L3/TRMM_3B43.7
- `fpref` : 3B43
- `fsuff` : 7.HDF
"""
function TRMMMonthly(
    ST = String,
    DT = Date;
    start :: TimeType = Date(1998),
    stop  :: TimeType = Date(2019),
    path  :: AbstractString = homedir(),
)

	@info "$(modulelog()) - Setting up data structure containing information on TRMM Monthly data to be downloaded"

    fol = joinpath(path,"trmmmonthly"); if !isdir(fol); mkpath(fol) end
    fol = joinpath(path,"trmmmask");    if !isdir(fol); mkpath(fol) end

	start = Date(year(start),1,1)
	stop = Date(year(stop),12,31)
    trmmcheckdates(start,stop)

    return TRMMMonthly{ST,DT}(
		"trmmmonthly", "TRMM Monthly (TMPA 3B43)", "10.5067/TRMM/TMPA/MONTH/7",
        start, stop,
		joinpath(path,"trmmmonthly"),
		joinpath(path,"trmmmask"),
        "https://disc2.gesdisc.eosdis.nasa.gov/opendap/TRMM_L3/TRMM_3B43.7",
        "3B43", "7.HDF",
    )

end

function show(io::IO, npd::TRMMMonthly{ST,DT}) where {ST<:AbstractString, DT<:TimeType}
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
		"    Timestep                   : 1 Month\n",
        "    Data Resolution            : 0.25º\n",
        "    Data Server        (hroot) : ", npd.hroot, '\n',
	)
end
