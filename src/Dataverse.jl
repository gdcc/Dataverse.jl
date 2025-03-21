module Dataverse

include("restDataverse.jl")
import Dataverse.restDataverse: file_list, dataverse_scan

pyDataverse_install() = pyDataverse_install(true)
pyDataverse_APIs() = pyDataverse_APIs(true)

include("pyDataverse.jl")
export pyDataverse

include("downloads.jl")
import Dataverse.downloads: file_download, unzip, untargz

include("json_ld.jl")
export json_ld

end
