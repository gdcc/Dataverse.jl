# Dataverse.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://gaelforget.github.io/Dataverse.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://gaelforget.github.io/Dataverse.jl/dev/)
[![Build Status](https://github.com/gaelforget/Dataverse.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/gaelforget/Dataverse.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/gaelforget/Dataverse.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/gaelforget/Dataverse.jl)

Package to use and interface with the [Dataverse](https://dataverse.org) project APIs, collections, datasets, etc.

Some documentation on available APIs is linked to here.

- <https://demo.dataverse.org>
- <https://pydataverse.readthedocs.io/en/latest/index.html>
- <https://guides.dataverse.org/en/5.11/api/index.html>

```
using Dataverse
(DataAccessApi,NativeApi)=pyDataverse.APIs()
```

For more see the [demo notebook](https://github.com/gaelforget/Dataverse.jl/blob/main/docs/src/notebook.jl)
