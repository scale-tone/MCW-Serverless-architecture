function Disable-InternetExplorerESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force
    Stop-Process -Name Explorer -Force
    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
}

# Resolves an error caused by Powershell defaulting to TLS 1.0 to connect to websites, but website security requires TLS 1.2.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Tls11, [Net.SecurityProtocolType]::Tls12, [Net.SecurityProtocolType]::Ssl3
[Net.ServicePointManager]::SecurityProtocol = "Tls, Tls11, Tls12, Ssl3"

# Disable IE ESC
Disable-InternetExplorerESC

# Download and extract the starter solution files
Invoke-WebRequest 'https://github.com/microsoft/MCW-Serverless-architecture/archive/main.zip' -OutFile 'C:\MCW.zip'
Expand-Archive -LiteralPath 'C:\MCW.zip' -DestinationPath 'C:\ServerlessMCW' -Force

# Download and install Microsoft Edge
Invoke-WebRequest 'https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/b3ed8b52-ee6b-401e-aa19-85b6f3dbfa0e/MicrosoftEdgeEnterpriseX64.msi' -OutFile 'C:\MicrosoftEdgeEnterpriseX64.msi'
$msiArgs = @(
    "/i"
    "C:\MicrosoftEdgeEnterpriseX64.msi"
    "/qn"
    "/norestart"
    "/L*v C:\edge-install-log.txt"
)
Start-Process msiexec.exe -ArgumentList $msiArgs -Wait -NoNewWindow

# Set the default Git branch to main
git config --global init.defaultBranch main
