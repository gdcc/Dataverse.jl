# Dataverse.jl

[![docs](https://img.shields.io/badge/pkg-documentation-blue.svg)](https://gdcc.github.io/Dataverse.jl/dev/)
[![DOI](https://zenodo.org/badge/260379066.svg)](https://doi.org/10.5281/zenodo.6665834)

[![Build Status](https://github.com/gdcc/Dataverse.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/gdcc/Dataverse.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/gaelforget/Dataverse.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/gaelforget/Dataverse.jl)
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/gdcc/Dataverse.jl/HEAD)

Interface to the [Dataverse project](https://dataverse.org) APIs, collections and datasets.

<details>
 <summary> Links to documentation on available APIs </summary>
<p>

- <https://demo.dataverse.org>
- <https://pydataverse.readthedocs.io/en/latest/index.html>
- <https://guides.dataverse.org/en/5.11/api/index.html>

</p>
</details>

```
using Dataverse
(DataAccessApi,NativeApi)=pyDataverse.APIs()
```

👉 [demo notebook](https://gdcc.github.io/Dataverse.jl/dev/notebook.html) and [notebook code](https://github.com/gdcc/Dataverse.jl/blob/main/docs/src/notebook.jl)
