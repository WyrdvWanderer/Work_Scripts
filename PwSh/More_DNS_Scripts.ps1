# Check current DNS Suffix Search List 
$currentSuffixes = (Get-DnsClientGlobalSetting).SuffixSearchList 
# Add new DNS suffixes 
$newSuffixes = $currentSuffixes + "newdomain.com" + "anotherdomain.com" 
# Set the new DNS Suffix Search List 
Set-DnsClientGlobalSetting -SuffixSearchList $newSuffixes 
# Verify the changes 
Get-DnsClientGlobalSetting 