"""
    IMERGMonthly{ST<:AbstractString, DT<:TimeType} <: IMERGDataset

Object containing information on Montly IMERG datasets to be downloaded
"""
struct IMERGMonthly{ST<:AbstractString, DT<:TimeType} <: IMERGDataset
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
    IMERGMonthly(
        ST = String,
        DT = Date;
        start :: TimeType,
        stop  :: TimeType,
        path  :: AbstractString = homedir(),
    ) -> npd :: IMERGMonthly{ST,DT}

Creates a `IMERGMonthly` dataset `npd` to retrieve datasets for Monthly output

Keyword Arguments
=================
- `start` : Date at which download / analysis of the dataset begins
- `stop` : Date at which download / analysis of the dataset ends
- `path` : The directory in which the folder `imergmonthly` will be created for data downloads, storage and analysis, default is the home directoy called by `homedir()`

The following fields in `npd` will be fixed as below:
- `ID` : imergmonthly
- `name` : IMERG Monthly
- `doi` : 10.5067/GPM/IMERG/3B-MONTH/06
- `hroot` : https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGM.06
- `fpref` : 3B-MO.MS.MRG.3IMERG
- `fsuff` : V06B.HDF5
"""
function IMERGMonthly(
    ST = String,
    DT = Date;
    start :: TimeType = Date(2001),
    stop  :: TimeType = Dates.now() - Year(2),
    path  :: AbstractString = homedir(),
    v6    :: Bool = false,
)

	@info "$(modulelog()) - Setting up data structure containing information on IMERG Monthly data to be downloaded"

    if v6
        fol = joinpath(path,"imergv6monthly")
    else
        fol = joinpath(path,"imergv7monthly")
    end; if !isdir(fol); mkpath(fol) end
    fol = joinpath(path,"imergmask");    if !isdir(fol); mkpath(fol) end

	start = Date(year(start),1,1)
	stop  = Date(year(stop),12,31)
    imergcheckdates(start,stop)

    if v6
        return IMERGMonthly{ST,DT}(
            "imergv6monthly", "IMERGv6 Monthly", "10.5067/GPM/IMERG/3B-MONTH/06",
            start, stop,
            joinpath(path,"imergv6monthly"),
            joinpath(path,"imergmask"),
            "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGM.06",
            "3B-MO.MS.MRG.3IMERG", "V06B.HDF5", v6
        )
    else
        return IMERGMonthly{ST,DT}(
            "imergv7monthly", "IMERGv7 Monthly", "10.5067/GPM/IMERG/3B-MONTH/07",
            start, stop,
            joinpath(path,"imergv7monthly"),
            joinpath(path,"imergmask"),
            "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGM.07",
            "3B-MO.MS.MRG.3IMERG", "V07B.HDF5", v6
        )
    end

end

function show(io::IO, npd::IMERGMonthly{ST,DT}) where {ST<:AbstractString, DT<:TimeType}
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
		"    Timestep                   : 1 Month\n",
        "    Data Resolution            : 0.1º\n",
        "    Data Server        (hroot) : ", npd.hroot, '\n',
	)
end
