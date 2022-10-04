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
    publications = vcat([getproperty(bib, :children) for bib in getproperty(root, :children)]...)


    return DataFrame()
end


TABLE_DATA = Dict()


function get_table_data(root::ElementNode, table=Dict())
    next_level = Dict()
    for (k, v) in getproperty(root, :attributes)
        if haskey(table, k)
            push!(table[k],  v)
        else
            table[k] = [v]
        end
    end

    for child in getproperty(root, :children)
        rname = root.name # Symbol(string(replace(string(root.name), "-" => "_"), "_", i))
        cname = child.name # Symbol(string(replace(string(child.name), "-" => "_"), "_", i))
        if typeof(child) == TextNode
            if haskey(table, cname)
                push!(table[cname], child.text)
            else
                table[cname] =  [child.text]
            end
        else
            if haskey(next_level, rname)
                push!(next_level[rname], get_table_data(child, table))
            else
                next_level[rname] = [get_table_data(child, table)]
            end
        end
    end
    return table, next_level
end
