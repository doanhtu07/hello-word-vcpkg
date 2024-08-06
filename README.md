# Basic setup

NOTE: This setup is tested on MacOS only. For Windows, read further below.

## Tutorial

https://learn.microsoft.com/en-us/vcpkg/get_started/get-started?pivots=shell-bash

## Install vcpkg

Install vcpkg with `brew install vcpkg`

This formula provides only the `vcpkg` executable. To use vcpkg:

```
git clone https://github.com/microsoft/vcpkg "$HOME/vcpkg"
export VCPKG_ROOT="$HOME/vcpkg"
```

## Init a new project

`vcpkg new --application`

## Add fmt dependency

`vcpkg add port fmt`

## Create CMakeLists.txt and CMakePresets.json

See example files in this folder

## Configure build

`cmake --preset=default -DCMAKE_EXPORT_COMPILE_COMMANDS=1`

## Build

`cmake --build build`

## Neovim

- https://gist.github.com/sivteck/a3030d07ba4676a88d25ab5d86459a5c
- https://stackoverflow.com/questions/59263015/cmake-how-to-change-compile-commands-json-output-location

## Resources

- https://cmake.org/cmake/help/book/mastering-cmake/chapter/Writing%21CMakeLists%20Files.html
- https://cmake.org/cmake/help/latest/manual/cmake-variables.7.html
- https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html

---

- https://www.ics.com/blog/find-and-link-libraries-cmake#:~:text=The%20main%20thing%20we%20will%20use%20here%20is,you%E2%80%99re%20looking%20for%20is%20already%20built%20and%20installed.

# Cross compiling for Windows

NOTE: Trying to cross compile on Windows but not successful.

- https://cmake.org/cmake/help/book/mastering-cmake/chapter/Cross%20Compiling%20With%20CMake.html
- https://www.reddit.com/r/cmake/comments/1biuopg/crosscompile_from_linux_to_windows/
  - https://gist.github.com/peterspackman/8cf73f7f12ba270aa8192d6911972fe8

## Install mingw-w64 toolchain

`brew install mingw-w64`

- Carefully check where mingw-w64 is installed
- `/usr/local/Cellar/mingw-w64/12.0.0`

## Create toolchain cmake file

- `mkdir ~/cmake-cross-compile-toolchains`
- `cd ~/cmake-cross-compile-toolchains`
- Create `mingw-w64-x86_64.cmake` like in https://gist.github.com/peterspackman/8cf73f7f12ba270aa8192d6911972fe8

## Check the triplet file for vcpkg

https://stackoverflow.com/questions/58777810/how-to-integrate-vcpkg-in-linux-with-cross-build-toolchain-as-well-as-sysroot

https://learn.microsoft.com/en-us/vcpkg/users/examples/overlay-triplets-linux-dynamic

https://devblogs.microsoft.com/cppblog/vcpkg-host-dependencies/

https://opencoursehub.cs.sfu.ca/bfraser/grav-cms/cmpt433/links/files/2024-student-howtos/Cross-compiling_External_C_C++LibrariesUsing_vcpkg.pdf

https://stackoverflow.com/questions/77556548/using-custom-triplets-with-vcpkg-and-cmake-in-manifest-mode

- `cd $VCPKG_ROOT/triplets/`
- `mkdir tudo-custom`
- `cp x64-windows.cmake tudo-custom/x64-windows-custom.cmake`
- Fix the content of the file a bit
- `vcpkg install <lib_name>:<target_triplet> --overlay-triplets=$VCPKG_ROOT/triplets/tudo-custom/`
  - `vcpkg install fmt:x64-windows-custom --overlay-triplets=$VCPKG_ROOT/triplets/tudo-custom/`

```
"VCPKG_OVERLAY_TRIPLETS": "$env{VCPKG_ROOT}/triplets/tudo-custom/",
```

## Configure build

`cmake --preset=windows -DCMAKE_EXPORT_COMPILE_COMMANDS=1`

## Build

`cmake --build build`

## Conclusion

I successfully run the configure step. But somehow I couldn't run the build step.

It always output:

- ld: archive member '/' not a mach-o file for libfmtd.a

# Test Windows VM

https://github.com/StefanScherer/windows-docker-machine?tab=readme-ov-file

https://stackoverflow.com/questions/45380972/how-can-i-run-a-docker-windows-container-on-osx

- Need vagrant + virtual box:

  - Vagrant is a tool for building and managing virtual machine environments in a single workflow
  - and VirtualBox is one of the most commonly used providers for Vagrant

`brew install --cask vagrant`
