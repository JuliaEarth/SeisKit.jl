using SeisKit
using Test

# list of tests
testfiles = ["ibmfloat.jl"]

@testset "SeisKit.jl" begin
  for testfile in testfiles
    println("Testing $testfile...")
    include(testfile)
  end
end
