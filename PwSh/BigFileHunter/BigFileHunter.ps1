# Look for files larger than 5GB in the C: drive
Get-ChildItem -Path C:\ -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Length -gt 5GB } | Select-Object FullName, @{Name="Size";Expression={"{0:N2} GB" -f ($_.Length / 1GB)}}, LastWriteTime
