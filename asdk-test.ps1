Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

Get-Module -Name Azs.* -ListAvailable | Uninstall-Module -Force -Verbose
Get-Module -Name Azure* -ListAvailable | Uninstall-Module -Force -Verbose

# Install the AzureRM.BootStrapper module. Select Yes when prompted to install NuGet
Install-Module -Name AzureRM.BootStrapper

# Install and import the API Version Profile required by Azure Stack into the current PowerShell session.
Use-AzureRmProfile -Profile 2019-03-01-hybrid -Force
Install-Module -Name AzureStack -RequiredVersion 1.8.0

# Change directory to the root directory.
cd c:\

# Enforce usage of TLSv1.2 to download the Azure Stack tools archive from GitHub
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest `
  -Uri https://github.com/Azure/AzureStack-Tools/archive/master.zip `
  -OutFile master.zip

# Expand the downloaded files.
Expand-Archive -Path master.zip -DestinationPath . -Force

# Change to the tools directory.
cd c:\AzureStack-Tools-master