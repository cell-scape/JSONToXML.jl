using JSONToXML
using Test

const LEXER_INPUT::String = """
    <book price="55">
        <author>Jeffrey D. Ullman</author>
    </book>
"""

@testset "JSONToXML.jl" begin
    @testset "Lexer" begin
        lex = Lexer(LEXER_INPUT)
        tokens = lex!(lex)
        @testset "Lexer Input:\n$LEXER_INPUT\n" begin
            @test tokens[1] == Token(:LBRACE, "<")
            @test tokens[2] == Token(:TEXT, "book price")
            @test tokens[3] == Token(:EQUAL, "=")
            @test tokens[4] == Token(:QUOTE, "\"")
            @test tokens[5] == Token(:TEXT, "55")
            @test tokens[6] == Token(:QUOTE, "\"")
            @test tokens[7] == Token(:RBRACE, ">")
            @test tokens[8] == Token(:LBRACE, "<")
            @test tokens[9] == Token(:TEXT, "author")
            @test tokens[10] == Token(:RBRACE, ">")
            @test tokens[11] == Token(:TEXT, "Jeffrey D. Ullman")
            @test tokens[12] == Token(:LBRACE, "<")
            @test tokens[13] == Token(:SLASH, "/")
            @test tokens[14] == Token(:TEXT, "author")
            @test tokens[15] == Token(:RBRACE, ">")
            @test tokens[16] == Token(:LBRACE, "<")
            @test tokens[17] == Token(:SLASH, "/")
            @test tokens[18] == Token(:TEXT, "book")
            @test tokens[19] == Token(:RBRACE, ">")
            @test tokens[20] == Token(:EOF, "\0")
        end
    end
    @testset "Parser" begin

    end
end
