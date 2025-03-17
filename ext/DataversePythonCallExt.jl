module DataversePythonCallExt

using Dataverse, PythonCall
#import NetworkOptions

"""
    Dataverse.pyDataverse_APIs

```
using Dataverse, PythonCall
Dataverse.pyDataverse_install()
(DataAccessApi,NativeApi)=Dataverse.pyDataverse_APIs(true)
dataset = NativeApi.get_dataset("doi:10.7910/DVN/KBHLOD")
```
"""
function Dataverse.pyDataverse_APIs(flag=true; base_url = "https://dataverse.harvard.edu/")
#   cafile=NetworkOptions.ca_roots_path()
#   ENV["SSL_CERT_FILE"] = cafile
    tmp=PythonCall.pyimport("pyDataverse")
    api=PythonCall.pyimport("pyDataverse.api")
    return api.DataAccessApi(base_url), api.NativeApi(base_url)
end

end

