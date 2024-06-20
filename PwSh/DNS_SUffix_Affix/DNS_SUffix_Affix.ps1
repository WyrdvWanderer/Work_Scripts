# Function to run as a different user if required
function Run-WithCredentials {
    param(
        [scriptblock]$ScriptBlock
    )
    $credential = Get-Credential -Message "Enter credentials to perform DNS suffix update"
    Start-Job -ScriptBlock $ScriptBlock -Credential $credential | Wait-Job | Receive-Job
}

# Script block for DNS suffix management
$dnsManagementScript = {
    param(
        [string]$SuffixToAdd,
        [string]$SuffixToRemove
    )
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
    $propertyName = "SearchList"
    
    # Fetch current DNS suffixes
    $currentSuffixes = Get-ItemProperty -Path $regPath -Name $propertyName | Select-Object -ExpandProperty $propertyName
    $suffixArray = $currentSuffixes -split ","
    
    # Remove a suffix if specified
    if ($SuffixToRemove) {
        $suffixArray = $suffixArray | Where-Object { $_ -ne $SuffixToRemove }
    }
    
    # Add a new suffix if specified
    if ($SuffixToAdd -and $suffixArray -notcontains $SuffixToAdd) {
        $suffixArray += $SuffixToAdd
    }
    
    # Update the registry with the modified list
    $newSuffixes = $suffixArray -join ","
    Set-ItemProperty -Path $regPath -Name $propertyName -Value $newSuffixes
    
    Write-Output "DNS suffixes updated to: $newSuffixes"
}

# Example usage:
$SuffixToAdd = "example.com" # Set to $null if not adding
$SuffixToRemove = "your_dns_suffix" # Set to $null if not removing

# Check if the script needs to run with elevated permissions
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Output "Running with elevated credentials"
    Run-WithCredentials -ScriptBlock $dnsManagementScript -ArgumentList $SuffixToAdd, $SuffixToRemove
}
else {
    & $dnsManagementScript -SuffixToAdd $SuffixToAdd -SuffixToRemove $SuffixToRemove
}
