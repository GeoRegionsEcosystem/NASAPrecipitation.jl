"""
    IMERGHalfHourly{ST<:AbstractString, DT<:TimeType} <: IMERGDataset

Object containing information on Half-Hourly IMERG datasets to be downloaded
"""
struct IMERGHalfHourly{ST<:AbstractString, DT<:TimeType} <: IMERGDataset
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
    v6    :: Bool
end

"""
    IMERGEarlyHH(
        ST = String,
        DT = Date;
        start :: TimeType,
        stop  :: TimeType,
        path  :: AbstractString = homedir(),
    ) -> npd :: IMERGHalfHourly{ST,DT}

Creates a `IMERGHalfHourly` dataset `npd` to retrieve datasets from the Near Real-Time Early processing runs for Half-Hourly output

Keyword Arguments
=================
- `start` : Date at which download / analysis of the dataset begins
- `stop` : Date at which download / analysis of the dataset ends
- `path` : The directory in which the folder `imergearlyhh` will be created for data downloads, storage and analysis, default is the home directoy called by `homedir()`

The following fields in `npd` will be fixed as below:
- `ID` : imergearlyhh
- `name` : Early IMERG Half-Hourly
- `doi` : 10.5067/GPM/IMERG/3B-HH-E/06
- `hroot` : https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGHHE.06
- `fpref` : 3B-HHR-E.MS.MRG.3IMERG
- `fsuff` : V06B.HDF5
"""
function IMERGEarlyHH(
    ST = String,
    DT = Date;
    start :: TimeType = Date(2000,6,1),
    stop  :: TimeType = Dates.now() - Day(3),
    path  :: AbstractString = homedir(),
    v6    :: Bool = false,
)

	@info "$(modulelog()) - Setting up data structure containing information on Early IMERG Half-Hourly data to be downloaded"

    fol = joinpath(path,"imergearlyhh"); if !isdir(fol); mkpath(fol) end
    fol = joinpath(path,"imergmask");    if !isdir(fol); mkpath(fol) end
    imergcheckdates(start,stop)

    return IMERGHalfHourly{ST,DT}(
		"imergearlyhh", "Early IMERG Half-Hourly", "10.5067/GPM/IMERG/3B-HH-E/06",
        start, stop,
		joinpath(path,"imergearlyhh"),
		joinpath(path,"imergmask"),
        "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGHHE.06",
        "3B-HHR-E.MS.MRG.3IMERG", "V06B.HDF5", v6
    )

end

"""
    IMERGLateHH(
        ST = String,
        DT = Date;
        start :: TimeType,
        stop :: TimeType,
        path :: AbstractString = homedir(),
    ) -> npd :: IMERGHalfHourly{ST,DT}

Creates a `IMERGHalfHourly` dataset `npd` to retrieve datasets from the Near Real-Time Late processing runs for Half-Hourly output

Keyword Arguments
=================
- `start` : Date at which download / analysis of the dataset begins
- `stop` : Date at which download / analysis of the dataset ends
- `path` : The directory in which the folder `imerglatehh` will be created for data downloads, storage and analysis, default is the home directoy called by `homedir()`

The following fields in `npd` will be fixed as below:
- `ID` : imerglatehh
- `name` : Late IMERG Half-Hourly
- `doi`   : 10.5067/GPM/IMERG/3B-HH-L/06
- `hroot` : https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGHHL.06
- `fpref` : 3B-HHR-L.MS.MRG.3IMERG
- `fsuff` : V06B.HDF5
"""
function IMERGLateHH(
    ST = String,
    DT = Date;
    start :: TimeType = Date(2000,6,1),
    stop  :: TimeType = Dates.now() - Day(3),
    path  :: AbstractString = homedir(),
    v6    :: Bool = false
)

	@info "$(modulelog()) - Setting up data structure containing information on Late IMERG Half-Hourly data to be downloaded"

    fol = joinpath(path,"imerglatehh"); if !isdir(fol); mkpath(fol) end
    fol = joinpath(path,"imergmask");   if !isdir(fol); mkpath(fol) end
    imergcheckdates(start,stop)

    return IMERGHalfHourly{ST,DT}(
		"imerglatehh", "Late IMERG Half-Hourly", "10.5067/GPM/IMERG/3B-HH-L/06",
        start, stop,
		joinpath(path,"imerglatehh"),
		joinpath(path,"imergmask"),
        "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGHHL.06",
        "3B-HHR-L.MS.MRG.3IMERG", "V06B.HDF5", v6
    )

end

"""
    IMERGFinalHH(
        ST = String,
        DT = Date;
        start :: TimeType,
        stop :: TimeType,
        path :: AbstractString = homedir(),
    ) -> npd :: IMERGHalfHourly{ST,DT}

Creates a `IMERGHalfHourly` dataset `npd` to retrieve datasets from the final post-processing runs for Half-Hourly output

Keyword Arguments
=================
- `start` : Date at which download / analysis of the dataset begins
- `stop` : Date at which download / analysis of the dataset ends
- `path` : The directory in which the folder `imergfinalhh` will be created for data downloads, storage and analysis, default is the home directoy called by `homedir()`

The following fields in `npd` will be fixed as below:
- `ID` : imergfinalhh
- `name` : Final IMERG Half-Hourly
- `doi`   : 10.5067/GPM/IMERG/3B-HH/06
- `hroot` : https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGHH.06
- `fpref` : 3B-HHR.MS.MRG.3IMERG
- `fsuff` : V06B.HDF5
"""
function IMERGFinalHH(
    ST = String,
    DT = Date;
    start :: TimeType = Date(2000,6,1),
    stop  :: TimeType = Dates.now() - Month(6),
    path  :: AbstractString = homedir(),
    v6    :: Bool = false
)

	@info "$(modulelog()) - Setting up data structure containing information on Final IMERG Half-Hourly data to be downloaded"

    if v6
        fol = joinpath(path,"imergv6finalhh")
    else
        fol = joinpath(path,"imergv7finalhh")
    end; if !isdir(fol); mkpath(fol) end
    fol = joinpath(path,"imergmask");    if !isdir(fol); mkpath(fol) end
    imergcheckdates(start,stop)

    if v6
        return IMERGHalfHourly{ST,DT}(
            "imergv6finalhh", "Final IMERGv6 Half-Hourly", "10.5067/GPM/IMERG/3B-HH/06",
            start, stop,
            joinpath(path,"imergv6finalhh"),
            joinpath(path,"imergmask"),
            "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGHH.06",
            "3B-HHR.MS.MRG.3IMERG", "V06B.HDF5", v6
        )
    else
        return IMERGHalfHourly{ST,DT}(
            "imergv7finalhh", "Final IMERGv7 Half-Hourly", "10.5067/GPM/IMERG/3B-HH/07",
            start, stop,
            joinpath(path,"imergv7finalhh"),
            joinpath(path,"imergmask"),
            "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGHH.07",
            "3B-HHR.MS.MRG.3IMERG", "V07B.HDF5", v6
        )
    end

end

function show(io::IO, npd::IMERGHalfHourly{ST,DT}) where {ST<:AbstractString, DT<:TimeType}
    print(
		io,
		"The NASA Precipitation Dataset {$ST,$DT} has the following properties:\n",
		"    Dataset ID            (ID) : ", npd.ID, '\n',
		"    Logging Name        (name) : ", npd.name, '\n',
		"    DOI URL              (doi) : ", npd.doi,   '\n',
		"    Data Directory  (datapath) : ", npd.datapath, '\n',
		"    Mask Directory  (maskpath) : ", npd.maskpath, '\n',
		"    Date Begin         (start) : ", npd.start, '\n',
		"    Date End            (stop) : ", npd.stop, '\n',
		"    Timestep                   : 30 minutes\n",
        "    Data Resolution            : 0.1º\n",
        "    Data Server        (hroot) : ", npd.hroot, '\n',
	)
end
