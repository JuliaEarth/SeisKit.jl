@testset "Segy.gathers" begin
  fname = joinpath(datadir, "stacked2Drev1.sgy")
  fields = ("CROSSLINE_NUMBER",)

  # load all gathers into memory (not lazy)
  gathers = Segy.gathers(fname, fields)
  @test length(gathers) == 151

  # cannot load gathers lazily from a file name
  @test_throws ErrorException Segy.gathers(fname, fields, lazy=true)

  # load gathers lazily from an IO stream
  io = open(fname)
  gathers = Segy.gathers(io, fields, lazy=true)
  @test length(gathers) == 151
  close(io)

  # methods with a single field for convenience
  gathers = Segy.gathers(fname, "CROSSLINE_NUMBER")
  @test length(gathers) == 151
  gathers = Segy.gathers(fname, :CROSSLINE_NUMBER)
  @test length(gathers) == 151
end
