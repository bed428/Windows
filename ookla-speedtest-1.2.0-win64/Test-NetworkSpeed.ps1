#Output values based on 1Gbps/1Gbps speeds. Adust the Mbps values below to change coloring. 

#Network Test
Write-Host -Fore Cyan "`n----- TESTING NETWORK SPEED  -----"
    $Result = .\speedtest.exe --accept-license --accept-gdpr -f json | ConvertFrom-Json

    $UploadMbps = [Math]::Round($Result.upload.bytes / 1Mb)
    $DownloadMbps = [Math]::Round($Result.download.bytes / 1Mb)

#Download Results
Write-Host -Fore Cyan "---   DOWN (Mbps): " -NoNewline
    if($UploadMbps -gt 750){ Write-Host -Fore Green $DownloadMbps}
    elseif(($UploadMbps -lt 749) -and ($DownloadMbps -ge 400)){ Write-Host -Fore Yellow $DownloadMbps}
    elseif($UploadMbps -lt 400){Write-Host -Fore Red $DownloadMbps}

#Upload Results
Write-Host -Fore Cyan "---     UP (Mbps): " -NoNewline
    if($UploadMbps -gt 750){ Write-Host -Fore Green $UploadMbps}
    elseif(($UploadMbps -lt 749) -and ($UploadMbps -ge 400)){ Write-Host -Fore Yellow $UploadMbps}
    elseif($UploadMbps -lt 400){Write-Host -Fore Red $UploadMbps}


Write-Host -Fore Cyan "----------------------------------`n"
pause
