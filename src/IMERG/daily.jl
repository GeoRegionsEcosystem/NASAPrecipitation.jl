"""
    IMERGDaily{ST<:AbstractString, DT<:TimeType} <: IMERGDataset

Object containing information on Daily IMERG datasets to be downloaded
"""
struct IMERGDaily{ST<:AbstractString, DT<:TimeType} <: IMERGDataset
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
    IMERGEarlyDY(
        ST = String,
        DT = Date;
        dtbeg :: TimeType,
        dtend :: TimeType,
        sroot :: AbstractString = homedir(),
    ) -> npd :: IMERGDaily{ST,DT}

Creates a `IMERGDaily` dataset `npd` to retrieve datasets from the Near Real-Time Early processing runs for Daily output

Keyword Arguments
=================
- `dtbeg` : Date at which download / analysis of the dataset begins
- `dtend` : Date at which download / analysis of the dataset ends
- `sroot` : The directory in which the folder `imergearlydy` will be created for data downloads, storage and analysis, default is the home directoy called by `homedir()`

The following fields in `npd` will be fixed as below:
- `npdID` : imergearlydy
- `lname` : Early IMERG Daily
- `doi`   : 10.5067/GPM/IMERGDE/DAY/06
- `hroot` : https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGDE.06
- `fpref` : 3B-DAY-E.MS.MRG.3IMERG
- `fsuff` : S000000-E235959.V06.nc4
"""
function IMERGEarlyDY(
    ST = String,
    DT = Date;
    dtbeg :: TimeType = Date(2000,6),
    dtend :: TimeType = Dates.now() - Month(2),
    sroot :: AbstractString = homedir(),
)

	@info "$(modulelog()) - Setting up data structure containing information on Early IMERG Daily data to be downloaded"

    fol = joinpath(sroot,"imergearlydy"); if !isdir(fol); mkpath(fol) end

	dtbeg = Date(year(dtbeg),month(dtbeg),1)
	dtend = Date(year(dtend),month(dtend),daysinmonth(dtend))
    imergcheckdates(dtbeg,dtend)

    return IMERGDaily{ST,DT}(
		"imergearlydy", "Early IMERG Daily", "10.5067/GPM/IMERGDE/DAY/06",
        dtbeg, dtend,
		joinpath(sroot,"imergearlydy"),
		joinpath(sroot,"imergmask"),
        "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGDE.06",
        "3B-DAY-E.MS.MRG.3IMERG", "S000000-E235959.V06.nc4",
    )

end

"""
    IMERGLateDY(
        ST = String,
        DT = Date;
        dtbeg :: TimeType,
        dtend :: TimeType,
        sroot :: AbstractString = homedir(),
    ) -> npd :: IMERGDaily{ST,DT}

Creates a `IMERGDaily` dataset `npd` to retrieve datasets from the Near Real-Time Late processing runs for Daily output

Keyword Arguments
=================
- `dtbeg` : Date at which download / analysis of the dataset begins
- `dtend` : Date at which download / analysis of the dataset ends
- `sroot` : The directory in which the folder `imerglatedy` will be created for data downloads, storage and analysis, default is the home directoy called by `homedir()`

The following fields in `npd` will be fixed as below:
- `npdID` : imerglatedy
- `lname` : Late IMERG Daily
- `doi`   : 10.5067/GPM/IMERGDL/DAY/06
- `hroot` : https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGDL.06
- `fpref` : 3B-DAY-L.MS.MRG.3IMERG
- `fsuff` : S000000-E235959.V06.nc4
"""
function IMERGLateDY(
    ST = String,
    DT = Date;
    dtbeg :: TimeType = Date(2000,6),
    dtend :: TimeType = Dates.now() - Month(2),
    sroot :: AbstractString = homedir(),
)

	@info "$(modulelog()) - Setting up data structure containing information on Late IMERG Daily data to be downloaded"

    fol = joinpath(sroot,"imerglatedy"); if !isdir(fol); mkpath(fol) end

	dtbeg = Date(year(dtbeg),month(dtbeg),1)
	dtend = Date(year(dtend),month(dtend),daysinmonth(dtend))
    imergcheckdates(dtbeg,dtend)

    return IMERGDaily{ST,DT}(
		"imerglatedy", "Late IMERG Daily", "10.5067/GPM/IMERGDL/DAY/06",
        dtbeg, dtend,
		joinpath(sroot,"imerglatedy"),
		joinpath(sroot,"imergmask"),
        "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGDL.06",
        "3B-DAY-L.MS.MRG.3IMERG", "S000000-E235959.V06.nc4",
    )

end

"""
    IMERGFinalDY(
        ST = String,
        DT = Date;
        dtbeg :: TimeType,
        dtend :: TimeType,
        sroot :: AbstractString = homedir(),
    ) -> npd :: IMERGDaily{ST,DT}

Creates a `IMERGDaily` dataset `npd` to retrieve datasets from the Final post-processing runs for Daily output

Keyword Arguments
=================
- `dtbeg` : Date at which download / analysis of the dataset begins
- `dtend` : Date at which download / analysis of the dataset ends
- `sroot` : The directory in which the folder `imergfinaldy` will be created for data downloads, storage and analysis, default is the home directoy called by `homedir()`

The following fields in `npd` will be fixed as below:
- `npdID` : imergfinaldy
- `npdID` : Final IMERG Daily
- `doi`   : 10.5067/GPM/IMERGDF/DAY/06
- `hroot` : https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGDF.06
- `fpref` : 3B-DAY.MS.MRG.3IMERG
- `fsuff` : S000000-E235959.V06.nc4
"""
function IMERGFinalDY(
    ST = String,
    DT = Date;
    dtbeg :: TimeType = Date(2000,6),
    dtend :: TimeType = Dates.now() - Month(6),
    sroot :: AbstractString = homedir(),
)

	@info "$(modulelog()) - Setting up data structure containing information on Final IMERG Daily data to be downloaded"

    fol = joinpath(sroot,"imergfinaldy"); if !isdir(fol); mkpath(fol) end

	dtbeg = Date(year(dtbeg),month(dtbeg),1)
	dtend = Date(year(dtend),month(dtend),daysinmonth(dtend))
    imergcheckdates(dtbeg,dtend)

    return IMERGDaily{ST,DT}(
		"imergfinaldy", "Final IMERG Daily", "10.5067/GPM/IMERGDF/DAY/06",
        dtbeg, dtend,
		joinpath(sroot,"imergfinaldy"),
		joinpath(sroot,"imergmask"),
        "https://gpm1.gesdisc.eosdis.nasa.gov/opendap/GPM_L3/GPM_3IMERGDF.06",
        "3B-DAY.MS.MRG.3IMERG", "S000000-E235959.V06.nc4",
    )

end

function show(io::IO, npd::IMERGDaily{ST,DT}) where {ST<:AbstractString, DT<:TimeType}
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
		"    Timestep                : 1 Day\n",
        "    Data Resolution         : 0.1º\n",
        "    Data Server     (hroot) : ", npd.hroot, '\n',
	)
end
