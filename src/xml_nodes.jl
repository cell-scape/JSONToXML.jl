"""
Node Types: XML Specific
---

1. Node: Abstract type
2. RootNode: Dummy Root Node
3. ElementNode: Tags
4. TextNode: Text
5. XMLDocument <: AbstractSyntaxTree
"""

const NodeType::DataType = Symbol
const EMPTY_NODE::NodeType = :EMPTY_NODE

abstract type Node end

struct RootNode <: Node end

@kwdef mutable struct ElementNode <: Node
    name::NodeType = EMPTY_NODE
    attributes::Dict{Symbol, String} = Dict{Symbol, String}()
    children::Vector{Node} = Node[]

    ElementNode(name::NodeType, attributes::Dict{Symbol, String}, children::Vector{Node}) = new(name, attributes, children)
end

@kwdef struct TextNode <: Node
    text::String = ""
    name::NodeType = EMPTY_NODE

    TextNode(text::String, name::NodeType) = new(text, name)
end

@kwdef struct XMLDocument <: AbstractSyntaxTree
    root::Node = RootNode()

    XMLDocument(root::Node) = new(root)
end
