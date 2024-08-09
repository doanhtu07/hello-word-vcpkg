# About

This simple example project will compile a small program that uses `fmt` C++ package installed from vcpkg.

Then, we use CMake to build the project.

There are two build targets we will consider: MacOS and Windows.

We will conduct the both build processes on a single MacOS machine.

The executable of each process can then run natively on the process's target machine.

# Target MacOS basic setup

**NOTE**: For targeting Windows (using your MacOS machine), read further below.

## Tutorial link

Assuming you are on a MacOS machine, you can follow the official tutorial for bash here:

https://learn.microsoft.com/en-us/vcpkg/get_started/get-started?pivots=shell-bash

### 1. Install vcpkg

Install vcpkg with `brew install vcpkg`

This formula provides only the `vcpkg` executable. To use vcpkg:

```
git clone https://github.com/microsoft/vcpkg "$HOME/vcpkg"
export VCPKG_ROOT="$HOME/vcpkg"
```

### 2. Init a new project

`vcpkg new --application`

### 3. Add fmt dependency

`vcpkg add port fmt`

### 4. Create CMakeLists.txt and CMakePresets.json

See/Clone example files in this folder

### 5. Configure build

`cmake --preset=default`

### 6. Build

`cmake --build build`

### 7. Run program

Look at the build folder, you should see an executable named `HelloWorld`.

You can run the file directly on MacOS. It should work just fine.

## Neovim (optional)

I use clangd installed from Mason as the LSP for C++

**NOTE**: clangd will look for a file called `compile_commands.json` for LSP suggestions to work correctly with packages installed with `vcpkg`

**LINKS**:

- https://gist.github.com/sivteck/a3030d07ba4676a88d25ab5d86459a5c
- https://stackoverflow.com/questions/59263015/cmake-how-to-change-compile-commands-json-output-location

## Extra resources (optional)

- https://cmake.org/cmake/help/latest/manual/cmake-variables.7.html
- https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html
- https://www.ics.com/blog/find-and-link-libraries-cmake#:~:text=The%20main%20thing%20we%20will%20use%20here%20is,you%E2%80%99re%20looking%20for%20is%20already%20built%20and%20installed.

# Target Windows (using your MacOS machine)

Yes, you can actually build a C++ project targeting Windows using CMake, vcpkg, and your MacOS machine ONLY!

But, of course, it's not as simple as it seems.

If you're interested, you can take a look at my windows_activity_log markdown file in this folder.

Here in the main markdown, I'll just go straight to the process that works for me.

## Is this process the best way to go?

I have no idea. But it's a good and strong start as you cannot go wrong using an actual Windows VM instance and a Docker container.

You can always buy or setup a real Windows machine, but I don't have one, so that might be the reason I spent time setting up all this.

But I hope that even if you don't feel the need to target Windows using your MacOS machine, you can still learn something from this process and maybe apply it for another build pipeline that you're doing.

## Overview

1. Boot up a Windows VM on your MacOS machine
   1. Run a docker container with Microsoft image inside the Windows VM context
   2. Install some dependencies (which should be handled by my Dockerfile)
2. Setup environment variables with a simple script
3. Run the Cmake configure step
4. Run the Cmake build step
5. Run program

**NOTE**:

- The docker image my Dockerfile outputs will be large (~16 GB) as it needs to install the buildtools and workload vctools from Visual Studio
- But after that, everything should work smoothly

## 1. Boot up a Windows VM on your MacOS machine

### Install Vagrant and VirtualBox

#### Main links

- https://github.com/StefanScherer/windows-docker-machine?tab=readme-ov-file
- https://stackoverflow.com/questions/45380972/how-can-i-run-a-docker-windows-container-on-osx

#### Install Vagrant

`brew install --cask vagrant`

#### Install VirtualBox

`brew install --cask virtualbox`

### Clone windows-docker-machine Github repo

`git clone https://github.com/StefanScherer/windows-docker-machine <your_chosen_destination>`

`cd <your_chosen_destination>`

### Run Windows Server VM

`vagrant up --provider virtualbox 2022-box`

### Docker context

Check available Docker contexts. You should see a new context "2022-box".

`docker context ls`

Switch to the "2022-box" context.

`docker context use 2022-box`

**NOTE**: You can always switch back to other context with `docker context use <context_name>`

### Build Docker image

Assuming you are at the root of my repo project:

`cd ./scripts/windows`

`docker build -t buildtools_choco:latest -m 2GB .`

### Run docker container

Assuming you are at the root of my repo project:

`cd ./scripts/windows`

`docker compose up -d`

**NOTE**:

- My docker compose file will bind the current repo project folder to `C:/my-project` inside the container

### Execute the docker container shell

`docker exec -it windows_container powershell`

## 2. Setup environment variables with a simple script

Assuming you are already inside the container shell:

`cd C:\my-project`

`.\scripts\windows\setup-env.ps1`

## 3. Run the Cmake configure step

`cmake --preset=windows_vm`

## 4. Run the Cmake build step

`cmake --build build`

## 5. Run program

You will notice that inside the `build` folder both on the container and on your host MacOS machine, you have a new `Debug` folder.

This folder will contain the executable with `.exe` as the extension that you can run on Windows natively.

# Conclusion

Thanks for spending the time reading this. Good luck! I hope you learn something new, because I learned a lot.

# Questions?

If you have any questions, feel free to contact me or open an issue on Github.

**NOTE**:

- I'm not an expert in this, but if I know any resources, I'll let you know.
- If you want to do some Docker command stuff, ask ChatGPT or any LLMs! They helped me a lot lol...
