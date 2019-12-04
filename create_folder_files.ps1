<#
.SYNOPSIS
    Creates folders based on input folder_list.txt file

.DESCRIPTION
    This script creates folders and txt files based on full file paths located in the folder_list.txt file

.EXAMPLE
    .\create_folder_files.ps1 .\folder_list.txt
#>

Param(
    [parameter(mandatory = $true)][string]$file
)

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$folderList = Get-Content $dir$file
$rowCount = $folderList | Measure-Object

# checkFileFolder checks if the file path is a directory or a file and returns its respective messages
function checkFileFolder {
    param($listItem)

    if (Test-Path $listItem) {
        # if ($listItem.PSISContainer) {
        if ((Get-Item $listItem) -is [System.IO.DirectoryInfo]) {
            Write-Host "SUCCESS: Folder $listItem created." -ForegroundColor Green
        }
        else {
            Write-Host "SUCCESS: File $listItem created." -ForegroundColor Green
        }
    }
    else {
        # if ($listItem.PSISContainer) {
        if ((Get-Item $listItem) -is [System.IO.DirectoryInfo]) {
            Write-Host "ERROR: Unable to create $listItem folder." -ForegroundColor Red
        }
        else {
            Write-Host "ERROR: Unable to create $listItem file." -ForegroundColor Red
        }
    }
}

function createFolderFiles {
    param($listItem)

    $x = Test-Path $listItem
	
    # Check if folder path exists
    if ($x) { 
        Write-Host "INFO: $listItem exists."
    }
    else {
        # Check if folder path contains files
        if ($listItem -cmatch '\.[\w]+$') {

            # Create Notification.txt and notify.txt files
            if ($listItem.Contains("Notification.txt") -or $listItem.Contains("notify.txt")) {
                [void](New-Item $listItem -type file)
                checkFileFolder -listItem $listItem
            }
            else {
                Write-Host "WARNING: Skipped file. Did not create $listItem" -ForegroundColor Yellow
            }
        }
        else {
            [void](New-Item $listItem -type directory)
            checkFileFolder -listItem $listItem
        }
    }
}

for ($i = 0; $i -le ($rowCount.Count - 1); $i++) {
    createFolderFiles -listItem $folderList[$i]
}