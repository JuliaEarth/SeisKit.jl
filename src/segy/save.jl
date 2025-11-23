# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    save(fname::AbstractString, segy)

Save `segy` data to the file `fname`.
"""
save(fname::AbstractString) = open(save, fname, "w")

"""
    save(io::IO, segy)

Save `segy` data to the IO stream `io`.
"""
function save(io::IO)
end
