# Variables
$Uri = 'https://raw.githubusercontent.com/Azure/AzureStack-Tools/master/Deployment/asdk-installer.ps1'
$LocalPath = 'C:\AzureStack_Installer'
# Create folder
New-Item $LocalPath -Type directory
# Enforce usage of TLSv1.2 to download from GitHub
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# Download file
Invoke-WebRequest $uri -OutFile ($LocalPath + '\' + 'asdk-installer.ps1')
