module Dataverse

include("downloads.jl")

export get_from_dataverse, dataverse_lists, example_lists

get_from_dataverse=downloads.get_from_dataverse
dataverse_lists=downloads.dataverse_lists
example_lists=downloads.example_lists

end
