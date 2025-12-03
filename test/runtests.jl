using SeisKit
using Unitful
using Test

# environment settings
isCI = "CI" ∈ keys(ENV)
islinux = Sys.islinux()
visualtests = !isCI || (isCI && islinux)
datadir = joinpath(@__DIR__, "data")

# list of tests
testfiles = [
  # core tests
  "segy/ibmfloat.jl",
  "segy/headers.jl",

  # load/save tests
  "segy/load.jl",
  "segy/save.jl",

  # utility tests
  "segy/utils.jl"
]

@testset "SeisKit.jl" begin
  for testfile in testfiles
    println("Testing $testfile...")
    include(testfile)
  end
end
