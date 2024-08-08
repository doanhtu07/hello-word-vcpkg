# escape=`

# https://gitlab.com/gitlab-org/gitlab-runner/-/issues/26606

# Use the latest Windows Server Core 2022 image.
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Chocolatey
ADD https://chocolatey.org/install.ps1 C:\TEMP\install.ps1

RUN powershell C:\TEMP\install.ps1 `
  && del C:\TEMP\install.ps1

# choco-cleaner
RUN choco install --no-progress -y choco-cleaner `
  && choco-cleaner

# Build tools (Required before installing vctools)
RUN choco install -y visualstudio2022buildtools `
  && choco-cleaner

# VCTools
RUN choco install -y visualstudio2022-workload-vctools `
  && choco-cleaner

# git
RUN choco install -y git.install `
  && choco-cleaner

# vcpkg
RUN git clone --depth 1 https://github.com/microsoft/vcpkg.git `
  && cd vcpkg `
  && bootstrap-vcpkg.bat -disableMetrics

# cmake
RUN choco install -y cmake `
  && choco-cleaner


# Define the entry point for the docker container.
# This entry point starts the developer command prompt and launches the PowerShell shell.
ENTRYPOINT ["C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
