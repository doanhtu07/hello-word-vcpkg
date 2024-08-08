# NOTE

Really sorry in advance, but I'm too lazy to organize this file.

If I have time, I'll try to make it cleaner for reading.

# Cross compiling for Windows

**NOTE**: Trying to cross compile on Windows but not successful.

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

## Install Vagrant and VirtualBox

https://github.com/StefanScherer/windows-docker-machine?tab=readme-ov-file

https://stackoverflow.com/questions/45380972/how-can-i-run-a-docker-windows-container-on-osx

- Need vagrant + virtual box:

  - Vagrant is a tool for building and managing virtual machine environments in a single workflow
  - and VirtualBox is one of the most commonly used providers for Vagrant

`brew install --cask vagrant`

`brew install --cask virtualbox`

`docker context ls`

`docker context use 2022-box`

## Build the microsoft image

`docker build -t buildtools_choco:latest -m 2GB .`

## Test docker compose / command

`docker run -it -v C:$(pwd):C:/my-project mcr.microsoft.com/windows/servercore:ltsc2022 powershell`

OR

`docker compose up -d`

## Run docker container shell

`docker exec -it windows_container powershell`

## Install winget through Powershell

https://github.com/asheroto/winget-install

`Install-Script winget-install -Force`

`winget-install`

-> Not successful

## Switch to scoop

https://github.com/ScoopInstaller/Scoop

```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

Install as admin

`iex "& {$(irm get.scoop.sh)} -RunAsAdmin"`

## Switch back to winget

https://github.com/microsoft/winget-cli/issues/3037

- But it takes too long -> Will need to put into Dockerfile

## Install dependencies

- `scoop install git`
- vcpkg: Follow their guide
  - https://learn.microsoft.com/en-us/vcpkg/get_started/get-started?pivots=shell-bash
  - `git clone https://github.com/microsoft/vcpkg.git C:\vcpkg`
  - `cd C:\vcpkg; .\bootstrap-vcpkg.bat`
  - `./scripts/vcpkg-windows.ps1`
- `scoop install cmake`
<!-- - `./scripts/msvc-windows.ps1` -->
- `scoop install ninja`

## Visual Studio in Container

https://github.com/MicrosoftDocs/visualstudio-docs/blob/main/docs/install/build-tools-container.md

## Will try choco to setup Visual Studio instead

https://github.com/microsoft/vcpkg/discussions/21311

https://devblogs.microsoft.com/cppblog/using-msvc-in-a-docker-container-for-your-c-projects/

https://gitlab.com/gitlab-org/gitlab-runner/-/issues/26606

https://github.com/cirruslabs/docker-images-windows/issues/16

https://stackoverflow.com/questions/31165480/path-of-visual-studio-c-compiler

- `C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\VC\\Auxiliary\\Build\\vcvarsall.bat`

https://stackoverflow.com/questions/44828842/why-is-cmake-not-finding-the-compiler-cl

- Add `C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.40.33807\bin\Hostx64\x64` to PATH

"CMAKE_TRY_COMPILE_TARGET_TYPE": "STATIC_LIBRARY"
"CMAKE_MAKE_PROGRAM": "C:/ProgramData/chocolatey/bin/ninja.exe",

https://stackoverflow.com/questions/53633705/cmake-the-c-compiler-is-not-able-to-compile-a-simple-test-program
