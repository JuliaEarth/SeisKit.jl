@testset "Dataset" begin
  # low-level api
  d = Segy.load(joinpath(datadir, "stacked2Drev1.sgy"))
  xy = Segy.rawcoords(d)
  @test length(xy) == length(d.traces)
  @test unit(first(first(xy))) == u"m"
  @test Segy.datum(d) === WGS84Latest
  @test_throws ErrorException Segy.crs(d)
  @test Segy.coords(d) == [Cartesian{WGS84Latest}(x, y) for (x, y) in xy]
  @test Segy.positions(d) == [Point(Cartesian{WGS84Latest}(x, y)) for (x, y) in xy]
  @test Segy.ndims(d) == 2
  @test Segy.image(d) isa Matrix{Float64}
  @test Segy.segment(d) == let
    points = Segy.positions(d)
    Segment(first(points), last(points))
  end

  # image and grid relations
  img = Segy.image(d)
  grid = Segy.grid(d)
  @test grid isa StructuredGrid
  @test size(grid) == (350, 7700)
  @test size(img) == size(grid) .+ 1
  @test Segy.grid(d, velocity=4000.0) == Segy.grid(d)
end
