# VixCheck.ps1

param
(
    [Parameter(Mandatory=$False)][string]$utilPwd,
    [Parameter(Mandatory=$False)][string]$fqdn,
    [Parameter(Mandatory=$False)][string]$accessCode,
    [Parameter(Mandatory=$False)][string]$verifyCode,
    [Parameter(Mandatory=$False)][string]$icn,
    [Parameter(Mandatory=$False)][string]$siteId,
    [Parameter(Mandatory=$False)][string]$userId
)

#If the user did not provide the password, explain why it is needed and get it
if([string]::IsNullOrWhiteSpace($utilPwd))
{
    $scriptName = $myInvocation.myCommand.name
    Write-Output "`nThis script calls VIX REST APIs to:`n- Get a VIX Java security token based on VistA Access and Verify Codes.`n- Check patient sites.`n- Check user details.
`nDefaults are for the localhost with VistA DEV codes
Command Line Syntax: -utilPwd u [-fqdn f -accessCode a -verifyCode v -icn i -siteId s -userId u]`nExample: ${scriptName} -utilPwd thePlainTextPassword -fqdn vhaispappvixip5.vha.med.va.gov"
    while ([string]::IsNullOrWhiteSpace($utilPwd)) {$utilPwd = Read-Host -Prompt "utilPwd"}
}

function DecryptedVixJava($encrypted)
{
    $decryptedOutput = & java -jar C:\VixConfig\Encryption\ImagingUtilities-0.1.jar -operation=decrypt -password="$utilPwd" -input="$encrypted"
    #Sample is (Decrypted string is:    foo)
    $parts = $decryptedOutput -split ": "
    if([string]::IsNullOrWhiteSpace($parts[1]))
    {
        Write-Output "The decryption utility failed. Perhaps the password is incorrect. This script cannot proceed."
        Exit
    }
    $theValue = $parts[1].TrimStart()
    return $theValue, $didErrorOccur
}

if([string]::IsNullOrWhiteSpace($fqdn))       { $fqdn = "localhost" }
if([string]::IsNullOrWhiteSpace($accessCode)) { $accessCode = DecryptedVixJava("0xnjE7HRRL1QXFE5KqmiP+0BTFaVBN6N") }
if([string]::IsNullOrWhiteSpace($verifyCode)) { $verifyCode = DecryptedVixJava("0xnjE7HRRL1IbqPLnS3/WmODOwERpXyWzg==") }
if([string]::IsNullOrWhiteSpace($icn))        { $icn="1006170580V294705" }
if([string]::IsNullOrWhiteSpace($siteId))     { $siteId="660" }
if([string]::IsNullOrWhiteSpace($userId))     { $userId="126" }

$myProps = @{}
$myProps.VixJavaSecurityToken = ""
$myProps.myGuid = [guid]::NewGuid()
$myProps.URL = "http://${fqdn}:8080"
$myProps.AccessCode = $accessCode
$myProps.VerifyCode = $verifyCode
$myProps.Icn = $icn
$myProps.SiteId = $siteId
$myProps.UserId = $userId

# prepare authentication string
$pair = $accessCode + ":" + $verifyCode
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$basicAuthValue = "Basic $base64"
$headers = @{ Authorization = $basicAuthValue }
$headers.Add("xxx-transaction-id", $myProps.myGuid)
#uncomment the following line for debugging
#$headers.getEnumerator() | Sort-Object -property key | ForEach-Object { "[{0},{1}]" -f ($_.key, $_.value)}

$myProps.Headers = $headers
$myProperties = New-Object -TypeName PSObject -Property $myProps

function GetVixJavaSecurityToken
{
    Write-Output "`nGetting the VIX Java Security Token ..."

    $url = $myProperties.URL + "/ViewerStudyWebApp/restservices/study/user/token"
    #add -Verbose below for debugging
    $response = Invoke-WebRequest $url -Headers $myProperties.Headers
    #Write-Output "[DEBUG] response: ${response}"

    # parse response
    $xml = [xml]$response
    $myProperties.VixJavaSecurityToken = $xml.restStringType.value
    $msg = "is " + $myProperties.VixJavaSecurityToken
    if ([string]::IsNullOrWhiteSpace($myProperties.VixJavaSecurityToken)) { $msg = "was not returned"}
    Write-Output "The token $msg"
}

function GetTreatingFacilities
{
    Write-Output "`nCheck the treating facilities ..."

    # invoke request
    $url = $myProperties.URL + "/ViewerImagingWebApp/token/restservices/viewerImaging/getTreatingFacilities?securityToken=" + $myProperties.VixJavaSecurityToken
    if(![string]::IsNullOrWhiteSpace($myProperties.SiteId)) { $url = $url + "&siteId=" + $myProperties.SiteId }
    if(![string]::IsNullOrWhiteSpace($myProperties.Icn)) { $url = $url + "&icn=" + $myProperties.Icn }
    #add -Verbose below for debugging
    $response = Invoke-WebRequest $url -Headers $myProperties.Headers
    #Write-Output "[DEBUG] response: ${response}"

    # parse response
    #Write-Output "[DEBUG] response: ${response}.Content"
    $info = ([xml]$response.Content).treatingFacilityResults.treatingFacility.institutionName
    $info = $info + " (" + ([xml]$response.Content).treatingFacilityResults.treatingFacility.institutionIEN + ")"
    #Write-Output "[DEBUG] info: ${info}"
    $msg = "is " + $info
    if ([string]::IsNullOrWhiteSpace($info)) { $msg = "was not returned"}
    Write-Output "The site(s) info $msg"
}

function GetUserInfo
{
    Write-Output "`nChecking user information ..."
    $headers = @{ "xxx-transaction-id" = $myProperties.myGuid }

    # invoke request
    $url = $myProperties.URL + "/ViewerImagingWebApp/token/restservices/viewerImaging/getUserInformation?securityToken=" + $myProperties.VixJavaSecurityToken
    if(![string]::IsNullOrWhiteSpace($myProperties.SiteId)) { $url = $url + "&siteId=" + $myProperties.SiteId }
    if(![string]::IsNullOrWhiteSpace($myProperties.UserId)) { $url = $url + "&userId=" + $myProperties.UserId }
    #uncomment the following line for debugging
    #$headers.getEnumerator() | Sort-Object -property key | ForEach-Object { "[{0},{1}]" -f ($_.key, $_.value)}
    #add -Verbose below for debugging
    $response = Invoke-WebRequest $url -Headers $headers
    #Write-Output "[DEBUG] response: ${response}"

    # parse response
    $xml = [xml]$response
    $info = $xml.restStringType.value
    $msg = "is " + $info
    if ([string]::IsNullOrWhiteSpace($info)) { $msg = "was not returned"}
    Write-Output "The user info $msg"
}

function CheckAll()
{
    try
    {
        GetVixJavaSecurityToken
        if([string]::IsNullOrWhiteSpace($myProperties.VixJavaSecurityToken))
        {
            Exit
        }
    }
    catch
    {
        Write-Output $_.Exception
        Exit
    }
    try
    {
        GetTreatingFacilities
    }
    catch
    {
        Write-Output $_.Exception
    }
    try
    {
        GetUserInfo
    }
    catch
    {
        Write-Output $_.Exception
    }
}

CheckAll
