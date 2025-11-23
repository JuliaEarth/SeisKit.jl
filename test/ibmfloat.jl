@testset "IBMFloat32" begin
  # examples from Wikipedia page
  b = 0b1_100_0010_0111_0110_1010_0000_0000_0000
  x = convert(Float64, reinterpret(SeisKit.IBMFloat32, b))
  @test x == -118.625

  # largest representable number
  b = 0b0_111_1111_1111_1111_1111_1111_1111_1111
  x = convert(Float64, reinterpret(SeisKit.IBMFloat32, b))
  @test x == 7.2370051459731155e75

  # smallest positive normalized number
  b = 0b0_000_0000_0001_0000_0000_0000_0000_0000
  x = convert(Float64, reinterpret(SeisKit.IBMFloat32, b))
  @test x == 5.397605346934028e-79

  # zero
  b = 0b0_000_0000_0000_0000_0000_0000_0000_0000
  x = convert(Float64, reinterpret(SeisKit.IBMFloat32, b))
  @test iszero(x)
end
