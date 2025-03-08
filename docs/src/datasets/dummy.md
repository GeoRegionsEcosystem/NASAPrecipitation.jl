# Dummy Datasets

Dummy datasets are meant to specify the paths to the NASAPrecipitation root directory, and LandSea Dataset directory, without needing inputs for date.

```@repl
using NASAPrecipitation
npd = IMERGDummy(path=homedir())
npd = TRMMDummy(path=homedir())
isdir(npd.maskpath)
```