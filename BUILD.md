# How to Build

The official builds are made by Github workflows. If you want
to build locally, the easiest way is to read the scripts
in `.github/workflows` (which mostly execute the scripts
in `build-scripts`).

For example, for Linux
```
export $(cat build.env | xargs)
PATH=$PATH:$PWD/flutter/bin
./build-scripts/build-linux.sh $FLUTTER_VERSION
```

Other platforms have more dependencies, but the idea is the same.

Good luck
