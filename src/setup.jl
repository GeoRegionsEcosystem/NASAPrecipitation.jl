function setup(;
    login     :: AbstractString = "",
    password  :: AbstractString = "",
    overwrite :: Bool = false
)

    fdodsrc = joinpath(homedir(),".dodsrc")
    if !isfile(fdodsrc)
        @info "$(modulelog()) - Setting up .dodsrc file for NASA OPeNDAP servers to point at cookie and .netrc directories ..."
        open(fdodsrc,"w") do f
            write(f,"HTTP.COOKIEJAR=$(joinpath(homedir(),".urs_cookies"))")
            write(f,"HTTP.NETRC=$(joinpath(homedir(),".netrc"))")
        end
    else
        if overwrite
            @warn "$(modulelog()) - .dodsrc file exists at $fdodsrc, overwriting again"
            open(fdodsrc,"w") do f
                write(f,"HTTP.COOKIEJAR=$(joinpath(homedir(),".urs_cookies"))")
                write(f,"HTTP.NETRC=$(joinpath(homedir(),".netrc"))")
            end
        else
            @info "$(modulelog()) - .dodsrc file exists at $fdodsrc"
        end
    end

    if !netrc_check()
        if login == "" && password == ""
            @warn "$(modulelog()) - .netrc file does not exist at $(netrc_file()), you need to setup the .netrc file in order for NASAPrecipitation.jl to work"
        end
    end

    if netrc_check() && !netrc_checkmachine(netrc_read(logging=false),machine="urs.earthdata.nasa.gov")
        if login == "" && password == ""
            @warn "$(modulelog()) - No existing machine urs.earthdata.nasa.gov in .netrc file, please setup login and password for this machine for NASAPrecipitation.jl to work"
        end
    end

    if login != "" && password != ""
        @info "$(modulelog()) - Setting up .netrc file containing login and password information for NASA OPeNDAP servers ..."
        netrc = netrc_read()
        if netrc_check() && netrc_checkmachine(netrc,machine="urs.earthdata.nasa.gov")
            netrc_modify!(netrc,machine="urs.earthdata.nasa.gov",login=login,password=password)
        else
            netrc_add!(netrc,machine="urs.earthdata.nasa.gov",login=login,password=password)
        end
        netrc_write(netrc)
    end

end