# Show pwsh version

$PSVersionTable

# Set the default Powershell Profile
sudo cp ./.devcontainer/profile.ps1 /opt/microsoft/powershell/7/profile.ps1

# Install additional modules

if(-not(Get-InstalledModule -Name PSReadline -AllowPrerelease -ErrorAction SilentlyContinue)) {
    Install-Module -Name PSReadline -AllowPrerelease -Force
}

Install-Module powershell-yaml -Force

Install-Module -Name PSKubectlCompletion -AllowPrerelease -Force


# GCP

Install-Module -Name GoogleCloud -Force



