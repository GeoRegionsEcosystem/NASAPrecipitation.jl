## DateString Aliasing
yrmo2dir(date::TimeType) = Dates.format(date,dateformat"yyyy/mm")
yrmo2str(date::TimeType) = Dates.format(date,dateformat"yyyymm")
yr2str(date::TimeType)   = Dates.format(date,dateformat"yyyy")
ymd2str(date::TimeType)  = Dates.format(date,dateformat"yyyymmdd")

function arthurhou(email::AbstractString)
    return "https://$(email):$(email)@arthurhouhttps.pps.eosdis.nasa.gov/"
end

function jsimpson(email::AbstractString)
    return "https://$(email):$(email)@jsimpsonhttps.pps.eosdis.nasa.gov/"
end

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

function ncoffsetscale(data::Array{<:Real},init=0)

    dmax = init
    dmin = init
    for ii = 1 : length(data)
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
    outarray :: Array{Int16},
    inarray  :: Array{<:Real},
    scale    :: Real,
    offset   :: Real
)

    for ii = 1 : length(inarray)

        idata = (inarray[ii] - offset) / scale
        if isnan(idata)
              outarray[ii] = -32767
        else; outarray[ii] = round(Int16,idata)
        end

    end

    return

end
