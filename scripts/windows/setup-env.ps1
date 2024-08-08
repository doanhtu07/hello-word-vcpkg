# vcpkg
$env:VCPKG_ROOT = "C:\vcpkg"
$env:PATH = "$env:VCPKG_ROOT;$env:PATH"

# executable for build tools
$ExecutablePath = "C:\Program Files (x87)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.40.33807\bin\Hostx64\x64"
$env:PATH = "$ExecutablePath;$env:PATH"
