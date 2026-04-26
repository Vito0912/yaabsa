Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
$bundleCandidates = @(
  (Join-Path $repoRoot "build\windows\x64\runner\Release"),
  (Join-Path $repoRoot "build\windows\runner\Release")
)
$bundleDir = $bundleCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $bundleDir) {
  throw "Windows bundle not found. Run flutter build windows --release first."
}

$pubspecPath = Join-Path $repoRoot "pubspec.yaml"
$pubspecContent = Get-Content $pubspecPath -Raw
if ($pubspecContent -notmatch '(?m)^version:\s*([^\s]+)') {
  throw "Unable to read version from pubspec.yaml"
}
$fullVersion = $Matches[1].Trim()
$appVersion = $fullVersion.Split('+')[0]

$outputDir = Join-Path $repoRoot "output\windows"
$stageDir = Join-Path $PSScriptRoot "stage"
$templatePath = Join-Path $PSScriptRoot "installer.iss.in"
$generatedScriptPath = Join-Path $PSScriptRoot "installer.generated.iss"
$outputBaseFilename = "yaabsa-$appVersion-windows-installer"

Remove-Item -Recurse -Force $stageDir -ErrorAction SilentlyContinue
Remove-Item -Force $generatedScriptPath -ErrorAction SilentlyContinue

New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
New-Item -ItemType Directory -Path $stageDir -Force | Out-Null
Copy-Item -Path (Join-Path $bundleDir "*") -Destination $stageDir -Recurse -Force

$template = Get-Content $templatePath -Raw
$scriptContent = $template
$scriptContent = $scriptContent.Replace("@APP_VERSION@", $appVersion)
$scriptContent = $scriptContent.Replace("@SOURCE_DIR@", $stageDir)
$scriptContent = $scriptContent.Replace("@OUTPUT_DIR@", $outputDir)
$scriptContent = $scriptContent.Replace("@OUTPUT_BASE_FILENAME@", $outputBaseFilename)
Set-Content -Path $generatedScriptPath -Value $scriptContent -Encoding UTF8

$isccPath = @(
  "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
  "${env:ProgramFiles}\Inno Setup 6\ISCC.exe"
) | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1
if (-not $isccPath) {
  throw "Inno Setup compiler (ISCC.exe) not found."
}

& $isccPath $generatedScriptPath
if ($LASTEXITCODE -ne 0) {
  throw "Inno Setup compilation failed."
}

$installerPath = Join-Path $outputDir "$outputBaseFilename.exe"
if (-not (Test-Path $installerPath)) {
  throw "Expected installer not found at $installerPath"
}

Remove-Item -Recurse -Force $stageDir
Remove-Item -Force $generatedScriptPath

Write-Host "Created $installerPath"
