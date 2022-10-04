"""
    Parser

Parses XML token stream into Element and Text Nodes

# Fields
- `lexer::Lexer`: Lexer that has lexed
- `current_token::Token`: Current token
- `peek_token::Token`: Next token
- `ast::AbstractSyntaxTree`: Parsed AST
"""
@kwdef mutable struct Parser
    lexer::Lexer = Lexer()
    current_token::Token = Token()
    peek_token::Token = Token()
    ast::AbstractSyntaxTree = AST()

    function Parser(lexer::Lexer)
        if isempty(lexer.tokens)
            return new(lexer, Token(), Token())
        elseif length(lexer.tokens) == 1
            return new(lexer, popfirst!(lexer.tokens), Token())
        end
        new(lexer, popfirst!(lexer.tokens), popfirst!(lexer.tokens))
    end
end


"""
    next_token!(parser::Parser)::Token

Get the next token in the token stream.

# Arguments
- `parser::Parser`: Parser

# Returns
- `::Token`: Returns the newest token, but mutates parser.

# Examples
```julia
julia> next_token!(parser)
[...]
```
"""
function next_token!(parser::Parser)::Token
    parser.current_token = parser.peek_token
    if length(parser.lexer.tokens) == 0
        parser.peek_token = Token()
    else
        parser.peek_token = popfirst!(parser.lexer.tokens)
    end
    return parser.peek_token
end
