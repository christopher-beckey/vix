#script to update VistaConnectionConfiguration.Config to toggle between the VistA new style broker and the old style broker

$vistaConnectionFile="C:\VixConfig\VistaConnectionConfiguration.Config"

function ReadVistaConnectionConfig([xml] $xmlDocument) {	
	$vistaConnNewStyleBool = $xmlDocument.SelectSingleNode('//java/object/void[@property="newStyleLoginEnabled"]/boolean')				
	$currentVistaConnNewStyle = $vistaConnNewStyleBool.InnerText 	
	$vistaConnOldStyleBool = $xmlDocument.SelectSingleNode('//java/object/void[@property="oldStyleLoginEnabled"]/boolean')						
	$currentVistaConnOldStyle =$vistaConnOldStyleBool.InnerText 
    
    Write-Host "newStyleLoginEnabled boolean currently set to $currentVistaConnNewStyle." -ForegroundColor Black -BackgroundColor Yellow
    Write-Host "oldStyleLoginEnabled boolean currently set to $currentVistaConnOldStyle." -ForegroundColor Black -BackgroundColor Yellow
} 

function UpdateVistaConnectionNewStyleConfig([xml] $xmlDocument, $styleBool) {	
	$vistaConnNewStyleBool = $xmlDocument.SelectSingleNode('//java/object/void[@property="newStyleLoginEnabled"]/boolean')	
	$vistaConnNewStyle = $xmlDocument.SelectSingleNode('//java/object/void[@property="newStyleLoginEnabled"]')
	
    if ($styleBool -eq $true){
        $newStyleBool = "true"
        $oldStyleBool = "false"
    }
    
    if ($styleBool -eq $false){
        $newStyleBool = "false"
        $oldStyleBool = "true"
    }
       
	if ($vistaConnNewStyleBool.InnerText -ne $newStyleBool) {
		$vistaConnNewStyle.RemoveChild($vistaConnNewStyleBool) | Out-Null		 	
		$vistaConnNewStyleFilterText=$newStyleBool
		$vistaConnNewStyleElement=$xmlDocument.CreateElement('boolean')
		$vistaConnNewStyleElement.InnerText = $vistaConnNewStyleFilterText
		$vistaConnNewStyle.AppendChild($vistaConnNewStyleElement) | Out-Null
		Write-Host "Updating newStyleLoginEnabled value to $newStyleBool."		
	}
	else 
	{
		Write-Host "newStyleLoginEnabled value already set to $newStyleBool."	
	}
	
	$vistaConnOldStyleBool = $xmlDocument.SelectSingleNode('//java/object/void[@property="oldStyleLoginEnabled"]/boolean')	
	$vistaConnOldStyle = $xmlDocument.SelectSingleNode('//java/object/void[@property="oldStyleLoginEnabled"]')
					
	if ($vistaConnOldStyleBool.InnerText -ne $oldStyleBool ) {
		$vistaConnOldStyle.RemoveChild($vistaConnOldStyleBool) | Out-Null		
		$vistaConnOldStyleFilterText=$oldStyleBool 
		$vistaConnOldStyleElement=$xmlDocument.CreateElement('boolean')
		$vistaConnOldStyleElement.InnerText = $vistaConnOldStyleFilterText
		$vistaConnOldStyle.AppendChild($vistaConnOldStyleElement) | Out-Null
		Write-Host "Updating oldStyleLoginEnabled value to $oldStyleBool "		
	}
	else 
	{
		Write-Host "oldStyleLoginEnabled value already set to $oldStyleBool."	
	}		
}

function Enable-NewStyle
{    
    $confirmNewStyle = Read-Host "Confirm you want to enable the New Style Broker (Y/N)?"   
    
    if ($confirmNewStyle -eq "Y")
    {   
        Write-Host "Enabling New Style Broker."
        $styleBool = $true
        [xml]$vistaConnXmlDoc = Get-Content -Path $vistaConnectionFile
        UpdateVistaConnectionNewStyleConfig $vistaConnXmlDoc $styleBool
        $vistaConnXmlDoc.Save($vistaConnectionFile)	    
    }
}

function Enable-OldStyle
{    
    $confirmOldStyle = Read-Host "Confirm you want to enable the New Style Broker (Y/N)?"     
    
    if ($confirmOldStyle -eq "Y")
    {   
        Write-Host "Enabling Old Style Broker."
        $styleBool = $false
        [xml]$vistaConnXmlDoc = Get-Content -Path $vistaConnectionFile
        UpdateVistaConnectionNewStyleConfig $vistaConnXmlDoc $styleBool
        $vistaConnXmlDoc.Save($vistaConnectionFile)	      
    }
}

function Confirm-Type {

    Write-Host  "*****************************************************************************"
    Write-Host  "This script will do the following operations:"
    Write-Host  "  1) Enable the New Style Broker and disable the Old Style Broker."
    Write-Host  "  2) Enable the Old Style Broker and disable the New Style Broker."
    Write-Host  "*****************************************************************************`n`n"
    [xml]$vistaConnXmlDoc = Get-Content -Path $vistaConnectionFile
    ReadVistaConnectionConfig $vistaConnXmlDoc	  

    Do {$styleOption = Read-Host "Please choose Style Broker Option (1 to enable New Style, 2 to enable Old Style, or Q to Quit)"} while ($styleOption -notmatch "1|2|Q")

    switch ($styleOption)
    {
        '1' {'Enable New Style Broker'
              Enable-NewStyle
            }
        '2' {'Enable Old Style Broker'
                Enable-OldStyle
            }
        'Q' {'quitter...'
                Exit
            }
    }
}

Confirm-Type
Write-Host  "Style Broker script has finished."