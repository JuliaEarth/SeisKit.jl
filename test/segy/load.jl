@testset "Segy.load" begin
    # stacked 2D seismic in revision 1.0
    seis = Segy.load(joinpath(datadir, "stacked2Drev1.sgy"))
    @test length(seis.traces) == 7701
    @test length(seis.traceheaders) == 7701
    @test seis.binaryheader.SAMPLES_PER_TRACE == 351
    @test seis.binaryheader.SAMPLE_INTERVAL == 0x2710
end
