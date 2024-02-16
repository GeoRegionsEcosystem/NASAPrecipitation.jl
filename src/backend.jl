"""
    addNPDGeoRegions() -> nothing

Checks for the three GeoRegions (GPM, TRMM, TRMMLSM) required by NASAPrecipitation.jl, and adds them if they do not exist.
"""
function addNPDGeoRegions()
	@info "$(modulelog()) - Checking to see if GeoRegions required by NASAPrecipitation.jl have been added to the list of available GeoRegions"
    disable_logging(Logging.Warn)
	if !isGeoRegion("IMERG",throw=false) ||
	    !isGeoRegion("TRMM",throw=false) ||
	    !isGeoRegion("TRMMLSM",throw=false)
        disable_logging(Logging.Debug)
        @info "$(modulelog()) - At least one of the required three GeoRegions (IMERG, TRMM, TRMMLSM) has not been added, proceeding to add them again ..."
	    addGeoRegions(joinpath(@__DIR__,"NPDGeoRegions.txt"))
    else
        disable_logging(Logging.Debug)
        @info "$(modulelog()) - All of the required three GeoRegions (IMERG, TRMM, TRMMLSM) have been added"
	end
	return
end

## DateString Aliasing
yrmo2dir(date::TimeType) = Dates.format(date,dateformat"yyyy/mm")
yrmo2str(date::TimeType) = Dates.format(date,dateformat"yyyymm")
yr2str(date::TimeType)   = Dates.format(date,dateformat"yyyy")
ymd2str(date::TimeType)  = Dates.format(date,dateformat"yyyymmdd")

function imergrawfiles()

    fnc = Vector{AbstractString}(undef,48);

    for ii = 1 : 48

        hr = (ii-1)/2; mi = mod(hr,1); hr = hr - mi;
        hr = @sprintf("%02d",hr);
        id = @sprintf("%04d",(ii-1)*30);

        if iszero(mi)
              fnc[ii] = "S$(hr)0000-E$(hr)2959.$(id)"
        else; fnc[ii] = "S$(hr)3000-E$(hr)5959.$(id)"
        end

    end

    return fnc

end

function gpmlonlat()
    lon = convert(Array,-179.95:0.1:179.95)
    lat = convert(Array,-89.95:0.1:89.95)
    return lon,lat
end

function trmmlonlat(;full::Bool=false)

    lon = convert(Array,-179.875:0.25:179.875)
    if !full
		  lat = convert(Array,-49.875:0.25:49.875)
	else; lat = convert(Array,-89.875:0.25:89.875)
	end

    return lon,lat

end

function trmmcheckdates(
    dtbeg :: TimeType,
    dtend :: TimeType
)

    if dtbeg < Date(1998,1,1)
        error("$(modulelog()) - You have specified a date that is before the earliest available date of TRMM TMPA data, 1998-01-01.")
    end

    if dtend > Date(2019,12,31)
        error("$(modulelog()) - You have specified a date that is after the latest available date of TRMM TMPA data, 2019-12-31.")
    end

end

function imergcheckdates(
    dtbeg :: TimeType,
    dtend :: TimeType
)

    if dtbeg < Date(2000,6,1)
        error("$(modulelog()) - You have specified a date that is before the earliest available date of GPM IMERG data, 2000-06-01.")
    end

    if dtend > (Dates.now() - Day(3))
        error("$(modulelog()) - You have specified a date that is later than the latest available date of GPM IMERG Near-Realtime data, $(now() - Day(3)).")
    end

end

function ncoffsetscale(data::AbstractArray{<:Real})

    init = data[findfirst(!isnan,data)]
    dmax = init
    dmin = init
    for ii in eachindex(data)
        dataii = data[ii]
        if !isnan(dataii)
            if dataii > dmax; dmax = dataii end
            if dataii < dmin; dmin = dataii end
        end
    end

    scale = (dmax-dmin) / 65533;
    offset = (dmax+dmin-scale) / 2;

    return scale,offset

end

function real2int16!(
    outarray :: AbstractArray{Int16},
    inarray  :: AbstractArray{<:Real},
    scale    :: Real,
    offset   :: Real
)

    for ii in eachindex(inarray)

        idata = (inarray[ii] - offset) / scale
        if isnan(idata)
              outarray[ii] = -32767
        else; outarray[ii] = round(Int16,idata)
        end

    end

    return

end

function extractregionlsm!(
	outarray :: Array{<:Real,2},
	inarray  :: Array{<:Real,2},
	ginfo	 :: RectGrid
)

    iglon = ginfo.ilon
    iglat = ginfo.ilat
    for ilat in eachindex(iglat), ilon in eachindex(iglon)
		outarray[ilon,ilat] = inarray[iglat[ilat],iglon[ilon]]
	end

end

function extractregionlsm!(
	outarray :: Array{<:Real,2},
	inarray  :: Array{<:Real,2},
	ginfo	 :: PolyGrid
)

	iglon = ginfo.ilon
	iglat = ginfo.ilat
	for ilat in eachindex(iglat), ilon in eachindex(iglon)
		outarray[ilon,ilat] = inarray[iglat[ilat],iglon[ilon]] * ginfo.mask[ilon,ilat]
	end

end

function nanmean(
    data :: AbstractArray,
    dNaN :: AbstractArray
)
    nNaN = length(dNaN)
    for iNaN in 1 : nNaN
        dNaN[iNaN] = !isnan(data[iNaN])
    end
    dataii = @view data[dNaN]
    if !isempty(dataii); return mean(dataii); else; return NaN; end
end

function nanmean(
    data :: AbstractArray,
    dNaN :: AbstractArray,
    wgts :: AbstractArray,
)
    nNaN = length(dNaN)
    for iNaN in 1 : nNaN
        dNaN[iNaN] = !isnan(data[iNaN])
    end
    dataii = view(data,dNaN) .* view(wgts,dNaN)
    wgtsii = view(wgts,dNaN)
    if !isempty(dataii); return sum(dataii) / sum(wgtsii); else; return NaN; end
end