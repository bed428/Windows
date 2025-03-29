#Manual Variables: 
	$GoodSpeed = 750 #Mbps - Above is Green
	$MedianSpeed = 400 #Mbps - Below is red. 
	$SpeedtestLocation = "C:\scripts\ookla-speedtest-1.2.0-win64\"

#Network Test
Set-Location $SpeedtestLocation
Write-Host -Fore Cyan "`n----- TESTING NETWORK SPEED  -----"
    $Result = .\speedtest.exe --accept-license --accept-gdpr -f json | ConvertFrom-Json

    $UploadMbps = [Math]::Round($Result.upload.bytes / 1Mb)
    $DownloadMbps = [Math]::Round($Result.download.bytes / 1Mb)

#Download Results
Write-Host -Fore Cyan "---   DOWN (Mbps): " -NoNewline
    if($UploadMbps -ge $GoodSpeed){ Write-Host -Fore Green $DownloadMbps}
    elseif($UploadMbps -lt $MedianSpeed){Write-Host -Fore Red $DownloadMbps ; $Bad = $True}
	elseif($UploadMbps -lt $GoodSpeed){ Write-Host -Fore Yellow $DownloadMbps}


#Upload Results
Write-Host -Fore Cyan "---     UP (Mbps): " -NoNewline
    if($UploadMbps -gt $GoodSpeed){ Write-Host -Fore Green $UploadMbps}
    elseif($UploadMbps -lt $MedianSpeed){Write-Host -Fore Red $UploadMbps ; $Bad = $True}
	elseif($UploadMbps -lt $GoodSpeed){ Write-Host -Fore Yellow $UploadMbps}
    

Write-Host -Fore Cyan "----------------------------------`n"

if($Bad){pause}else{Start-Sleep -Seconds 5 ; exit}
