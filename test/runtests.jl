using Segy
using Test

# list of tests
testfiles = ["ibmfloat.jl"]

@testset "Segy.jl" begin
  for testfile in testfiles
    include(testfile)
  end
end
