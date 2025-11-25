@testset "Segy.save" begin
  file = tempname() * ".sgy"
  seis1 = Segy.load(joinpath(datadir, "stacked2Drev1.sgy"))
  Segy.save(file, seis1)
  seis2 = Segy.load(file)
  @test seis1.traces == seis2.traces
end