#Parameters
  $YourPath = "E:\"
#Parameters


Function Send-ToRecycleBin 
{
    param
	(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    if (-Not (Test-Path $Path))
	{
        Write-Warning "Path does not exist: $Path"
        return
    }

    # Load the Shell.Application COM object
		$shell = New-Object -ComObject Shell.Application
		$folderPath = Split-Path $Path
		$fileName = Split-Path $Path -Leaf
		$folder = $shell.Namespace($folderPath)
		$item = $folder.ParseName($fileName)

    # Move to Recycle Bin
		$item.InvokeVerb("delete")
}



$ErrorActionPreference = "Stop"
Set-Location $YourPath

# Get all files recursively
	$AllFiles = Get-ChildItem -Recurse -File
	$OriginalCount = $AllFiles.Count

# Hashtable to store hashes and the FIRST file associated with each hash
	$FileHashes = @{}
	$Delete = @()




# ---- CORE LOGIC ---- #
foreach ($File in $AllFiles) 
{

    # Compute file hash
    $FileHash = (Get-FileHash -Path $File.FullName -ErrorAction Stop).Hash

    # If this hash has NOT been seen before, store it
    if($null -eq $FileHash)
    {
        Write-Host "`nNULL HASH`t-`t$($File.fullname)" -f red
    }
    elseif ( -not $FileHashes.ContainsKey($FileHash) ) 
	{
        # Store the original file path for this hash
        $FileHashes[$FileHash] = $File.FullName
    }
    else 
	{
        # We HAVE seen this hash — this is a duplicate
			$Original = $FileHashes[$FileHash]

			Write-Host "DUPLICATE detected:"
			Write-Host "`tOriginal:  $Original"
			Write-Host "`tDuplicate: $($File.FullName)"
			Write-Host ""

        # Add this duplicate to deletion list
        $Delete += $File.FullName
    }
}





# ---- DELETE THE IDENTIFIED DUPLICATES ----
foreach ($Path in $Delete) 
{
    Send-ToRecycleBin $Path
}

# File Summary
	$NewCount = (Get-ChildItem -Recurse -File).Count

	Write-Host ""
	Write-Host "Original file count:  $OriginalCount"
	Write-Host "Duplicate count:       $($Delete.Count)"
	Write-Host "After cleanup:         $NewCount"
	Write-Host ""


# Delete empty folders 
	if($YourPath -match "OneDrive|My Drive")
    {
        Write-Host -F Red 'ERROR: Path appears to be a cloud drive. You do not want to clear empty folders, as $Folder.Count does not work on OneDrive or other cloud directories.'
        break
    }
	$TotalCount = 0
    do {
        $EmptyDirs = Get-ChildItem -Recurse -Directory -Force | Where-Object {
            (Get-ChildItem -Path $_.FullName -Force).Count -eq 0
        }

        foreach ($Dir in $EmptyDirs) {
            try 
			{
                Remove-Item -Path $Dir.FullName -Recurse -Force -ErrorAction Stop
                Write-Host "Deleted empty folder: $($Dir.FullName)"
            } catch 
			{
                Write-Warning "Failed to delete folder: $($Dir.FullName)"
            }
        }
        
        $RemovedCount = $EmptyDirs.Count
        $TotalCount += $RemovedCount
    } while ($RemovedCount -gt 0)

Write-Host "Removed Empty Folders - $($TotalCount)"

