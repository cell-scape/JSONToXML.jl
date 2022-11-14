"""
    xml_to_dataframe(xml::XMLDocument)::DataFrame

Convert XMLDocument object into Tabular structure

# Arguments
- `xml::XMLDocument`: A parsed XML syntax tree

# Returns
- `::DataFrame`: A DataFrame conforming to the schema in the DOM.

# Examples
```julia
julia> xml_to_dataframe(xml)
NxM DataFrame
[...]
```
"""
function xml_to_dataframe(xml::XMLDocument)::DataFrame
    root = xml.root
    schema = DataFrame[]
    table_data = get_table_data(root)
    
    return DataFrame()
end




function get_table_data(root::Node, level::Int=0, row_id::Int=0)
    schema = Dict{Symbol, Any}(
        :name => root.name,
        :id => row_id,
        :depth => level,
        :colnames => Set{Symbol}([]),
        :tblnames => Set{Symbol}([]),
        :tables => Dict{Symbol, Any}(),
        :columns => [(; id=row_id, column=key, val=value) for (key, value) in getproperty(root, :attributes)],
    )
    row_id = 1
    for child in getproperty(root, :children)
        # Found a terminal cell value
        if !isnothing(child.text)
            push!(schema[:colnames], child.name)
            push!(schema[:columns], (; id=row_id, column=child.name, val=child.text))
        else
            # This is a new table
            push!(schema[:tblnames], child.name)
            if haskey(schema[:tables], child.name)
                push!(schema[:tables][child.name], get_table_data(child, level+1, row_id))
            else
                push!(schema[:tables], child.name => [get_table_data(child, level+1, row_id)])
            end
        end
        row_id += 1
    end
    return schema
end
