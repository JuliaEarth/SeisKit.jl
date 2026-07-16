# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    setrev(th, bh, eh, trh)

Set SEG-Y revision to rev 1.0 or 2.1 depending
on the presence of extended headers.
"""
function setrev(th, bh, eh, trh)
  # copy inputs to avoid side effects
  bh′ = deepcopy(bh)

  if isempty(eh)
    # be conservative, save in revision 1.0
    bh′.MAJOR_REVISION_NUMBER = 1
    bh′.MINOR_REVISION_NUMBER = 0
    bh′.ENDIAN_CONSTANT = BIG_ENDIAN
    bh′.SAMPLE_FORMAT_CODE = IEEE_FLOAT32
  else
    # extended headers require revision 2.x
    bh′.MAJOR_REVISION_NUMBER = 2
    bh′.MINOR_REVISION_NUMBER = 1
    bh′.ENDIAN_CONSTANT = LITTLE_ENDIAN
    bh′.SAMPLE_FORMAT_CODE = IEEE_FLOAT64
  end

  th, bh′, eh, trh
end
