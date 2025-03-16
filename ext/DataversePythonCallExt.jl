module DataversePythonCallExt

using Dataverse
import PythonCall, NetworkOptions

function Dataverse.pyDataverse_APIs(flag=true;do_install=false,base_url = "https://dataverse.harvard.edu/")
    do_install ? error("pyDataverse_install is now available via the Conda extension.") : nothing
    cafile=NetworkOptions.ca_roots_path()
    ENV["SSL_CERT_FILE"] = cafile
    tmp=PythonCall.pyimport("pyDataverse")
    api=PythonCall.pyimport("pyDataverse.api")
    return api.DataAccessApi(base_url), api.NativeApi(base_url)
end

end

"""
import Dataverse: pyDataverse_APIs
(DataAccessApi,NativeApi)=pyDataverse_APIs(true)
DOI = "doi:10.7910/DVN/KBHLOD"
dataset = NativeApi.get_dataset(DOI)
"""