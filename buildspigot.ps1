Param ($type, $version, $out)
function Separator() {
    Write-Host "------"
}
Clear-Host
Write-Host "BuildSpigot 1.0.0" -ForegroundColor Green
Separator

$original_path = Get-Location

function PrintHelp() {
    Write-Host "Usage: " -ForegroundColor Blue
    Write-Host "$ buildspigot [params]"
    Write-Host "-type: Type of the server. Can be: spigot or paper."
    Write-Host "-version: Minecraft version of the server."
    Write-Host "-out: file to output the jar to. default: server.jar"
    Separator
    Write-Host "Examples:" -ForegroundColor Blue
    Write-Host "$ buildspigot -type spigot -version 1.16.1 -out spigot.jar"
}

if (!($type) -or !($version)) {
    PrintHelp 
    Exit
}

if (!($out)) {
    $out = "server.jar"
}

if (!($type -eq "spigot") -and !($type -eq "paper")) {
    Write-Host "Wrong type of server."
    PrintHelp
    Exit
}

if (!(Test-Path -Path build)) {
    New-Item -Path "build" -ItemType Directory | Out-Null
    # add a gitignore to the build folder to not confuse ide's
    New-Item -Path "build/.gitignore" | Out-Null
    Set-Content -Path "build/.gitignore" -Value "./*" | Out-Null
}

Set-Location -Path build

if ($type -eq "spigot") {
    if ((Test-Path -Path BuildTools.jar)) {
        Write-Host "> Updating BuildTools..." -ForegroundColor Blue
    }
    else {
        Write-Host "> Downloading BuildTools..." -ForegroundColor Blue
    }
    "curl -z BuildTools.jar -o BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar" | cmd 2>&1 | Out-Null
    Write-Host "> Successfully installed BuildTools." -ForegroundColor Blue
    Write-Host "> Running BuildTools..." -ForegroundColor Blue
    Write-Host "> This might take some time..." -ForegroundColor Blue
    java -jar BuildTools.jar --rev $version 2>&1 | Out-Null
    Write-Host "> Successfully compiled spigot" -ForegroundColor Blue
    if ((Test-Path -Path "../$($out)")) {
        Remove-Item -Path "../$($out)"
    }
    Move-Item -Path "./spigot-$($version).jar" -Destination "../$($out)"
    Write-Host "> Successfully moved the output jar" -ForegroundColor Blue
}

if ($type -eq "paper") {
    Write-Host "> Downloading paper..." -ForegroundColor Blue
    Invoke-WebRequest -Uri "https://papermc.io/api/v1/paper/$($version)/latest/download" -OutFile "paper-download.jar" | Out-Null
    if ((Test-Path -Path "../$($out)")) {
        Remove-Item -Path "../$($out)"
    }
    Move-Item -Path "./paper-download.jar" -Destination "../$($out)"
    Write-Host "> Successfully moved the output jar" -ForegroundColor Blue
}

Set-Location $original_path