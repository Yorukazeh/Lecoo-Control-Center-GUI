#Requires -Version 5.1
<#
.SYNOPSIS
    Build the Windows release, deploy its Qt runtime, and clean build-only files.

.DESCRIPTION
    Builds with cargo, then copies the Qt runtime (windeployqt), the MSVC x64
    runtime and the bundled font licenses next to
    target\release\Lecoo-Control-Center-GUI.exe, so that the executable runs
    without a Qt installation. The Qt runtime is never deleted - it is only
    added / updated - and the deployment is verified afterwards.

    Finally the folders cargo only needs while building (build\, deps\,
    incremental\, examples\, .fingerprint\) are removed, leaving a release
    directory that contains just the runnable application.

.PARAMETER QtBin
    Path to the Qt msvc2022_64 bin directory, e.g.
    C:\Qt\6.8.3\msvc2022_64\bin. When omitted, qmake must already be on PATH.

.PARAMETER NoBuild
    Skip "cargo build --release" and deploy/clean the existing executable.

.PARAMETER KeepBuildFiles
    Keep the build-only folders (target\release\build, deps, ...). Use this if
    you want the next "cargo build" to stay incremental.

.EXAMPLE
    .\scripts\package-windows.ps1 -QtBin C:\Qt\6.8.3\msvc2022_64\bin

.EXAMPLE
    .\scripts\package-windows.ps1 -QtBin C:\Qt\6.8.3\msvc2022_64\bin -KeepBuildFiles
#>
[CmdletBinding()]
param(
    [string]$QtBin = $env:QT_BIN,
    [switch]$NoBuild,
    [switch]$KeepBuildFiles
)

$ErrorActionPreference = "Stop"

$repo = Split-Path -Parent $PSScriptRoot
$releaseDir = Join-Path $repo "target\release"

Push-Location $repo
try {
    if ($QtBin) {
        $env:PATH = "$QtBin;$env:PATH"
    }

    if (-not (Get-Command qmake -ErrorAction SilentlyContinue)) {
        throw "qmake not found. Add the Qt bin directory to PATH or pass -QtBin <C:\Qt\6.8.3\msvc2022_64\bin>."
    }
    if (-not (Get-Command windeployqt -ErrorAction SilentlyContinue)) {
        throw "windeployqt not found. Add the Qt bin directory to PATH or pass -QtBin."
    }

    if (-not $NoBuild) {
        Write-Host "==> cargo build --release"
        cargo build --release
        if ($LASTEXITCODE -ne 0) { throw "cargo build --release failed" }
    }

    $exe = Join-Path $releaseDir "Lecoo-Control-Center-GUI.exe"
    if (-not (Test-Path $exe)) {
        throw "Executable not found: $exe (run without -NoBuild first)"
    }

    # Deploy the Qt runtime without deleting existing files.
    Write-Host "==> deploying Qt runtime next to the executable"
    windeployqt --release --no-translations `
        --qmldir (Join-Path $repo "qml") `
        $exe
    if ($LASTEXITCODE -ne 0) { throw "windeployqt failed" }

    foreach ($required in @("Qt6Core.dll", "Qt6Gui.dll", "Qt6Qml.dll", "Qt6Quick.dll")) {
        if (-not (Test-Path (Join-Path $releaseDir $required))) {
            throw "windeployqt did not deploy $required next to the executable."
        }
    }
    if (-not (Test-Path (Join-Path $releaseDir "platforms\qwindows.dll"))) {
        throw "windeployqt did not deploy the Windows platform plugin (platforms\qwindows.dll)."
    }

    # Copy the MSVC x64 runtime when Visual Studio is available.
    $vswhere = Join-Path ${env:ProgramFiles(x86)} "Microsoft Visual Studio\Installer\vswhere.exe"
    $vsPath = $null
    if (Test-Path $vswhere) {
        $vsPath = & $vswhere -latest -products "*" `
            -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
            -property installationPath
    }
    $crtDll = $null
    if ($vsPath) {
        $crtDll = Get-ChildItem -Path (Join-Path $vsPath "VC\Redist\MSVC") `
            -Recurse -Filter "vcruntime140.dll" -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -match '\\x64\\Microsoft\.VC[^\\]*\.CRT\\' } |
            Sort-Object FullName -Descending |
            Select-Object -First 1
    }
    if ($crtDll) {
        Copy-Item (Join-Path $crtDll.Directory.FullName "*.dll") $releaseDir -Force
        Write-Host "==> bundled MSVC runtime from $($crtDll.Directory.FullName)"
    } else {
        Write-Warning "MSVC x64 runtime not found; install the VC++ Redistributable on target machines, or pass a VS install with VC.Tools.x86.x64."
    }

    # Bundle font and third-party license files.
    $licenses = Join-Path $releaseDir "licenses"
    New-Item -ItemType Directory -Path $licenses -Force | Out-Null
    Copy-Item (Join-Path $repo "assets\fonts\*.txt") $licenses
    foreach ($doc in @("LICENSE", "THIRD-PARTY-NOTICES.md")) {
        $path = Join-Path $repo $doc
        if (Test-Path $path) { Copy-Item $path $releaseDir }
    }

    # Remove build-only folders unless incremental files are requested.
    if (-not $KeepBuildFiles) {
        Write-Host "==> removing build-only folders"
        foreach ($name in @("build", "deps", "incremental", "examples", ".fingerprint")) {
            $path = Join-Path $releaseDir $name
            if (-not (Test-Path $path)) { continue }
            Remove-Item -Recurse -Force $path -ErrorAction SilentlyContinue
            if (Test-Path $path) {
                Write-Warning "could not fully remove $path (is the app or cargo still running?)"
            }
        }
    }

    Write-Host "==> done. Run: $exe"
} finally {
    Pop-Location
}
