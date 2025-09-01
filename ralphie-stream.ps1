# ralphie-stream.ps1
# Author: Steven Olsen
# GitHub: https://github.com/OlsenSM91
# Streams adjectivenoun000..999 to stdout immediately.

[CmdletBinding()]
param(
  [string]$AdjectiveFile = "adjective_large.txt",
  [string]$NounFile      = "noun_large.txt",
  [int]$Start = 0,
  [int]$End   = 999
)

# Resolve paths (same folder as script by default)
$baseDir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$adjPath = Join-Path $baseDir $AdjectiveFile
$nounPath = Join-Path $baseDir $NounFile

if (-not (Test-Path $adjPath)) { throw "Adjective file not found: $adjPath" }
if (-not (Test-Path $nounPath)) { throw "Noun file not found: $nounPath" }
if ($Start -gt $End) { throw "Start ($Start) cannot be greater than End ($End)." }

# Load lists (trim and drop blank lines)
$adjectives = Get-Content -Path $adjPath -Encoding UTF8 | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
$nouns      = Get-Content -Path $nounPath -Encoding UTF8 | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

if ($adjectives.Count -eq 0) { throw "No adjectives found in $adjPath" }
if ($nouns.Count -eq 0)      { throw "No nouns found in $nounPath" }

# Stream to stdout line-by-line, no buffering
foreach ($adj in $adjectives) {
  foreach ($noun in $nouns) {
    for ($n = $Start; $n -le $End; $n++) {
      Write-Output ($adj + $noun + $n.ToString("D3"))
    }
  }
}
