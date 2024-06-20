#Set the condition to download Rufus via Invoke-Web 

# https://github.com/pbatard/rufus/releases/download/v4.3/rufus-4.3p.exe

# [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Url = "https://github.com/pbatard/rufus/releases/download/v4.3/rufus-4.3p.exe"
$Output = "C:\SWTOOLS\_Assets\Installers\rufus-4.3p.exe"
# $Proxy = "http://proxy.govconnect.nsw.gov.au:9090"


Invoke-WebRequest -Uri $Url -OutFile $Output #-Proxy #$Proxy -ProxyCredential (Get-Credential)