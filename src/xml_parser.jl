"""
    parse_xml_document!(parser::Parser)::XMLDocument

Parse the XML document into an AST of Element and Text nodes.

# Arguments
- `parser::Parser`: Parser

# Returns
- `::XMLDocument`: XML Document

# Examples
```julia
julia> dom = parse_xml_document(parser)
[...]
```
"""
function parse_xml_document!(parser::Parser)::XMLDocument
    while parser.current_token ≠ EOF_TOKEN
        if parser.current_token == LBRACE_TOKEN
            parser.ast = XMLDocument(parse_xml!(parser))
        end
        next_token!(parser)
    end
    return parser.ast
end


"""
    parse_xml!(parser::Parser)::Node

Parse an XML node.

# Arguments
- `parser::Parser`: Parser

# Returns
- `::Node`: An XML node

# Examples
```julia
julia> node = parse_xml!(parser)
[...]
```
"""
function parse_xml!(parser::Parser)::Node
    # Beginning a new tag
    node = Node()
    while parser.current_token ≠ LBRACE_TOKEN
        _ = next_token!(parser)
    end

    if parser.current_token == LBRACE_TOKEN && parser.peek_token.type == :TEXT
        node.name, node.attributes = get_tag_attributes!(parser)
    end
    _ = next_token!(parser)
    # Until end of tag
    while !(parser.current_token == LBRACE_TOKEN && parser.peek_token == SLASH_TOKEN)
        # Found a TextNode
        if parser.current_token == RBRACE_TOKEN && parser.peek_token.type == :TEXT
            _ = next_token!(parser)
            node.text = parser.current_token.literal
        end
        # Found a child
        if parser.current_token == LBRACE_TOKEN
            push!(node.children, parse_xml!(parser)) # recurse
        end
        _ = next_token!(parser) # advance
    end
    return node
end


"""
    get_tag_attributes!(parser::Parser)::Tuple{Symbol, Dict{Symbol, String}}

Gets all the key-value pairs for tag attributes.

# Arguments
- `parser::Parser`: Parser

# Returns
- `::Tuple{Symbol, Dict{Symbol, String}}`: Returns name and attribute dictionary.

# Examples
```julia
julia> get_tag_attributes(parser)
(:book, Dict{Symbol, String}(:price => "55"))
```
"""
function get_tag_attributes!(parser::Parser)
    attributes = Dict{Symbol, String}()
    name = nothing
    while parser.current_token.type ≠ TEXT_TOKEN.type
        _ = next_token!(parser)
    end
    if parser.current_token.type == TEXT_TOKEN.type
        tag_attrs = split(parser.current_token.literal) # split on space
        length(tag_attrs) == 1 && return (Symbol(replace(first(tag_attrs), "-" => "_")), attributes) # early escape
        name, attr = tag_attrs # unpack tuple
        name = Symbol(replace(string(name), "-" => "_"))
        attr = Symbol(replace(string(attr), "-" => "_"))
        t = parser.peek_token
        while t.type ≠ RBRACE_TOKEN.type
            if t.type == EQUAL_TOKEN.type
                t = next_token!(parser) # quote
                t = next_token!(parser) # value
                push!(attributes, Symbol(attr) => t.literal)
            elseif t.type == TEXT_TOKEN.type
                attr = t.literal # new attribute name
            end
            t = next_token!(parser) # advance tokens
        end
    end
    return (Symbol(name), attributes)
end
