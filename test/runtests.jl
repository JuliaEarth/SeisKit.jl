using SeisKit
using Test

# environment settings
isCI = "CI" ∈ keys(ENV)
islinux = Sys.islinux()
visualtests = !isCI || (isCI && islinux)
datadir = joinpath(@__DIR__, "data")

# list of tests
testfiles = ["segy/ibmfloat.jl", "segy/load.jl", "segy/save.jl", "segy/utils.jl"]

@testset "SeisKit.jl" begin
  for testfile in testfiles
    println("Testing $testfile...")
    include(testfile)
  end
end
