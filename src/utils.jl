# Utility functions

"""
    read_file(filename::AbstractString)::String

Reads a file stream into a String

# Arguments
- `filename::AbstractString`: Path to file

# Returns
- `::String`: File stream as a Julia String type

# Examples
```julia
julia> read_text("data/bibs.xml")
1869-element Vector{UInt8}
 0x3c
 0x62
 0x69
 0x62
 0x73
 0x3e
 0x0a
    .
    .
    .
 0x62
 0x69
 0x62
 0x73
 0x3e
 0x0a
```
"""
read_file(filename::AbstractString)::String = read(filename) |> String
