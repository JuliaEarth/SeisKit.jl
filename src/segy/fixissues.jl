# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    fixissues(th, bh, eh, trh)

Fix known issues in SEG-Y headers.
"""
function fixissues(th, bh, eh, trh)
  # copy inputs to avoid side effects
  bh′ = deepcopy(bh)
  trh′ = deepcopy(trh)

  # fix SAMPLES_IN_TRACE = 0
  replace!(trh′.SAMPLES_IN_TRACE, 0 => bh.SAMPLES_PER_TRACE)

  if bh′.FIXED_LENGTH_TRACE_FLAG > 0
    # fix varying SAMPLES_IN_TRACE with FIXED_LENGTH_TRACE_FLAG > 0
    if !allequal(trh′.SAMPLES_IN_TRACE)
      bh′.FIXED_LENGTH_TRACE_FLAG = 0
    end

    # fix SAMPLES_IN_TRACE different from SAMPLES_PER_TRACE
    if !all(==(bh′.SAMPLES_PER_TRACE), trh′.SAMPLES_IN_TRACE)
      bh′.SAMPLES_PER_TRACE = first(trh′.SAMPLES_IN_TRACE)
    end
  end

  if bh′.FIXED_LENGTH_TRACE_FLAG > 1
    # fix invalid FIXED_LENGTH_TRACE_FLAG
    bh′.FIXED_LENGTH_TRACE_FLAG = 1
  end

  # currently no fixes implemented
  th, bh′, eh, trh′
end
