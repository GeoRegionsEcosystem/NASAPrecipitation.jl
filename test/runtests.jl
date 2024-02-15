using NASAPrecipitation
using Test

@testset "Setup NetRC for NASAPrecipitation.jl" begin
    @test isnothing(setup(
        login = "nasaprecipitation",
        password = "NASAPrecipitation1"
    ))
end

@testset "Test Downloading of IMERG Datasets" begin

    npd_hh = IMERGFinalHH(start=Date(2002),stop=Date(2002),path=pwd())
    npd_dy = IMERGFinalDY(start=Date(2002),stop=Date(2002),path=pwd())
    npd_mo = IMERGMonthly(start=Date(2002),stop=Date(2002),path=pwd())
    geo = GeoRegion("AR6_SEA")

    @test npd_hh.start == Date(2002)
    @test npd_dy.start == Date(2002)
    @test npd_mo.start == Date(2002)

    @test npd_hh.stop == Date(2002)
    @test npd_dy.stop == Date(2002,1,31)
    @test npd_mo.stop == Date(2002,12,31)

    for npd in [npd_hh,npd_dy,npd_mo]
        #@test isnothing(download(npd,geo))
    end

end
