# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    updaterev(th, bh, eh, trh)

Update SEG-Y headers to rev 2.1 compliance.
"""
function updaterev(th, bh, eh, trh)
  # copy inputs to avoid side effects
  bh′ = deepcopy(bh)

  # update revision number to 2.1
  bh′.MAJOR_REVISION_NUMBER = 2
  bh′.MINOR_REVISION_NUMBER = 1

  # update endianess to little-endian
  bh′.ENDIAN_CONSTANT = 33620995

  # update number type to IEEE Float64
  bh′.SAMPLE_FORMAT_CODE = 6

  # currently no updates implemented
  th, bh′, eh, trh
end
