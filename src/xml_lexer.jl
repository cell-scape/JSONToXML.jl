"""
    next_xml_token!(lexer::Lexer, tokens::Dict{Char, Symbol})::Token

Advances the lexer and gets the next XML Token. Pass to lex!()

# Arguments
- `lexer::Lexer`: Lexer
- `tokens::Dict{Char, Symbol}`: The set of tokens.

# Returns
- `::Token`: A token

# Examples
```julia
julia> next_xml_token!(lexer, XML_TOKENS)
Token(:RBRACE, ">")
```
"""
function next_xml_token!(lexer::Lexer, tokens::Dict{Char, Symbol})::Token
    skip_whitespace!(lexer)
    literal = lexer.char
    token_type = get(tokens, literal, nothing)
    if isnothing(token_type)
        token_type = TEXT_TOKEN.type
        literal = read_text!(lexer, tokens)
    end
    token = Token(token_type, string(literal))
    read_char!(lexer)
    return token
end
