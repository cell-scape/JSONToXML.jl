import Base: @kwdef

@kwdef struct Tag
    name::Symbol = Symbol()

    Tag(name::Symbol) = new(name)
    Tag(name::String) = new(Symbol(name))
end

const EMPTY_TAG::Tag = Tag()

@kwdef struct Attribute
    name::Symbol = Symbol()
    value::String = ""

    Attribute(name::Symbol) = new(name, "")
    Attribute(name::String) = new(Symbol(name), "")
    Attribute(name::Symbol, value::String) = new(name, value)
    Attribute(name::String, value::String) = new(Symbol(name), value)
end

const EMPTY_ATTR::Attribute = Attribute()

@kwdef struct Node{T} where {T <: Tag}
    tag::T = EMPTY_TAG
    attributes::Vector{Attribute} = Attribute[]
    value::Vector{Node{T}} = Node[]

    Node(tag, attributes, value) = new(tag, attributes, value)
end

@kwdef struct Leaf{T} <: Node{T}
    tag::T = Tag()
    value::String = ""
end
