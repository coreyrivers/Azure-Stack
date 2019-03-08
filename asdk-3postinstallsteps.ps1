# Install Azure Stack PowerShell
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

#Reset PW policy
Set-ADDefaultDomainPasswordPolicy -MaxPasswordAge 180.00:00:00 -Identity azurestack.local

# Install and import the API Version Profile required by Azure Stack into the current PowerShell session.
Install-Module AzureRM -RequiredVersion 2.4.0
Install-Module -Name AzureStack -RequiredVersion 1.7.0

# Download Azure Stack Tool
# Change directory to the root directory.
cd c:\

# Enforce usage of TLSv1.2 to download the Azure Stack tools archive from GitHub
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
invoke-webrequest `
  https://github.com/Azure/AzureStack-Tools/archive/master.zip `
  -OutFile AzureStack-Tools-master.zip

# Expand the downloaded files.
expand-archive AzureStack-Tools-master.zip -DestinationPath . -Force

#Set Language Mode
$ExecutionContext.SessionState.LanguageMode

# Add the Azure cloud subscription environment name. 
# Supported environment names are AzureCloud, AzureChinaCloud or AzureUSGovernment depending which Azure subscription you are using.
Add-AzureRmAccount -EnvironmentName "AzureCloud"

# Register the Azure Stack resource provider in your Azure subscription
Register-AzureRmResourceProvider -ProviderNamespace Microsoft.AzureStack

# Import the registration module that was downloaded with the GitHub tools
Import-Module C:\AzureStack-Tools-master\Registration\RegisterWithAzure.psm1

# If you have multiple subscriptions, run the following command to select the one you want to use:
# Get-AzureRmSubscription -SubscriptionID "<subscription ID>" | Select-AzureRmSubscription

# Register Azure Stack
$AzureContext = Get-AzureRmContext
$CloudAdminCred = Get-Credential -UserName AZURESTACK\AzureStackAdmin -Message "Enter the credentials to access the privileged endpoint."
# Change Registration Name
$RegistrationName = "UniqueAzureName"
Set-AzsRegistration `
-PrivilegedEndpointCredential $CloudAdminCred `
-PrivilegedEndpoint AzS-ERCS01 `
-BillingModel Development `
-RegistrationName $RegistrationName `
-UsageReportingEnabled:$true

# Validate ASDK - Run 'Test-Azurestack' at the prompt
Enter-PSSession -ComputerName AzS-ERCS01 -ConfigurationName PrivilegedEndpoint
