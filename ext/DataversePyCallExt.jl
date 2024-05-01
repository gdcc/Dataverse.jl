module DataversePyCallExt

using PyCall, Dataverse

function Dataverse.pyDataverse_APIs(flag=true;do_install=false,base_url = "https://dataverse.harvard.edu/")
    do_install ? error("pyDataverse_install is now available via the Conda extension.") : nothing
    tmp=pyimport("pyDataverse")
    api=pyimport("pyDataverse.api")
    return api.DataAccessApi(base_url), api.NativeApi(base_url)
end

end
