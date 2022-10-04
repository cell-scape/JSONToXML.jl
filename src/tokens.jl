#= Tokens =#

@kwdef struct Token
    type::TokenType = :EOF
    literal::String = "\0"

    Token(type::TokenType, literal::String) = new(type, literal)
end

const EOF_TOKEN::Token = Token(:EOF, "\0")
