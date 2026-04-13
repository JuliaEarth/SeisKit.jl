@testset "Traces" begin
  fname = joinpath(datadir, "stacked2Drev1.sgy")
  trh = Segy.traceheaders(fname)
  tr1 = Segy.traces(fname, trh, 10:20)
  tr2 = Segy.traces(fname, trh, 20:-1:10)
  @test length(tr1) == 11
  @test length(tr2) == 11
  @test tr2 == reverse(tr1)
end
