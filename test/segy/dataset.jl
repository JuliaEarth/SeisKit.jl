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
  @test Segy.matrix(d) isa Matrix{Float64}
  @test Segy.segment(d) == let
    points = sort(Segy.positions(d))
    Segment(first(points), last(points))
  end

  # high-level api
  mat = Segy.matrix(d)
  img = Segy.image(d)
  grid = img.geometry
  vals = values(img, 0)
  @test isnothing(values(img))
  @test grid isa StructuredGrid
  @test size(grid) == (350, 7700)
  @test size(mat) == size(grid) .+ 1
  @test vals.signal == vec(mat)
  @test Segy.image(d, velocity=4000.0) == Segy.image(d)
end
