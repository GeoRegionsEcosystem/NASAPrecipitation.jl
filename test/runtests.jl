using NASAPrecipitation
using Test

@testset "Setup NetRC for NASAPrecipitation.jl" begin
    @test setup(
        login = "nasaprecipitation",
        password = "NASAPrecipitation1"
    )
end

@testset "Test Downloading of IMERG Datasets" begin

    npd_hh = IMERGFinalHH(start=Date(2002),stop=Date(2002),path=pwd())
    npd_dy = IMERGFinalDY(start=Date(2002),stop=Date(2002),path=pwd())
    npd_mo = IMERGMonthly(start=Date(2002),stop=Date(2002),path=pwd())
    geo = GeoRegion("AR6_SEA")

    for npd in [npd_hh,npd_dy,npd_mo]
        @test download(npd,geo)
    end

end

@testset "Test Reading of IMERG Datasets" begin

    @test ds = read(npd_hh,geo,Date(2002),quiet=true)
    close(ds)
    @test ds = read(npd_dy,geo,Date(2002),quiet=true)
    close(ds)
    @test ds = read(npd_mo,geo,Date(2002),quiet=true)
    close(ds)
    @test !read(npd_dy,geo,Date(2003),quiet=true)

end

@testset "Test Downloading of LandSea Masks" begin

    trmm_mo = TRMMDummy(path=pwd())
    @test getLandSea(trmm_mo,geo,returnlsd=false)
    @test getLandSea(npd_mo,geo,returnlsd=false)

end

@testset "Test subGeoRegion Extraction" begin

    sgeo = RectRegion("TST","AR6_SEA","Test",[5,0,105,100],savegeo=false)
    @test extract(npd_mo,sgeo)
    @test extract(npd_mo,sgeo,geo)

end

@testset "Test Spatialtemporal Smoothing" begin

    @test smoothing(npd_hh,sgeo,temporal=true,hours=3)
    @test smoothing(npd_dy,sgeo,temporal=true,days=7,spatial=true,smoothlon=0.5)
    @test smoothing(npd_mo,sgeo,spatial=true,smoothlon=1,smoothlat=1)
    @test ds = read(npd_mo,geo,Date(2002),smooth=true,smoothlon=1,smoothlat=1,quiet=true)
    close(ds)

end