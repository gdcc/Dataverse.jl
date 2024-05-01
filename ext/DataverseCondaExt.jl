module DataverseCondaExt

using Conda, Dataverse

function Dataverse.pyDataverse_install(flag=true)
    Conda.pip_interop(true)
    Conda.pip("install", "pyDataverse")
end

end
