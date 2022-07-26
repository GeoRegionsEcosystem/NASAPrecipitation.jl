"""
    IMERGMonthly{ST<:AbstractString, DT<:TimeType} <: IMERGDataset

Object containing information on Montly IMERG datasets to be downloaded
"""
struct IMERGMonthly{ST<:AbstractString, DT<:TimeType} <: IMERGDataset
	npdID :: ST
	lname :: ST
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
- `npdID` : imergmonthly
- `lname` : IMERG Monthly
- `doi`   : 10.5067/GPM/IMERG/3B-MONTH/06
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
)

	@info "$(modulelog()) - Setting up data structure containing information on IMERG Monthly data to be downloaded"

    fol = joinpath(path,"imergmonthly"); if !isdir(fol); mkpath(fol) end
    fol = joinpath(path,"imergmask");    if !isdir(fol); mkpath(fol) end

	start = Date(year(start),1,1)
	stop  = Date(year(stop),12,31)
    imergcheckdates(start,stop)

    return IMERGMonthly{ST,DT}(
		"imergmonthly", "IMERG Monthly", "10.5067/GPM/IMERG/3B-MONTH/06",
        start, stop,
		joinpath(path,"imergmonthly"),
		joinpath(path,"imergmask"),
        "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGM.06",
        "3B-MO.MS.MRG.3IMERG", "V06B.HDF5",
    )

end

function show(io::IO, npd::IMERGMonthly{ST,DT}) where {ST<:AbstractString, DT<:TimeType}
    print(
		io,
		"The NASA Precipitation Dataset {$ST,$DT} has the following properties:\n",
		"    Dataset ID         (npdID) : ", npd.npdID, '\n',
		"    Logging Name       (lname) : ", npd.lname, '\n',
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
