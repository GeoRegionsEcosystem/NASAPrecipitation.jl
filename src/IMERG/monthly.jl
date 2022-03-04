"""
    IMERGMonthly{ST<:AbstractString, DT<:TimeType} <: IMERGDataset

Object containing information on Montly IMERG datasets to be downloaded
"""
struct IMERGMonthly{ST<:AbstractString, DT<:TimeType} <: IMERGDataset
	npdID :: ST
	lname :: ST
	doi   :: ST
    dtbeg :: DT
    dtend :: DT
    sroot :: ST
    smask :: ST
    hroot :: ST
    fpref :: ST
    fsuff :: ST
end

"""
    IMERGMonthly(
        ST = String,
        DT = Date;
        dtbeg :: TimeType,
        dtend :: TimeType,
        sroot :: AbstractString = homedir(),
    ) -> npd :: IMERGMonthly{ST,DT}

Creates a `IMERGMonthly` dataset `npd` to retrieve datasets for Monthly output

Keyword Arguments
=================
- `dtbeg` : Date at which download / analysis of the dataset begins
- `dtend` : Date at which download / analysis of the dataset ends
- `sroot` : The directory in which the folder `imergmonthly` will be created for data downloads, storage and analysis, default is the home directoy called by `homedir()`

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
    dtbeg :: TimeType = Date(2001),
    dtend :: TimeType = Dates.now() - Year(2),
    sroot :: AbstractString = homedir(),
)

	@info "$(modulelog()) - Setting up data structure containing information on IMERG Monthly data to be downloaded"

    fol = joinpath(sroot,"imergmonthly"); if !isdir(fol); mkpath(fol) end

	dtbeg = Date(year(dtbeg),1,1)
	dtend = Date(year(dtend),12,31)
    imergcheckdates(dtbeg,dtend)

    return IMERGMonthly{ST,DT}(
		"imergmonthly", "IMERG Monthly", "10.5067/GPM/IMERG/3B-MONTH/06",
        dtbeg, dtend,
		joinpath(sroot,"imergmonthly"),
		joinpath(sroot,"imergmask"),
        "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGM.06",
        "3B-MO.MS.MRG.3IMERG", "V06B.HDF5",
    )

end

function show(io::IO, npd::IMERGMonthly{ST,DT}) where {ST<:AbstractString, DT<:TimeType}
    print(
		io,
		"The NASA Precipitation Dataset {$ST,$DT} has the following properties:\n",
		"    Dataset ID      (npdID) : ", npd.npdID, '\n',
		"    Logging Name    (lname) : ", npd.lname, '\n',
		"    DOI URL          (doi)  : ", npd.doi,   '\n',
		"    Data Directory  (sroot) : ", npd.sroot, '\n',
		"    Mask Directory  (smask) : ", npd.smask, '\n',
		"    Date Begin      (dtbeg) : ", npd.dtbeg, '\n',
		"    Date End        (dtend) : ", npd.dtend, '\n',
		"    Timestep                : 1 Month\n",
        "    Data Resolution         : 0.1º\n",
        "    Data Server     (hroot) : ", npd.hroot, '\n',
	)
end
