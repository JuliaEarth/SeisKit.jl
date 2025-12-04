@testset "TextualHeader" begin
  h = Segy.textualheader(joinpath(datadir, "stacked2Drev1.sgy"))
  @test Segy.datum(h) === WGS84Latest
  @test_throws ErrorException Segy.crs(h)
end

@testset "TraceHeader" begin
  hs = Segy.traceheaders(joinpath(datadir, "stacked2Drev1.sgy"))
  xs = Segy.rawcoords.(hs)
  @test length(xs) == length(hs)
  @test all(x -> 466000u"m" < x[1] < 473600u"m", xs)
  @test all(x -> 7194309u"m" < x[2] < 7197755u"m", xs)
end
