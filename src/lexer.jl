"""
    Lexer

Lexer for XML and JSON parser

# Fields
- `input::String`: The input text
- `position::Int`: The current position in input
- `readPosition::Int`: The current reading position in input (after current char)
- `char::String`: The current character under examination
- `tokens::Vector{Token}`: The set of lexed tokens.
"""
@kwdef mutable struct Lexer
    input::String = ""
    position::Int = 0
    readPosition::Int = 0
    char::Char = '\0'
    tokens::Vector{Token} = Token[]

    function Lexer(input::String)
        isempty(input) && return Lexer()
        new(input, 1, 2, first(input), Token[])
    end
end


"""
    read_char!(lexer::Lexer)

Reads the next character in input and updates the Lexer.

# Arguments
- `lexer::Lexer`: The Lexer

# Returns
- `::Nothing`: Nothing

# Examples
```julia
julia> read_char!(lex)
[...]
```
"""
function read_char!(lexer::Lexer)
    if lexer.readPosition ≥ length(lexer.input)
        lexer.char = '\0'
    else
        lexer.char = lexer.input[lexer.readPosition]
    end
    lexer.position = lexer.readPosition
    lexer.readPosition += 1
    nothing
end


"""
    read_text!(lexer::Lexer)::String

Read text, tag identifiers, attribute values, or text nodes.

# Arguments
- `lexer::Lexer`: Our lexer

# Returns
- `::String`: The text literal under examination.

# Examples
```julia
julia> read_text!(lexer)
"title"
```
"""
function read_text!(lexer::Lexer, tokens::Dict{Char, Symbol})::String
    position = lexer.position
    while !haskey(tokens, lexer.input[lexer.readPosition])
        read_char!(lexer)
    end
    lexer.input[position:lexer.position]
end


"""
    skip_whitespace!(lexer::Lexer)::Nothing

Skip over whitespace between tokens.

# Arguments
- `lexer::Lexer`: Lexer

# Returns
- `::Nothing`: nothing

# Examples
```julia
julia> skip_whitespace!(lexer)
[...]
```
"""
function skip_whitespace!(lexer::Lexer)
    while isspace(lexer.char)
        read_char!(lexer)
    end
    nothing
end


"""
    lex!(lexer::Lexer)::Vector{Token}

Lexically analyze text and create a stream of tokens.

# Arguments
- `lexer::Lexer`: Lexer
- `next_token!::Function`: A function object for different syntaxes

# Returns
- `::Vector{Token}`: Return a stream of tokens

# Examples
```julia
julia> lex!(lexer, next_xml_token!)
[...]
```
"""
function lex!(lexer::Lexer, next_token!::Function, tokens::Dict{Char, Symbol})::Vector{Token}
    while lexer.position < length(lexer.input)
        push!(lexer.tokens, next_token!(lexer, tokens))
    end
    if lexer.char == '\0'
        push!(lexer.tokens, EOF_TOKEN)
    end
    return lexer.tokens
end
