@testset "Dataset" begin
  d = Segy.load(joinpath(datadir, "stacked2Drev1.sgy"))
  x = Segy.rawcoords(d)
  @test length(x) == length(d.traces)
  @test unit(first(first(x))) == u"m"
end
