$AppPath = Get-ChildItem "C:\Users\BDupy\AppData\Local\Discord" -Directory | Where-Object {$_.Name -like "app*"} | Sort-Object LastWriteTime -Descending | Select-Object -first 1
$exePath = (($AppPath.FullName) + '\Discord.exe')
$exeName = [System.IO.Path]::GetFileName($exePath)
$regPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"

# Ensure registry key exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set compatibility mode to Run as Administrator
Set-ItemProperty -Path $regPath -Name $exePath -Value "~ RUNASADMIN"

Write-Host "Compatibility mode for $exeName set to 'Run as Administrator'"
