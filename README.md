# BuildSpigot

A powershell script to quickly update BuildTools and build spigot jar's.

## Usage

In PowerShell:

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/dada513/build-spigot/master/buildspigot.ps1" -OutFile "buildspigot.ps1"
./buildspigot.ps1 [params]
```

## BuildSpigot 1.0.0

`$ ./buildspigot.ps1 [params]`

`-type`: Type of the server. Can be: `spigot` or `paper`.  
`-version`: Minecraft version of the server.  
`-out`: file to output the jar to. default: `server.jar`

---

### Examples:

`$ ./buildspigot.ps1 -type spigot -version 1.16.1 -out spigot.jar`  
`$ ./buildspigot.ps1 -type paper -version 1.16.1 -out paper.jar`
