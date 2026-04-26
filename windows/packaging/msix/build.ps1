Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path

$pubspecPath = Join-Path $repoRoot "pubspec.yaml"
$pubspecContent = Get-Content $pubspecPath -Raw
if ($pubspecContent -notmatch '(?m)^version:\s*([^\s]+)') {
  throw "Unable to read version from pubspec.yaml"
}
$fullVersion = $Matches[1].Trim()
$baseVersion = $fullVersion.Split('+')[0]
$buildPart = if ($fullVersion.Contains('+')) { $fullVersion.Split('+')[1] } else { "0" }

$parts = $baseVersion.Split('.')
while ($parts.Count -lt 3) {
  $parts += "0"
}
if ($parts.Count -gt 3) {
  $parts = $parts[0..2]
}
$msixVersion = "$($parts[0]).$($parts[1]).$($parts[2]).$buildPart"

$outputDir = Join-Path $repoRoot "output\windows"
$logoPath = Join-Path $repoRoot "assets\logo_blue_big_abs.png"
if (-not (Test-Path $logoPath)) {
  throw "MSIX logo not found at $logoPath"
}
New-Item -ItemType Directory -Path $outputDir -Force | Out-Null

$outputName = "yaabsa-$msixVersion"

& dart pub global run msix:create `
  --display-name yaabsa `
  --publisher-display-name Vito0912 `
  --identity-name de.vito0912.yaabsa `
  --version $msixVersion `
  --logo-path $logoPath `
  --capabilities internetClient `
  --sign-msix false `
  --publisher "CN=Vito0912" `
  --build-windows false `
  --architecture x64 `
  --output-path $outputDir `
  --output-name $outputName

if ($LASTEXITCODE -ne 0) {
  throw "MSIX creation failed."
}

$msixPath = Join-Path $outputDir "$outputName.msix"
if (-not (Test-Path $msixPath)) {
  $generated = Get-ChildItem -Path $outputDir -Filter "*.msix" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
  if (-not $generated) {
    throw "MSIX output not found in $outputDir"
  }
  $msixPath = $generated.FullName
}

Write-Host "Created $msixPath"
