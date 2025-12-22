@testset "Dataset" begin
  d = Segy.load(joinpath(datadir, "stacked2Drev1.sgy"))
  xy = Segy.rawcoords(d)
  @test length(xy) == length(d.traces)
  @test unit(first(first(xy))) == u"m"
  @test Segy.datum(d) === WGS84Latest
  @test_throws ErrorException Segy.crs(d)
  @test Segy.coords(d) == [Cartesian{WGS84Latest}(x, y) for (x, y) in xy]
  @test Segy.positions(d) == [Point(Cartesian{WGS84Latest}(x, y)) for (x, y) in xy]
  @test Segy.ndims(d) == 2
  @test Segy.matrix(d) isa Matrix{Float64}
  @test Segy.image(d).geometry isa StructuredGrid
  @test Segy.image(d, velocity=4000.0) == Segy.image(d)
  @test Segy.segment(d) == let
    points = sort(Segy.positions(d))
    Segment(first(points), last(points))
  end
end
