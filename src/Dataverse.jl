module Dataverse

include("restDataverse.jl")
import Dataverse.restDataverse: file_list, dataverse_scan

pyDataverse_install(dev::String) = pyDataverse_install(true)
pyDataverse_APIs(dev::String) = pyDataverse_APIs(true)

include("pyDataverse.jl")
export pyDataverse

include("downloads.jl")
import Dataverse.downloads: file_download


end
