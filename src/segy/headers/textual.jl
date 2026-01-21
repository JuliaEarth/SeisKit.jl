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
  d = WGS84Latest # default datum
  for s in datumstrings(header)
    # remove dashes from datum string
    s = replace(s, "-" => "")

    # standardize to uppercase
    s = uppercase(s)

    # convert to datum type
    if s == "WGS84"
      d = WGS84Latest
      break
    elseif s == "ED50"
      d = ED50
      break
    elseif s == "SAD69"
      d = SAD69
      break
    end
  end
  d
end

"""
    datumstrings(header::TextualHeader) -> String

Retrieve datum string(s) from the SEG-Y textual `header`.
"""
function datumstrings(header::TextualHeader)
  # retrieve text content
  text = header.content

  # search for "DATUM ___" pattern
  m1 = map(m -> only(m.captures), eachmatch(r"\bdatum\b:?\s*(\w+-?\d*)"i, text))

  # search for "ON ___ DATUM" pattern
  m2 = map(m -> only(m.captures), eachmatch(r"\bon\b\s+(\w+\d*)\s*\bdatum\b"i, text))

  # list all matches in order of priority
  [m1; m2]
end

# write SEG-Y textual header to IO stream
Base.write(io::IO, header::TextualHeader) = write(io, encode(header.content, "ASCII"))

# display SEG-Y textual header in pretty format
Base.show(io::IO, header::TextualHeader) = print(io, replace(header.content, r"(C\d+)" => s"\n\1"))
