"""
    IMERGDummy{ST<:AbstractString} <: IMERGDataset

Object containing information on path information for IMERG datasets, with the following fields:
- `rootpath` : path of folder containing all GPM IMERG datasets
- `maskpath` : path of folder containing IMERG LandSea mask data
"""
struct IMERGDummy{ST<:AbstractString} <: IMERGDataset
    rootpath :: ST
	maskpath :: ST
end

"""
    TRMMDummy{ST<:AbstractString} <: TRMMDataset

Object containing information on path information for TRMM datasets, with the following fields:
- `rootpath` : path of folder containing all GPM IMERG datasets
- `maskpath` : path of folder containing IMERG LandSea mask data
"""
struct TRMMDummy{ST<:AbstractString} <: TRMMDataset
    rootpath :: ST
	maskpath :: ST
end

"""
    IMERGDummy(
        ST = String;
        path  :: AbstractString = homedir(),
    ) -> npd :: IMERGDummy

Creates a `IMERGDummy` dataset `npd` that contains information on the data and mask paths

Keyword Arguments
=================
- `path` : The directory in which the folder `imergmask` will be created for the IMERG Land-Sea mask
"""
function IMERGDummy(
    ST = String;
    path :: AbstractString = homedir(),
)

	@info "$(modulelog()) - Setting up data structure containing path information for IMERG Dummy Dataset"

    if !isdir(path); mkpath(path) end
    fol = joinpath(path,"imergmask"); if !isdir(fol); mkpath(fol) end

    return IMERGDummy{ST}(path,joinpath(path,"imergmask"))

end

"""
    TRMMDummy(
        ST = String;
        path  :: AbstractString = homedir(),
    ) -> npd :: IMERGDummy

Creates a `TRMMDummy` dataset `npd` that contains information on the data and mask paths

Keyword Arguments
=================
- `path` : The directory in which the folder `trmmmask` will be created for the TRMM Land-Sea mask
"""
function TRMMDummy(
    ST = String;
    path :: AbstractString = homedir(),
)

	@info "$(modulelog()) - Setting up data structure containing path information for TRMM Dummy Dataset"

    if !isdir(path); mkpath(path) end
    fol = joinpath(path,"trmmmask"); if !isdir(fol); mkpath(fol) end

    return TRMMDummy{ST}(path,joinpath(path,"trmmmask"))

end

function show(io::IO, npd::IMERGDummy{ST}) where {ST<:AbstractString}
    print(
		io,
		"The IMERG Dummy Dataset {$ST} has the following properties:\n",
        "    Root Directory (rootpath) : ", npd.rootpath, '\n',
		"    Mask Directory (maskpath) : ", npd.maskpath, '\n',
        "    Data Resolution           : 0.1º\n",
	)
end

function show(io::IO, npd::TRMMDummy{ST}) where {ST<:AbstractString}
    print(
		io,
		"The TRMM Dummy Dataset {$ST} has the following properties:\n",
        "    Root Directory (rootpath) : ", npd.rootpath, '\n',
		"    Mask Directory (maskpath) : ", npd.maskpath, '\n',
        "    Data Resolution           : 0.25º\n",
	)
end