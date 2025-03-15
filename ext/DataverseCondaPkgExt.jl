module DataverseCondaPkgExt

using CondaPkg, ArgoData

function Dataverse.conda(flag=:pyDataverse)
    if flag==:pyDataverse
        CondaPkg.add("pyDataverse")
    else
        error("unknown option")
    end
end

end
