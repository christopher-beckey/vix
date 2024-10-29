# sets the client TCP/IP socket connection timeout TcpTimedWaitDelay value to 30 in the Windows Registry if it is missing 
# or outside of the range of 30 to 240.
Try {
    Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpTimedWaitDelay"
}
Catch {
    Write-Output 'The TcpTimedWaitDelay key does not exist Setting to Value 30'
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpTimedWaitDelay" -Value 30
}
Finally {
    if (((Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpTimedWaitDelay") -lt  '30') -or ((Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpTimedWaitDelay") -gt  '240')) {
        Write-Output 'The value of TcpTimedWaitDelay is not within 30 to 240'
		Write-Output 'Setting the value of TcpTimedWaitDelay to 30'
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpTimedWaitDelay" -Value 30
    }  
}
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpTimedWaitDelay"

Write-Host "DONE with registry update and check"
