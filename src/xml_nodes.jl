@kwdef mutable struct Node
    name::Symbol = Symbol()
    attributes::Dict{Symbol, String} = Dict{Symbol, String}()
    children::Vector{Node} = Node[]
    text::Union{Nothing, String} = nothing

    Node(name::Symbol, attributes::Dict{Symbol, String}, children::Vector{Node}, string::Union{Nothing, String}) = new(name, attributes, children, string)
end

@kwdef struct XMLDocument <: AbstractSyntaxTree
    root::Node = Node()
    textnodes::Set{Symbol} = Set{Symbol}([])
    elemnodes::Set{Symbol} = Set{Symbol}([])
    size::Int = 0

    XMLDocument(root::Node, textnodes::Set{Symbol}, elemnodes::Set{Symbol}, size::Int) = new(root, textnodes, elemnodes, size)
    function XMLDocument(root::Node)
        size, textnodes, elemnodes = _xml(root, 1, Set{Symbol}([]), Set{Symbol}([root.name]))
        new(root, textnodes, elemnodes, size)
    end
end


function _xml(node::Node, size::Int=0, textnodes=Set{Symbol}([]), elemnodes=Set{Symbol}([]))
    for child in node.children
        if isnothing(child.text)
            s, t, e = _xml(child, length(child.children), textnodes, push!(elemnodes, child.name))
            union!(elemnodes, e)
            union!(textnodes, t)
            size += s
        else
            push!(textnodes, child.name)
        end
    end
    return size, textnodes, elemnodes
end