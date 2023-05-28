"""
    NASAPrecipitation.LandSea <: GeoRegions.LandSeaFlat

Object containing information on the Land Sea mask for IMERG or TRMM, a subType extension of the `GeoRegions.LandSeaFlat` superType
"""
struct LandSea{FT<:Real} <: LandSeaFlat
    lon  :: Vector{FT}
    lat  :: Vector{FT}
    lsm  :: Array{FT,2}
    mask :: Array{Int,2}
end