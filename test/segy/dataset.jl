@testset "Dataset" begin
  d = Segy.load(joinpath(datadir, "stacked2Drev1.sgy"))
  x = Segy.rawcoords(d)
  @test length(x) == length(d.traces)
  @test unit(first(first(x))) == u"m"
  @test Segy.datum(d) === WGS84Latest
  @test_throws ErrorException Segy.crs(d)
end
