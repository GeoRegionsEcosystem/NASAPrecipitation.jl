struct LandSea{FT<:Real}
    lon  :: Vector{FT}
    lat  :: Vector{FT}
    lsm  :: Array{FT,2}
    mask :: Array{Int,2}
end

function show(io::IO, lsd::LandSea)
	nlon = length(lsd.lon)
	nlat = length(lsd.lat)
    print(
		io,
		"The Land-Sea Mask Dataset has the following properties:\n",
		"    Longitude Points    (lon) : ", lsd.lon,  '\n',
		"    Latitude Points     (lat) : ", lsd.lat,  '\n',
		"    Region Size (nlon * nlat) : $(nlon) lon points x $(nlat) lat points\n",
	)
end