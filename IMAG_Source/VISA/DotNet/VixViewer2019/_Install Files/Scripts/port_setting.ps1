# sets DynamicPort TCP port settings and shows updated port settings.
Write-Host "setting port settings."
"NetSh INT IPV4 SET DynamicPort TCP Start=1025 num=64511" | cmd | Write-Output
Write-Host "showing port settings"
"NetSh INT IPV4 Show DynamicPort TCP" | cmd | Write-Output

Write-Host "DONE with port settings update and check"
