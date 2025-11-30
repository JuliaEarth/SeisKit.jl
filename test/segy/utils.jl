@testset "Utilities" begin
  @test Segy.isbigendian(joinpath(datadir, "stacked2Drev1.sgy"))
  @test Segy.numbertype(joinpath(datadir, "stacked2Drev1.sgy")) == Segy.IBMFloat32
  @test Segy.version(joinpath(datadir, "stacked2Drev1.sgy")).major == 1
  @test Segy.version(joinpath(datadir, "stacked2Drev1.sgy")).minor == 0
  @test Segy.samplespertrace(joinpath(datadir, "stacked2Drev1.sgy")) == 351
  @test Segy.ensembletype(joinpath(datadir, "stacked2Drev1.sgy")) == :STACKED
end
