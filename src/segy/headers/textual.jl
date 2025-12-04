# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    textualheader(fname::AbstractString) -> String

Read the SEG-Y textual header from the file `fname`.
"""
textualheader(fname::AbstractString) = open(textualheader, fname)

"""
    textualheader(io::IO) -> String

Read the SEG-Y textual header from the IO stream `io`.
"""
function textualheader(io::IO)
  # read first textual header bytes
  bytes = read(seekstart(io), TEXTUAL_HEADER_SIZE)

  # identify encoding from first byte
  # 'C' is 0x43 in ASCII and 0xC3 in EBCDIC
  encoding = first(bytes) == 0x43 ? "ASCII" : "EBCDIC-CP-US"

  # decode bytes with identified encoding
  content = decode(bytes, encoding)

  # return textual header
  TextualHeader(content)
end

# ------------------
# HEADER DEFINITION
# ------------------

"""
    TextualHeader(content)

SEG-Y textual header with string `content`.
"""
struct TextualHeader
  content::String
end

"""
    crs(header::TextualHeader) -> Type{<:CoordRefSystems.CRS}

Retrieve coordinate reference system from the SEG-Y textual `header`.
"""
function crs(header::TextualHeader)
  # remove spaces from CRS string
  c = replace(crsstring(header), " " => "")

  # standardize to uppercase
  c = uppercase(c)

  # convert to CRS type
  if startswith(c, "EPSG")
    # extract EPSG code
    code = parse(Int, last(split(c, ":")))
    CoordRefSystems.get(EPSG{code})
  elseif startswith(c, "UTM")
    # extract UTM code
    code = last(split(c, ":"))
    if endswith(code, "N")
      zone = parse(Int, chop(code))
      utmnorth(zone, datum=datum(header))
    elseif endswith(code, "S")
      zone = parse(Int, chop(code))
      utmsouth(zone, datum=datum(header))
    else # assume southern hemisphere
      zone = parse(Int, code)
      utmsouth(zone, datum=datum(header))
    end
  elseif c == "UNKNOWN"
    error("CRS not found in textual header.")
  end
end

"""
    crsstring(header::TextualHeader) -> String

Retrieve coordinate reference system string from the SEG-Y textual `header`.
"""
function crsstring(header::TextualHeader)
  # retrieve text content
  text = header.content

  # search for "EPSG ___" pattern
  m = match(r"(\bepsg\b:?\s*\d+)"i, text)
  isnothing(m) || return only(m.captures)

  # search for "UTM ZONE ___" pattern
  m = match(r"\(?\butm\b\)?\s*,?\s+\bzone\b:?\s*(id)?\s+(\d+\s*[ns]?)"i, text)
  isnothing(m) || return "UTM:" * last(m.captures)

  # return UNKNOWN string as default CRS
  "UNKNOWN"
end

"""
    datum(header::TextualHeader) -> CoordRefSystems.Datum

Retrieve datum from the SEG-Y textual `header`.
"""
function datum(header::TextualHeader)
  # remove dashes from datum string
  d = replace(datumstring(header), "-" => "")

  # standardize to uppercase
  d = uppercase(d)

  # convert to datum type
  if d == "WGS84"
    WGS84Latest
  elseif d == "ED50"
    ED50
  elseif d == "SAD69"
    SAD69
  else
    error("Unsupported datum: $d. Please open an issue to request support.")
  end
end

"""
    datumstring(header::TextualHeader) -> String

Retrieve datum string from the SEG-Y textual `header`.
"""
function datumstring(header::TextualHeader)
  # retrieve text content
  text = header.content

  # search for "DATUM ___" pattern
  m = match(r"\bdatum\b:?\s*(\w+-?\d*)"i, text)
  isnothing(m) || return only(m.captures)

  # search for "ON ___ DATUM" pattern
  m = match(r"\bon\b\s+(\w+\d*)\s*\bdatum\b"i, text)
  isnothing(m) || return only(m.captures)

  # return WGS84 as default datum
  "WGS84"
end

# write SEG-Y textual header to IO stream
Base.write(io::IO, header::TextualHeader) = write(io, encode(header.content, "ASCII"))

# display SEG-Y textual header in pretty format
Base.show(io::IO, header::TextualHeader) = print(io, replace(header.content, r"(C\d+)" => s"\n\1"))
