##########################################################
#
#	MiseEnDossiers.ps1
#	Date : 2018.08.03
#   Author : Galoseau Mathieu
#
##########################################################

Import-module .\Functions.ps1

#region Folderizer path filteType
Function Folderizer(
	[Parameter(Mandatory = $true)] [string] $path,
	[Parameter(Mandatory = $true)] [string] $filteType,
	[Parameter(Mandatory = $false)] [string] $to = ""
) 
{
	try
	{
		if($to -eq "")
		{
			$to = $path
		}

		 WriteLog ("START Folderizer path : {0}" -f $path) "Folderizer" "VideoToFolder"

		  Get-ChildItem "$($path)" -Filter "*.$($filteType)" `
		  | Select-Object Name, FullName  `
		  | ForEach-Object -Process {
		
			WriteLog ("File : {0}" -f $_.Name) "Folderizer" "VideoToFolder"
			WriteLog ("New Folder : {0}" -f $_.Name.Substring(0,$_.Name.LastIndexOf('.'))) "Folderizer" "VideoToFolder"

			$newFileFolder = "{0}\{1}" -f $to, $_.Name.Substring(0,$_.Name.LastIndexOf('.'))


			if ((Test-Path -LiteralPath $newFileFolder) -eq $false)
			{
				New-Item -ItemType directory -Path $newFileFolder
			}
				

			$FullName = $_.FullName.replace("'", "`'")
			$newFileFolder = $newFileFolder.replace("'", "`'")
			
			WriteLog ("move item from : {0} to {1}" -f $FullName, $newFileFolder) "Folderizer" "VideoToFolder"
			
		 		Move-Item  -LiteralPath "$($FullName)" -Destination "$($newFileFolder)"
		}
		
		 WriteLog ("END Folderizer path : {0}" -f $path) "Folderizer" "VideoToFolder"
	}catch
	{
		try
		{
			WriteLog $_.Exception.Message "Folderizer" "VideoToFolder" "Red"
		}
		catch
		{
			Write-Host ("[MiseEnDossiers] [VideoToFolder] ERROR : {0}" -f $_.Exception.Message) -foregroundcolor "Red"
		}
	}
}
#endregion 

Folderizer -path "\\NASMATG\Raid\Films" "mkv"
Folderizer -path "\\NASMATG\Raid\Films" "avi"
Folderizer -path "\\NASMATG\Raid\Films" "divx"
Folderizer -path "\\NASMATG\Raid\Films" "iso"
Folderizer -path "\\NASMATG\Raid\Films" "mp4"