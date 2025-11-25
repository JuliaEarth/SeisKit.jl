# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

using PrecompileTools

@setup_workload begin
  fname = joinpath(@__DIR__, "..", "test", "data", "stacked2Drev1.sgy")
  @compile_workload begin
    seismic = Segy.load(fname)
    Segy.save(tempname()*".sgy", seismic)
  end
end
