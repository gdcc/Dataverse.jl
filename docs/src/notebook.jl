### A Pluto.jl notebook ###
# v0.19.8

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 8e7742bc-ed2e-11ec-2bbe-adbcf21330e7
begin
	using Pkg; Pkg.activate()
	using Dataverse, PlutoUI
	"Packages ready"
end

# ╔═╡ 52c81a38-0b73-4585-8833-40a834c12312
md"""# Dataverse.jl

This package is about interfaces to the [Dataverse](https://dataverse.org) project APIs, collections, datasets, etc.

!!! tip
    Some documentation on available APIs is linked to here.

- <https://demo.dataverse.org>
- <https://pydataverse.readthedocs.io/en/latest/index.html>
- <https://guides.dataverse.org/en/5.11/api/index.html>
"""

# ╔═╡ e90fc026-b134-4694-87db-b5fc8fd1dcb2
begin
	doi_select = @bind doi Select(["10.7910/DVN/EE3C40","10.7910/DVN/RNXA2A","10.7910/DVN/AVVGYX"])

	md"""## APIs

	Select doi : $(doi_select)
		
	"""
end

# ╔═╡ 306ced7d-005e-4e50-8295-d911403ff5fa
DOI="doi:"*doi

# ╔═╡ e448e0ce-4991-4a75-b611-570aa64439f3
md"""## Appendix"""

# ╔═╡ d216f95e-fc57-4b89-b796-be08b3f137d2
begin
	(DataAccessApi,NativeApi)=pyDataverse.APIs(do_install=false)
	"APIs ready"
end

# ╔═╡ 2240395b-4112-4e8a-a233-26fde9dffbc4
dataset = NativeApi.get_dataset(DOI)

# ╔═╡ b15daa71-7ded-41d8-9dd0-904a07112950
files_list = dataset.json()["data"]["latestVersion"]["files"]

# ╔═╡ e7330644-dc09-453d-bd4e-7174fea43cfd
files_list[1]["dataFile"]

# ╔═╡ Cell order:
# ╟─52c81a38-0b73-4585-8833-40a834c12312
# ╟─e90fc026-b134-4694-87db-b5fc8fd1dcb2
# ╟─306ced7d-005e-4e50-8295-d911403ff5fa
# ╠═2240395b-4112-4e8a-a233-26fde9dffbc4
# ╠═e7330644-dc09-453d-bd4e-7174fea43cfd
# ╠═b15daa71-7ded-41d8-9dd0-904a07112950
# ╟─e448e0ce-4991-4a75-b611-570aa64439f3
# ╟─8e7742bc-ed2e-11ec-2bbe-adbcf21330e7
# ╟─d216f95e-fc57-4b89-b796-be08b3f137d2
