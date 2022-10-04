module JSONXMLCSV

import Base: @kwdef

using ArgParse
using CSV
using DataFrames
using Dates

include("constants.jl")
include("utils.jl")
include("tokens.jl")
include("lexer.jl")
include("nodes.jl")
include("parser.jl")
include("xml_tokens.jl")
include("xml_lexer.jl")
include("xml_nodes.jl")
include("xml_parser.jl")
include("xml_to_csv.jl")
include("json_tokens.jl")
include("json_lexer.jl")
include("json_nodes.jl")
include("json_parser.jl")


export FILENAME, TOKENS, EMPTY_NODE
export Lexer, TokenType, Token, Parser, NodeType, RootNode, ElementNode, TextNode, XMLDocument
export read_file, read_char!, next_token!, read_text!, lex!
export parse_xml_document!, parse_xml!, get_tag_attributes!

"""
    argparser()

Set up command line arguments
"""
function argparser()
    s = ArgParse.ArgParseSettings(prog="JSON and XML Parser", epilog="---")
    @add_arg_table! s begin
        "--xml", "-x"
            help="Path to XML file"
            arg_type = String
        "--json", "-j"
            help="Path to JSON file"
            arg_type = String
        "--out", "-o"
            help = "Output file path (e.g. bibs.csv)"
            arg_type = String
            default = "out.csv"
    end
    return s
end

"""
    julia_main()::Cint

Binary entrypoint. Parses command line arguments.

# Arguments
- `ARGS::Vector{String}`: Command line arguments

# Returns
- `::Cint`: C integer type.

# Examples
```bash
\$ JSONToXML --xml data/bibs.xml --out xml.csv
```
"""
function julia_main()::Cint
    ap = argparser()
    args = parse_args(ARGS, ap, as_symbols=true)
    try
        out = args[:out]
        if !isnothing(args[:xml])
            xml_out = ""
            if occursin(lowercase(out), "xml")
                xml_out = out
            elseif occursin(out, ".")
                name, ext = split(out, '.')
                xml_out = "$(name)_xml.$(ext)"
            else
                xml_out = "$(out)_xml.csv"
            end
        end
        if !isnothing(args[:json])
            json_out = ""
            if occursin(out, "json")
                json_out = out
            elseif occursin(out, ".")
                name, ext = split(out, '.')
                json_out = "$(name)_json.$(ext)"
            else
                json_out = "$(out)_json.csv"
            end
        end
    catch ex
        @warn ex
        return -1
    end
    return 0
end

end # module
