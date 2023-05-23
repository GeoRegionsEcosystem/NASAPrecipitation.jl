struct IMERGDummy{ST<:AbstractString} <: IMERGDataset
	maskpath :: ST
end

struct TRMMDummy{ST<:AbstractString} <: TRMMDataset
	maskpath :: ST
end

function IMERGDummy(
    ST = String;
    path :: AbstractString = homedir(),
)

	@info "$(modulelog()) - Setting up data structure containing path information for IMERG Dummy Dataset"

    fol = joinpath(path,"imergmask"); if !isdir(fol); mkpath(fol) end

    return IMERGDummy{ST}(joinpath(path,"imergmask"))

end

function TRMMDummy(
    ST = String;
    path :: AbstractString = homedir(),
)

	@info "$(modulelog()) - Setting up data structure containing path information for TRMM Dummy Dataset"

    fol = joinpath(path,"trmmmask"); if !isdir(fol); mkpath(fol) end

    return TRMMDummy{ST}(joinpath(path,"trmmmask"))

end

function show(io::IO, npd::IMERGDummy{ST}) where {ST<:AbstractString}
    print(
		io,
		"The IMERG Dummy Dataset {$ST} has the following properties:\n",
		"    Mask Directory (maskpath) : ", npd.maskpath, '\n',
        "    Data Resolution           : 0.1º\n",
	)
end

function show(io::IO, npd::TRMMDummy{ST}) where {ST<:AbstractString}
    print(
		io,
		"The TRMM Dummy Dataset {$ST} has the following properties:\n",
		"    Mask Directory (maskpath) : ", npd.maskpath, '\n',
        "    Data Resolution           : 0.25º\n",
	)
end