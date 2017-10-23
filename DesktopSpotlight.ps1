#NAME:  DesktopSpotlight
#AUTHOR: David Reed, @ReedTechno
#LASTEDIT: 10/19/2017 12:22

[CMDLETBinding()]
PARAM(
    
# Where do you want to store the Images?
$IMGstore = "C:\temp\SpotLight",

# Asset Path
$AssetPath = "$env:LOCALAPPDATA\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets"

)

Function Get-FileMetaData
{
  <#
   .Synopsis
    This function gets file metadata and returns it as a custom PS Object 
   .Description
    This function gets file metadata using the Shell.Application object and
    returns a custom PSObject object that can be sorted, filtered or otherwise
    manipulated.
   .Example
    Get-FileMetaData -folder "e:\music"
    Gets file metadata for all files in the e:\music directory
   .Example
    Get-FileMetaData -folder (gci e:\music -Recurse -Directory).FullName
    This example uses the Get-ChildItem cmdlet to do a recursive lookup of 
    all directories in the e:\music folder and then it goes through and gets
    all of the file metada for all the files in the directories and in the 
    subdirectories.  
   .Example
    Get-FileMetaData -folder "c:\fso","E:\music\Big Boi"
    Gets file metadata from files in both the c:\fso directory and the
    e:\music\big boi directory.
   .Example
    $meta = Get-FileMetaData -folder "E:\music"
    This example gets file metadata from all files in the root of the
    e:\music directory and stores the returned custom objects in a $meta 
    variable for later processing and manipulation.
   .Parameter Folder
    The folder that is parsed for files 
   .Notes
    NAME:  Get-FileMetaData
    AUTHOR: ed wilson, msft
    LASTEDIT: 01/24/2014 14:08:24
    KEYWORDS: Storage, Files, Metadata
    HSG: HSG-2-5-14
   .Link
     Http://www.ScriptingGuys.com
 #Requires -Version 2.0
 #>
 Param([string[]]$folder)
 foreach($sFolder in $folder)
  {
   $a = 0
   $objShell = New-Object -ComObject Shell.Application
   $objFolder = $objShell.namespace($sFolder)

   foreach ($File in $objFolder.items())
    { 
     $FileMetaData = New-Object PSOBJECT
      for ($a ; $a  -le 266; $a++)
       { 
         if($objFolder.getDetailsOf($File, $a))
           {
             $hash += @{$($objFolder.getDetailsOf($objFolder.items, $a))  =
                   $($objFolder.getDetailsOf($File, $a)) }
            $FileMetaData | Add-Member $hash
            $hash.clear() 
           } #end if
       } #end for 
     $a=0
     $FileMetaData
    } #end foreach $file
  } #end foreach $sfolder
} #end Get-FileMetaData

#Test to see if path exists. If false, create path.
IF (Test-Path $IMGstore) {
    Write-Host "Path Exists"
} Else {
    MD $IMGstore
}

#Create Temp Path
IF (Test-Path $IMGstore/temp) {
    Write-Host "Path Exists"
} Else {
    MD $IMGstore/temp
}

#Get images that have been added in the last 24 hrs
$NewAssets = Get-ChildItem $AssetPath | Where-Object {$_.CreationTime -gt (Get-Date).AddDays(-1)  }

#Copy files to temp and add .jpg extension
foreach ($NewAsset in $NewAssets){
    Copy-Item $AssetPath\$NewAsset -Destination $IMGstore\temp\$NewAsset.jpg
}

#Get Meta file for all images in temp folder
$TempAssetMeta = Get-FileMetaData $IMGstore\temp\


foreach ($AssetMeta in $TempAssetMeta){
    #Set Variables for asset name and demension
    $Demension = ($AssetMeta).Dimensions
    $FileName = ($AssetMeta).FileName
    #Check if the file is the right demension for your screen (Microsoft downloads both horizontal and vertical copies of each spotlight image)
    If (($AssetMeta).Dimensions -eq "1920 x 1080") {
        Copy-Item $IMGstore\temp\$filename -Destination $IMGstore\$filename -Force
        Remove-Item $IMGstore\temp\$filename
    } Else {
        Remove-Item $IMGstore\temp\$filename
    }
}
Remove-Item $IMGstore\temp\ -Force -Recurse

