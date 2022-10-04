# XML Tokens

const XML_TOKENS = Dict{Char, TokenType}(
    '<' => :LBRACE,
    '>' => :RBRACE,
    '/' => :SLASH,
    '=' => :EQUAL,
    '"'=> :QUOTE,
    '\0' => :EOF,
)

const TEXT_TOKEN::Token = Token(:TEXT, "TEXT")
const LBRACE_TOKEN::Token = Token(:LBRACE, "<")
const RBRACE_TOKEN::Token = Token(:RBRACE, ">")
const SLASH_TOKEN::Token = Token(:SLASH, "/")
const EQUAL_TOKEN::Token = Token(:EQUAL, "=")
