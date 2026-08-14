module Dataverse

include("restDataverse.jl")
import Dataverse.restDataverse: file_list, dataverse_scan

function pyDataverse_install end
function pyDataverse_APIs end

include("pyDataverse.jl")
export pyDataverse

include("downloads.jl")
import Dataverse.downloads: file_download, unzip, untargz

include("json_ld.jl")
export json_ld

end
