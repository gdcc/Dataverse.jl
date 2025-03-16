module DataverseCondaPkgExt

using CondaPkg, Dataverse

function Dataverse.pyDataverse_install(flag=true)
    CondaPkg.add("pyDataverse")
end

"""
function Dataverse.conda(flag=:pyDataverse)
    if flag==:pyDataverse
        CondaPkg.add("pyDataverse")
    else
        error("unknown option")
    end
end
"""

end
